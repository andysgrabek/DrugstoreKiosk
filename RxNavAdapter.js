const http = require('axios');
const { map, tap, filter }= require('rxjs/operators');
const RxNavInteractionAPIURL = 'https://rxnav.nlm.nih.gov/REST/interaction/list.json?rxcuis=';
const RxNavDrugIDAPIURL = 'https://rxnav.nlm.nih.gov/REST/rxcui.json?name=';
const drug = require('./drug.js');
const { from, of, forkJoin, zip} = require('rxjs');

var adapter = {

    /**
     * Looks up a drug by its EAN code in the csv file database and sends the response to the client in the form of a drug object
     *
     * @param {Object} body Request body containing the ean of the drug
     * @param {Object} res Response object that can receive the results and send them to the client
     * @param {Object} next The Express.js middleware object that can handle errors redirected to it
     */
    getDrug: function(body, res, next) {
        return drug.findDrug(body).subscribe(response => res.send(response), error => next(error));;
    },


    /**
     * Recieves the list of drug names, extracts the id for each object using the RxNav API, and for the list of
     * IDs queries the RxNav Interaction API to retrieve the conflicts.
     * Then it parses and filters the conflicts and converts them into an array of object conforming to the architecture assumptions.
     *
     * @param {Object} req Request body containing the drug names to check for conflicts
     * @param {Object} res Response object that can receive the results and send them to the client
     * @param {Object} next The Express.js middleware object that can handle errors redirected to it
     */
    getConflicts: function(req, res, next) {
        const names = [];
        console.log(JSON.stringify(req));
        req.forEach(drug => names.push(drug.name));
        let getId = (name) => from(http.get(RxNavDrugIDAPIURL + name.toLowerCase()));
        const idStream = [];
        names.forEach(name => {
            idStream.push(getId(name))
        });
        forkJoin(idStream)
            .subscribe(
                (conflicts) => {
                    let validObjs = [];
                    conflicts.forEach(c => {
                        if(c.data.idGroup.hasOwnProperty('rxnormId')){
                            validObjs.push(c.data)
                        }
                    });
                    console.log(validObjs)
                    const validIDs = validObjs.map(obj => obj.idGroup.rxnormId[0]);
                    const idString = validIDs.join('+');
                    console.log(idString);

                    let serverResponseList = [];
                    from(http.get(RxNavInteractionAPIURL + idString))
                        //.pipe(map(r => r.data.fullInteractionTypeGroup[0/*0 = drugBank*/].fullInteractionType))
                        .subscribe(r => {
                            console.log(r.data)
                            if(r.data.fullInteractionTypeGroup === undefined){
                                res.send("No conflicts found");
                                return
                            }
                            r = r.data.fullInteractionTypeGroup[0/*0 = drugBank*/].fullInteractionType;
                            r.forEach(interaction => {
                                serverResponseList.push({
                                    LHS:{
                                        code: "none",
                                        substance: "none",
                                        name:interaction.interactionPair[0].interactionConcept[0].minConceptItem.name
                                    },
                                    RHS:{
                                        code: "none",
                                        substance: "none",
                                        name:interaction.interactionPair[0].interactionConcept[1].minConceptItem.name
                                    },
                                    descriptionText:interaction.interactionPair[0].description
                                });

                            });
                            res.send(serverResponseList)
                        })
                },
                (err) => {
                    console.log(err);
                    res.send("Error");
                }
            );
    },

};

module.exports = adapter;

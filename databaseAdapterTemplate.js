var adapter = {

    /**
     * Looks up a drug by its EAN code in the database and sends the response to the client in the form of a drug object
     *
     * @param {Object} body Request body containing the ean of the drug
     * @param {Object} res Response object that can receive the results and send them to the client
     * @param {Object} next The Express.js middleware object that can handle errors redirected to it
     */
    getDrug: function(body, res, next) {

        res.send( {
            ean: "0000000000000",
            activeSubstance: "Ibuprofenum",
            displayName: "Ibum"
        })
    },

    /**
     * Recieves the list of drug names, checks the conflicts between them and sends the response to the client
     * in the form of object array.
     *
     * @param {Object} body Request body containing the drug names to check for conflicts
     * @param {Object} res Response object that can receive the results and send them to the client
     * @param {Object} next The Express.js middleware object that can handle errors redirected to it
     */
    getConflicts: function(body, res, next) {

        res.send( [
            {
                LHS:{
                    ean: "0000000000000",
                    activeSubstance: "Ibuprofenum",
                    displayName: "Ibum"
                },
                RHS:{
                    ean: "1111111111111",
                    activeSubstance: "Latanoprostum",
                    displayName: "Xalatan"
                },
                descriptionText: "Mismatch"
            },

            {
                LHS:{
                    ean: "0000000000000",
                    activeSubstance: "Ibuprofenum",
                    displayName: "Ibum"
                },
                RHS:{
                    ean: "1111111111111",
                    activeSubstance: "Latanoprostum",
                    displayName: "Xalatan"
                },
                descriptionText: "Mismatch"
            }
        ])
    },

};

module.exports = adapter;

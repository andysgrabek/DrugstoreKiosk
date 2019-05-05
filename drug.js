const Papa = require('papaparse');
const fs = require('fs');
const { throwError } = require('rxjs');
const { of } = require('rxjs');
const eanLength = 13;

let data = fs.readFileSync(__dirname + '/drugs.csv');
let csvString = data.toString();
let config = { header: true, delimiter: ";" };
let parseResult = Papa.parse(csvString, config);

var drug = {

    /**
     * Finds a drug by its EAN code in the CSV database
     *
     * @param {string} ean The EAN code of the drug in question
     * @returns {Observable}
     */
    findDrug: function(ean) {

        if (ean.length !== eanLength) {
            return throwError("Barcode NOT in EAN format");
        }

        for (let i = 0; i < parseResult.data.length; i++) {
            const drug = parseResult.data[i];
            if (drug.EAN != null && (drug.EAN === ean || drug.EAN.includes(ean))) {
                const object = {
                    code: ean,
                    substance: drug.Ingredient,
                    name: drug.Name
                };
                console.log("Found drug: " + object.toString());
                return of(object);
            }
        }

        return throwError("No drug exists with EAN: " + ean);
    }

};

module.exports = drug;
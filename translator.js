const http = require('axios');
const uuidv4 = require('uuid/v4');
const { from } = require('rxjs');
const { map } = require('rxjs/operators');
const subscriptionKey = process.env.translatorAPI;
const baseUrl = process.env.translatorAddress;
const endpointUrl = 'translate';

var translator = {

    /**
     * Translates text into a target language using Microsoft Machine Translation
     *
     * @param {string} text The text to be translated
     * @param {string} targetLang The locale code of the target language
     * @param {boolean} html signals the translation service if the text is in html format
     * @returns {Observable}
     */
    translateText: function (text, targetLang, html) {

        let options = {
            method: 'post',
            headers: {
                'Ocp-Apim-Subscription-Key': subscriptionKey,
                'Content-type': 'application/json',
                'X-ClientTraceId': uuidv4().toString()
            },
            params: {
                'api-version': '3.0',
                'to': targetLang,
                'textType': html ? 'html' : 'plain'
            },
            data: [{
                "text": text
            }]
        };

        return from(http.request(baseUrl + endpointUrl, options)).pipe(map(res => res.data[0].translations[0].text));

    },

    /**
     * Translates array of texts into a target language using Microsoft Machine Translation
     *
     * @param {[string]} textArray The text to be translated
     * @param {string} targetLang The locale code of the target language
     * @param {boolean} html signals the translation service if the text is in html format
     * @returns {Observable}
     */
    translateTextArray: function (textArray, targetLang, html) {
        console.log(JSON.stringify(textArray));
        let data = [];
        for (let i = 0; i < textArray.length; i++) {
            data.push({
                "text": textArray[i]
            });
        }

        console.log(data);
        let options = {
            method: 'post',
            headers: {
                'Ocp-Apim-Subscription-Key': subscriptionKey,
                'Content-type': 'application/json',
                'X-ClientTraceId': uuidv4().toString()
            },
            params: {
                'api-version': '3.0',
                'to': targetLang,
                'textType': html ? 'html' : 'plain'
            },
            data: data
        };

        return from(http.request(baseUrl + endpointUrl, options)).pipe(map(res => res.data.map(obj => obj.translations[0].text)));

    }

};

module.exports = translator;


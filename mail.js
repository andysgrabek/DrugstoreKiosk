const sgMail = require('@sendgrid/mail');
const sgAPI = process.env.emailAPI;
sgMail.setApiKey(sgAPI);
const senderAddress = process.env.emailSender;
const emailTitle = 'Drug Compatibility Report';
const translator = require('./translator.js');
const { from, Observable } = require('rxjs');

var email = {

    /**
     * Instructs the SendGrid service to send an email with the given content
     *
     * @param {string} data JSON containing recipient address and list of conflicts
     * @returns {Observable}
     */
    sendReport: function(data) {
        let htmlText = this.prepareHtml(data);
        let titleTranslationResult = translator.translateText(emailTitle, data.locale, false);
        let bodyTranslationResult = translator.translateText(htmlText, data.locale, true);
        return from(Promise.all([titleTranslationResult.toPromise(), bodyTranslationResult.toPromise()])
            .then(function(values) {
                const msg = {
                    to: data.recipient,
                    from: senderAddress,
                    subject: values[0],
                    html: values[1]
                };
                return from(sgMail.send(msg));
            }));
    },

    /**
     * Prepares an html message to be used as email content in English
     *
     * @param {data} data JSON containing recipient address and list of conflicts
     * @returns {string}
     */
    prepareHtml: function (data) {
        return `
            <div>
            <h2>
            Dear ${data.recipient}
            </h2>
            <p>Presented below are the conflicts detected between your drugs.</p>
            <ul>${data.conflicts.map(conflict => `<li>Conflict between 
                ${conflict.RHS.name} and 
                ${conflict.LHS.name}
                Description of conflict: ${conflict.descriptionText}</li>`)}
            </ul>
            </div>
        `;
    }

};

module.exports = email;

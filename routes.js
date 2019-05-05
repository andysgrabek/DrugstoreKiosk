const express = require('express');
const mail = require('./mail');
const translator = require('./translator');
const adapter = require('./RxNavAdapter.js');
const router = express.Router();

router.get('/getDrug', function(req, res, next) {
    console.log(req.query.ean);
    adapter.getDrug(req.query.ean,res,next);
});

router.post('/getConflicts', function(req, res, next) {
    console.log('Post body ' + JSON.stringify(req.body));
    adapter.getConflicts(req.body, res, next);
});

router.post('/sendReport', function(req, res, next) {
    console.log('Post body ' + JSON.stringify(req.body));
    mail.sendReport(req.body).subscribe(response => response.subscribe(res2 => res.send(res2)), error => next(error));
});

router.post('/getTranslation', function(req, res, next) {
    console.log('Text to be translated: ' + req.body.text + ' into ' + req.body.targetLang);
    translator.translateText(req.body.text, req.body.targetLang, req.body.html)
        .subscribe(
            text => {
                res.send(text);
                console.log(text);
            }, err => {
                next(err);
            })
});

router.post('/getTranslations', function(req, res, next) {
    console.log(JSON.stringify(req.body));
    console.log('Texts to be translated: ' + JSON.stringify(req.body.texts) + ' into ' + req.body.targetLang);
    translator.translateTextArray(req.body.texts, req.body.targetLang, req.body.html)
        .subscribe(
            text => {
                res.send(text);
                console.log(text);
            }, err => {
                next(err);
            })
});


module.exports = router;

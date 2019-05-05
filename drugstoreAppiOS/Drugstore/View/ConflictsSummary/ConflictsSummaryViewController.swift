//
//  ConflictsSummaryViewController.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 30/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import UIKit
import StatusAlert
import IHProgressHUD

class ConflictsSummaryViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func skipPressed(_ sender: UIButton) {
        returnToWelcomeScreen()
    }
    
    @IBAction func sendReportPressed(_ sender: UIButton) {
        prepareToSendReport()
    }
    
    @IBAction func emailEditingDidEnd(_ sender: UITextField) {
        prepareToSendReport()
    }
    
    func prepareToSendReport() {
        emailTextField.resignFirstResponder()
        if let address = emailTextField.text {
            if address.isValidEmail() {
                sendReport(to: address)
                return
            }
        }
        let statusAlert = StatusAlert()
        statusAlert.canBePickedOrDismissed = false
        statusAlert.image = UIImage(named: "Cross", in: nil, compatibleWith: nil)
        statusAlert.title = NSLocalizedString("ValidEmailPrompt", comment: "")
        statusAlert.showInKeyWindow()
    }
    
    func returnToWelcomeScreen() {
        if let viewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController() {
            present(viewController, animated: true) {
                SelectedDrugs.clear()
            }
        }
    }
    
    func sendReport(to address: String) {
        let statusAlert = StatusAlert()
        IHProgressHUD.show(withStatus: NSLocalizedString("SendingEmailStatus", comment: ""))
        statusAlert.canBePickedOrDismissed = false
        RestManager.shared.sendReport(address: address, conflicts: DetectedConflicts.conflicts, locale: Locale.current.languageCode!).responseString { response in
            IHProgressHUD.dismiss()
            if (response.error == nil) {
                statusAlert.image = UIImage(named: "Tick", in: nil, compatibleWith: nil)
                statusAlert.title = NSLocalizedString("EmailSentStatus", comment: "")
                statusAlert.showInKeyWindow()
                _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    self.returnToWelcomeScreen()
                }
            }
            else {
                statusAlert.image = UIImage(named: "Cross", in: nil, compatibleWith: nil)
                statusAlert.title = NSLocalizedString("EmailNotSentStatus", comment: "")
                statusAlert.showInKeyWindow()
            }
        }
    }
    
}

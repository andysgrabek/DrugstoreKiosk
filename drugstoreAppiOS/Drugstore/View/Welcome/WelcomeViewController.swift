//
//  ViewController.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 25/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import UIKit
import IHProgressHUD
import StatusAlert

class WelcomeViewController: UIViewController {

    @IBAction func beginPressed(_ sender: UIButton) {
        IHProgressHUD.show(withStatus: NSLocalizedString("CheckingServerAvailabilityPrompt", comment: ""))
        RestManager.shared.getServer().response { response in
            IHProgressHUD.dismiss()
            if response.error != nil {
                let statusAlert = StatusAlert()
                statusAlert.canBePickedOrDismissed = false
                statusAlert.image = UIImage(named: "Cross", in: nil, compatibleWith: nil)
                statusAlert.title = NSLocalizedString("ServerUnavailablePrompt", comment: "")
                statusAlert.showInKeyWindow()
            }
            else {
                if let viewController = UIStoryboard(name: "ScanDrug", bundle: nil).instantiateInitialViewController() {
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
}


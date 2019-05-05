//
//  NoConflictsViewController.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 30/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import UIKit

class NoConflictsViewController: UIViewController {
    
    @IBOutlet weak var endButton: UIButton!
    
    @IBAction func endPressed(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController() {
            present(viewController, animated: true) {
                SelectedDrugs.clear()
            }
        }
    }
    
    override func viewDidLoad() {
        endButton.layer.cornerRadius = endButton.bounds.height / 2 - 10
    }
    
}

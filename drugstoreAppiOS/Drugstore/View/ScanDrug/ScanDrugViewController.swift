//
//  ScanDrugViewController.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 27/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import UIKit
import BarcodeScanner
import StatusAlert
import IHProgressHUD
import Alamofire
import AlamofireObjectMapper

class ScanDrugViewController: UIViewController {
    
    @IBOutlet weak var drugListTableView: UITableView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drugListTableView.isHidden = true
        scanButton.layer.cornerRadius = scanButton.bounds.height / 2 - 10
        doneButton.layer.cornerRadius = doneButton.bounds.height / 2 - 10
        typeButton.layer.cornerRadius = typeButton.bounds.height / 2 - 10
        drugListTableView.delegate = self
        drugListTableView.dataSource = self
    }
    
    func removeDrug(code: String) {
        let indexA = SelectedDrugs.drugs.firstIndex() { drug in
            return drug.code == code
        }
        if let index = indexA {
            SelectedDrugs.drugs.remove(at: index)
            self.drugListTableView.beginUpdates()
            self.drugListTableView.deleteRows(at: [IndexPath(row: 0, section: index)], with: .automatic)
            self.drugListTableView.deleteSections([index], with: .automatic);
            self.drugListTableView.endUpdates()
        }
        if SelectedDrugs.drugs.count == 0 {
            self.drugListTableView.isHidden = true
        }
        
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        if SelectedDrugs.drugs.count > 0 {
            IHProgressHUD.show(withStatus: NSLocalizedString("PleaseWaitStatus", comment: ""))
            RestManager.shared.getConflicts(drugs: SelectedDrugs.drugs).responseArray { (response: DataResponse<[Conflict]>) in
                if response.error == nil && response.result.value != nil && response.result.value?.count != 0 {
                    DetectedConflicts.conflicts = response.result.value!
                    if let viewController = UIStoryboard(name: "ConflictsList", bundle: nil).instantiateInitialViewController() {
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
                else {
                    if let viewController = UIStoryboard(name: "NoConflicts", bundle: nil).instantiateInitialViewController() {
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
                IHProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func chooseDrugPressed(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "ChooseDrug", bundle: nil).instantiateInitialViewController() {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func scanDrugPressed(_ sender: UIButton) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.headerViewController.closeButton.setTitle(NSLocalizedString("ClosePrompt", comment: ""), for: .normal)
        viewController.headerViewController.titleLabel.text = NSLocalizedString("ScanPrompt", comment: "")
        present(viewController, animated: true) {
            viewController.cameraViewController.cameraButton.sendActions(for: UIControl.Event.touchUpInside)//choose which camera to use
            viewController.messageViewController.messages.processingText = NSLocalizedString("LookingUpDrugStatus", comment: "")
        }
    }
}


extension ScanDrugViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrugTableViewCell") as! DrugTableViewCell
        cell.configure(drug: SelectedDrugs.drugs[indexPath.section], delegate: self)
        return cell
    }
    
}

extension ScanDrugViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SelectedDrugs.drugs.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension ScanDrugViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        if (SelectedDrugs.drugs.contains { drug in return drug.code == code }) {
            let statusAlert = StatusAlert()
            statusAlert.canBePickedOrDismissed = false
            statusAlert.image = UIImage(named: "Tick", in: nil, compatibleWith: nil)
            statusAlert.title = NSLocalizedString("AlreadyScannedDrugStatus", comment: "")
            controller.dismissalDelegate?.scannerDidDismiss(controller)
            statusAlert.showInKeyWindow()
            return
        }
        
        RestManager.shared.getDrug(ean: code).responseObject { (response2: DataResponse<Drug>) in
            if (response2.error == nil) {
                let drug: Drug = response2.result.value!
                SelectedDrugs.drugs.append(drug)
                self.drugListTableView.isHidden = false
                self.drugListTableView.beginUpdates()
                self.drugListTableView.insertSections([SelectedDrugs.drugs.count - 1], with: .automatic)
                self.drugListTableView.insertRows(at: [IndexPath(row: 0, section: SelectedDrugs.drugs.count - 1)], with: .automatic)
                self.drugListTableView.endUpdates()
                let statusAlert = StatusAlert()
                statusAlert.canBePickedOrDismissed = false
                statusAlert.image = UIImage(named: "Tick", in: nil, compatibleWith: nil)
                statusAlert.title = NSLocalizedString("FoundDrugStatus", comment: "")
                statusAlert.showInKeyWindow()
            }
            else {
                let statusAlert = StatusAlert()
                statusAlert.canBePickedOrDismissed = false
                statusAlert.image = UIImage(named: "Cross", in: nil, compatibleWith: nil)
                statusAlert.title = NSLocalizedString("FailedToFindDrugStatus", comment: "")
                statusAlert.showInKeyWindow()
            }
            controller.dismissalDelegate?.scannerDidDismiss(controller)
        }
    }
    
    
}

extension ScanDrugViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    
}

extension ScanDrugViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

//
//  ConflictViewController.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 30/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import UIKit

class ConflictViewController: UIViewController {
    
    var delegate: ConflictsViewController?
    var conflict: Conflict?
    @IBOutlet weak var conflictTableView: UITableView!
    
    override func viewDidLoad() {
        conflictTableView.dataSource = self
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        delegate?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func previousPressed(_ sender: UIButton) {
        delegate?.previousPage()
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        delegate?.nextPage()
    }
    
}

extension ConflictViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var retCell: UITableViewCell
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConflictLabelCell")!
            retCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConflictHeadCell") as! ConflictHeadTableViewCell
            cell.LHS.text = conflict?.LHS?.name?.capitalizingFirstLetter()
            cell.RHS.text = conflict?.RHS?.name?.capitalizingFirstLetter()
            retCell = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionLabelCell")!
            retCell = cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionTableViewCell
            RestManager.shared.getTranslation(text: conflict?.descriptionText ?? "", targetLang: Locale.current.languageCode!).responseString { response in
                if response.error == nil {
                    cell.descriptionText.text = response.value
                }
                else {
                    cell.descriptionText.text = self.conflict?.descriptionText
                }
            }
            retCell = cell
        default:
            retCell = UITableViewCell()
        }
        return retCell
    }
}

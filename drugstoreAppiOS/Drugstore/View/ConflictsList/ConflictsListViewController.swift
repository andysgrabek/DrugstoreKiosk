//
//  ConflictsListViewController.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 18/01/2019.
//  Copyright © 2019 Andrzej Grabowski. All rights reserved.
//

import UIKit

class ConflictsListViewController: UIViewController {

    @IBOutlet weak var conflictsFound: UILabel!
    @IBOutlet weak var conflictsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conflictsTableView.delegate = self
        conflictsTableView.dataSource = self
        conflictsFound.text = conflictsFound.text! + " " + String(describing: DetectedConflicts.conflicts.count)
    }

    @IBAction func donePressed(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "ConflictsSummary", bundle: nil).instantiateInitialViewController() {
            present(viewController, animated: true, completion: nil)
        }
    }
}

extension ConflictsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Conflicts", bundle: nil).instantiateInitialViewController() {
            CATransaction.begin()
            navigationController?.pushViewController(viewController, animated: true)
            CATransaction.setCompletionBlock({
                let vc = viewController as! ConflictsViewController
                vc.setSelected(conflictIndex: indexPath.section)
                tableView.deselectRow(at: indexPath, animated: true)
            })
            CATransaction.commit()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetectedConflicts.conflicts.count
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

extension ConflictsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConflictTableViewCell") as! ConflictTableViewCell
        cell.configure(conflict: DetectedConflicts.conflicts[indexPath.section])
        return cell
    }
    
    
}

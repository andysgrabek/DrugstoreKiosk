//
//  ConflictTableViewCell.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 19/01/2019.
//  Copyright © 2019 Andrzej Grabowski. All rights reserved.
//

import UIKit

class ConflictTableViewCell: UITableViewCell {

    @IBOutlet weak var LHSDrug: UILabel!
    @IBOutlet weak var RHSDrug: UILabel!

    func configure(conflict: Conflict) {
        LHSDrug.text = conflict.LHS?.name
        LHSDrug.text?.capitalizeFirstLetter()
        RHSDrug.text = conflict.RHS?.name
        RHSDrug.text?.capitalizeFirstLetter()
    }
    
}

//
//  DrugTableViewCell.swift
//  Drugstore
//
//  Created by Andrzej Grabowski on 27/12/2018.
//  Copyright © 2018 Andrzej Grabowski. All rights reserved.
//

import UIKit

class DrugTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    var delegate: ScanDrugViewController?
    var drug: Drug?
    
    func configure(drug: Drug, delegate: ScanDrugViewController) {
        self.drug = drug
        nameLabel.text = drug.name
        nameLabel.text?.capitalizeFirstLetter()
        barcodeLabel.text = "EAN: " + drug.code!
        ingredientLabel.text = drug.substance
        self.delegate = delegate
    }
    
    @IBAction func removePressed(_ sender: UIButton) {
        delegate?.removeDrug(code: (drug?.code)!)
    }

}

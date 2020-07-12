//
//  UWATeamTableViewCell.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/11/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

class UWATeamTableViewCell: UITableViewCell {
    @IBOutlet weak var teamLabel: UILabel!

    var teamItem: UWATeam? {
        didSet {
            if let label = teamLabel {
                label.text = teamItem?.name
            }
        }
    }

}

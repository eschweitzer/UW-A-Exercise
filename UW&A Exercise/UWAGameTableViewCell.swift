//
//  UWAGameTableViewCell.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/11/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

class UWAGameTableViewCell: UITableViewCell {
    @IBOutlet weak var gameLabel: UILabel!

    var gameItem: UWAGame? {
        didSet {
            if let label = gameLabel, let game = gameItem {
                label.text = "\(game.team1.name) plays \(game.team2.name)"
            }
        }
    }

}

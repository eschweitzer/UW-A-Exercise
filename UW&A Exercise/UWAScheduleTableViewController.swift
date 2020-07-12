//
//  UWAScheduleTableViewController.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/11/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

class UWAScheduleTableViewController: UITableViewController {
    
    var teams: [UWATeam]?
    var schedule: [[UWAGame]]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        teams = [UWATeam]()
        schedule = teams?.createSchedule()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let number = schedule?.count {
            return number
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let number = schedule?[section].count {
            return number
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let day = schedule?[section].first?.date {
            let dayOfWeek: String = (day % 2 == 0) ? "Saturday" : "Sunday"
            return "Day \(day + 1) (\(dayOfWeek))"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? UWAGameTableViewCell,
            let game = schedule?[indexPath.section][indexPath.row] {
            cell.gameItem = game
            return cell
        }
        return UITableViewCell()
    }

}

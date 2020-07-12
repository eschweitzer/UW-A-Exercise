//
//  MasterViewController.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/11/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

protocol UWAMaster : MasterViewController {
    func addTeam(_ team: UWATeam)
    var teams: [UWATeam] { get }
}

class MasterViewController: UITableViewController, UWAMaster {

    @IBOutlet weak var noTeamsLabel: UILabel!
    var sortedTeams: [[UWATeam]]?
    var teams = [UWATeam]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        let scheduleButton = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(createSchedule(_:)))
        navigationItem.rightBarButtonItems = [addButton, scheduleButton]
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        teams = [UWATeam]()
        sortedTeams = teams.createSortedTeams()
        enableNoTeamLabel()
        enableScheduleButton()
    }

    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "addTeam", sender: self)
    }
    
    @objc
    func createSchedule(_ sender: Any) {
        performSegue(withIdentifier: "schedule", sender: self)
    }
    
    func addTeam(_ team: UWATeam) {
        if team.name.count == 0 {
            return
        }
        if !teams.doesTeamExist(team.name) {
            teams.append(team)
            teams.save()
            enableScheduleButton()
            sortedTeams = teams.createSortedTeams()
            tableView.reloadData()
        } else {
            let alert = UIAlertController(title: "Duplicate Team", message: "That team name has already been used. Duplicate team not saved. Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        enableNoTeamLabel()
    }
    
    private func enableNoTeamLabel() {
        noTeamsLabel.isHidden = (teams.count > 0)
    }
    
    private func enableScheduleButton() {
        let rightBarButtonItems = navigationItem.rightBarButtonItems
        if let scheduleButton = rightBarButtonItems?[1] {
            scheduleButton.isEnabled = teams.count > 2
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTeam" {
            if let controller = (segue.destination as? UINavigationController)?.topViewController as? AddTeamViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if let team = sortedTeams?[indexPath.section][indexPath.row] {
                        var indexOfTeam = NSNotFound
                        for (idx, aTeam) in teams.enumerated() {
                            if (aTeam.name == team.name) {
                                indexOfTeam = idx
                                break;
                            }
                        }
                        if indexOfTeam < teams.count {
                            teams.remove(at: indexOfTeam)
                            controller.teamItem = team
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let number = sortedTeams?.count {
            return number
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let number = sortedTeams?[section].count {
            return number
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let poolName = sortedTeams?[section].first?.pool {
            return poolName
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? UWATeamTableViewCell,
            let team = sortedTeams?[indexPath.section][indexPath.row] {
            cell.teamItem = team
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let team = sortedTeams?[indexPath.section][indexPath.row] {
                var indexOfTeam = 0
                for (idx, aTeam) in teams.enumerated() {
                    if (aTeam.name == team.name) {
                        indexOfTeam = idx
                        break;
                    }
                }
                teams.remove(at: indexOfTeam)
                teams.save()
                enableNoTeamLabel()
                sortedTeams = teams.createSortedTeams()
            }
            if teams.count > 0 {
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                tableView.reloadData()
            }
        }
    }
    
}

extension MasterViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        guard let navigationController = secondaryViewController as? UINavigationController,
            let detailViewController = navigationController.topViewController as? AddTeamViewController else {
                // Fallback to the default
                return false
        }
        
        return detailViewController.teamItem == nil
    }
}

//
//  UWAPoolTableViewController.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/12/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

class UWAPoolTableViewController: UITableViewController, UITextFieldDelegate {
    
    var pools: [String]
    
    required init?(coder: NSCoder) {
        pools = PoolStorage.getPools()
        super.init(coder: coder)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let lastCell = tableView.cellForRow(at: IndexPath(row: pools.count, section: 0)) as? UWAEnterPoolTableViewCell {
            if let enteredText = lastCell.textField.text, enteredText.count > 0 {
                pools.append(enteredText)
                pools.sort()
                PoolStorage.savePools(pools)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pools.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < pools.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PoolName", for: indexPath)
            cell.textLabel?.text = pools[indexPath.row]
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "PoolNameEntry", for: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pools.remove(at: indexPath.row)
            PoolStorage.savePools(pools)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    
    // MARK: - TextField delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let newPool = textField.text {
            if newPool.count > 0 {
                pools.append(newPool)
                pools.sort()
                PoolStorage.savePools(pools)
                textField.text = ""
                tableView.reloadData()
            }
        }
        return true
    }

}

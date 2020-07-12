//
//  AddTeamViewController.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/11/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

class AddTeamViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var poolPicker: UIPickerView!
    var poolNames: [String]?
    weak var delegate: UWAMaster?

    func configureView() {
        if let team = teamItem {
            if let teamNameField = textField {
                teamNameField.text = team.name
            }
            if let picker = poolPicker, let names = poolNames {
                if let idx = names.firstIndex(of: team.pool) {
                    picker.selectRow(idx, inComponent: 0, animated: false)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let path = Bundle.main.path(forResource: "Pool Names", ofType: "plist") else {return}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let poolNamesFromPlist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String] else {return}
        poolNames = poolNamesFromPlist
        
        if let splitController = navigationController?.splitViewController {
            if !splitController.isCollapsed {
                let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTeam(_:)))
                navigationItem.rightBarButtonItem = saveButton
            }
        }
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let splitController = navigationController?.splitViewController {
            let controllers = splitController.viewControllers
            if let masterViewController = (controllers.first as? UINavigationController)?.viewControllers.first as? MasterViewController {
                delegate = masterViewController
            }
            if !splitController.isCollapsed {
                navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveTeam(nil)
    }
    
    @objc
    private func saveTeam(_ sender : Any?) {
        if let unwrappedDelegate = delegate, let team = teamItem {
            unwrappedDelegate.addTeam(team)
        }
    }
    
    var teamItem: UWATeam? {
        didSet {
            configureView()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if let team = teamItem {
                team.name = updatedText
            } else {
                teamItem = UWATeam()
                teamItem!.name = updatedText
            }
            if let picker = poolPicker, let names = poolNames {
                if let team = teamItem {
                    let pickerIndex = picker.selectedRow(inComponent: 0)
                    team.pool = names[pickerIndex]
                }
            }
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let count = poolNames?.count else { return 0 }
        return count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        if let poolName = poolNames?[row] {
            label.text = poolName
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let newPoolName = poolNames?[row] else { return }
        if let team = teamItem {
            team.pool = newPoolName
        } else {
            teamItem = UWATeam()
            teamItem!.pool = newPoolName
        }
        teamItem!.name = textField!.text!
    }
}


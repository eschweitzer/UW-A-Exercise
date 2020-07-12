//
//  UWADataModel.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/9/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

class UWATeam: Codable {
    public var name : String
    public var pool : String
    
    init() {
        name = ""
        pool = ""
    }
    
    convenience init(withName name: String, andPool pool: String ) {
        self.init()
        self.name = name
        self.pool = pool
    }
}

class UWAGame {
    var team1: UWATeam
    var team2: UWATeam
    var date: Int
    
    init() {
        team1 = UWATeam()
        team2 = UWATeam()
        date = 0
    }
    
    convenience init(withTeam team1: UWATeam, team team2: UWATeam, andDate date: Int) {
        self.init()
        self.team1 = team1
        self.team2 = team2
        self.date = date
    }
}

//
//  UWATeam.swift
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

extension Array where Element : UWATeam {
    
    static func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
    
    static func getFileURL() -> URL? {
        if let documentsDir = self.getDocumentsDirectory() {
            return documentsDir.appendingPathComponent("teams.json")
        }
        return nil
    }
    
    init() {
        do {
            let decoder = JSONDecoder()
            if let fileURL = Array.getFileURL() {
                let data = try Data(contentsOf: fileURL)
                self = try decoder.decode([Element].self, from: data)
            } else {
                self = []
            }
        } catch {
            self = []
        }
    }

    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            if let fileURL = Array.getFileURL() {
                try data.write(to: fileURL)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getTeamsFor(pool: String) -> [UWATeam] {
        return self.filter { (item) -> Bool in
            return pool == item.pool
        }
    }
    
    func getPoolFor(team: String) -> String {
        let foundTeams = self.filter { (aTeam) -> Bool in
            return aTeam.name == team
        }
        if let foundteam = foundTeams.first {
            return foundteam.pool
        }
        return ""
    }
    
    func doesTeamExist(_ team: String) -> Bool {
        return getPoolFor(team: team) != ""
    }
    
    private func allPools() -> [String] {
        var pools: [String] = []
        for team in self {
            if !pools.contains(team.pool) {
                pools.append(team.pool)
            }
        }
        return pools.sorted()
    }
    
    private func doesTeam(_ team: String, haveGameOnDay: [UWAGame]) -> Bool {
        let filtered = haveGameOnDay.filter { (game) -> Bool in
            return (game.team1.name == team) || (game.team2.name == team)
        }
        return filtered.count > 0
    }
    
    private func addGameToSchedule(_ schedule: inout [[UWAGame]], firstTeam: UWATeam, secondTeam: UWATeam) {
        var day = 0
        var maxGamesOnDay = 2
        if day % 2 == 0 {
            maxGamesOnDay = 3
        }
        while (day < schedule.count) && ((schedule[day].count >= maxGamesOnDay) || self.doesTeam(firstTeam.name, haveGameOnDay: schedule[day]) || self.doesTeam(secondTeam.name, haveGameOnDay: schedule[day])) {
            day += 1
            if day % 2 == 0 {
                maxGamesOnDay = 3
            } else {
                maxGamesOnDay = 2
            }
        }

        let newGame = UWAGame(withTeam: firstTeam, team: secondTeam, andDate: day)
        if (day >= schedule.count) || (schedule[day].count >= maxGamesOnDay) {
            let newDay: [UWAGame] = [newGame]
            schedule.append(newDay)
        } else {
            schedule[day].append(newGame)
        }
    }
    
    /**
     return An array with each element being an array of games on the day
     */
    func createSchedule() -> [[UWAGame]] {
        var schedule: [[UWAGame]] = []
        let poolNames = self.allPools()
        var poolIdx = 0
        while poolIdx < poolNames.count {
            var firstIdx = 0
            var secondIdx = 1
            var finalPoolIdx = 0
            if poolNames.count > 2 {
                finalPoolIdx = Int.random(in: 0 ..< poolNames.count - 1)
                if finalPoolIdx == poolIdx {
                    finalPoolIdx += 1
                }
            } else if poolNames.count == 2 {
                if poolIdx == 0 {
                    finalPoolIdx = 1
                } else {
                    finalPoolIdx = 0
                }
            }
            let lastGamePoolName = poolNames[finalPoolIdx]
            let poolName = poolNames[poolIdx]
            let teamsInPool = self.getTeamsFor(pool: poolName).shuffled()
            while firstIdx < teamsInPool.count - 1 {
                while secondIdx < teamsInPool.count {
                    self.addGameToSchedule(&schedule, firstTeam: teamsInPool[firstIdx], secondTeam: teamsInPool[secondIdx])
                    secondIdx += 1
                }
                
                // If there are at least two pools, add a final game with a team from a different pool
                if poolNames.count > 1 {
                    let lastGameTeamsInPool = self.getTeamsFor(pool: lastGamePoolName).shuffled()
                    if let secondTeam = lastGameTeamsInPool.first {
                        self.addGameToSchedule(&schedule, firstTeam: teamsInPool[firstIdx], secondTeam: secondTeam)
                    }
                }
                firstIdx += 1
                secondIdx = firstIdx + 1
            }
            // If there are at least two pools, add a final game with a team from a different pool for final team
            if poolNames.count > 1 {
                let lastGameTeamsInPool = self.getTeamsFor(pool: lastGamePoolName).shuffled()
                if let secondTeam = lastGameTeamsInPool.first {
                    self.addGameToSchedule(&schedule, firstTeam: teamsInPool[teamsInPool.count - 1], secondTeam: secondTeam)
                }
            }

            poolIdx += 1
        }
        
        return schedule
    }
}

//
//  UWAViewModel.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/11/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

struct DocumentsDirectory {
    
    fileprivate static func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
}

struct PoolStorage {
    
    private static func getFileURL() -> URL? {
        if let documentsDir = DocumentsDirectory.getDocumentsDirectory() {
            return documentsDir.appendingPathComponent("pools.json")
        }
        return nil
    }
    
    static func defaultPools() -> [String] {
        guard let path = Bundle.main.path(forResource: "Pool Names", ofType: "plist") else {return []}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let poolNamesFromPlist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String] else {return []}
        return poolNamesFromPlist
    }
    
    static func getPools() -> [String] {
        do {
            let decoder = JSONDecoder()
            if let fileURL = PoolStorage.getFileURL() {
                let data = try Data(contentsOf: fileURL)
                if data.count == 0 {
                    return defaultPools()
                }
                return try decoder.decode([String].self, from: data)
            } else {
                return defaultPools()
            }
        } catch {
            return defaultPools()
        }
    }
    
    static func savePools(_ pools: [String]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(pools)
            if let fileURL = PoolStorage.getFileURL() {
                try data.write(to: fileURL)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension Array where Element : UWATeam {
    
    private static func getFileURL() -> URL? {
        if let documentsDir = DocumentsDirectory.getDocumentsDirectory() {
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
    
    mutating func deleteTeam(_ team: UWATeam) {
        var indexOfTeam = NSNotFound
        for (idx, aTeam) in self.enumerated() {
            if (aTeam.name == team.name) {
                indexOfTeam = idx
                break;
            }
        }
        if (indexOfTeam >= 0) && (indexOfTeam < self.count) {
            self.remove(at: indexOfTeam)
            save()
        }
    }
    
    func createSortedTeams() -> [[UWATeam]] {
        if self.count <= 0 {
            return []
        }
        
        var teams: [[UWATeam]] = []
        let pools = allPools()
        for poolName in pools {
            let filteredTeams = self.filter({ (team) -> Bool in
                return team.pool == poolName
            })
            let orderedTeams = filteredTeams.sorted { (first: UWATeam, second: UWATeam) -> Bool in
                return first.name < second.name
            }
            teams.append(orderedTeams)
        }
        return teams
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
     Reads the array of teams and schedules games between the teams.
     
      Games are scheduled between teams using the following rules:
     
      Each team has a game with every team in the same pool.
     
      Each team has one additional game with a team from another random pool. All teams in a pool face random opponents from the same pool.
     
      There are three game slots on even days (Saturday) and 2 slots on even odd days (Sunday).
     
      A team can only play a game in one slot each day.
     
     - Returns: An array with each element being an array of games on the day. Even indices (0, 2, 4, ...) are Saturdays and will have no more than three games. Odd indicies (1, 3, 5, ...) are Sundays and will have no more than two games.
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

//
//  UW_A_ExerciseTests.swift
//  UW&A ExerciseTests
//
//  Created by Eric Schweitzer on 7/11/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import XCTest
@testable import UW_A_Exercise

class UW_A_ExerciseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateScheduleFor4TeamsIn1Pool() {
        let team1A = UWATeam(withName:"Team 1", andPool:"Pool A")
        let team2A = UWATeam(withName:"Team 2", andPool:"Pool A")
        let team3A = UWATeam(withName:"Team 3", andPool:"Pool A")
        let team4A = UWATeam(withName:"Team 4", andPool:"Pool A")
        let teams = [team1A, team2A, team3A, team4A]
        let schedule = teams.createSchedule()
        
        for (dayIdx, day) in schedule.enumerated() {
            var maxGamesOnDay = 2
            if dayIdx % 2 == 0 {
                maxGamesOnDay = 3
            }
            XCTAssertLessThanOrEqual(day.count, maxGamesOnDay, "Too many games on day \(dayIdx)")
            var counts: [String : Int] = [:]
            for game in day {
                if let currentCount1 = counts[game.team1.name] {
                    var newCount = currentCount1
                    newCount += 1
                    counts[game.team1.name] = newCount
                } else {
                    counts[game.team1.name] = 1
                }
                if let currentCount2 = counts[game.team2.name] {
                    var newCount = currentCount2
                    newCount += 1
                    counts[game.team2.name] = newCount
                } else {
                    counts[game.team2.name] = 1
                }
            }
            for (team, count) in counts {
                XCTAssertEqual(count, 1, "\(team) has more than 1 game on day \(dayIdx)")
            }
        }
    }

    func testCreateScheduleFor4TeamsIn2Pools() {
        let team1A = UWATeam(withName:"Team 1A", andPool:"Pool A")
        let team2A = UWATeam(withName:"Team 2A", andPool:"Pool A")
        let team1B = UWATeam(withName:"Team 1B", andPool:"Pool B")
        let team2B = UWATeam(withName:"Team 2B", andPool:"Pool B")
        let teams = [team1A, team2A, team1B, team2B]
        let schedule = teams.createSchedule()
        
        for (dayIdx, day) in schedule.enumerated() {
            var maxGamesOnDay = 2
            if dayIdx % 2 == 0 {
                maxGamesOnDay = 3
            }
            XCTAssertLessThanOrEqual(day.count, maxGamesOnDay, "Too many games on day \(dayIdx)")
            var counts: [String : Int] = [:]
            for game in day {
                if let currentCount1 = counts[game.team1.name] {
                    var newCount = currentCount1
                    newCount += 1
                    counts[game.team1.name] = newCount
                } else {
                    counts[game.team1.name] = 1
                }
                if let currentCount2 = counts[game.team2.name] {
                    var newCount = currentCount2
                    newCount += 1
                    counts[game.team2.name] = newCount
                } else {
                    counts[game.team2.name] = 1
                }
            }
            for (team, count) in counts {
                XCTAssertEqual(count, 1, "\(team) has more than 1 game on day \(dayIdx)")
            }
        }
    }
    
    func testCreateScheduleFor8TeamsIn2Pools() {
        let team1A = UWATeam(withName:"Team 1A", andPool:"Pool A")
        let team2A = UWATeam(withName:"Team 2A", andPool:"Pool A")
        let team3A = UWATeam(withName:"Team 3A", andPool:"Pool A")
        let team4A = UWATeam(withName:"Team 4A", andPool:"Pool A")
        let team1B = UWATeam(withName:"Team 1B", andPool:"Pool B")
        let team2B = UWATeam(withName:"Team 2B", andPool:"Pool B")
        let team3B = UWATeam(withName:"Team 3B", andPool:"Pool B")
        let team4B = UWATeam(withName:"Team 4B", andPool:"Pool B")
        let teams = [team1A, team2A, team3A, team4A, team1B, team2B, team3B, team4B]
        let schedule = teams.createSchedule()
        
        var totals: [String : Int] = [:]
        for (dayIdx, day) in schedule.enumerated() {
            var maxGamesOnDay = 2
            if dayIdx % 2 == 0 {
                maxGamesOnDay = 3
            }
            XCTAssertLessThanOrEqual(day.count, maxGamesOnDay, "Too many games on day \(dayIdx)")
            var counts: [String : Int] = [:]
            for game in day {
                if let currentCount1 = totals[game.team1.name] {
                    var newCount = currentCount1
                    newCount += 1
                    totals[game.team1.name] = newCount
                } else {
                    totals[game.team1.name] = 1
                }
                if let currentCount2 = totals[game.team2.name] {
                    var newCount = currentCount2
                    newCount += 1
                    totals[game.team2.name] = newCount
                } else {
                    totals[game.team2.name] = 1
                }

                if let currentCount1 = counts[game.team1.name] {
                    var newCount = currentCount1
                    newCount += 1
                    counts[game.team1.name] = newCount
                } else {
                    counts[game.team1.name] = 1
                }
                if let currentCount2 = counts[game.team2.name] {
                    var newCount = currentCount2
                    newCount += 1
                    counts[game.team2.name] = newCount
                } else {
                    counts[game.team2.name] = 1
                }
            }
            for (team, count) in counts {
                XCTAssertEqual(count, 1, "\(team) has more than 1 game on day \(dayIdx)")
            }
        }
        for (team, count) in totals {
            XCTAssertGreaterThanOrEqual(count, 4, "\(team) has \(count) games")
        }
    }
    
    func testCreateScheduleFor32TeamsIn4Pools() {
        let team1A = UWATeam(withName:"Team 1A", andPool:"Pool A")
        let team2A = UWATeam(withName:"Team 2A", andPool:"Pool A")
        let team3A = UWATeam(withName:"Team 3A", andPool:"Pool A")
        let team4A = UWATeam(withName:"Team 4A", andPool:"Pool A")
        let team5A = UWATeam(withName:"Team 5A", andPool:"Pool A")
        let team6A = UWATeam(withName:"Team 6A", andPool:"Pool A")
        let team7A = UWATeam(withName:"Team 7A", andPool:"Pool A")
        let team8A = UWATeam(withName:"Team 8A", andPool:"Pool A")
        let team1B = UWATeam(withName:"Team 1B", andPool:"Pool B")
        let team2B = UWATeam(withName:"Team 2B", andPool:"Pool B")
        let team3B = UWATeam(withName:"Team 3B", andPool:"Pool B")
        let team4B = UWATeam(withName:"Team 4B", andPool:"Pool B")
        let team5B = UWATeam(withName:"Team 5B", andPool:"Pool B")
        let team6B = UWATeam(withName:"Team 6B", andPool:"Pool B")
        let team7B = UWATeam(withName:"Team 7B", andPool:"Pool B")
        let team8B = UWATeam(withName:"Team 8B", andPool:"Pool B")
        let team1C = UWATeam(withName:"Team 1C", andPool:"Pool C")
        let team2C = UWATeam(withName:"Team 2C", andPool:"Pool C")
        let team3C = UWATeam(withName:"Team 3C", andPool:"Pool C")
        let team4C = UWATeam(withName:"Team 4C", andPool:"Pool C")
        let team5C = UWATeam(withName:"Team 5C", andPool:"Pool C")
        let team6C = UWATeam(withName:"Team 6C", andPool:"Pool C")
        let team7C = UWATeam(withName:"Team 7C", andPool:"Pool C")
        let team8C = UWATeam(withName:"Team 8C", andPool:"Pool C")
        let team1D = UWATeam(withName:"Team 1D", andPool:"Pool D")
        let team2D = UWATeam(withName:"Team 2D", andPool:"Pool D")
        let team3D = UWATeam(withName:"Team 3D", andPool:"Pool D")
        let team4D = UWATeam(withName:"Team 4D", andPool:"Pool D")
        let team5D = UWATeam(withName:"Team 5D", andPool:"Pool D")
        let team6D = UWATeam(withName:"Team 6D", andPool:"Pool D")
        let team7D = UWATeam(withName:"Team 7D", andPool:"Pool D")
        let team8D = UWATeam(withName:"Team 8D", andPool:"Pool D")
        let teams = [team1A, team2A, team3A, team4A, team5A, team6A, team7A, team8A,
                     team1B, team2B, team3B, team4B, team5B, team6B, team7B, team8B,
                     team1C, team2C, team3C, team4C, team5C, team6C, team7C, team8C,
                     team1D, team2D, team3D, team4D, team5D, team6D, team7D, team8D]
        let schedule = teams.createSchedule()
        
        var totals: [String : Int] = [:]
        for (dayIdx, day) in schedule.enumerated() {
            var maxGamesOnDay = 2
            if dayIdx % 2 == 0 {
                maxGamesOnDay = 3
            }
            XCTAssertLessThanOrEqual(day.count, maxGamesOnDay, "Too many games on day \(dayIdx)")
            var counts: [String : Int] = [:]
            for game in day {
                if let currentCount1 = totals[game.team1.name] {
                    var newCount = currentCount1
                    newCount += 1
                    totals[game.team1.name] = newCount
                } else {
                    totals[game.team1.name] = 1
                }
                if let currentCount2 = totals[game.team2.name] {
                    var newCount = currentCount2
                    newCount += 1
                    totals[game.team2.name] = newCount
                } else {
                    totals[game.team2.name] = 1
                }

                if let currentCount1 = counts[game.team1.name] {
                    var newCount = currentCount1
                    newCount += 1
                    counts[game.team1.name] = newCount
                } else {
                    counts[game.team1.name] = 1
                }
                if let currentCount2 = counts[game.team2.name] {
                    var newCount = currentCount2
                    newCount += 1
                    counts[game.team2.name] = newCount
                } else {
                    counts[game.team2.name] = 1
                }
            }
            for (team, count) in counts {
                XCTAssertEqual(count, 1, "\(team) has more than 1 game on day \(dayIdx)")
            }
        }
        for (team, count) in totals {
            XCTAssertGreaterThanOrEqual(count, 8, "\(team) has \(count) games")
        }
    }
    
    func testCreateScheduleFor21TeamsIn4Pools() {
        let team1A = UWATeam(withName:"Team 1A", andPool:"Pool A")
        let team1B = UWATeam(withName:"Team 1B", andPool:"Pool B")
        let team2B = UWATeam(withName:"Team 2B", andPool:"Pool B")
        let team3B = UWATeam(withName:"Team 3B", andPool:"Pool B")
        let team4B = UWATeam(withName:"Team 4B", andPool:"Pool B")
        let team1C = UWATeam(withName:"Team 1C", andPool:"Pool C")
        let team2C = UWATeam(withName:"Team 2C", andPool:"Pool C")
        let team3C = UWATeam(withName:"Team 3C", andPool:"Pool C")
        let team4C = UWATeam(withName:"Team 4C", andPool:"Pool C")
        let team5C = UWATeam(withName:"Team 5C", andPool:"Pool C")
        let team6C = UWATeam(withName:"Team 6C", andPool:"Pool C")
        let team7C = UWATeam(withName:"Team 7C", andPool:"Pool C")
        let team8C = UWATeam(withName:"Team 8C", andPool:"Pool C")
        let team1D = UWATeam(withName:"Team 1D", andPool:"Pool D")
        let team2D = UWATeam(withName:"Team 2D", andPool:"Pool D")
        let team3D = UWATeam(withName:"Team 3D", andPool:"Pool D")
        let team4D = UWATeam(withName:"Team 4D", andPool:"Pool D")
        let team5D = UWATeam(withName:"Team 5D", andPool:"Pool D")
        let team6D = UWATeam(withName:"Team 6D", andPool:"Pool D")
        let team7D = UWATeam(withName:"Team 7D", andPool:"Pool D")
        let team8D = UWATeam(withName:"Team 8D", andPool:"Pool D")
        let teams = [team1A,
                     team1B, team2B, team3B, team4B,
                     team1C, team2C, team3C, team4C, team5C, team6C, team7C, team8C,
                     team1D, team2D, team3D, team4D, team5D, team6D, team7D, team8D]
        let schedule = teams.createSchedule()
        
        for (dayIdx, day) in schedule.enumerated() {
            var maxGamesOnDay = 2
            if dayIdx % 2 == 0 {
                maxGamesOnDay = 3
            }
            XCTAssertLessThanOrEqual(day.count, maxGamesOnDay, "Too many games on day \(dayIdx)")
            var counts: [String : Int] = [:]
            for game in day {
                if let currentCount1 = counts[game.team1.name] {
                    var newCount = currentCount1
                    newCount += 1
                    counts[game.team1.name] = newCount
                } else {
                    counts[game.team1.name] = 1
                }
                if let currentCount2 = counts[game.team2.name] {
                    var newCount = currentCount2
                    newCount += 1
                    counts[game.team2.name] = newCount
                } else {
                    counts[game.team2.name] = 1
                }
            }
            for (team, count) in counts {
                XCTAssertEqual(count, 1, "\(team) has more than 1 game on day \(dayIdx)")
            }
        }
    }

}

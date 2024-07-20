//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Igor Kirpinev on 20.07.2024.
//

import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
        case date
        case correctAnswers
    }
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.correct.rawValue)
            let total = storage.integer(forKey: Keys.total.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            if correctAnswers == 0 {
                return 0
            }
                        
            return Double(correctAnswers) / Double(gamesCount * 10) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let gameResult = GameResult(correct: count, total: amount, date: Date())
        
        correctAnswers += count
        gamesCount += 1
        
        if gameResult.isBetterThan(bestGame) {
            bestGame = gameResult
        }
    }
}

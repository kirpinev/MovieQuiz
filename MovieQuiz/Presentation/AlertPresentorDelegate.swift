//
//  AlertPresentorDelegate.swift
//  MovieQuiz
//
//  Created by Igor Kirpinev on 18.07.2024.
//

protocol AlertPresentorDelegate: AnyObject {
    func showResult(quiz result: QuizResultsViewModel)
}

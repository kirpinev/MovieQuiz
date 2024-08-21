//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Igor Kirpinev on 20.08.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuestion(quiz step: QuizStepViewModel)
    func showResult(quiz result: QuizResultsViewModel)
    
    func showAnswerResult(isCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func toggleButtonsActivity()
    func resetImageViewBorder()
}

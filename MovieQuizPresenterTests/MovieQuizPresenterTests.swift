//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Igor Kirpinev on 20.08.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func toggleButtonsActivity() {
        
    }
    
    func resetImageViewBorder() {
        
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        
    }
    
    func showResult(quiz result: QuizResultsViewModel) {
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Igor Kirpinev on 20.08.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    
    weak var viewController: MovieQuizViewControllerProtocol?
    var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
        
        self.viewController?.showLoadingIndicator()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func noButtonClicked() {
        handleAnswer(isYes: false)
    }
    
    func yesButtonClicked() {
        handleAnswer(isYes: true)
    }
    
    func handleAnswer(isYes: Bool) {
        viewController?.toggleButtonsActivity()
        
        guard let currentQuestion else {
            return
        }
        
        let isCorrect = currentQuestion.correctAnswer == isYes
        
        viewController?.showAnswerResult(isCorrect: isCorrect)
        
        if (isCorrect) {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {
                return
            }
            
            self.showNextQuestionOrResults()
            self.viewController?.resetImageViewBorder()
            self.viewController?.toggleButtonsActivity()
        }
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let gamesCount = statisticService.gamesCount
            let bestGame = statisticService.bestGame
            let totalAccuracy = statisticService.totalAccuracy
            
            let text = "Ваш результат \(correctAnswers)/\(questionsAmount)\n" +
            "Количество сыгранных игр: \(gamesCount)\n" +
            "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\n" +
            "Средняя точность: \(String(format: "%.2f", totalAccuracy))%"
            let model = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз")
            
            viewController?.showResult(quiz: model)
        } else {
            switchToNextQuestion()
            
            questionFactory?.requestNextQuestion()
        }
    }
    
    func showLoadingIndicator() {
        viewController?.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        viewController?.hideLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showQuestion(quiz: viewModel)
        }
    }
}

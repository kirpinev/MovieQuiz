//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Igor Kirpinev on 16.07.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        self.delegate?.showLoadingIndicator()

        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {
                return
            }
                        
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Int(Float(movie.rating) ?? 0)
            let randomRating = Int(Float.random(in: 4..<10))
            let text = "Рейтинг этого фильма больше чем \(Int(randomRating))?"
            let correctAnswer = rating > randomRating
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.delegate?.hideLoadingIndicator()
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}

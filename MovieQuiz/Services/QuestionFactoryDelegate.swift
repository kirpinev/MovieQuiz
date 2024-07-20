//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Igor Kirpinev on 18.07.2024.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}

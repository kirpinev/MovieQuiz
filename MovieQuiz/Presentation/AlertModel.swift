//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Igor Kirpinev on 18.07.2024.
//

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}

//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Igor Kirpinev on 19.08.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
                
        app.buttons["Yes"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() throws {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
                
        app.buttons["No"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinish() throws {
        sleep(3)
                
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        let alert = app.alerts.firstMatch
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    
    func testCloseAlert() throws {
        sleep(3)
                
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        let alert = app.alerts.firstMatch
        
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]

        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}

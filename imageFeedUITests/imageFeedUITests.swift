//
//  imageFeedUITests.swift
//  imageFeedUITests
//
//  Created by Maxim on 06.04.2025.
//

import XCTest

final class imageFeedUITests: XCTestCase {
    let app = XCUIApplication()
    let fullName = ""
    let username = ""
    let email = ""
    let password = ""
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(email)
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    func testFeed() throws {
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        let cellToLike = tableQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.tap()
        sleep(3)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        let backButton = app.buttons["backButton"]
        backButton.tap()
        
    }
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts[fullName].exists)
        XCTAssertTrue(app.staticTexts[username].exists)
        app.buttons["logOutButton"].tap()
        
        app.alerts["alert"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}

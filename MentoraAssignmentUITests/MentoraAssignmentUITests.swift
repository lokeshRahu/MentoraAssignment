//
//  MentoraAssignmentUITests.swift
//  MentoraAssignmentUITests
//
//  Created by Lokesh Lebaka on 18/09/22.
//

import XCTest

class MentoraAssignmentUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchPage()
    {
        let app = XCUIApplication()
        app.launch()
        
        let searchUserSearchField = app.searchFields["Search user"]
        XCTAssert(searchUserSearchField.exists)
        
        searchUserSearchField.tap()
        searchUserSearchField.clearSearchFieldEnterText(credentials: "LokeshLebaka")

                
        let showHistoryButton = app.navigationBars["GitHub Users"].buttons["Show History"]
        XCTAssert(showHistoryButton.exists)
    }
    func testSearchUsersFunctionality() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let searchUserSearchField = app.searchFields["Search user"]
        searchUserSearchField.tap()
        searchUserSearchField.clearSearchFieldEnterText(credentials: "Lokesh")
        let searchButton = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        searchButton.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Lokesh Dhakar"]/*[[".cells.staticTexts[\"Lokesh Dhakar\"]",".staticTexts[\"Lokesh Dhakar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
               
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Show followers"]/*[[".cells",".buttons[\"Show followers\"].staticTexts[\"Show followers\"]",".staticTexts[\"Show followers\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Followers"].buttons["lokesh's details"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Show following"]/*[[".cells",".buttons[\"Show following\"].staticTexts[\"Show following\"]",".staticTexts[\"Show following\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Following"].buttons["lokesh's details"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["share ios"]/*[[".cells.buttons[\"share ios\"]",".buttons[\"share ios\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        app.navigationBars["GitHub Users"].buttons["Show History"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIElement {
    // to clear the username search field if the username is already typed
    func clearSearchFieldEnterText(credentials: String) {
        guard let credentialsString = self.value as? String else {
            XCTFail(" Failed to empty the text field ")
            return
        }

        tap()
        let deleteString = credentialsString.map { _ in "\u{8}" }.joined(separator: "")
        typeText(deleteString)
        typeText(credentials)
    }
}

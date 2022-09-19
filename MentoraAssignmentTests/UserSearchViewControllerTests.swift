//
//  UserSearchViewControllerTests.swift
//  MentoraAssignmentTests
//
//  Created by Lokesh Lebaka on 19/09/22.
//

import XCTest
import CoreData
@testable import MentoraAssignment

class UserSearchViewControllerTests: XCTestCase {

    // system under test for UserSearchViewController
    var sut: UserSearchViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // setting up UserSearchViewController
        guard let viewController = UserSearchViewController.createViewController() else {
            return XCTFail("Could not instantiate UserSearchViewController")
        }

        // instantiate the UserSearchViewController
        sut = viewController
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // destroy the viewContoller
        sut = nil
        super.tearDown()
    }
    
    func testUserSearchViewControllerHasUIElements() {
        // load viewDidLoad()
        sut.loadViewIfNeeded()

        // test search bar exists
        XCTAssertNotNil(sut.searchBar,
                        "Controller should have searchbar")
        
        // test search results table view exists
        XCTAssertNotNil(sut.searchResultsTableView,
                        "Controller should have searchResultsTableView")
        
        // test showHistoryButton exists
        XCTAssertNotNil(sut.showHistoryButton,
                        "Controller should have showHistoryButton")
    }

    func testShowHistoryButtonClicked() {
        // load viewDidLoad()
        sut.loadViewIfNeeded()
        
        // create mock details
        sut.showHistoryData = false
        sut.searchBar.text = "unitTests"
        sut.showHistoryButtonClicked(sut.showHistoryButton!)
        
        XCTAssertTrue(sut.showHistoryData, "showHistoryData value should be true")
        XCTAssertEqual(sut.showHistoryButton.title, "Hide Searches")
        
        sut.showHistoryButtonClicked(sut.showHistoryButton!)
        
        XCTAssertFalse(sut.showHistoryData, "showHistoryData value should be false")
        XCTAssertEqual(sut.showHistoryButton.title, "Recent Searches")
    }
    
    // MARK:- UITableViewDataSource, UITableViewDelegate Test Methods
    
    func testNumberOfSections() {
        // load viewDidLoad()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfSections(in: sut.searchResultsTableView), 1)
    }
    
    func testNumberOfRowsInSection() {
        // load viewDidLoad()
        sut.loadViewIfNeeded()
        
        sut.showHistoryData = false
        sut.activeUser = nil
        XCTAssertEqual(sut.tableView(sut.searchResultsTableView, numberOfRowsInSection: 0), 0)
        
        // Mock Data to test filtered users
        sut.showHistoryData = true
        XCTAssertEqual(sut.tableView(sut.searchResultsTableView, numberOfRowsInSection: 0), 0)
        
        // Mock Data to test active user
        sut.showHistoryData = false
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        if let activeUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            let userDict = ["avatar_url" : "sdfds.com", "bio" : "", "email" : "lebakulokesh095@gmail.com", "company" : "Simbesi", "name" : "Lokesh Lebaka", "login" : "LokeshLebaka", "followers" : 0, "following" : 1, "location" : "Hyderabad", "public_gists" : 0, "public_repos" : 1, "updated_at" : "", "followers_url" : "", "following_url" : "", "html_url" : ""] as [String : Any]
            activeUser.fillObject(userDict: userDict)
            
            sut.activeUser = activeUser
            XCTAssertEqual(sut.tableView(sut.searchResultsTableView, numberOfRowsInSection: 0), 1)
            
            sut.showHistoryData = true
            sut.filteredUsers = [activeUser, activeUser, activeUser]
            XCTAssertEqual(sut.tableView(sut.searchResultsTableView, numberOfRowsInSection: 0), 3)
        }

    }
    
    func testCellForRowAtIndexPath() {
        // load viewDidLoad()
        sut.loadViewIfNeeded()
        
        // Mock Data to test active user
        sut.showHistoryData = false
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        if let activeUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            let userDict = ["avatar_url" : "sdfds.com", "bio" : "", "email" : "lebakulokesh095@gmail.com", "company" : "Simbesi", "name" : "Lokesh Lebaka", "login" : "LokeshLebaka", "followers" : 0, "following" : 1, "location" : "Hyderabad", "public_gists" : 0, "public_repos" : 1, "updated_at" : "", "followers_url" : "", "following_url" : "", "html_url" : ""] as [String : Any]
            activeUser.fillObject(userDict: userDict)
            
            sut.activeUser = activeUser
            sut.filteredUsers = [activeUser, activeUser, activeUser]
        }
        var cell = sut.tableView(sut.searchResultsTableView, cellForRowAt: IndexPath.init(row: 0, section: 0))
        XCTAssertNotNil(cell, "cell should be initialised")
        XCTAssertTrue(cell is UserDisplayTableViewCell)
        guard let userDetailsCell = cell as? UserDisplayTableViewCell else {
            return
        }
        XCTAssertEqual(userDetailsCell.nameLabel?.text, "Lokesh Lebaka")
        
        sut.showHistoryData = true
        cell = sut.tableView(sut.searchResultsTableView, cellForRowAt: IndexPath.init(row: 2, section: 0))
        XCTAssertNotNil(cell, "cell should be initialised")
        XCTAssertTrue(cell is UserDisplayTableViewCell)
        guard let userDetailsCell = cell as? UserDisplayTableViewCell else {
            return
        }
        XCTAssertEqual(userDetailsCell.nameLabel?.text, "Lokesh Lebaka")

    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//
//  UserFollowersViewControllerTests.swift
//  MentoraAssignmentTests
//
//  Created by Lokesh Lebaka on 19/09/22.
//

import XCTest
@testable import MentoraAssignment
import CoreData

class UserFollowersViewControllerTests: XCTestCase {

    // system under test for UserSearchViewController
    var sut: UserFollowersViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // setting up UserFollowersViewController
        guard let viewController = UserFollowersViewController.createViewController() else {
            return XCTFail("Could not instantiate UserFollowersViewController")
        }

        // instantiate the UserFollowersViewController
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

        // test userDetailsTableView exists
        XCTAssertNotNil(sut.followersTableView,
                        "Controller should have userDetailsTableView")
    }
    
    // MARK:- UITableViewDataSource, UITableViewDelegate Test Methods
    
    func testNumberOfSections() {
        // load viewDidLoad()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfSections(in: sut.followersTableView), 1)
    }
    
    func testNumberOfRowsInSection() {
        // load viewDidLoad()
        sut.loadViewIfNeeded()
        
        sut.activeUser = nil
        sut.usersArray = []
        XCTAssertEqual(sut.tableView(sut.followersTableView, numberOfRowsInSection: 0), 0)
        
        
        // Mock Data to test active user
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        if let activeUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            let userDict = ["avatar_url" : "sdfds.com", "bio" : "", "email" : "lebakulokesh095@gmail.com", "company" : "Simbesi", "name" : "Lokesh Lebaka", "login" : "LokeshLebaka", "followers" : 0, "following" : 1, "location" : "Hyderabad", "public_gists" : 0, "public_repos" : 1, "updated_at" : "", "followers_url" : "", "following_url" : "", "html_url" : ""] as [String : Any]
            activeUser.fillObject(userDict: userDict)
            
            sut.activeUser = activeUser
            sut.usersArray = [activeUser]
            XCTAssertEqual(sut.tableView(sut.followersTableView, numberOfRowsInSection: 0), 1)
        }

    }
    
    func testCellForRowAtIndexPath() {
        // load viewDidLoad()
        sut.loadViewIfNeeded()
        
        // Mock Data to test active user
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        if let activeUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            let userDict = ["avatar_url" : "sdfds.com", "bio" : "", "email" : "lebakulokesh095@gmail.com", "company" : "Simbesi", "name" : "Lokesh Lebaka", "login" : "LokeshLebaka", "followers" : 0, "following" : 1, "location" : "Hyderabad", "public_gists" : 0, "public_repos" : 1, "updated_at" : "", "followers_url" : "", "following_url" : "", "html_url" : ""] as [String : Any]
            activeUser.fillObject(userDict: userDict)
            
            sut.activeUser = activeUser
            sut.usersArray = [activeUser]
        }
        let cell = sut.tableView(sut.followersTableView, cellForRowAt: IndexPath.init(row: 0, section: 0))
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

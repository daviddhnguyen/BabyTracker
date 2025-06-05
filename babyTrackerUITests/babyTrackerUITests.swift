//
//  babyTrackerUITests.swift
//  babyTrackerUITests
//
//  Created by David Nguyen on 5/25/25.
//

import XCTest

final class babyTrackerUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication().launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Prints out the heirachy to identify the elements in the console
    //print(app.debugDescription)
    
    //Test homescreen loads
    func testHomePageTitle() throws {
        XCTAssertTrue(app.staticTexts["Home"].exists)
    }
    
    func testHomeDisplaysLastSleepEntry() throws {
        XCTAssertTrue(app.buttons["Sleeping"].exists)
    }
    
    func testHomeDisplaysLastFeedEntry() throws {
        XCTAssertTrue(app.buttons["Feeding"].exists)
    }
    
    func testHomeDisplaysLastDiaperEntry() throws {
        XCTAssertTrue(app.buttons["Diapers"].exists)
    }
    
    //Test going to Log Page
    func testTappingSleepNavigatesToSleepLog() throws {
        app.buttons["Sleeping"].tap()
        XCTAssertTrue(app.staticTexts["Sleep Log"].exists)
    }

    func testTappingFeedNavigatesToFeedLog() throws {
        app.buttons["Feeding"].tap()
        XCTAssertTrue(app.staticTexts["Feed Log"].exists)
    }
    
    func testTappingDiapersNavigatesToDiaperLog() throws {
        app.buttons["Diapers"].tap()
        XCTAssertTrue(app.staticTexts["Diaper Log"].exists)
    }
    
    //Test showing correct Log Data
    func testTappingSleepShowsSleepLogData() throws {
        app.buttons["Sleeping"].tap()
        XCTAssertTrue(app.staticTexts["durationLabel"].exists)
    }
    
    func testTappingFeedShowsFeedLogData() throws {
        app.buttons["Feeding"].tap()
        XCTAssertTrue(app.staticTexts["bottleTypeLabel"].exists)
        XCTAssertTrue(app.staticTexts["amountLabel"].exists)
    }
    
    func testTappingDiapersShowsDiaperLogData() throws {
        app.buttons["Diapers"].tap()
        XCTAssertTrue(app.staticTexts["diaperTypeLabel"].exists)
    }
    
    //Test navigating to log data details page
    func testNavigateToDataDetailPageSleep() throws {
        app.buttons["Sleeping"].tap()
        
        let items = app.buttons.matching(identifier: "durationLabel")
        print(app.debugDescription)
        XCTAssertTrue(items.count > 0)
        
        let firstCell = items.firstMatch
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()
        
        XCTAssertTrue(app.staticTexts["durationLabel"].exists)
    }
    
    func testNavigateToDataDetailPageFeed() throws {
        app.buttons["Feeding"].tap()
        
        let items = app.buttons.matching(identifier: "bottleTypeLabel-amountLabel")
        //print(app.debugDescription)
        XCTAssertTrue(items.count > 0)
        
        let firstCell = items.firstMatch
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()
        
        XCTAssertTrue(app.staticTexts["bottleTypeLabel"].exists)
    }
    
    func testNavigateToDataDetailPageDiaper() throws {
        app.buttons["Diapers"].tap()
        
        let items = app.buttons.matching(identifier: "diaperTypeLabel")
        print(app.debugDescription)
        XCTAssertTrue(items.count > 0)
        
        let firstCell = items.firstMatch
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()
        
        XCTAssertTrue(app.staticTexts["diaperTypeLabel"].exists)
    }
    
    //Test to edit log data details page
    func testEditDataDetailPageSleep() throws {
        app.buttons["Sleeping"].tap()
        
        let items = app.buttons.matching(identifier: "durationLabel")
        let firstCell = items.firstMatch
        firstCell.tap()
        
        XCTAssertTrue(app.buttons["edit"].exists)
    
    //Test to delete log data detail
    
    //Test to navigate to add new entry page
    
    //Test to add new sleep entry + verify it was added to homepage
    
    //Test to add new feed entry + verify it was added to homepage
    
    //Test to add new diaper entry + verify it was added to homepage
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

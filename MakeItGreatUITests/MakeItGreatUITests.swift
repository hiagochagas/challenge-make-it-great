//
//  MakeItGreatUITests.swift
//  MakeItGreatUITests
//
//  Created by Tales Conrado on 17/11/20.
//

import XCTest

class MakeItGreatUITests: XCTestCase {
    func test_clickOnEachList_isWorking() {
        let app = XCUIApplication()
        app.activate()
        
        let collectionViewsQuery = XCUIApplication().collectionViews
        let zeroButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Next"]/*[[".cells.staticTexts[\"Next\"]",".staticTexts[\"Next\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(zeroButton.isHittable)
        zeroButton.tap()
        let firstButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Inbox"]/*[[".cells.staticTexts[\"Inbox\"]",".staticTexts[\"Inbox\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(firstButton.isHittable)
        firstButton.tap()
        let secondButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Maybe"]/*[[".cells.staticTexts[\"Maybe\"]",".staticTexts[\"Maybe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(secondButton.isHittable)
        secondButton.tap()
        let thirdButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Waiting"]/*[[".cells.staticTexts[\"Waiting\"]",".staticTexts[\"Waiting\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(thirdButton.isHittable)
        thirdButton.tap()
        let fourthButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Projects"]/*[[".cells.staticTexts[\"Projects\"]",".staticTexts[\"Projects\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(fourthButton.isHittable)
        fourthButton.tap()
    }
    
    func test_SegmentedControl_isWorking() {
        let app = XCUIApplication()
        app.activate()
        
        let firstButton = app.tabBars["Tab Bar"].buttons["Progress"]
        XCTAssertTrue(firstButton.isHittable)
        firstButton.tap()
        let secondButton = app.buttons["Milestones"]
        XCTAssertTrue(secondButton.isHittable)
        secondButton.tap()
        let thirdButton = app.buttons["Calendar"]
        XCTAssertTrue(thirdButton.isHittable)
        thirdButton.tap()
        
    }
    
}

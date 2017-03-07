//
//  BoTree911_memberTests.swift
//  BoTree911_memberTests
//
//  Created by piyushMac on 16/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import XCTest
@testable import BoTree911_member

class BoTree911_memberTests: XCTestCase {
    
    var vcLogin: LoginViewController!
    var vcTicketDetail: TicketDetailViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vcLogin = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vcTicketDetail = storyboard.instantiateViewController(withIdentifier: "TicketDetailViewController") as! TicketDetailViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsEmailValidate() {// Check Email formate
        if "sp@gmail.com".isValidEmail() {
            XCTAssert(true,"Valid Email")
        } else {
            XCTAssert(false, "Invalid Email")
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.vcTicketDetail.viewDidLoad()
        }
    }
    
}

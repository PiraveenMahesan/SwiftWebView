//
//  IdentosInterviewTests.swift
//  IdentosInterviewTests
//
//  Created by Piraveen Mahesan on 2024-10-30.
//

import XCTest
@testable import IdentosInterview

final class IdentosInterviewTests: XCTestCase {
    
    var webViewModel: WebViewModel!

    override func setUpWithError() throws {
        super.setUp()
               webViewModel = WebViewModel()
    }

    override func tearDownWithError() throws {
        webViewModel = nil
               super.tearDown()
    }
            
            //Sample Unit Test to check valid URL is loading correctly 
    func testValidURLLoading() {
        let validURL = "https://www.google.com/"
        webViewModel.loadURL(urlString: validURL)
        XCTAssertEqual(webViewModel.webView.url?.absoluteString, validURL)
    }


}

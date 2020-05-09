//
//  UtilsTests.swift
//  BeatBlenderTests
//
//  Created by 김선웅 on 2020/05/10.
//  Copyright © 2020 novdov. All rights reserved.
//

import Foundation
import XCTest

@testable import BeatBlender

class UtilsTests: XCTestCase {
    func testMapToRequestBodyString() throws {
        let body: [String:Any] = ["query1": "value1", "query2": 2]
        let expectedBodyString = "query1=value1&query2=2"
        
//        let bodyString = mapToRequestBodyString(body)
        
        XCTAssertEqual(mapToRequestBodyString(body), expectedBodyString)
    }
}

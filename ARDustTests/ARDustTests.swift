//
//  ARDustTests.swift
//  ARDustTests
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import XCTest
@testable import ARDust

class ARDustTests: XCTestCase {
    // 1. SUT(System Under Test)
    var dustUnderTest: DustMeasure!
    // 2.
    override func setUp() {
        super.setUp()
          // SUT 객체 생성과 동작하는 코드 기입
        dustUnderTest = DustMeasure()
        dustUnderTest.startMeasure()
            // 초미세먼지 추가 + 30
          dustUnderTest.addUltraDust(30)
    }
    // 3.
    override func tearDown() {
        super.tearDown()
           // SUT 객체 해제
        dustUnderTest = nil
    }
    // 4.
    func testScoreIsComputed() {
        // given
        let guess = dustUnderTest.totalDust - 10    // error를 발생시키기 위한 임의의 추측값
        // when
        let difference = dustUnderTest.check(guess: guess)
        // then
        XCTAssertEqual(difference, 0, "차이가 0이 아니므로, 예측한 미세먼지 총량이 다릅니다.")
        
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}

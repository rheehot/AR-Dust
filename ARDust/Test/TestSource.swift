//
//  TestSource.swift
//  ARDust
//
//  Created by youngjun goo on 2019/10/18.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation

class DustMeasure {
    var time = 0
    var totalDust = 0   // 초기 미세먼지 양
    var ultraDust = 0 // 초미세먼지 양
    
    // 측정 시작
    func startMeasure() {
        time = 0
          totalDust = 50
    }
    // dust 정보 가져온다 가정
    func addUltraDust(_ dust: Int) {
        time = time + 1 // 시간은 늘어나고
        ultraDust += dust // 기존의 초미세먼지에 추가적으로 더한다.
        totalDust += ultraDust // 초기미세먼지양에 초미세먼지의 양을 더한다.
    }
    
    func check(guess: Int) -> Int {
          // 추측값과 실제 값의 차이를 반환한다.
        return totalDust - guess
    }
}

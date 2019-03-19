//
//  LocationCoordinate.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation


class LocationCoordinate {
    private let pi = Double.pi
    private let semiMinorAxisA = 6377397.155          // 장반경a
    private let flatteningF = 0.00334277318217481     // 편평률f
    private var semiMinorAxisB: Double = 0.0                // 단반경b
    private let originScaleFactorKo = 1.0             // 원점축척계수ko
    private let originAdditionValueX = 500000.0       // 원점가산값X(N), if 제주도 = 550000
    private let originAdditionValueY = 200000.0       // 원점가산값Y(E)
    private let originLatitude = 38.0                 // 원점위도
    private let originLongitude = 127.0               // 원점경도
    private var firstEccentricty: Double = 0.0              // 제1이심률e^2
    private var secondEccentricty: Double = 0.0             // 제2이심률e'^2
    private var originLatitudeRadian: Double = 0.0          // 원점위도 라디안
    private var originLongitudeRadian: Double = 0.0         // 원점경도 라디안
    private var originMeridianMo: Double = 0.0              // 원점자오선호장MO
    private var originMeridianE1: Double = 0.0              // 원점자오선호장e1
    private let correction10405Seconds = 0.0          // 10.405초 보정
    
    init() {
        semiMinorAxisB = semiMinorAxisA * (1 - flatteningF)
        firstEccentricty = (pow(semiMinorAxisA, 2) - pow(semiMinorAxisB, 2)) / pow(semiMinorAxisA, 2)
        secondEccentricty = (pow(semiMinorAxisA, 2) - pow(semiMinorAxisB, 2)) / pow(semiMinorAxisB, 2)
        originLatitudeRadian = originLatitude / 180 * pi
        originLongitudeRadian = originLongitude / 180 * pi
        originMeridianMo = semiMinorAxisA * ((1 - firstEccentricty / 4 - 3 * pow(firstEccentricty, 2) / 64 - 5 * pow(firstEccentricty, 3) / 256) * originLatitudeRadian - (3 * firstEccentricty / 8 + 3 * pow(firstEccentricty, 2) / 32 + 45 * pow(firstEccentricty, 3) / 1024) * sin(2 * originLatitudeRadian) + (15 * pow(firstEccentricty, 2) / 256 + 45 * pow(firstEccentricty, 3) / 1024) * sin(4 * originLatitudeRadian) - (35 * pow(firstEccentricty, 3) / 2072) * sin(6 * originLatitudeRadian))
        originMeridianE1 = (1 - sqrt(1 - firstEccentricty)) / (1 + sqrt(1 - firstEccentricty))
    }
    
    //경위도 좌표 -> TM 좌표
    func convertToPlaneRect(latitude: Double, longitude: Double) -> (Double, Double) {
        // Φ, PHI
        let phi = latitude / 180 * pi
        // λ, LAMDA
        let lamda = (longitude - correction10405Seconds) / 180 * pi
        // T
        let t = pow(tan(phi), 2)
        // C
        let c = (firstEccentricty / (1 - firstEccentricty)) * pow(cos(phi), 2)
        // A
        let a = (lamda - (originLongitude / 180 * pi)) * cos(phi)
        // N
        let n = semiMinorAxisA / sqrt(1 - firstEccentricty * pow(sin(phi), 2))
        // M
        let m = semiMinorAxisA * ((1 - firstEccentricty / 4 - 3 * pow(firstEccentricty, 2) / 64 - 5 * pow(firstEccentricty, 3) / 256) * phi - (3 * firstEccentricty / 8 + 3 * pow(firstEccentricty, 2) / 32 + 45 * pow(firstEccentricty, 3) / 1024) * sin(2 * phi) + (15 * pow(firstEccentricty, 2) / 256 + 45 * pow(firstEccentricty, 3) / 1024) * sin(4 * phi) - 35 * pow(firstEccentricty, 3) / 3072 * sin(6 * phi))
        // X, TM X(N)
        let x = originAdditionValueY + originScaleFactorKo * n * (a + pow(a, 3) / 6 * (1 - t + c) + pow(a, 5) / 120 * (5 - 18 * t + pow(t, 2) + 72 * c - 58 * secondEccentricty))
        // Y, TM Y(E)
        let y = originAdditionValueX + originScaleFactorKo * (m - originMeridianMo + n * tan(phi) * (pow(a, 2) / 2 + pow(a, 4) / 24 * (5 - t + 9 * c + 4 * pow(c, 2)) + pow(a, 6) / 720 * (61 - 58 * t + pow(t, 2) + 600 * c - 330 * secondEccentricty)))
        return (x, y)
    }
}

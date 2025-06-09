//
//  CLLocation+.swift
//  SCMLocation
//
//  Created by Lee Wonsun on 6/8/25.
//

import Foundation
import CoreLocation

public extension CLLocation {
    func distanceInKm(from location: CLLocation) -> String {
        let distance = self.distance(from: location) / 1000.0
        return String(format: "%.2f", distance) + "km"
    }
    
    func intDistanceInM(from location: CLLocation) -> Int {
        let distance = self.distance(from: location)
        return Int(distance.rounded())
    }
}

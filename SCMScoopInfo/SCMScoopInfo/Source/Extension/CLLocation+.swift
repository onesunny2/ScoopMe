//
//  CLLocation+.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/28/25.
//

import CoreLocation

extension CLLocation {
    func distanceInKm(from location: CLLocation) -> String {
        let distance = self.distance(from: location) / 1000.0
        return String(format: "%.2f", distance) + "km"
    }
}

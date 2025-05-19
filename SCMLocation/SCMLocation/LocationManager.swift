//
//  LocationManager.swift
//  SCMLocation
//
//  Created by Lee Wonsun on 5/19/25.
//

import SwiftUI
import Combine
import CoreLocation
import SCMLogger

public final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    public override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// 현재 시스템 설정 자체 권한 상태 확인
    public func checkDeviceCondition() async {
        if CLLocationManager.locationServicesEnabled() {
            // 활성화 되었으면 허용 케이스 나누고
            await checkPermission()
        } else {
            // 앱 시작했을 때는 바로 설정앱으로 보내지 않음. 나중에 주소를 바꾸던지 뭔가 하려고 할 때 요청
            Log.info("사용자 위치 권한 서비스 미설정")
        }
    }
    
    /// 현재 시스템 설정 권한 없거나, 허용을 denied 했을 때 설정하도록 보내기
    public func sendSettinApp() async {
        guard !CLLocationManager.locationServicesEnabled() || manager.authorizationStatus == .denied else { return }
        
        await openSettings()
    }
    
    /// 현재 위치 요청
    public func getCurrentLocation() async {
        guard CLLocationManager.locationServicesEnabled() else {
            Log.debug("위치권한 서비스 미설정")
            await openSettings()
            return
        }
        
        let authStatus = manager.authorizationStatus
        guard authStatus != .denied else {
            Log.debug("위치권한 서비스 미설정")
            await openSettings()
            return
        }
        
        manager.startUpdatingLocation()
    }
    
    /// 위치 업데이트 중지
    public func stopUpdateLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationManager {
    
    /// 위치정보 제공 허용 범위
    @MainActor
    private func checkPermission() {
        switch manager.authorizationStatus {
        case .notDetermined:  // 앱 첫시작 or 한번만 허용 (권한 상태가 정해지지 않음)
            Log.debug("위치 권한 아직 미정")
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .denied:  // 위치 권한 거부 -> 나중에 권한 거부 상태이면 인터렉션 할 때 다 alert창 띄울 것
            Log.debug("위치 권한 거부 - 추후 알럿창 알림")
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            Log.debug("위치 권한 항상 허용")
        default:
            Log.error("알 수 없는 위치 권한 상태 입니다")
        }
    }
    
    /// 위치 좌표를 주소로 변환
    private func getGeocodeLacation(_ location: CLLocation) async throws -> String {
        
        let placemarks = try await LocationManager.geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first else {
            Log.error("주소 정보 없음")
            throw GeoLocationError.noAddressFound
        }
        
        return formatAddress(from: placemark)
    }
    
    /// placemark 주소 포맷팅
    private func formatAddress(from placemark: CLPlacemark) -> String {
        
        var components = [String]()
        
        // 국가
        if let country = placemark.country { components.append(country) }
        
        // 시도
        if let administrativeArea = placemark.administrativeArea { components.append(administrativeArea) }
        
        // 구/군
        if let locality = placemark.locality { components.append(locality) }
        
        // 도로명
        if let thoroughfare = placemark.thoroughfare {
            var thoroughfareComponent = thoroughfare
            
            // 번지
            if let subThoroughfare = placemark.subThoroughfare {
                thoroughfareComponent += " \(subThoroughfare)"
            }
            
            components.append(thoroughfareComponent)
        }
        
        return components.joined(separator: " ")
    }
}

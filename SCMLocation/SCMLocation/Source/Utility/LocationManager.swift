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

public final class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    static let geocoder = CLGeocoder()
    
    @Published public var currentLocation: CLLocation
    @Published public var currentAddress: String = ""
    @Published public var isLoading: Bool = false
    @Published public var permissionStatus: Bool = true
    @Published public var showAlert: Bool = false
    
    public var alertMessage: String = "현재 위치를 찾기 위해서는 설정 앱에서 위치 권한 설정이 필요합니다.\n확인을 누르면 설정으로 이동합니다."
    
    private let addressStorageKey: String = "savedAddresses"
    private let selectedAddressKey: String = "selectedAddress"
    
    public override init() {
        
        let selectedAddress = UserDefaults.standard.fetchStruct(SavedLocation.self, for: selectedAddressKey)
        self.currentLocation = CLLocation(
            latitude: selectedAddress?.latitude ?? 37.6527579,
            longitude: selectedAddress?.longitude ?? 127.0463256
        )
        
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        applyGeoAddress()
    }
    
    /// 현재 시스템 설정 자체 권한 상태 확인
    public func checkDeviceCondition() async {
        
        await updatePermissionStatus()
        
        if CLLocationManager.locationServicesEnabled() {
            // 활성화 되었으면 허용 케이스 나누고
            await checkPermission()
        } else {
            // 앱 시작했을 때는 바로 설정앱으로 보내지 않음. 나중에 주소를 바꾸던지 뭔가 하려고 할 때 요청
            Log.info("사용자 위치 권한 서비스 미설정")
        }
    }
    
    /// 디바이스 시스템 위치서비스 활성화 위해 설정 앱으로 이동
    @MainActor
    public func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url) { success in
                if success { Log.debug("설정앱 이동 성공")  } else { Log.error("설정 앱 이동 실패") }
            }
        }
    }
    
    /// 현재 위치 요청
    @MainActor
    public func startCurrentLocation() async {
        
        await updatePermissionStatus()
        
        guard !permissionStatus else {
            showAlert = true
            return
        }
        
        isLoading = true
        manager.startUpdatingLocation()
    }
    
    /// 위치 업데이트 중지
    public func stopUpdateLocation() {
        manager.stopUpdatingLocation()
        isLoading = false
    }
    
    public func updatePermissionStatus() async {
        
        // locationServicesEnabled >> 이 작업을 메인스레드에서 돌아가도록 하면 안됨
        let locationServicesEnabled = await Task.detached {
            return CLLocationManager.locationServicesEnabled()
        }.value
        
        await MainActor.run {
            permissionStatus = !locationServicesEnabled || manager.authorizationStatus == .denied
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    /// 사용자 위치 획득 성공 후 실행
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = locations.last?.coordinate else { return }
        
        currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        Log.debug("현재위치: \(currentLocation)")
        
        applyGeoAddress()
        stopUpdateLocation()
    }
    
    /// 사용자 위치 획득에 실패한 경우 (서비스 설정 거부)
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        Log.error("사용자 위치 업데이트 실패")
        stopUpdateLocation()
    }
    
    /// 권한 변경 일어나면 다시 체크
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task {
            await checkPermission()
        }
    }
}

extension LocationManager {
    
    /// 위치정보 제공 허용 범위
    @MainActor
    private func checkPermission() {
        switch manager.authorizationStatus {
        case .notDetermined:  // 앱 첫시작 or 한번만 허용 (권한 상태가 정해지지 않음)
            Log.debug("위치 권한 아직 미정")
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
    
    /// 주소 -> @published 변수에 적용
    private func applyGeoAddress() {
        Task {
            do {
                let address = try await getGeocodeLacation(currentLocation)
                await MainActor.run {
                    self.currentAddress = address
                }
            } catch {
                Log.error("주소 변환 실패: \(error)")
            }
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

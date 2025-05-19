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
    
    /// 디바이스 시스템 위치서비스 활성화 위해 설정 앱으로 이동
    @MainActor
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url) { success in
                if success { Log.debug("설정앱 이동 성공")  } else { Log.error("설정 앱 이동 실패") }
            }
        }
    }
    
}

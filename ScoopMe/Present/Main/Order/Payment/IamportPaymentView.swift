//
//  IamportPaymentView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/11/25.
//

import SwiftUI
import WebKit
import iamport_ios
import SCMLogger

struct IamportPaymentView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    let paymentInfo: PaymentInfo
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = IamportPaymentViewController()
        view.paymentInfo = paymentInfo
        view.dismissAction = dismiss
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

final class IamportPaymentViewController: UIViewController, WKNavigationDelegate {
    
    var paymentInfo: PaymentInfo?
    var dismissAction: DismissAction?
    
    private lazy var wkWebView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .clear
        view.navigationDelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWebView()
        
        // 결제 정보가 있으면 결제 요청 시작
        if let payInfo = paymentInfo {
            requestIamportPayment(payInfo: payInfo)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeWebView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Iamport.shared.close()
        dismissAction?()
        SCMSwitcher.shared.switchTo(.login)
    }
    
    private func setupWebView() {
        view.addSubview(wkWebView)
        wkWebView.frame = view.frame
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        wkWebView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        wkWebView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wkWebView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func removeWebView() {
        view.willRemoveSubview(wkWebView)
        wkWebView.stopLoading()
        wkWebView.removeFromSuperview()
        wkWebView.uiDelegate = nil
        wkWebView.navigationDelegate = nil
    }
    
    // SDK 결제 요청
    func requestIamportPayment(payInfo: PaymentInfo) {
        let userCode = Secret.iamportUsercode
        let payment = createPaymentData(payInfo: payInfo)
        
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: userCode,
            payment: payment) { [weak self] response in
                guard let self, let response else { return }
                
                Log.debug("🔗 결제 결과: \(String(describing: response))")
                
                // 결제가 success 하면 결제 uid 전달
                let impUid = (response.success == true) ? response.imp_uid : nil
                payInfo.onPaymentComplete(impUid)
                
                if response.success == true {
                    showPaymentSuccessAlert {
                        self.dismissAction?()
                    }
                } else {
                    self.dismissAction?()
                }
            }
    }
    
    private func createPaymentData(payInfo: PaymentInfo) -> IamportPayment {
        return IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: payInfo.orderCode,
            amount: payInfo.totalPrice
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = payInfo.storeName
            $0.buyer_name = "이원선"
            $0.app_scheme = "scoopme"
        }
    }
    
    // 결제 성공 시 띄울 알럿창
    private func showPaymentSuccessAlert(completion: @escaping () -> ()) {
        let alert = UIAlertController(
            title: "결제 완료",
            message: "결제가 성공적으로 완료되었습니다.",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "닫기", style: .default) { _ in
            completion()
        }
        
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
}

// 결제 단계에서 필요한 정보
struct PaymentInfo: Identifiable {
    let id = UUID()
    let storeName: String
    let orderCode: String
    let totalPrice: String
    let onPaymentComplete: (String?) -> Void
}

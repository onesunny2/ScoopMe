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
    let paymentInfo: PaymentInfo
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = IamportPaymentViewController()
        view.paymentInfo = paymentInfo
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

final class IamportPaymentViewController: UIViewController, WKNavigationDelegate {
    
    var paymentInfo: PaymentInfo?
    var presentationMode: Binding<PresentationMode>?
    
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
        print(#function)
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
        presentationMode?.wrappedValue.dismiss()
    }
    
    private func setupWebView() {
        print(#function)
        view.addSubview(wkWebView)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func removeWebView() {
        print(#function)
        view.willRemoveSubview(wkWebView)
        wkWebView.stopLoading()
        wkWebView.removeFromSuperview()
        wkWebView.uiDelegate = nil
        wkWebView.navigationDelegate = nil
    }
    
    // SDK 결제 요청
    func requestIamportPayment(payInfo: PaymentInfo) {
        print(#function)
        let userCode = Secret.iamportUsercode
        let payment = createPaymentData(payInfo: payInfo)
        
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: userCode,
            payment: payment) { [weak self] response in
                guard self != nil else { return }
                Log.debug("🔗 결제 결과: \(String(describing: response))")
            }
    }
    
    private func createPaymentData(payInfo: PaymentInfo) -> IamportPayment {
        print(#function)
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
}

// 결제 단계에서 필요한 정보
struct PaymentInfo: Identifiable {
    let id = UUID()
    let storeName: String
    let orderCode: String
    let totalPrice: String
}

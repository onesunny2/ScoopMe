//
//  SignUpView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject private var route: Router
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var checkPW: String = ""
    @State private var nickname: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var alertMessage: String = ""
    
    @State private var showAlert: Bool = false
    @State private var isComplete: Bool = false
    
    private let signupManager = SignUpManager.shared
    
    var body: some View {
        ZStack {
            Color.scmBrightSprout
                .ignoresSafeArea()
            
            vstackContents
        }
        .backButton(.scmBlackSprout)
        .navigationRightItem {
            Image(.homeFill)
                .basicImage(width: 25, color: .scmBlackSprout)
                .asButton {
                    route.popToLoginRoot()
                }
        }
        .showAlert(
            isPresented: $showAlert,
            title: EmailDuplication.title.string,
            message: alertMessage
        )
    }
    
    private var vstackContents: some View {
        VStack(alignment: .center, spacing: 28) {
            Text(StringLiterals.title.text)
                .basicText(.JNLargeTitle2, .scmBlackSprout)
            
            textfields
            
            signupButton
        }
        .defaultHorizontalPadding()
    }
    
    private var textfields: some View {
        VStack(alignment: .leading) {
            // 이메일
            requiredText(.email)
            LoginTextFieldCell(
                text: $email,
                placeholder: StringLiterals.email.placeholder
            )
            .overlay(alignment: .trailing) {
                emailValidationButton
                    .padding(.trailing, 10)
            }
            
            // 비밀번호
            requiredText(.password).padding(.top, 12)
            LoginSecureFieldCell(
                text: $password,
                placeholder: StringLiterals.password.placeholder
            )
            
            HStack {
                Spacer()
                Text(StringLiterals.punctuation.placeholder)
                    .basicText(.PTBody3, .scmGray75)
            }.padding(.top, 2)
            
            // 비밀번호 확인
            requiredText(.checkPw).padding(.top, 12)
            LoginSecureFieldCell(
                text: $checkPW,
                placeholder: StringLiterals.checkPw.placeholder
            )
            
            // 닉네임
            requiredText(.nickname).padding(.top, 12)
            LoginTextFieldCell(
                text: $nickname,
                placeholder: StringLiterals.nickname.placeholder
            )
            
            // 휴대전화
            Text(StringLiterals.phoneNum.text)
                .basicText(.PTBody1, .scmGray75)
                .padding(.top, 12)
            LoginTextFieldCell(
                text: $phoneNumber,
                placeholder: StringLiterals.phoneNum.placeholder
            )
        }
    }
    
    private var signupButton: some View {
        NextButtonCell(
            title: StringLiterals.signup.text,
            buttonColor: isComplete ? .scmBlackSprout : .scmGray45
        )
        .asButton {
            // TODO: 테스트용 코드
            isComplete.toggle()
        }
    }
    
    private func requiredText(_ type: StringLiterals) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(type.text)
                .basicText(.PTBody1, .scmGray75)
            
            Text("*")
                .basicText(.PTBody1, .scmBlackSprout)
        }
    }
    
    private var emailValidationButton: some View {
        Text(StringLiterals.emailValidation.text)
            .basicText(.PTBody3, .scmGray15)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.scmDeepSprout)
                )
            .asButton {
                Log.info("중복확인 버튼 클릭")
                
                Task {
                    let result = await signupManager.postEmailValidation(email)
                    alertMessage = result.message
                    
                    showAlert = true
                }
            }
    }
}

private enum StringLiterals: String {
    case title = "회원가입"
    case email = "이메일"
    case password = "비밀번호"
    case checkPw = "비밀번호 확인"
    case nickname = "닉네임"
    case phoneNum = "휴대전화"
    case signup = "가입하기"
    case punctuation
    case emailValidation = "중복확인"
    case completeValidation = "사용가능"
    
    var text: String {
        return self.rawValue
    }
    
    var placeholder: String {
        switch self {
        case .password:
            return "8자 이상, 영문/슷자/특수문자 1개 이상 포함"
        case .nickname:
            return ". , ? * - @는 사용할 수 없습니다."
        case .phoneNum:
            return "-는 제외하고 적어주세요 (예: 01012345678)"
        case .punctuation:
            return "* 특수문자: @, $, !, %, *, #, ?, &"
        default: return ""
        }
    }
}

#Preview {
    SignUpView()
}

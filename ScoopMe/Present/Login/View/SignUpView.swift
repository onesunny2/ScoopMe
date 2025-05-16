//
//  SignUpView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI
import SCMLogger
import SCMLogin

struct SignUpView: View {
    
    @EnvironmentObject private var route: Router
    @StateObject private var signupManager = SignUpManager()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var checkPW: String = ""
    @State private var nickname: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var checkEmailText: Bool = false
    @State private var showAlert: Bool = false
    private var completeSignup: Bool {
        return signupAvailable()
    }
    
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
            title: signupManager.alertTitle,
            message: signupManager.alertMessage
        )
        .showAlert(
            isPresented: $signupManager.successSignup,
            title: StringLiterals.signupAlertTitle.text,
            message: StringLiterals.signupAlertMessage.text,
            action: {
                route.popLoginRoute()
            }
        )
        .lowercaseTextfield($email) {
            // 이메일에 대한 변경사항 있으면 다시 중복확인 하도록 초기화 해야 함
            signupManager.emailAvailable = false
        }
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
            HStack(alignment: .center) {
                requiredText(.email)
                Spacer()
                Text(checkEmailForm() ? StringLiterals.empty.text : StringLiterals.noEmail.text)
                    .basicText(.PTBody3, email.isEmpty ? .clear : (checkEmailForm() ? .blue : .red))
            }
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
            HStack(alignment: .center) {
                requiredText(.checkPw)
                Spacer()
                Text((password == checkPW) ? StringLiterals.empty.text : StringLiterals.noPW.text)
                    .basicText(.PTBody3, checkPW.isEmpty ? .clear : ((password == checkPW) ? .blue : .red))
            }.padding(.top, 12)
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
            buttonColor: completeSignup ? .scmBlackSprout : .scmGray45
        )
        .asButton (
            {
                Log.debug("회원가입 버튼 클릭")
                
                Task {
                    await signupManager.postSignupValidation(
                        email,
                        password,
                        nickname,
                        phoneNumber
                    )
                }
            },
            disabled: !completeSignup)
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
        Text(
            signupManager.emailAvailable ? StringLiterals.completeValidation.text :  StringLiterals.emailValidation.text
        )
        .basicText(.PTBody3, signupManager.emailAvailable ? .scmBlackSprout : .scmGray15)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(checkEmailForm() ? (signupManager.emailAvailable ? .scmGray45 : .scmBlackSprout) : .scmGray45)
        )
        .asButton ({
            Log.info("중복확인 버튼 클릭")
            
            Task {
                await signupManager.postEmailValidation(email)
                showAlert = true
            }
        }, disabled: !(checkEmailForm() && !signupManager.emailAvailable))
    }
}


// MARK: Methods
extension SignUpView {
    
    /// 이메일 text 형식 확인
    private func checkEmailForm() -> Bool {
        
        guard !email.isEmpty else { return false }
        
        guard !containsKorean() else { return false }
        
        // @ 기호 기준으로 분리
        let parts = email.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false)
        
        // @가 1개인지 확인
        guard parts.count == 2 else { return false }
        
        let localPart = parts[0]
        let domainPart = parts[1]
        
        guard !localPart.isEmpty && !domainPart.isEmpty else { return false }
        
        // local part의 .이 시작과 끝에 있는지 확인
        guard !localPart.hasPrefix(".") && !localPart.hasSuffix(".") else { return false }
        
        // domain part의 .이 시작과 끝에 있는지 확인
        guard !domainPart.hasPrefix(".") && !domainPart.hasSuffix(".") else { return false }
        
        // 뒤에 .이 최소 1개인지
        guard domainPart.contains(".") else { return false }
        
        return true
    }
    
    /// 한글 포함여부
    private func containsKorean() -> Bool {
        let range = email.range(of: "[ㄱ-ㅎㅏ-ㅣ가-힣]", options: .regularExpression)
        return range != nil
    }
    
    /// 회원가입 가능 여부
    private func signupAvailable() -> Bool {
        
        // 각 텍스트 필드 공백X + 이메일 중복확인 통과
        guard !email.isEmpty && !password.isEmpty && !checkPW.isEmpty && !nickname.isEmpty && signupManager.emailAvailable && (password == checkPW) else { return false }
        
        return true
    }
}

private enum StringLiterals: String {
    case empty = ""
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
    case noEmail = "이메일이 올바른지 확인해주세요"
    case noPW = "비밀번호가 일치하지 않습니다"
    case signupAlertTitle = "완료"
    case signupAlertMessage = "회원가입이 완료되었습니다. 로그인 후 서비스 사용이 가능합니다."
    
    var text: String {
        return self.rawValue
    }
    
    var placeholder: String {
        switch self {
        case .email:
            return "이메일은 모두 소문자로 작성해주세요."
        case .password:
            return "8자 이상, 영문/숫자/특수문자 1개 이상 포함"
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

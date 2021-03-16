//
//  LoginModel.swift
//  Voiceses
//
//  Created by Radi Barq on 14/03/2021.
//

import Foundation
import CryptoKit
import AuthenticationServices
import FirebaseAuth

class LoginViewModel: ObservableObject {
    
    @Published var currentNonce:String?
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    let alertTitle = "Oops!"
    let alertDismissButtonTitle = "Got it!"
    
    func signinWithAppleOnRequestHandler(request: ASAuthorizationAppleIDRequest) {
        let nounce = randomNonceString()
        currentNonce = nounce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nounce)
    }
    
    func signinWithAppleOnCompletionHandler(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                guard let nounce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                
                guard let appleIDToken = appleIDCredential.identityToken else {
                    fatalError("Invalid state: A login callback was received, but identity token is not available")
                }
                
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    fatalError("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nounce)
                Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                    guard let weakSelf = self else { return }
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                        weakSelf.showAlert(with: "An error happened while sign in, please try again later.")
                        return
                    }
                    
                    print("Login")
                }
            default:
                break
            }
        case .failure(let error):                              print(error.localizedDescription)
            showAlert(with: "An error happened while sign in, please try again later.")
            break
        }
    }
    
    // From https://firebase.google.com/docs/auth/ios/apple
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    //Hashing function using CryptoKit
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func showAlert(with message: String) {
        showingAlert = true
        alertMessage = message
    }
}

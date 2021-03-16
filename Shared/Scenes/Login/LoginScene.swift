//
//  LoginScene.swift
//  Voiceses
//
//  Created by Radi Barq on 13/03/2021.
//

import SwiftUI
import AuthenticationServices

struct LoginScene: View {
    @StateObject private var loginViewModel: LoginViewModel = LoginViewModel()
    
    @ViewBuilder
    var body: some View {
        #if os(iOS)
        content
        #else
        content
            .frame(minWidth: 1000, minHeight: 800)
        
        #endif
    }
    
    var content: some View {
        return GeometryReader { geometry in
            VStack {
                VStack() {
                    Text("VOICΞSΞS")
                        .font(.system(size: geometry.size.width/8, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .padding(.horizontal, 16)
                
                
                Text("80 hours of courses for SwiftUI")
                    .font(.title3)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                VStack {
                    SignInWithAppleButton(
                        onRequest: { request in
                            loginViewModel.signinWithAppleOnRequestHandler(request: request)
                        },
                        onCompletion: { result in
                            loginViewModel.signinWithAppleOnCompletionHandler(result: result)
                        }
                    )
                }
                .frame(width: geometry.size.width / 1.5, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding()
                Spacer()
            }
            .frame(height: geometry.size.height / cardMaxHeightFactor)
            .frame(maxWidth: .infinity)
            .padding(.top, 75)
            .background(
                Image("girl-sitting-with-phone")
                    .resizable()
                    .frame(width: geometry.size.height / 4.2, height: geometry.size.height / 4.2, alignment: .bottom)
                    .opacity(showBottomImage ? 1 : 0)
                , alignment: .bottom)
            .background(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous))
            .alert(isPresented: $loginViewModel.showingAlert) {
                Alert(title: Text(loginViewModel.alertTitle), message: Text(loginViewModel.alertMessage), dismissButton: .default(Text(loginViewModel.alertDismissButtonTitle)))
            }
            Spacer()
        }
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginScene()
                .previewDevice("iPhone 12 Pro Max")
            LoginScene()
                .previewDevice("iPhone 11")
        }
    }
}

private extension LoginScene {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalClass
    #endif
    
    private var cardCornerRadius: CGFloat {
        #if os(iOS)
        return 25
        #else
        return 0
        #endif
    }
    
    private var cardMaxHeightFactor: CGFloat {
        #if os(iOS)
        return 1.5
        #else
        return 1.3
        #endif
    }
    
    private var showBottomImage: Bool {
        #if os(iOS)
        return horizontalClass == .compact
        #else
        return true
        #endif
    }
}

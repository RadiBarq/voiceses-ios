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
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalClass
    #endif
    
    var body: some View {
        #if os(iOS)
        content
        #else
        content
            .frame(minWidth: 1000, minHeight: 800)
        #endif
    }
    
    private var content: some View {
        GeometryReader { geometry in
            VStack {
                Text("VOICΞSΞS")
                    .font(.system(size: geometry.size.width/8, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Keep your school records simply organized")
                    .font(.title3)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                SignInWithAppleButton(
                    onRequest: { request in
                        loginViewModel.signinWithAppleOnRequestHandler(request: request)
                    },
                    onCompletion: { result in
                        loginViewModel.signinWithAppleOnCompletionHandler(result: result)
                    }
                )
                .frame(width: geometry.size.width / 1.5, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
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
            .background(Color.accent)
            .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous))
            Spacer()
        }
        .alert(isPresented: $loginViewModel.showingAlert) {
            Alert(title: Text(self.alertTitle),
                  message: Text(loginViewModel.alertMessage),
                  dismissButton: .default(Text(alertDismissButtonTitle)))
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

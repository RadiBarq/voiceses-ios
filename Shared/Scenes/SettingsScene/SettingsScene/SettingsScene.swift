//
//  SettingsScene.swift
//  Voiceses
//
//  Created by Radi Barq on 28/03/2021.
//

import SwiftUI

struct SettingsScene: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Section() {
                HStack {
                    Text("Email:")
                        .foregroundColor(Color.accent)
                    Text(FirebaseAuthenticationService.getUserEmail() ?? "")
                }
            }
            
            Section() {
                Button("Send feedback") {
                    viewModel.showMailScene()
                }
                
                Button("A word from the creator") {
                    viewModel.isShowingAboutTheCreatorScene.toggle()
                }
            }
            
            Section() {
                HStack {
                    Text("Version:")
                        .foregroundColor(Color.accent)
                    Text("1.0.0")
                       
                }
                Button("Logout") {
                    viewModel.logout()
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .foregroundColor(Color.accent)
            }
        }
        .sheet(isPresented: $viewModel.isShowingMailScene) {
            MailView(isShowing: $viewModel.isShowingMailScene,
                     result: $viewModel.sendingFeedbackResult)
        }
        .sheet(isPresented: $viewModel.isShowingAboutTheCreatorScene) {
            aboutTheCreatorText
                .padding()
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(alertTitle),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text(alertDismissButtonTitle)))
        }
    }
    
    private var aboutTheCreatorText: Text {
        Text("My name is Radi Barq from Palestine. I have been working as an iOS developer professionally for more than two years. I love to create iOS apps that I think are useful for people and make their lives easier. When I was at the university, I looked for an app that's easy to create flashcards using Apple pencil and quickly create daily tests. I did not find that app back then, so I decided to develop VOICΞSΞS app after I graduated from university so other students could create flashcards easily. Thank you for choosing the VOICΞSΞS app, and I hope you enjoy it.")
            .font(.headline)
    }
}

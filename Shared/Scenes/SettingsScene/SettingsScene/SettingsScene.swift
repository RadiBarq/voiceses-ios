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
                    Text("radibaraq@gmail.com")
                }
            }
            .padding()
            
            Section() {
                Button("Send feedback") {
                    viewModel.showMailScene()
                }
                
                Button("About the creator") {
                    viewModel.isShowingAboutTheCreatorScene.toggle()
                }
            }
            .padding()
            
            Section() {
                HStack {
                    Text("Version:")
                    Text("1.0.0")
                        .foregroundColor(Color.accent)
                }
                Button("Logout") {
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .foregroundColor(Color.accent)
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.isShowingMailScene) {
            MailView(isShowing: $viewModel.isShowingMailScene,
                     result: $viewModel.sendingFeedbackResult)
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(alertTitle),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text(alertDismissButtonTitle)))
        }
    }
}

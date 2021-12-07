//
//  SettingsViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 07/12/2021.
//

import Foundation
import MessageUI

class SettingsViewModel: ObservableObject {
    @Published var isShowingMailScene = false
    @Published var isShowingAboutTheCreatorScene = false
    @Published var sendingFeedbackResult: Result<MFMailComposeResult, Error>? = nil
    @Published var alertMessage = ""
    @Published var showingAlert = false

    func showMailScene() {
        if MFMailComposeViewController.canSendMail() {
            isShowingMailScene.toggle()
        } else {
            showingAlert.toggle()
            alertMessage = "Can't send emails, please make sure you have an email account provided inside Apple mail app."
        }
    }
}

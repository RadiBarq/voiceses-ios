//
//  SettingsScene.swift
//  Voiceses
//
//  Created by Radi Barq on 28/03/2021.
//

import SwiftUI

struct SettingsScene: View {
    private let viewModel = SettingsViewModel()
    var body: some View {
        Form {
            Section() {
                HStack {
                    Text("Email:")
                    Text("radibaraq@gmail.com")
                }
            }
            Section() {
                List(viewModel.listItems, id: \.self) { item in
                    NavigationLink(destination: {
                        Text("Item is added here")
                    }) {
                        Text(item)
                    }
                }
            }
            Section() {
                HStack {
                    Text("Version:")
                    Text("1.0.0")
                }
                Button("Logout") {
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .foregroundColor(Color.accent)
            }
        }
    }
}

struct SettingsScene_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScene()
    }
}

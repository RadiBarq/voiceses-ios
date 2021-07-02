//
//  ContentView.swift
//  Shared
//
//  Created by Radi Barq on 13/03/2021.
//

import SwiftUI
import Combine

struct LunchWindow: View {
    @StateObject private var lunchWindowViewModel = LunchWindowViewModel()
    var body: some View {
        Group {
            if lunchWindowViewModel.isUserLoggedin {
                HomeScene()
            } else {
                LoginScene()
            }
        }
        .onAppear {
            #if os(iOS)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.accent)], for: .selected)
            #endif
        }
    }
}

struct LunchWindow_Previews: PreviewProvider {
    static var previews: some View {
        LunchWindow()
    }
}

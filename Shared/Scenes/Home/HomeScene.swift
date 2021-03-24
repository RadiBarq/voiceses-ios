//
//  HomeScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 16/03/2021.
//

import SwiftUI

struct HomeScene: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #else
    #endif
    
    @ViewBuilder
    var body: some View {
        ZStack {
            #if os(iOS)
            if horizontalSizeClass == .compact {
                    tabView
            } else {
                SideBar()
            }
            #else
            SideBar()
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
            #endif
        }
    }
    
    var tabView: some View {
        TabView {
            ForEach(NavigationItem.allCases) { navigationItem in
                NavigationView {
                    navigationItem.view
                        .navigationTitle(navigationItem.title)
                }
                .tabItem {
                    Image(systemName: navigationItem.systemImageName)
                    Text(navigationItem.title)
                }
        }
        .accentColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
        }
    }
}

struct HomeScene_Previews: PreviewProvider {
    static var previews: some View {
        HomeScene()
            .previewLayout(.device)
            .previewDevice("iPhone 11")
    }
}

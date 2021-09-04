//
//  HomeScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 16/03/2021.
//

import SwiftUI

struct HomeScene: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#else
#endif
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
    
    private var tabView: some View {
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
        }
        .accentColor(Color.accent)
    }
}

struct HomeScene_Previews: PreviewProvider {
    static var previews: some View {
        HomeScene()
            .previewLayout(.device)
            .previewDevice("iPhone 11")
    }
}

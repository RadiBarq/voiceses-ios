//
//  Sidebar.swift
//  Voiceses
//
//  Created by Radi Barq on 16/03/2021.
//

import SwiftUI

struct SideBar: View {
    @State private var selection: NavigationItem?
    
    var body: some View {
        NavigationView {
            sidebar
                .navigationTitle("VOICΞSΞS")
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {}) {
                            Image(systemName: "person.crop.circle").font(.system(size: 22, weight: .light))
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        Button(action: toggleSidebar, label: {
                            Image(systemName: "sidebar.left")
                        })
                    }
                }
            SubjectsScene()
        }
        .accentColor(Color.accent)
    }
    
    private var sidebar: some View {
        List(NavigationItem.allCases, selection: $selection) { navigationItem in
            NavigationLink(
                destination:
                    navigationItem.view
                    .navigationTitle(navigationItem.title)) {
                Label(navigationItem.title, systemImage: navigationItem.systemImageName)
            }
            .tag(navigationItem)
        }
        .listStyle(SidebarListStyle())
    }
    
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}

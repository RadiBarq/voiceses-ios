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
#if !os(iOS)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: toggleSidebar, label: {
                            Image(systemName: "sidebar.left")
                        })
                    }
                }
#endif
            SubjectsScene()
        }
        .accentColor(.accent)
    }
    
    private var sidebar: some View {
        VStack {
#if !os(iOS)
            Text("VOICΞSΞS")
                .font(.largeTitle)
                .bold()
                .padding()
#endif
            List(NavigationItem.allCases, selection: $selection) { navigationItem in
                NavigationLink(
                    destination:
                        navigationItem.view
                        .navigationTitle(navigationItem.title)) {
                    Label(navigationItem.title, systemImage: navigationItem.systemImageName)
                }
                        .tag(navigationItem.id)
            }
            .listStyle(SidebarListStyle())
        }
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

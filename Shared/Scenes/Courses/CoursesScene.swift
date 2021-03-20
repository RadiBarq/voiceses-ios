//
//  CoursesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct CoursesScene: View {
    @Namespace var namespace
    @State var items = courses
    @State var show = false
    @State var showNavBar = true
    @State var selection: Set<NavigationItem> = [.courses]
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 159), spacing: 16)]) {
                ForEach(items) { item in
                    NavigationLink(destination: Text("Hello world")) {
                        Text("Hello World")
                    }
                }
            }
        }
        .navigationTitle("Courses")
    }
}
struct CoursesScene_Previews: PreviewProvider {
    static var previews: some View {
        CoursesScene()
    }
}

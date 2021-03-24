//
//  CoursesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct CoursesScene: View {
    @Namespace var namespace
    @State var items = testCourses
    @State var show = false
    @State var showNavBar = true
    @State var selection: Set<NavigationItem> = [.courses]
 
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(items) { item in
                        NavigationLink(destination: Text("Run the app")) {
                            CourseView(course: item)
                                .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                                .padding()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Courses")
        }
    }
}
struct CoursesScene_Previews: PreviewProvider {
    static var previews: some View {
        CoursesScene()
            .previewDevice("iPhone 11")
    }
}

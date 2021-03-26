//
//  CoursesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct CoursesScene: View {
    @State private var items = testCourses
    @State private var showLecturesOnMac = false
    
    var body: some View {
        content
            .navigationTitle("Courses")
    }
    
    private var content: some View {
        #if os(iOS)
        return GeometryReader { geometry in
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
        }
        #else
        return
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 3), spacing: 16)]) {
                        ForEach(items) { item in
                            CourseView(course: item)
                                .frame(minWidth: geometry.size.width / 3, minHeight: geometry.size.height / 3)
                                .padding()
                                .onTapGesture {
                                    showLecturesOnMac.toggle()
                                }
                                .sheet(isPresented: $showLecturesOnMac) {
                                    /// TODO: show the lectures view
                                    Text("Run the app")
                                }
                        }
                    }
                    .padding()
                }
            }
        #endif
    }
}
struct CoursesScene_Previews: PreviewProvider {
    static var previews: some View {
        CoursesScene()
            .previewDevice("iPhone 11")
    }
}

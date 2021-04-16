//
//  CoursesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct SubjectsScene: View {
    @StateObject private var subjectsSceneViewModel = SubjectsSceneViewModel()
    
    var body: some View {
        content
            .navigationTitle("Subjects")
            .toolbar {
                ToolbarItem(placement:  ToolbarItemPlacement.automatic) {
                    Button(action: {
                        subjectsSceneViewModel.showAddNewSubjectView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
            }
            .sheet(isPresented: $subjectsSceneViewModel.showAddNewSubjectView) {
                AddNewSubjectScene(addNewSubjectViewModel: AddNewSubjectViewModel(isPresented: $subjectsSceneViewModel.showAddNewSubjectView))
            }
            .alert(isPresented: $subjectsSceneViewModel.showingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(subjectsSceneViewModel.alertMessage),
                      dismissButton: .default(Text(alertDismissButtonTitle))
                )
            }
    }
    
    private var content: some View {
        #if os(iOS)
        return GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(subjectsSceneViewModel.subjects) { item in
                        NavigationLink(destination: Text("Run the app")) {
                            SubjectView(subject: item, deleteAction: {
                                subjectsSceneViewModel.deleteSubject(at: item.id!)
                            })
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
struct SubjectsScene_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsScene()
            .previewDevice("iPhone 11")
    }
}

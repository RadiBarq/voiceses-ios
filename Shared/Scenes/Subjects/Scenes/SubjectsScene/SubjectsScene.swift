//
//  CoursesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct SubjectsScene: View {
    @StateObject private var subjectsSceneViewModel = SubjectsSceneViewModel()
    @State var isActiveOnMac = false
    
#if !os(iOS)
    @State private var currentSelectedSubject: Subject?
    @State private var cardsScenePushed: Bool = false
#endif
    var body: some View {
        content
            .navigationTitle("Subjects")
            .alert(isPresented: $subjectsSceneViewModel.showingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(subjectsSceneViewModel.alertMessage),
                      dismissButton: .default(Text(alertDismissButtonTitle)))
            }
            .alert(isPresented: $subjectsSceneViewModel.showDeleteSubjectAlert) {
                Alert(title: Text("Be careful"),
                      message: Text("All lectures of the deleted subject will be removed!"),
                      primaryButton: .destructive(Text("Delete")) {
                    subjectsSceneViewModel.deleteSubject()
                },
                      secondaryButton: .cancel(Text("Cancel"))
                )
            }
            .sheet(isPresented: $subjectsSceneViewModel.showAddNewSubjectView) {
                AddNewSubjectScene(isPresented: $subjectsSceneViewModel.showAddNewSubjectView)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
#if os(iOS)
                    Button(action: {
                        subjectsSceneViewModel.showAddNewSubjectView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
#else
                    if !cardsScenePushed {
                        Button(action: {
                            subjectsSceneViewModel.showAddNewSubjectView.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                        })
                    } else {
                        EmptyView()
                    }
#endif
                }
            }
    }
    
    private var content: some View {
#if os(iOS)
        return GeometryReader { geometry in
            ScrollView {
                SearchBar(placeholder: "Search subjects...", text: $subjectsSceneViewModel.searchText)
                    .padding()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(subjectsSceneViewModel.searchedSubjects) { item in
                        NavigationLink(destination: CardsScene(cardsSceneViewModel: CardsSceneViewModel(subject: item))
                        ) {
                            SubjectView(subject: .constant(item), deleteAction: {
                                subjectsSceneViewModel.showDeleteSubjectAlert.toggle()
                                subjectsSceneViewModel.selectedSubjectIDToBeDelete = item.id!
                            }, updateSubjectAction: { subject in
                                subjectsSceneViewModel.update(subject: subject)
                            })
                                .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                       .padding()
                        }
                    }
                }
                .padding()
                .animation(.easeInOut(duration: 0.5))
            }
        }
#else
        return GeometryReader { geometry in
            if !cardsScenePushed {
                ScrollView {
                    SearchBar(placeholder: "Search subjects...", text: $subjectsSceneViewModel.searchText)
                        .padding()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 3), spacing: 16)]) {
                        ForEach(subjectsSceneViewModel.searchedSubjects) { item in
                            SubjectView(subject: .constant(item), deleteAction: {
                                subjectsSceneViewModel.showDeleteSubjectAlert.toggle()
                                subjectsSceneViewModel.selectedSubjectIDToBeDelete = item.id!
                            }, updateSubjectAction: { subject in
                                subjectsSceneViewModel.update(subject: subject)
                            })
                                .frame(minWidth: geometry.size.width / 3, minHeight: geometry.size.height / 3)
                                .padding()
                                .onTapGesture {
                                    cardsScenePushed = true
                                    currentSelectedSubject = item
                                }
                        }
                        .animation(.easeInOut(duration: 0.5))
                        .padding()
                    }
                }
                .transition(.move(edge: .leading)).animation(.default)
            }
            if cardsScenePushed {
                CardsScene(cardsSceneViewModel: CardsSceneViewModel(subject: currentSelectedSubject!), isPresented: $cardsScenePushed)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
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

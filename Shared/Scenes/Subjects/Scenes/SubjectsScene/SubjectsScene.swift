//
//  CoursesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct SubjectsScene: View {
    @StateObject private var subjectsViewModel = SubjectsViewModel()
    @State private var isActiveOnMac = false
#if !os(iOS)
    @State private var currentSelectedSubject: Subject?
    @State private var cardsScenePushed: Bool = false
#endif
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalClass
#endif
    
    var body: some View {
        content
            .navigationTitle("Subjects")
            .alert(isPresented: $subjectsViewModel.showingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(subjectsViewModel.alertMessage),
                      dismissButton: .default(Text(alertDismissButtonTitle)))
            }
            .alert(isPresented: $subjectsViewModel.showDeleteSubjectAlert) {
                Alert(title: Text("Be careful"),
                      message: Text("All lectures of the deleted subject will be removed!"),
                      primaryButton: .destructive(Text("Delete")) {
                    subjectsViewModel.deleteSubject()
                },
                      secondaryButton: .cancel(Text("Cancel"))
                )
            }
            .sheet(isPresented: $subjectsViewModel.showingAddNewSubjectScene) {
                AddNewSubjectScene(isPresented: $subjectsViewModel.showingAddNewSubjectScene)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        subjectsViewModel.reverseSubjects()
                    }, label: {
                        Image(systemName: self.subjectsViewModel.sortOptions == .ascend ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                    })
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        subjectsViewModel.showingAddNewSubjectScene.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
#else
                ToolbarItem(placement: .automatic) {
                    if !cardsScenePushed {
                        Button(action: {
                            subjectsViewModel.reverseSubjects()
                        }, label: {
                            Image(systemName: self.subjectsViewModel.sortOptions == .ascend ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                        })
                    } else {
                        EmptyView()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if !cardsScenePushed {
                        Button(action: {
                            subjectsViewModel.showingAddNewSubjectScene.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                        })
                    } else {
                        EmptyView()
                    }
                }
#endif
            }
    }
    
    private var content: some View {
#if os(iOS)
        return GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                SearchBar(placeholder: "Search subjects...", text: $subjectsViewModel.searchText)
                    .padding(horizontalClass == .compact ? 16 : 25)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(subjectsViewModel.searchedSubjects) { item in
                        NavigationLink(destination: CardsScene(subject: item)) {
                            SubjectView(subject: .constant(item), deleteAction: {
                                subjectsViewModel.showDeleteSubjectAlert.toggle()
                                subjectsViewModel.selectedSubjectIDToBeDeleted = item.id!
                            }, updateSubjectAction: { subject in
                                subjectsViewModel.update(subject: subject)
                            })
                            .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                            .padding()
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: subjectsViewModel.sortOptions)
                    .animation(.easeInOut(duration: 0.5), value: subjectsViewModel.searchedSubjects)
                }
                .padding(horizontalClass == .compact ? 16 : 25)
            }
            .edgesIgnoringSafeArea([.leading, .trailing])
            
        }
#else
        return GeometryReader { geometry in
            if !cardsScenePushed {
                ScrollView(showsIndicators: false) {
                    SearchBar(placeholder: "Search subjects...", text: $subjectsViewModel.searchText)
                        .padding()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 3), spacing: 16)]) {
                        ForEach(subjectsViewModel.searchedSubjects) { item in
                            SubjectView(subject: .constant(item), deleteAction: {
                                subjectsViewModel.showDeleteSubjectAlert.toggle()
                                subjectsViewModel.selectedSubjectIDToBeDeleted = item.id!
                            }, updateSubjectAction: { subject in
                                subjectsViewModel.update(subject: subject)
                            })
                                .frame(minWidth: geometry.size.width / 3, minHeight: geometry.size.height / 3)
                                .padding()
                                .onTapGesture {
                                    cardsScenePushed = true
                                    currentSelectedSubject = item
                                }
                        }
                        .padding()
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: subjectsViewModel.sortOptions)
                .animation(.easeInOut(duration: 0.5), value: subjectsViewModel.searchedSubjects)
                .transition(.move(edge: .leading))
            }
            if cardsScenePushed {
                CardsScene(subject: currentSelectedSubject!, isPresented: $cardsScenePushed)
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.default, value: cardsScenePushed)
#endif
    }
}

struct SubjectsScene_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsScene()
            .previewDevice("iPhone 11")
    }
}

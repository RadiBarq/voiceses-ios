//
//  TestsArchiveTestsScene.swift
//  TestsArchiveTestsScene
//
//  Created by Radi Barq on 01/09/2021.
//

import SwiftUI

struct TestsArchiveTestsScene: View {
    let subject: Subject
    @StateObject private var viewModel = TestsArchiveTestsViewModel()
    var body: some View {
#if os(iOS)
        content
#else
        NavigationView {
            content
        }
#endif
    }
    private var content: some View {
        Group {
            if viewModel.showsLoadingIndicator {
                ProgressView()
            } else {
                List {
#if !os(iOS)
                    Text("Tests")
                        .font(.largeTitle)
                        .bold()
                        .padding()
#endif
                    ForEach(viewModel.tests, id: \.id) { test in
                        NavigationLink(destination: TestsArchiveCardsScene(subject: subject, test: test)) {
                            let dateString = Date(timeIntervalSince1970: TimeInterval(test.timestamp / 1000)).getCurrentDateWithTimeAsString()
                            Text(dateString)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTest)
                }
            }
        }
        .navigationTitle("Tests")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.showingTestsArchiveFilterTestsScene.toggle()
                }, label: {
                    Text("Filter")
                })
                    .disabled(viewModel.allTests.isEmpty)
            }
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    viewModel.reverseCards()
                }, label: {
                    Image(systemName: self.viewModel.sortOptions == .ascend ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                })
                    .disabled(viewModel.tests.count <= 1)
            }
        }
        .animation(.default, value: self.viewModel.sortOptions)
        .onAppear {
            viewModel.getTests(for: subject)
        }
        .sheet(isPresented: $viewModel.showingTestsArchiveFilterTestsScene) {
            TestsArchiveFilterTestsScene(isPresented: $viewModel.showingTestsArchiveFilterTestsScene, startDate: $viewModel.startDate, endDate: $viewModel.endDate, isFilterApplied: $viewModel.isFilterApplied)
        }
    }
}

struct TestsArchiveTestsScene_Previews: PreviewProvider {
    static var previews: some View {
        TestsArchiveTestsScene(subject: testSubjects[0])
    }
}

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
        content
            .navigationTitle("Tests")
            .onAppear {
                viewModel.getTests(for: subject)
            }
    }
    
    private var content: some View {
        List {
            ForEach(viewModel.tests, id: \.id) { test in
                NavigationLink(destination: Text(test.dateCreated)) {
                    Text(test.dateCreated)
                        .foregroundColor(Color.primary)
                }
            }
            .onDelete(perform: viewModel.deleteTest)
        }
    }
}

struct TestsArchiveTestsScene_Previews: PreviewProvider {
    static var previews: some View {
        TestsArchiveTestsScene(subject: testSubjects[0])
    }
}

//
//  SearchScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct TestsArchiveSubjectsScene: View {
    @StateObject private var viewModel = TestsArchiveSubjectsViewModel()
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
        List {
            ForEach(viewModel.searchedSubjects, id: \.id) { subject in
                NavigationLink(destination: TestsArchiveTestsScene(subject: subject)) {
                    Text(subject.title)
                        .foregroundColor(Color.primary)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search for a subject")
    }
}

struct TestsScene_Previews: PreviewProvider {
    static var previews: some View {
        TestsArchiveSubjectsScene()
    }
}

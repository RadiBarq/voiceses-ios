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
                NavigationLink(destination: Text(subject.title)) {
                    Text(subject.title)
                        .foregroundColor(Color.accent)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search for a subject") {
            ForEach(viewModel.searchedSubjects, id: \.id) { result in
                Text("Are you looking for \(result.title)?")
                    .searchCompletion(result.title)
            }
        }
    }
}

struct TestsScene_Previews: PreviewProvider {
    static var previews: some View {
        TestsArchiveSubjectsScene()
    }
}

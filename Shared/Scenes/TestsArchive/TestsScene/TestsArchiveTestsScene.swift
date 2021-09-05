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
        List {
#if !os(iOS)
            Text("Tests")
                .font(.largeTitle)
                .bold()
                .padding()
#endif
            ForEach(viewModel.tests, id: \.id) { test in
                NavigationLink(destination: Text(test.dateCreated)) {
                    Text(test.dateCreated)
                }
            }
            .onDelete(perform: viewModel.deleteTest)
        }
        .navigationTitle("Tests")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    viewModel.reverseCards()
                }, label: {
                    Image(systemName: self.viewModel.sortOptions == .ascend ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                })
                    .disabled(viewModel.tests.isEmpty)
            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                DatePicker("Start date",
//                           selection: $viewModel.startDate,
//                           in: ...Date.startOfYesterday,
//                           displayedComponents: [.date, .hourAndMinute])
//                    .disabled(viewModel.tests.isEmpty)
//            }
//
//            ToolbarItem(placement: .navigationBarTrailing) {
//                DatePicker("End date",
//                           selection: $viewModel.endDate,
//                           in: ...Date(),
//                           displayedComponents: [.date, .hourAndMinute])
//                    .disabled(viewModel.tests.isEmpty)
//            }
            
        }
        .onAppear {
            viewModel.getTests(for: subject)
        }
    }
}

struct TestsArchiveTestsScene_Previews: PreviewProvider {
    static var previews: some View {
        TestsArchiveTestsScene(subject: testSubjects[0])
    }
}

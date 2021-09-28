//
//  TestResultScene.swift
//  TestResultScene
//
//  Created by Radi Barq on 23/09/2021.
//

import SwiftUI

struct TestResultScene: View {
    let subject: Subject
    let test: Test
    @Binding var isPresented: Bool
    @Binding var showingTestScene: Bool
    @StateObject private var viewModel = TestResultViewModel()
    @State private var selection: Int? = nil
    var body: some View {
#if os(iOS)
        NavigationView {
            content
        }
        .navigationTitle("Test Result")
#else
        NavigationView {
            ScrollView {
                content
                    .padding()
                    .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
                    .accentColor(Color.accent)
            }
        }
#endif
    }
    
    private var content: some View {
        GeometryReader { geometry in
            if viewModel.testsArchivesCardPushed {
                TestsArchiveCardsScene(subject: subject, test: test)
                    .transition(.move(edge: .trailing))
            }
            
            if !viewModel.testsArchivesCardPushed {
                VStack {
                    testResultCircle
                    Section {
                        Button("Repeat The Test") {
                            isPresented.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showingTestScene.toggle()
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width / 1.5, height: 40)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.white)
                        .buttonStyle(.plain)
#if os(iOS)
                        NavigationLink(destination: TestsArchiveCardsScene(subject: subject, test: test), tag: 0, selection: $selection) {
                            Button("Show Full Details") {
                                self.selection = 0
                            }
                            .padding()
                            .frame(width: geometry.size.width / 1.5, height: 40)
                            .background(Color.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.white)
                            .buttonStyle(.plain)
                        }
#else
                        Button("Show Full Details") {
                            viewModel.testsArchivesCardPushed.toggle()
                        }
                        .padding()
                        .frame(width: geometry.size.width / 1.5, height: 40)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.white)
                        .buttonStyle(.plain)
#endif
                        Spacer()
                    }
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.default, value: viewModel.testsArchivesCardPushed)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    isPresented.toggle()
                }) {
                    Text("Close")
                }
            }
        }
        .onAppear {
            viewModel.setupTestInformation(with: test.score)
        }
        .accentColor(Color.accent)
    }
    
    private var testResultCircle: some View {
        GeometryReader { reader in
            VStack(alignment: .center) {
                Circle()
                    .fill(Color.white)
                    .padding()
                    .frame(width: reader.size.width / 1.3, height: reader.size.height, alignment: .center)
                    .shadow(color: viewModel.testResultColor.opacity(0.6), radius: 20, x: 0, y: 10)
                    .overlay {
                        VStack(alignment: .center) {
                            Text("Your score is")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.black)
                            Text(viewModel.testResult)
                                .font(.largeTitle)
                                .foregroundColor(viewModel.testResultColor)
                                .bold()
                        }
                    }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

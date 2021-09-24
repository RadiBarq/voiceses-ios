//
//  TestResultScene.swift
//  TestResultScene
//
//  Created by Radi Barq on 23/09/2021.
//

import SwiftUI

struct TestResultScene: View {
    @StateObject private var viewModel = TestResultViewModel()
    var body: some View {
#if os(iOS)
        NavigationView {
            content
        }
        .navigationTitle("Test Result")
#else
        ScrollView {
            content
            .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
            .accentColor(Color.accent)
        }
#endif
    }
    
    private var content: some View {
        GeometryReader { geometry in
            VStack {
                testResultCircle
                Section {
                    Button("Repeat The Test") {
                        
                    }
                    .padding()
                    .frame(width: geometry.size.width / 1.5, height: 50)
                    .background(Color.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
                    Button("Show Full Details") {
                    }
                    .padding()
                    .frame(width: geometry.size.width / 1.5, height: 50)
                    .background(Color.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.calculateTestResult()
        }
    }
    
    private var testResultCircle: some View {
        GeometryReader { reader in
            VStack(alignment: .center) {
                Circle()
                    .fill(.white)
                    .frame(width: reader.size.width / 1.5, height: reader.size.height / 1.5, alignment: .center)
                    .shadow(color: Color.green.opacity(0.5), radius: 20, x: 0, y: 10)
                    .overlay {
                        VStack(alignment: .center) {
                            Text("Your score is")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.black)
                            Text(viewModel.testResult)
                                .font(.largeTitle)
                                .foregroundColor(.green)
                                .bold()
                        }
                    }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct TestResultScene_Previews: PreviewProvider {
    static var previews: some View {
        TestResultScene()
    }
}

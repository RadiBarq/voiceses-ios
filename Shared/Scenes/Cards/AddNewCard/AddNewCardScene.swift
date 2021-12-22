//
//  AddNewCardScene.swift
//  Voiceses
//
//  Created by Radi Barq on 01/05/2021.
//

import SwiftUI
import PencilKit

struct AddNewCardScene: View {
    @Binding var isPresented: Bool
    var subject: Subject
    @State private var frontCanvas = PKCanvasView()
    @State private var backCanvas = PKCanvasView()
    @StateObject var addNewCardViewModel = AddNewCardViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Group {
                if addNewCardViewModel.cardSide == .front {
                    DrawingCanvas(canvasView: $frontCanvas)
                } else {
                    DrawingCanvas(canvasView: $backCanvas)
                }
            }
        }
        .cornerRadius(25)
        .padding()
        .rotation3DEffect(addNewCardViewModel.cardSide == .front ? .degrees(0): .degrees(-180), axis: (x: 1, y: 0, z: 0))
        .animation(.linear(duration: 0.5), value: addNewCardViewModel.cardSide)
        .shadow(color: colorScheme == .light ? addNewCardViewModel.parentColor.opacity(0.6) : .clear,
                radius: 20, x: 0, y: 10)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    if addNewCardViewModel.areBothCanvasesEmpty(frontCanvas: frontCanvas, backCanvas: backCanvas) {
                        isPresented.toggle()
                        return
                    }
                    addNewCardViewModel.showCloseConfirmationAlert()
                }, label: {
                    Text("Close")
                })
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    addNewCardViewModel.saveCard(frontCanvas: frontCanvas, backCanvas: backCanvas, isPresented: $isPresented)
                }, label: {
                    Text("Save") 
                })
            }
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    addNewCardViewModel.cardSide.toggle()
                }, label: {
                    Text("Switch side")
                })
            }
        }
        .navigationTitle("\(addNewCardViewModel.cardSide.rawValue.capitalized) side")
        .accentColor(Color.accent)
        .alert(isPresented: $addNewCardViewModel.showingAlert) {
            Alert(title: Text(self.alertTitle),
                  message: Text(addNewCardViewModel.alertMessage),
                  dismissButton: .default(Text(alertDismissButtonTitle)))
        }
        .alert(isPresented: $addNewCardViewModel.showingAlert) {
            Alert(title: Text(self.alertTitle),
                  message: Text(addNewCardViewModel.alertMessage),
                  dismissButton: .default(Text(alertDismissButtonTitle)))
        }
        .alert(isPresented: $addNewCardViewModel.showingCloseConfirmationAlert) {
            Alert(title: Text(addNewCardViewModel.alertTitle),
                  message: Text(addNewCardViewModel.alertMessage),
                  primaryButton: .cancel(),
                  secondaryButton: .default(Text("Delete everything"), action: {
                isPresented.toggle()
            }))
        }
        .onAppear {
            addNewCardViewModel.setup(subject: subject)
        }
        .animation(.default, value: addNewCardViewModel.subject)
    }
}

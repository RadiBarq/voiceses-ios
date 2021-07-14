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
    var frontCanvas = PKCanvasView()
    var backCanvas = PKCanvasView()
    @ObservedObject var addNewCardViewModel: AddNewCardViewModel
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    if addNewCardViewModel.cardSide == .front {
                        DrawingCanvas(canvasView: frontCanvas)
                    } else {
                        DrawingCanvas(canvasView: backCanvas)
                    }
                }
            }
            .cornerRadius(25)
            .shadow(color: addNewCardViewModel.parentColor.opacity(0.8), radius: 20, x: 0, y: 10)
            .padding()
            .navigationTitle("\(addNewCardViewModel.cardSide.rawValue.capitalized) side")
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
            .rotation3DEffect(addNewCardViewModel.cardSide == .front ? .degrees(0): .degrees(-180), axis: (x: 1, y: 0, z: 0))
        }
        .accentColor(Color.accent)
        .animation(.linear(duration: 0.5))
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
    }
}

struct AddNewCardScene_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        AddNewCardScene(isPresented: $isPresented, addNewCardViewModel: AddNewCardViewModel(subject: testSubjects[0]))
    }
}

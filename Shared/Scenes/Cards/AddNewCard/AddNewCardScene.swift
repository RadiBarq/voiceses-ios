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
            .shadow(color: addNewCardViewModel.parentColor.opacity(0.5), radius: 20, x: 0, y: 10)
            .padding()
            .navigationTitle("\(addNewCardViewModel.cardSide.rawValue.capitalized) side")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Text("Close")
                    })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        addNewCardViewModel.saveCanvasesImage(frontCanvas: frontCanvas, backCanvas: backCanvas)
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
    }
}

struct AddNewCardScene_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        AddNewCardScene(isPresented: $isPresented, addNewCardViewModel: AddNewCardViewModel(subject: testSubjects[0]))
    }
}

struct DrawingCanvas: UIViewRepresentable {
    var canvasView: PKCanvasView
    static var picker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        self.canvasView.drawingPolicy = .anyInput
        self.canvasView.becomeFirstResponder()
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            DrawingCanvas.picker.addObserver(canvasView)
            DrawingCanvas.picker.setVisible(true, forFirstResponder: uiView)
            uiView.becomeFirstResponder()
         }
    }
}

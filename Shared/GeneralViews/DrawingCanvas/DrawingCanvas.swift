//
//  DrawingCanvas.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 22/06/2021.
//

import SwiftUI
import PencilKit

struct DrawingCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    static var picker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        self.canvasView.drawingPolicy = .anyInput
        self.canvasView.becomeFirstResponder()
        self.canvasView.backgroundColor = .white
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DrawingCanvas.picker.addObserver(canvasView)
            DrawingCanvas.picker.setVisible(true, forFirstResponder: uiView)
            uiView.becomeFirstResponder()
         }
    }
}

//
//  CustomTextField.swift
//  Voiceses
//
//  Created by Radi Barq on 05/06/2021.
//

import SwiftUI
import Foundation

struct CustomTextView: UIViewRepresentable {
    @Binding var text: String
    private(set) var isFirstResponder: Bool = false
    private(set) var foregroundColor: Color
    private(set) var font: UIFont
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextView>) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.font = font
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.textColor = UIColor(foregroundColor)
        view.textAlignment = .center
        view.delegate = context.coordinator
        return view
    }
    
    func makeCoordinator() -> CustomTextView.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextView>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
        @Binding var text: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
        }
    }
}

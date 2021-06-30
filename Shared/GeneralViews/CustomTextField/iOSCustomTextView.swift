//
//  CustomTextField.swift
//  Voiceses
//
//  Created by Radi Barq on 05/06/2021.
//

import SwiftUI
import Foundation

struct iOSCustomTextView: UIViewRepresentable {
    @Binding var text: String
    private(set) var isFirstResponder: Bool = false
    private(set) var foregroundColor: UIColor
    private(set) var font: UIFont
    
    func makeUIView(context: UIViewRepresentableContext<iOSCustomTextView>) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.isEditable = true
        textView.textContainer.maximumNumberOfLines = 5
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.textColor = foregroundColor
        textView.textAlignment = .center
        textView.delegate = context.coordinator
        return textView
    }
    
    func makeCoordinator() -> iOSCustomTextView.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<iOSCustomTextView>) {
        uiView.text = text
        if !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        var didBecomeFirstResponder = false
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
    }
}

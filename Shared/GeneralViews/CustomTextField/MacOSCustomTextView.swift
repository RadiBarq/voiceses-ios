//
//  macOSCustomTextView.swift
//  Voiceses
//
//  Created by Radi Barq on 16/06/2021.
//

import Foundation
import SwiftUI

struct MacOSCustomTextView: NSViewRepresentable {
    @Binding var text: String
    private(set) var isFirstResponder: Bool = false
    private(set) var foregroundColor: NSColor
    private(set) var font: NSFont

    func makeNSView(context: NSViewRepresentableContext<MacOSCustomTextView>) -> NSTextView {
        let textView = NSTextView()
        textView.font = font
        textView.isEditable = true
        textView.isSelectable = true
        textView.textContainer?.maximumNumberOfLines = 5
        textView.backgroundColor = .clear
        textView.textColor = foregroundColor
        textView.alignment = .center
        textView.delegate = context.coordinator
        return textView
    }

    func updateNSView(_ uiView: NSTextView, context: NSViewRepresentableContext<MacOSCustomTextView>) {
        uiView.string = text
        if !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
    
    func makeCoordinator() -> MacOSCustomTextView.Coordinator {
        return Coordinator(text: $text)
    }
    
    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String
        var didBecomeFirstResponder = false
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            text = textView.string
        }
    }
}

struct CustomTextView: NSViewRepresentable {
    @Binding var foregroundColor: NSColor
    @Binding var text: String
    private(set) var font: NSFont
    
    func makeNSView(context: NSViewRepresentableContext<CustomTextView>) -> NSTextView {
        let textView = NSTextView()
        textView.font = font
        textView.isEditable = true
        textView.isSelectable = true
        textView.textContainer?.maximumNumberOfLines = 5
        textView.backgroundColor = .clear
        textView.textColor = foregroundColor
        textView.alignment = .center
        return textView
    }
    
    func updateNSView(_ uiView: NSTextView, context: NSViewRepresentableContext<CustomTextView>) {
        uiView.textColor = foregroundColor
        uiView.string = text
    }
    
    func makeCoordinator() -> CustomTextView.Coordinator {
        return Coordinator(text: $text)
    }
    
    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            text = textView.string
        }
    }
}

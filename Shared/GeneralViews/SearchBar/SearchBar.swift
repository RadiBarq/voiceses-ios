//
//  SearchBar.swift
//  Voiceses
//
//  Created by Radi Barq on 17/04/2021.
//

import SwiftUI

struct SearchBar: View {
    var placeholder: String
    @Binding var text: String
    @State private var isEditing = false
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(.systemGray6)
        #else
        return Color(.separatorColor)
        #endif
    }
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(backgroundColor)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.default, value: isEditing)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(placeholder: "Search subjects...", text: .constant(""))
    }
}

//
//  CourseView.swift
//  Voiceses
//
//  Created by Radi Barq on 24/03/2021.
//

import SwiftUI

struct SubjectView: View {
    @Binding var subject: Subject
    let deleteAction: () -> Void
    let updateSubjectAction: (Subject) -> Void
    private let cornerRadius: CGFloat = 22
    @State private var showingTextField = false
    @State private var titleText = ""
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 4) {
                HStack {
                    Button(action: {
                        deleteAction()
                    }) {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(Color(hex: subject.colorHex).whiteOrBlack)
                            .font(.title2)
                    }
                    .background(Color.clear)
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        showingTextField.toggle()
                        updateSubjectName()
                    }) {
                        Text(showingTextField ? "Done" : "Edit")
                            .foregroundColor(Color(hex: subject.colorHex).whiteOrBlack)
                    }
                    .background(Color.clear)
                    .buttonStyle(PlainButtonStyle())
                }
                titleView
                Text("Cards: \(subject.numberOfCards ?? 0)")
                    .foregroundColor(Color(hex: subject.colorHex).whiteOrBlack)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.init(hex: subject.colorHex))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color(hex: subject.colorHex).opacity(0.5), radius: 20, x: 0, y: 10)
        }
        .onAppear {
            titleText = subject.title
        }
    }

    @ViewBuilder
    private var titleView: some View {
        GeometryReader { reader in
            if self.showingTextField {
                CustomTextView(text: $titleText, isFirstResponder: showingTextField, foregroundColor: Color(hex: subject.colorHex).whiteOrBlack, font: UIFont.systemFont(ofSize: reader.size.width / 10, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text(subject.title)
                    .font(.system(size: reader.size.width / 10))
                    .bold()
                    .foregroundColor(Color(hex: subject.colorHex).whiteOrBlack)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    private func updateSubjectName() {
        var currentSubject = subject
        if subject.title != titleText && !titleText.isEmpty {
            currentSubject.title = titleText
            updateSubjectAction(currentSubject)
        }
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectView(subject: .constant(testSubjects[0]), deleteAction: {
        }, updateSubjectAction: { subject in
        })
    }
}

//
//  CourseView.swift
//  Voiceses
//
//  Created by Radi Barq on 24/03/2021.
//

import SwiftUI

struct CourseView: View {
    let course: Subject
    private let cornerRadius: CGFloat = 22
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 4) {
                Text(course.title)
                    .font(.system(size: reader.size.width / 10))
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.leading)
                
                Text("Lectures: \(course.numberOfLectures ?? 0)")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.init(hex: course.colorHex))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color.init(hex: course.colorHex).opacity(0.5), radius: 20, x: 0, y: 10)
        }
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView(course: testCourses[0])
            .previewDevice("iPhone 11")
    }
}

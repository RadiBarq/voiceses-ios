//
//  AddNewLectureScene.swift
//  Voiceses
//
//  Created by Radi Barq on 26/04/2021.
//

import SwiftUI

struct AddNewLectureScene_temp: View {
    let hours = 30
    let minutes = 30
    let seconds = 40
    @State private var lectureName = "Enter Lecture Name"
    @State private var animateSmaller = false
    @State private var animateMedium = false
    @State private var animateLarger = false
    @State private var isRecording = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    TextField("", text: $lectureName)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                    VStack(alignment: .center) {
                        Text("\(hours):\(minutes):\(seconds)")
                            .font(.title)
                            
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: geometry.size.height / 3)
                .frame(maxWidth: .infinity)
                .background(
                    Image("background-24")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                )
                .background(Color.accent)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding()
                
                ZStack {
                    if isRecording {
                        Circle()
                            .frame(width: (geometry.size.height / 3) + 80, height:  (geometry.size.height / 3) + 80)
                            .foregroundColor(Color(#colorLiteral(red: 0.1333333333, green: 0.2862745098, blue: 0.7019607843, alpha: 1)))
                            .opacity(0.3)
                            .scaleEffect(animateLarger ? 1.2 : 0.5, anchor: .center)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1)
                                                .repeatForever(autoreverses: true)
                                                .delay(0.3)) {
                                    self.animateLarger.toggle()
                                }
                            }
                        
                        Circle()
                            .frame(width: (geometry.size.height / 3) + 40, height:  (geometry.size.height / 3) + 40)
                            .foregroundColor(Color(#colorLiteral(red: 0.1333333333, green: 0.2862745098, blue: 0.7019607843, alpha: 1)))
                            .opacity(0.6)
                            .scaleEffect(animateMedium ? 1.2 : 0.5, anchor: .center)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1)
                                                .repeatForever(autoreverses: true)
                                                .delay(0.2)) {
                                    self.animateMedium.toggle()
                                }
                            }
                        Circle()
                            .frame(width: (geometry.size.height / 3), height:  (geometry.size.height / 3))
                            .foregroundColor(Color(#colorLiteral(red: 0.1333333333, green: 0.2862745098, blue: 0.7019607843, alpha: 1)))
                            .opacity(1)
                            .scaleEffect(animateSmaller ? 1.2 : 0.5, anchor: .center)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1)
                                                .repeatForever(autoreverses: true)
                                                .delay(0.1)) {
                                    self.animateSmaller.toggle()
                                }
                            }
                    }
                    
                    Button(action: {
                        isRecording.toggle()
                    }, label: {
                        Image(systemName: isRecording ?  "pause.fill" : "record.circle.fill" )
                            .resizable()
                            .foregroundColor(.accent)
                            .frame(width: geometry.size.height / 14, height: geometry.size.height / 14, alignment: .center)
                        
                    })
                        .buttonStyle(.plain)
                }
                .frame(width: (geometry.size.height / 3) + 80, height:  (geometry.size.height / 3) + 80)
                .padding(.top, geometry.size.height / 12)
                
            }
        }
    }
}

struct AddNewLectureScene_Previews: PreviewProvider {
    static var previews: some View {
        AddNewLectureScene_temp()
    }
}

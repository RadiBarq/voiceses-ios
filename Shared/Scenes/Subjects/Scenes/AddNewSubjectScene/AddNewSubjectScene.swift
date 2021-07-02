//
//  AddNewSubjectScene.swift
//  Voiceses
//
//  Created by Radi Barq on 26/03/2021.
//

import SwiftUI

struct AddNewSubjectScene: View {
    @StateObject var addNewSubjectViewModel = AddNewSubjectViewModel()
    @Binding var isPresented: Bool
    
    var body: some View {
#if os(iOS)
        NavigationView {
            content
                .toolbar(content: {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            addNewSubjectViewModel.doneButtonClicked()
                            isPresented = false
                            
                        }, label: { Text("Add") })
                            .disabled(addNewSubjectViewModel.isDoneButtonDisabled)
                    }
                })
            
                .alert(isPresented: $addNewSubjectViewModel.showingAlert) {
                    Alert(title: Text(alertTitle),
                          message: Text(addNewSubjectViewModel.alertMessage),
                          dismissButton: .default(Text(alertDismissButtonTitle))
                    )
                }
        }
        .accentColor(Color.accent)
        
#else
        ScrollView {
            content
                .toolbar(content: {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            addNewSubjectViewModel.doneButtonClicked()
                            isPresented = false
                        }, label: { Text("Add") })
                            .disabled(addNewSubjectViewModel.isDoneButtonDisabled)
                    }
                })
                .accentColor(Color.accent)
                .alert(isPresented: $addNewSubjectViewModel.showingAlert) {
                    Alert(title: Text(alertTitle),
                          message: Text(addNewSubjectViewModel.alertMessage),
                          dismissButton: .default(Text(alertDismissButtonTitle))
                    )
                }
        }
        .padding()
        .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
#endif
    }
    
    private var content: some View {
        return Form {
            Section(header: Text("Subject info")) {
                VStack(alignment: .leading) {
                    TextField("Subject name", text: $addNewSubjectViewModel.name)
                        .padding(.bottom, 16)
                    ColorPicker("Subject color", selection: $addNewSubjectViewModel.color)
                }
                .padding()
            }
        }
        .navigationTitle("Add Subject")
    }
}

struct AddNewSubjectScene_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        AddNewSubjectScene(isPresented: $isPresented)
    }
}

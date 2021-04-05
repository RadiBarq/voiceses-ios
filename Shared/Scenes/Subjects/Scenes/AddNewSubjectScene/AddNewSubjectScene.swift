//
//  AddNewSubjectScene.swift
//  Voiceses
//
//  Created by Radi Barq on 26/03/2021.
//

import SwiftUI

struct AddNewSubjectScene: View {
    @ObservedObject var addNewSubjectViewModel: AddNewSubjectViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Subject name", text: $addNewSubjectViewModel.name)
                    ColorPicker("Subject color", selection: $addNewSubjectViewModel.color)
                }
            }
            .navigationBarTitle("New Subject")
            .toolbar(content: {
                ToolbarItem(placement: .automatic) {
                    Button(action: addNewSubjectViewModel.doneButtonClicked, label: { Text("Add") })
                        .disabled(addNewSubjectViewModel.isDoneButtonDisabled)
                }
            })
            
        }
        .accentColor(Color.accent)
        .alert(isPresented: $addNewSubjectViewModel.showingAlert) {
            Alert(title: Text(alertTitle),
                  message: Text(addNewSubjectViewModel.alertMessage),
                  dismissButton: .default(Text(alertDismissButtonTitle))
            )
        }
    }
}

struct AddNewSubjectScene_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        let addNewSubjectViewModel = AddNewSubjectViewModel(isPresented: $isPresented)
        AddNewSubjectScene(addNewSubjectViewModel: addNewSubjectViewModel)
    }
}

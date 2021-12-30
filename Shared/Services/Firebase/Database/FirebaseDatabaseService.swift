//
//  FirebaseService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation
import Firebase

protocol FirebaseDatabaseService {
    var ref: DatabaseReference { get }
}

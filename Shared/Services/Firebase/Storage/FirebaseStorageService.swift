//
//  FirebaseStorageService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 07/05/2021.
//
import Foundation
import FirebaseStorage

protocol FirebaseStorageService {
    var ref: StorageReference { get }
}

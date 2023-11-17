//
//  ImagePicker.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 16/11/23.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var isPickerShowing : Bool
    
    @Binding var selectedImage : UIImage?  // the question mark means that the variable is an optional, which is something that could be nil and you have to check before you can use it.
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        
        return imagePicker
    }
    
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}


class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent : ImagePicker
    
    init(_ picker : ImagePicker) {
        self.parent = picker
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        
        parent.isPickerShowing = false
        
        print("photo selected")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //code when the user cancel the picker UI
        parent.isPickerShowing = false
    }
    
}

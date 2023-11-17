//
//  NoteModel.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 15/11/23.
//

import Foundation
import SwiftData
import UIKit

@Model
class DataNote: Identifiable {
    
    @Attribute(.unique)
    var id : String
    //var title: String
    var additionalText: String
    //var image : UIImage
    
    init(additionalText: String) {
        self.id = UUID().uuidString
        //self.title = title
        self.additionalText = additionalText
        //self.image =  UIImage(imageLiteralResourceName: "noimage")
    }
    
}

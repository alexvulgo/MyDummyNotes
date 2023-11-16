//
//  NoteModel.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 15/11/23.
//

import Foundation
import SwiftData

@Model
class DataNote: Identifiable {
    var id : String
    //var title: String
    var additionalText: String
    
    init(additionalText: String) {
        self.id = UUID().uuidString
        //self.title = title
        self.additionalText = additionalText
    }
    
}

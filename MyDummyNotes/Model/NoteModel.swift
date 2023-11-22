//
//  NoteModel.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 15/11/23.
//

import Foundation
import SwiftData
import UIKit
import SwiftUI

@Model
class DataNote: Identifiable {
    
    @Attribute(.unique)
    var id : String
    var timeStamp: Date
    var additionalText: String
    var storedImages : [Data] = []
    
    init(additionalText: String, timestamp : Date = .now) {
        self.id = UUID().uuidString
        self.additionalText = additionalText
        self.timeStamp = timestamp
        
        
    }
    
}



    
    


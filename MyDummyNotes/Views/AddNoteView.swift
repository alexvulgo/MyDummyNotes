//
//  AddNoteView.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 14/11/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddNoteView: View {
    //SwiftData Variable
    @Environment(\.modelContext) private var context
    
    @State var note : DataNote?
    
    //Text Editor Field
    @State private var additionalText : String = ""
    //Check if the text editor is focus
    @FocusState private var isFocused: Bool
    //Image selected
    @State var selectedPhoto : PhotosPickerItem?
    
    @State var newPhotoData : Data?
    
 
    
    
    var body: some View {
        
        NavigationStack {
            VStack(){
                TextEditor(text: $additionalText)
                    .focused($isFocused)
                    .onAppear() {
                        if(note != nil) {
                            additionalText = note?.additionalText ?? ""
                        }
                    }
                
                //check if it's a new note or a passed one
                if let imageData = note?.image ?? newPhotoData,
                   let uiImage = UIImage(data: imageData){
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ , maxHeight: 300)
                }
                
                
            }
            
            
            .toolbar {
                
                ToolbarItem() {
                    Button("Done") {
                        if(note != nil) {
                            updateText(note ?? DataNote(additionalText: ""))
                            
                            
                        } else {
                            self.note = saveText()
                            
                            
                        }
                        isFocused = false
                        
                    }.bold()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        Label("Add Image", systemImage : "camera")
                    }
                    
                    
                }
                
            }
            
            .task(id: selectedPhoto) {
                
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                    if(note != nil) {
                        note?.image = data
                    } else {
                        newPhotoData = data
                        
                    }
                }
            }
        }
    }
    
    //Function for add the additional Text in a Note
    func saveText() -> DataNote {
        if(note == nil) {
            let newNote = DataNote(additionalText: additionalText)
            if(newPhotoData != nil) {
                newNote.image = newPhotoData
            }
            context.insert(newNote)
            
            return newNote
        }
        
        return DataNote(additionalText: "")
        
        
    }
    
    func updateText(_ note : DataNote) {
        note.additionalText = additionalText
        try? context.save()
        
    }
    
}

#Preview {
    AddNoteView()
}

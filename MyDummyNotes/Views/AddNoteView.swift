//
//  AddNoteView.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 14/11/23.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    //SwiftData Variable
    @Environment(\.modelContext) private var context
    
    @State var note : DataNote?
    
    //Text Editor Field
    @State private var additionalText : String = ""
    
    @FocusState private var isFocused: Bool
    
    @State var isPickerShowing = false
    
    //@State var isCreated = false
    
    @State var selectedImage : UIImage?
    
   
    
    
    
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
                
                
                if selectedImage != nil {
                    Image(uiImage : selectedImage!)
                        .resizable()
                        .frame(width: 200, height: 200)
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
                    
                    Button("Add Note", systemImage : "camera"){
                        isPickerShowing = true
                    }
                    .sheet(isPresented: $isPickerShowing){
                        //Image Picker
                        ImagePicker(isPickerShowing: $isPickerShowing,selectedImage: $selectedImage)
                    }
                    
                }
            }
        }
    }
    
    //Function for add the additional Text in a Note
    func saveText() -> DataNote {
        if(note == nil) {
            let newNote = DataNote(additionalText: additionalText)
           // self.note = newNote
            context.insert(newNote)
            
            return newNote
        }
        //isCreated = true
        
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

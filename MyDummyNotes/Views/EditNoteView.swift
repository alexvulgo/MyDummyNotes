//
//  EditNoteView.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 15/11/23.
//

import SwiftUI

struct EditNoteView: View {
    var note : DataNote
    
    @Environment(\.modelContext) private var context
    
    //Text Editor Field
    @State private var additionalText : String = ""
    
    var body: some View {
        
        //additionalText = "ciao"
        
        NavigationStack {
            VStack(){
                
                TextEditor(text: $additionalText)
                    .onAppear() {
                        additionalText = note.additionalText
                    }
            }
            
            
            .toolbar {
                
                ToolbarItem() {
                    Button("Done") {
                        saveText(note)
                    }.bold()
                }
            }
        }
    }
    
    //Function for add the additional Text in a Note
    func saveText(_ note : DataNote) {
        note.additionalText = additionalText
        try? context.save()
        
    }
}

#Preview {
    let note = DataNote(additionalText: "Trying saving strings")
    return EditNoteView(note: note)
}

//
//  MainView.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 14/11/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query private var notes : [DataNote]
    
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationStack {
            List() {
                ForEach(notes) { note in
                    VStack(alignment: .leading){
                        Text(note.title)
                            .bold()
                        Text(note.additionalText)
                    }
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteNote(notes[index])
                    }
                }
                
                
            }
            
            .navigationTitle("Notes")
            
            .toolbar {
                
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Add Note", systemImage : "square.and.pencil") {
                        
                        addNote()
                        
                    }
                    
                }
                
            }
            
        } .searchable(text: $searchText)
        
        
        
    }
    
    func addNote() {
        //Create the note
        //Add the item to the data context
        let note = DataNote(title:"Test" , additionalText: "Testing how to save strings")
        context.insert(note)
    }
    
    func deleteNote( _ note: DataNote) {
        //Delete the note
        // The underscored variable name refers to the underlying storage
        context.delete(note)
    }
    
}

#Preview {
    MainView()
        .modelContainer(for: DataNote.self, inMemory: true)
}

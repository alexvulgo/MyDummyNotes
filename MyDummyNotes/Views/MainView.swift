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
                    NavigationLink(destination: AddNoteView(note: note)) {
                        VStack(alignment: .leading){
                            HStack {
                                Text(note.timeStamp, format: .dateTime.day().month().year())
                                    .bold()
                                Text(note.additionalText)
                                    .lineLimit(1)
                                Spacer()
                                
                                if let imageData = note.storedImages.first,
                                   let uiImage = UIImage(data: imageData){
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 35 , maxHeight: 35)
                                        .cornerRadius(5)
                                }
                            }
                        }
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
                    
                    Text(String(notes.count) + " Notes")
                    
                }
                
                ToolbarItem(placement: .bottomBar) {
                    
                    Spacer()
                    
                }
                
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: AddNoteView()){
                        Button("Add Note", systemImage : "square.and.pencil") {
                        }
                        
                        .accessibilityAddTraits([.isButton])
                        .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                        
                        
                        
                    }
                    
                }
                
            }
            
        } .searchable(text: $searchText)
        
        
        
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

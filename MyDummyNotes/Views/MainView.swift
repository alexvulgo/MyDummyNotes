//
//  MainView.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 14/11/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    //Swift Data
    
    @Environment(\.modelContext) private var context
    
    @Query private var notes : [DataNote]
    
    //Searchbar
    @State private var searchText = ""
    
    //Filter by additional text
    var searchResults: [DataNote] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.additionalText.contains(searchText) }
        }
    }
    
    //Dynamic Type options
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        
        NavigationStack {
            
            List() {
                
                //View if dynamic type is on
                
                if sizeCategory.isAccessibilityCategory {
                    
                    ForEach(searchResults, id: \.self) { note in
                        NavigationLink(destination: AddNoteView(note: note)) {
                            VStack(alignment: .leading){
                                Text(note.timeStamp, format: .dateTime.day().month().year())
                                    .fixedSize(horizontal: false, vertical: true)
                                    .bold()
                                
                                
                                Text(note.additionalText)
                                    .lineLimit(3)
                                    .font(.body)
                                
                                
                                //Spacer()
                                
                                if let imageData = note.storedImages.first,
                                   let uiImage = UIImage(data: imageData){
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 150 , maxHeight: 170)
                                        .cornerRadius(5)
                                }
                            }
                            
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            deleteNote(notes[index])
                        }
                    }
                    
                }  else {
                    
                    //Normal View
                    
                    ForEach(searchResults, id: \.self) { note in
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
                        .accessibilityLabel("New note")
                        .accessibilityHint("Double tap to compose a new note")
                        
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

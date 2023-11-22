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
                    .font(.body) //use font that support dynamic type
                    .focused($isFocused)
                    .onAppear() {
                        if(note != nil) {
                            additionalText = note?.additionalText ?? ""
                            
                        }
                        
                    }
                
                VStack {
                    TabView {
                        
                        if(note == nil) {
                            if let imageData = newPhotoData,
                               let uiImage = UIImage(data: imageData){
                                Image(uiImage: uiImage)
                                
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                                    .cornerRadius(15)
                                    .accessibilityRemoveTraits(.isImage)
                                    .contextMenu(){
                                        Button(role: .destructive) {
                                            newPhotoData = nil
                                        }
                                        
                                    label: {
                                        
                                        Label("Delete", systemImage: "trash")
                                    }
                                        
                                    }
                            }
                            
                        }
                        
                        ForEach(note?.storedImages ?? [], id: \.self) { image in
                            if let uiImage = UIImage(data: image){
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                                    .accessibilityRemoveTraits(.isImage)
                                    .contextMenu(){
                                        Button(role: .destructive){
                                            if let idx = note?.storedImages.firstIndex(of: image) {
                                                note?.storedImages.remove(at: idx)
                                            }
                                        }
                                    label: {
                                        
                                        Label("Delete", systemImage: "trash")
                                    }
                                        
                                    }
                                    .accessibilityLabel("Image attachment")
                                    .accessibilityHint("Double tap and hold to scroll")
                                
                                
                            }
                        }
                        
                    }.tabViewStyle(.page)
                        .containerShape(Rectangle())
                        .cornerRadius(15)
                        .padding(10)
                    
                    
                }
                
            }
            
            
            
            //check if it's a new note or a passed one
            //  if let imageData = note?.image ?? newPhotoData,
            //  let uiImage = UIImage(data: imageData){
            //  Image(uiImage: uiImage)
            // .resizable()
            //  .scaledToFill()
            //  .frame(maxWidth: .infinity , maxHeight: 300)
            
            
            
            
            .navigationTitle("\(note?.timeStamp ?? Date.now, format: .dateTime.day().month().year()) \(note?.timeStamp ?? Date.now, format: .dateTime.hour().minute())")
            .navigationBarTitleDisplayMode(.inline)
            
            
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
                
                
                ToolbarItem(placement: .bottomBar) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        Label("Add Image", systemImage : "camera")
                            .accessibilityAddTraits([.isButton])
                            .accessibilityLabel("Camera")
                            .accessibilityHint("Double tap to add a photo into the current note")
                        
                    }
                    
                    
                }
                
                ToolbarItem(placement: .bottomBar) {
                    
                    Spacer()
                    
                }
                
                ToolbarItem(placement: .bottomBar) {
                    // NavigationLink(destination: AddNoteView()){
                    Button("Add Note", systemImage : "square.and.pencil") {
                    }.disabled(true)
                        .accessibilityAddTraits([.isButton])
                        .accessibilityLabel("New note")
                        .accessibilityHint("Double tap to compose a new note")
                }
                
            }
            
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                    if(note != nil) {
                        note?.storedImages.append(data)
                        selectedPhoto = nil
                    } else {
                        newPhotoData = data
                        selectedPhoto = nil
                        
                    }
                }
            }
        }
    }
    
    
    
    //Function for add the additional Text in a Note
    func saveText() -> DataNote {
        if(note == nil) {
            let newNote = DataNote(additionalText: additionalText)
            newNote.timeStamp = Date.now
            if(newPhotoData != nil) {
                //newNote.image = newPhotoData
                newNote.storedImages.append(newPhotoData!)
            }
            
            context.insert(newNote)
            
            return newNote
        }
        
        return DataNote(additionalText: "")
        
    }
    
    func updateText(_ note : DataNote) {
        note.additionalText = additionalText
        note.timeStamp = Date.now
        try? context.save()
        
    }
    
}

#Preview {
    AddNoteView()
}

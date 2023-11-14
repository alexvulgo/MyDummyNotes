//
//  MainView.swift
//  MyDummyNotes
//
//  Created by Alessandro Esposito Vulgo Gigante on 14/11/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            List() {
                NavigationLink() {
                    AddNoteView()
                } label: {
                    
                    Text("ciao")
                }
            }
            .navigationTitle("Notes")
            
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { print("Pressed") }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                    }
                    
                }
                
            }
            
        }
        
    }
}

#Preview {
    MainView()
}

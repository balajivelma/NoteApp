//
//  CreateNoteView.swift
//  POC
//
//  Created by balajireddy velma on 07/09/22.
//

import SwiftUI
import CoreData

struct CreateNoteView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isShowing: Bool
    @Binding var taskText: String
    var note: NoteItem?
    private var isButtonDisabled: Bool { taskText.isEmpty }
    
    private func addItem() {
        withAnimation {
            if let currentNote = note {
                currentNote.text = taskText
                currentNote.date = Date()
            } else {
                let newItem = NoteItem(context: viewContext)
                newItem.date = Date()
                newItem.text = taskText
                newItem.id = UUID()
            }
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            taskText = ""
        }
    }
    
    var body: some View {
        VStack {
          Spacer()
          VStack(spacing: 16) {
            TextEditor(text: $taskText)
              .foregroundColor(.black)
              .font(.system(size: 14, weight: .bold, design: .rounded))
              .padding()
              .background(
                Color(UIColor.secondarySystemBackground)
              )
              .cornerRadius(10)
              .frame(maxHeight: 200)
            
            Button(action: {
                isShowing = false
                addItem()
            }) {
              Spacer()
              Text("SAVE")
                .font(.system(size: 24, weight: .bold, design: .rounded))
              Spacer()
            } //: Button
            .disabled(isButtonDisabled)
            .padding()
            .foregroundColor(.white)
            .background(isButtonDisabled ? Color.gray : Color.pink)
            .cornerRadius(10)
          } //: VStack
          .padding(.horizontal)
          .padding(.vertical, 20)
          .background(
             Color.white
          )
          .cornerRadius(16)
          .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
          .frame(maxWidth: 640)
        } //: Vstack
        .padding()
      }
}

struct CreateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoteView(isShowing: .constant(true), taskText: .constant(""), note: nil)
    }
}

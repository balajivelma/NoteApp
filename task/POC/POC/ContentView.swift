//
//  ContentView.swift
//  POC
//
//  Created by balajireddy velma on 06/09/22.
//

import SwiftUI
import CoreData

struct ContentView : View {
    
    @State var currentNote: NoteItem?
    @State var taskText = ""
    @State private var showNewNote = false
    @State private var showDeleteAlert = false
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
      sortDescriptors: [NSSortDescriptor(keyPath: \NoteItem.date, ascending: false)],
      animation: .default)
    var notes: FetchedResults<NoteItem>
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    Text("Notes")
                        .font(.largeTitle.bold())
                        .frame(alignment: .leading)
                    let colums = Array(repeating: GridItem(.flexible(), spacing: 15), count: 1)
                    LazyVGrid(columns: colums) {
                        ForEach(notes, id: \.id) { note in
                            NoteCardView(note: note)
                                .padding([.trailing, .leading], 10)
                                .onLongPressGesture {
                                    currentNote = note
                                    showDeleteAlert.toggle()
                                }
                        }
                    }
                    .padding(.top, 30)
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("Hey!"), message: Text("Are you sure to delete this note"), primaryButton: .destructive(Text("Delete"), action: {
                            deleteItems()
                        }), secondaryButton: .cancel())
                    }
                }
                .padding(.top, 30)
            }
            Spacer(minLength: 80)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if !showNewNote {
                    Button(action: {
                        showNewNote = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                    })
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                .clipShape(Circle())
                        )
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                }
                }
            }
            if showNewNote {
                VStack {
                  Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(Color.gray)
                .opacity(0.5)
                .blendMode(.overlay)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                  withAnimation() {
                    showNewNote = false
                  }
                }
                CreateNoteView(isShowing: $showNewNote, taskText: $taskText, note: currentNote)
            }
        }
    }
    
    @ViewBuilder
    func NoteCardView(note: NoteItem) -> some View {
        let text = note.text ?? ""
        let date = note.date ?? Date()
        VStack{
            Text(text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Text(date, style: .date)
                    .foregroundColor(.black)
                    .opacity(0.8)
                Spacer(minLength: 0)
                Button {
                    taskText = text
                    currentNote = note
                    showNewNote = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 15, weight: .bold))
                        .padding(8)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                .clipShape(Circle())
                        )
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                }
            }
        }
        .padding()
        .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(.gray, lineWidth: 2)
                    .shadow(radius: 2)
            )
    }
    
    private func deleteItems() {
        if let currentNote = currentNote, let note = notes.first(where: { $0.id == currentNote.id }) {
            viewContext.delete(note)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentNote: nil).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

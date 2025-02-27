//
//  NotesView.swift
//  SwiftUiFireBaseLogin
//
//  Created by Harshit Verma on 2/25/25.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct NotesView: View {
    @State private var note: String = ""
    @State private var notes: [Note] = []
    @State private var editingNote: Note? = nil
    @State private var showLogin = false
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $note)
                    .frame(height: 150)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .onChange(of: note) {
                        if note.count > 1000 {
                            note = String(note.prefix(1000))
                        }
                    }

                HStack {
                    Button(action: saveNote) {
                        Text(editingNote == nil ? "Save" : "Update")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }

                    if editingNote != nil {
                        Button(action: cancelEdit) {
                            Text("Cancel")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                    }
                }

                List {
                    ForEach(notes) { note in
                        VStack(alignment: .leading) {
                            Text(note.content)
                                .padding()
                            HStack {
                                Button("Edit") { startEditing(note) }
                                    .foregroundColor(.blue)
                                Spacer()
                                Button("Delete") { deleteNote(note) }
                                    .foregroundColor(.red)
                            }
                        }
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.vertical, 4)
                    }
                }

                Spacer()

                Button(action: logOut) {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding()
            .onAppear(perform: fetchNotes)
            .navigationTitle("My Notes")
            .fullScreenCover(isPresented: $showLogin) {
                ContentView() // Assuming you already have a LoginView
            }
        }
    }

    func saveNote() {
        guard let userId = user?.uid else {
            print("User not logged in")
            showLogin = true
            return
        }

        let noteData: [String: Any] = [
            "content": note,
            "timestamp": Timestamp(),
            "userId": userId
        ]

        if let editingNote = editingNote {
            // Update existing note
            db.collection("notes").document(editingNote.id).updateData(noteData) { error in
                if let error = error {
                    print("Update failed: \(error.localizedDescription)")
                } else {
                    print("Note updated!")
                    fetchNotes()
                    resetNote()
                }
            }
        } else {
            // Add new note
            db.collection("notes").addDocument(data: noteData) { error in
                if let error = error {
                    print("Save failed: \(error.localizedDescription)")
                } else {
                    print("Note saved!")
                    fetchNotes()
                    resetNote()
                }
            }
        }
    }

    func fetchNotes() {
        guard let userId = user?.uid else { return }
        db.collection("notes")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Fetch failed: \(error.localizedDescription)")
                    return
                }

                if let documents = snapshot?.documents {
                    notes = documents.map { doc in
                        Note(
                            id: doc.documentID,
                            content: doc["content"] as? String ?? ""
                        )
                    }
                }
            }
    }

    func deleteNote(_ note: Note) {
        db.collection("notes").document(note.id).delete { error in
            if let error = error {
                print("Delete failed: \(error.localizedDescription)")
            } else {
                print("Note deleted!")
                fetchNotes()
            }
        }
    }

    func startEditing(_ note: Note) {
        self.note = note.content
        self.editingNote = note
    }

    func cancelEdit() {
        resetNote()
    }

    func resetNote() {
        note = ""
        editingNote = nil
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            showLogin = true
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}

struct Note: Identifiable {
    var id: String
    var content: String
}

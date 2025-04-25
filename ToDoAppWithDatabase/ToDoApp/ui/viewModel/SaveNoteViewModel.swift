import Foundation

class SaveNoteViewModel {
    
    var notesRepository = NotesRepository()
    
    func saveNote(note: String) {
        notesRepository.save(note: note)
    }
}

import Foundation

class NoteDetailViewModel {
    
    var notesRepository = NotesRepository()

    func update(note_id: Int, note: String) {
        notesRepository.update(note_id: note_id, note: note)
    }
}

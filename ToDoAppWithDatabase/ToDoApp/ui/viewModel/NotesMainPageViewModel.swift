import Foundation
import RxSwift

class NotesMainPageViewModel {
    
    var notesRepository = NotesRepository()
    
    var noteList = BehaviorSubject<[Notes]>(value: [Notes]())
    
     init() {
         copyDatabase()
         noteList = notesRepository.noteList
    }
    
    func search(searchWord: String) {
        notesRepository.search(searchWord: searchWord)
    }
    
    func delete(note_id: Int) {
        notesRepository.delete(note_id: note_id)
        uploadNotes()
    }
    
    func uploadNotes() {
        
        notesRepository.uploadNotes()
    }
    
    func copyDatabase() {
        
        let bundlePath = Bundle.main.path(forResource: "todo_app", ofType: ".sqlite")
        let destinationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let targetPath = URL(fileURLWithPath: destinationPath).appendingPathComponent("todo_app.sqlite")
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: targetPath.path) {
            print("Database already exists")
        } else {
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: targetPath.path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

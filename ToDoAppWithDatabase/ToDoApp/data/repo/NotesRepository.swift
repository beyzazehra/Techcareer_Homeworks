import Foundation
import RxSwift

class NotesRepository {
    
    var noteList = BehaviorSubject<[Notes]>(value: [Notes]())
    
    let db: FMDatabase?
    
    init() {
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniYolu = URL(fileURLWithPath: hedefYol).appendingPathComponent("todo_app.sqlite")
        
        db = FMDatabase(path: veritabaniYolu.path)
    }

    func save(note: String) {
        
        db?.open()
        
        do {
            try db!.executeUpdate("INSERT INTO toDos (name) VALUES (?)", values: [note])
            print("success")
        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func update(note_id: Int, note: String) {
        db?.open()
        
        do {
            try db!.executeUpdate("UPDATE toDos SET name = ? WHERE id = ?", values: [note, note_id])
        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func search(searchWord: String) {
        db?.open()
        
        
        do {
            var results = [Notes]()

            let result = try db!.executeQuery( "SELECT * FROM toDos WHERE id LIKE '%\(searchWord)%'", values: nil)
            
            while result.next() {
                let note_id = Int(result.string(forColumn: "id")) ?? 0
                let note = result.string(forColumn: "name")
                
                let notes = Notes(note_id: note_id, note: note)
                results.append(notes)
            }
           
            noteList.onNext(results)

        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func delete(note_id: Int) {
        db?.open()
        
        do {
            try db!.executeUpdate("DELETE FROM toDos WHERE id = ?", values: [note_id])
        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func uploadNotes() {
        
        db?.open()
        
        
        do {
            var noteArray = [Notes]()

            let result = try db!.executeQuery( "SELECT * FROM toDos", values: nil)
            
            while result.next() {
                let note_id = Int(result.string(forColumn: "id")) ?? 0
                let note = result.string(forColumn: "name") ?? ""
                
                let notes = Notes(note_id: note_id, note: note)
                noteArray.append(notes)
            }
           
            noteList.onNext(noteArray)

        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
}

import UIKit

class NoteDetail: UIViewController {

    @IBOutlet weak var noteTextField: UITextField!
    
    var note: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tempNote = note {
            noteTextField.text = tempNote.note
        }
    }

    @IBAction func editButton(_ sender: Any) {
        
        if let note = noteTextField.text {
            edit(note: note)
        }
    }
    
    func edit(note: String) {
        print("Note Edit: \(note)")
    }
}

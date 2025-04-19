import UIKit

class NoteDetail: UIViewController {

    @IBOutlet weak var noteTextField: UITextView!
    
    var note: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextField.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

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

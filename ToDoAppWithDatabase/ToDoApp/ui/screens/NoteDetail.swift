import UIKit

class NoteDetail: UIViewController {

    @IBOutlet weak var noteTextField: UITextView!
    
    var note: Notes?
    var noteDetailViewModel = NoteDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextField.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        if let tempNote = note {
            noteTextField.text = tempNote.note
        }
    }

    @IBAction func editButton(_ sender: Any) {
       
        edit( note_id: note!.note_id!,note: noteTextField.text)
    }
    
    func edit(note_id: Int, note: String) {
        
        noteDetailViewModel.update(note_id: note_id, note: note)
    }
}

import UIKit

class SaveNote: UIViewController {
        
    @IBOutlet weak var noteTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextField.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    @IBAction func saveButton(_ sender: Any) {
       
        if let note = noteTextField.text {
            save(note: note)
        }
  }
    
    func save(note: String) {
        print("Note Saved: \(note)")
    }
}

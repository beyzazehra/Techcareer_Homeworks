import UIKit

class SaveNote: UIViewController {
    
    
    @IBOutlet weak var noteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

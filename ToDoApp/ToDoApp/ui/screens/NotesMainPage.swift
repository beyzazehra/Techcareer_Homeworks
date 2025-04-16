import UIKit

class NotesMainPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {

            if let note = sender as? Notes {
                let nextVC = segue.destination as! NoteDetail
                nextVC.note = note
            }
        }
    }
}


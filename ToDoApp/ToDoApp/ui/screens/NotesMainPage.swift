import UIKit

class NotesMainPage: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    
    var notesList = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTableView.dataSource = self
        notesTableView.delegate = self
        appendDummyData()
    }

    func appendDummyData() {
        
        let n1 = Notes(note_id: 1, note: "This is note 1 content")
        let n2 = Notes(note_id: 2, note: "This is note 2 content")
        let n3 = Notes(note_id: 3, note: "This is note 3 content")
        
        notesList.append(n1)
        notesList.append(n2)
        notesList.append(n3)
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

extension NotesMainPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteCell

        let note = notesList[indexPath.row]
        cell.noteCellTextField.text = note.note
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let note = notesList[indexPath.row]
        
        performSegue(withIdentifier: "toDetail", sender: note)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let note = self.notesList[indexPath.row]
            
            let alert = UIAlertController(title: "Are you sure you want to delete?", message: "\(note.note ?? "")", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
                print("Delete Note: \(note.note ?? "")")
            }
            alert.addAction(yesAction)
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

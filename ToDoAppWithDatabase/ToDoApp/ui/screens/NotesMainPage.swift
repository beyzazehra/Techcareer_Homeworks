import UIKit
import RxSwift

class NotesMainPage: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    
    var noteList = [Notes]()
    var notesMainPageViewModel = NotesMainPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTableView.dataSource = self
        notesTableView.delegate = self
        
        _ = notesMainPageViewModel.noteList.subscribe (onNext: { list in //dinleme
            self.noteList = list
            self.notesTableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notesMainPageViewModel.uploadNotes()
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

extension NotesMainPage: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        notesMainPageViewModel.search(searchWord: searchText)
    }
}

extension NotesMainPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteCell

        let note = noteList[indexPath.row]
        cell.noteCellTextField.text = note.note
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let note = noteList[indexPath.row]
        
        performSegue(withIdentifier: "toDetail", sender: note)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let note = self.noteList[indexPath.row]
            
            let alert = UIAlertController(title: "Are you sure you want to delete?", message: "\(note.note ?? "")", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
                self.notesMainPageViewModel.delete(note_id: note.note_id!)
            }
            alert.addAction(yesAction)
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

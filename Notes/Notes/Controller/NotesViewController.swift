//
//  NotesViewController.swift
//  Notes
//
//  Created by Abul Kashem on 12/2/23.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesTableView: UITableView!
    
    var notes = [Note]()
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNotes()
        notesTableView.reloadData()
    }
    
    func setupTableView(){
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }
    
    @IBAction func notesAddBarButtonAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "NotesDetailsTableViewController") as! NotesDetailsTableViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func fetchNotes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            notes = [Note]()
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rowAddDate", ascending: true)]
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch {
            alertNotifyUser(message: "Fetch for notes failed.")
        }
    }
    
    func deleteNote(indexPath: IndexPath) {
        let note = notes[indexPath.row]
        if let managedObjectContext = note.managedObjectContext {
            managedObjectContext.delete(note)
            
            do {
                try managedObjectContext.save()
                self.notes.remove(at: indexPath.row)
                notesTableView.reloadData()
            } catch {
                alertNotifyUser(message: "Delete failed.")
                notesTableView.reloadData()
            }
        }
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
        self.present(alert, animated: true,completion: nil)
    }


}
extension NotesViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell",for: indexPath)
        let note = notes[indexPath.row]
        
        //cell.detailTextLabel?.text = string(from: note.addDate!)

        cell.textLabel?.text = note.title
        if let addDate = note.addDate{
            cell.detailTextLabel?.text = dateFormatter.string(from: addDate)
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete"){(rowAction, indexPath) in
            self.deleteNote(indexPath: indexPath)
        }
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NotesDetailsTableViewController else{return}
        
        if let segueIdentifier = segue.identifier, segueIdentifier == "note", let indexPathForSelectedRow = notesTableView.indexPathForSelectedRow{
            destination.note = notes[indexPathForSelectedRow.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
        
}

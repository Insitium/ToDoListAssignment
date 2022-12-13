//
//  ToDoTableView.swift
//  ToDoListAssignment
//
//  Created by Sarthak Vashistha on 2022-12-11.
//

import UIKit
import CoreData


var toDoList = [NotesData]()

class ToDoTableView: UITableViewController{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var firstload = true
    func nonDeletedToDo() -> [NotesData]
    {
        var nonDeletedToDoList = [NotesData]()
        for toDo in toDoList
        {
            if(toDo.deletedDate == nil){
                nonDeletedToDoList.append(toDo)
            }
        }
        return nonDeletedToDoList
    }
    
    override func viewDidLoad() {
        if(firstload){
            firstload = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesData")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let toDo = result as! NotesData
                    toDoList.append(toDo)
                }
            }
            catch{
                print("Fetching Failed")
            }
        }
    }
    
    var selectedToDo: NotesData? = nil

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete"){_, _, _ in
            self.context.delete(toDoList[indexPath.row])
            toDoList.remove(at: indexPath.row)
            do{
                try self.context.save()
            }catch _ {}
            
        }
        let done = UIContextualAction(style: .normal, title: "Done", handler:{(context, view,actionPerformed: (Bool)->()) in
            let alert = UIAlertController(title:"Alert", message:"Task done", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Great!", style: .cancel, handler: {action in
            }))
            self.present(alert, animated: true)
            actionPerformed(true)
        })
        done.backgroundColor = .systemYellow
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,done])
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit", handler: {(context, view,actionPerformed:(Bool)->()) in
            let editView = self.storyboard?.instantiateViewController(withIdentifier: "ToDoDetailVC") as! ToDoDetailVC
            self.navigationController?.pushViewController(editView, animated: true)
            actionPerformed(true)
        })
        edit.backgroundColor = .blue
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit])
        return swipeConfiguration
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDoCell = tableView.dequeueReusableCell(withIdentifier: "toDoCellID", for: indexPath) as! ToDoCell
        let date = Date()
        
        let thisNotesData: NotesData!
        thisNotesData = nonDeletedToDo()[indexPath.row]
        toDoCell.nameLabel.text = thisNotesData.notes
        toDoCell.notesLabel.text = thisNotesData.name
        
        return toDoCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return nonDeletedToDo().count
        }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editToDo", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editToDo"){
            let indexPath = tableView.indexPathForSelectedRow!
            let toDoNotes = segue.destination as? ToDoDetailVC
            
            let selectedToDo : NotesData!
            selectedToDo = nonDeletedToDo()[indexPath.row]
            toDoNotes?.selectedToDo = selectedToDo
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

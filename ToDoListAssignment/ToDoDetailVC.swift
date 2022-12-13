//
//  ViewController.swift
//  ToDoListAssignment
//
/* Created and Developed by
 Manmeen Kaur - 301259638
 Sarthak Vashistha - 301245284
 Neha Patel - 301280513
 
 
 Date Created: 11/12/2022
 To-Do List Assignment - Created To Do List App - Data Persistence + Gesture Control
 Version: 1.3.0
 */
import UIKit
import CoreData

class ToDoDetailVC: UIViewController {
    
    
    @IBOutlet weak var taskTitleTF: UITextField!
    
    @IBOutlet weak var TaskDescriptionTV: UITextView!
    
    @IBOutlet weak var dueDateSwitch: UISwitch!
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    @IBOutlet weak var completedSwitch: UISwitch!
    
    
    var selectedToDo: NotesData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedToDo != nil){
            taskTitleTF.text = selectedToDo?.name
            TaskDescriptionTV.text = selectedToDo?.notes
            dueDateSwitch.isOn = ((selectedToDo?.hasDueDate) != nil)
            DatePicker.date = selectedToDo?.date ?? Date()
            completedSwitch.isOn = ((selectedToDo?.isCompleted) != nil)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedToDo==nil){
            let entity = NSEntityDescription.entity(forEntityName: "NotesData", in: context)
            
            let newToDo = NotesData(entity: entity!, insertInto:context)
            newToDo.id = toDoList.count as NSNumber
            newToDo.name = self.taskTitleTF.text
            newToDo.notes = self.TaskDescriptionTV.text
            newToDo.date = self.DatePicker.date
            newToDo.hasDueDate = self.dueDateSwitch.isSelected
            newToDo.isCompleted = self.completedSwitch.isSelected
            
            
            do{
                try context.save()
                toDoList.append(newToDo)
                self.navigationController?.popToRootViewController(animated: true)
            }
            catch{
                print("context saving error")
                
            }
        }
        else    //edit
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesData")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let toDo = result as! NotesData
                    if(toDo == selectedToDo)
                    {
                        toDo.name = taskTitleTF.text
                        toDo.notes = TaskDescriptionTV.text
                        toDo.date = DatePicker.date
                        toDo.hasDueDate = dueDateSwitch.isSelected
                        toDo.isCompleted = completedSwitch.isSelected
                        try context.save()
                        navigationController?.popViewController(animated: true)
                        
                        
                    }
                }
            }
            catch{
                print("Fetching Failed")
            }
        }
        
    }
    
    
    @IBAction func DeleteToDo(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesData")
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let toDo = result as! NotesData
                if(toDo == selectedToDo)
                {
                    toDo.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                    
                    
                }
            }
        }
        catch{
            print("Fetching Failed")
        }
    }
}


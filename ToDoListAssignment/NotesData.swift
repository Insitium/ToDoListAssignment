//
//  NotesData.swift
//  ToDoListAssignment
/* Created and Developed by
 Manmeen Kaur - 301259638
 Sarthak Vashistha - 301245284
 Neha Patel - 301280513
 
 
 Date Created: 11/12/2022
 To-Do List Assignment - Created To Do List App - Data Persistence + Gesture Control
 Version: 1.3.0
 */

import CoreData

@objc(NotesData)
class NotesData: NSManagedObject{
    @NSManaged public var date: Date?
    @NSManaged public var deletedDate: Date?
    @NSManaged public var dueDate: String?
    @NSManaged public var hasDueDate: Bool
    @NSManaged public var id: NSNumber
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
}

//
//  NotesData.swift
//  ToDoListAssignment
//
//  Created by Sarthak Vashistha on 2022-12-12.
//

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

//
//  Persistence.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/9/21.
//

import CoreData
import UIKit

func CreateGoal(goal: String, details: String, done: Bool, context: NSManagedObjectContext) {
    let newGoal = Goal(context:context)
    newGoal.goal = goal
    newGoal.details = details
    newGoal.done = false
}

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        createExampleDatabase(viewContext: viewContext)
        return result
    }()
    
    static func createExampleDatabase(viewContext: NSManagedObjectContext) {
        CreateGoal(goal: "Leaving the Curb", details: "Signal and wait until it's safe to re-enter traffic.", done: false, context: viewContext)
        CreateGoal(goal: "Controlling the Vehicle", details: "Use the gas pedal, brake, steering wheel, and other controls correctly. Change your speed to suit the number and speed of other vehicles, pedestrians, road conditions, weather conditions, construction, amount of light, and the distance you can see ahead.", done: false, context: viewContext)
        CreateGoal(goal: "Switching Lanes", details: "Use Signal, Mirror, Over the Shoulder, and Go (SMOG). Switch lanes smoothly and maintain speed while keeping a safe distance from other vehicles.", done: false, context: viewContext)
        CreateGoal(goal: "Traffic Signals", details: "Understanding traffic signals and signs.", done: false, context: viewContext)
        CreateGoal(goal: "Intersections", details: "Scan carefully for signs, signals, pedestrians, and other vehicles. Yield and take the right-of-way correctly. Understand point of no return.", done: false, context: viewContext)
        CreateGoal(goal: "Stopping", details: "Be able to stop smoothly and at the right spot. Be able to stop quickly and safely in an emergency.", done: false, context: viewContext)
        CreateGoal(goal: "Backing up", details: "Look over right shoulder. Can back in a straight line. Have complete control of the vehicle.", done: false, context: viewContext)
        CreateGoal(goal: "Parking on a Hill", details: "Turn steering wheel the correct way.", done: false, context: viewContext)
        CreateGoal(goal: "Parallel Parking", details: "Park 12-18 inches from the curb", done: false, context: viewContext)
        CreateGoal(goal: "Backing out of Driveway into Traffic", details: "Make the proper stops and signals, while staying close to the curb. Be alert for pedestrian traffic and other vehicles.", done: false, context: viewContext)
        CreateGoal(goal: "Arm Signals", details: "Arms signals for right/left turns and slow or stop.", done: false, context: viewContext)
        CreateGoal(goal: "Freeway Driving", details: "Maintain speed, distance between cars. Enter and exit safely.", done: false, context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DriveBuddy")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { [self] (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                let viewContext = self.container.viewContext
                if inMemory || (try? viewContext.count(for: Goal.fetchRequest())) == 0 {
                  PersistenceController.createExampleDatabase(viewContext:viewContext)
                }
              }
        })
        
        // Automatically persist when entering background.
        if (!inMemory) {
            let center = NotificationCenter.default
            let notification = UIApplication.willResignActiveNotification
            center.addObserver(forName: notification, object: nil, queue: nil) { [self] _ in
                if self.container.viewContext.hasChanges {
                    try? self.container.viewContext.save()
                }
            }
        }
    }
}

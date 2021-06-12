//
//  Standard.swift
//  School
//
//  Created by Vishal Singh on 12/06/21.
//  Copyright © 2021 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation

class Standard: ObservableObject, Identifiable {
    let id = UUID()
    var name: String = ""
    
    // these fire `objectWillChange` which is a part of ObservableObject protocol
    // in our case both the standard view observes these properties
    @Published var students: [Student] = []
    @Published var averageMarks: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // custom publisher (also called subjects)
    // used to trigger an event manually
    // in our case when a new student gets added, we send this event
    var studentCountUpdatedPublisher = PassthroughSubject<Void, Never>()
    
    func createNewStudent() {
        let newStudent = Student(students.count + 1, marks: "0.0")
        admitStudent(newStudent)
        
        // firing custom publisher when a new student gets added
        studentCountUpdatedPublisher.send(())
    }
    
    // Subscribing to default publishers for any array elements
    
    private func admitStudent(_ newStudent: Student) {
        students.append(newStudent)
        newStudent
            .objectWillChange
            .debounce(for: 0.1, scheduler: DispatchQueue.main, options: nil)
            .sink { _ in
                self.updateAverage()
            }
            .store(in: &cancellables)
    }
    
    private func updateAverage() {
        let sum = students.reduce(0.0) { $0 + (Double($1.marks) ?? 0.0) }
        self.averageMarks = String(format: "%.2f", (sum / Double(students.count)))
    }
    
    init(_ number: Int) {
        self.name = "Class \(number)"
    }
}


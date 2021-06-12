//
//  Student.swift
//  School
//
//  Created by Vishal Singh on 12/06/21.
//  Copyright © 2021 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation

class Student: ObservableObject, Identifiable {
    let id = UUID()

    // these fire `objectWillChange` which is a part of ObservableObject protocol
    // in our case both the student view and standard class observe/receive/subscribe to these changes
    @Published var name: String = ""
    @Published var marks: String = "90.0"
    
    init(_ number: Int, marks: String) {
        self.name = "Student \(number)"
        self.marks = marks
    }
}

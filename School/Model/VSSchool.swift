//
//  VSSchool.swift
//  School
//
//  Created by Vishal Singh on 12/06/21.
//  Copyright © 2021 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation

class VSSchool: ObservableObject, Identifiable {
    let id = UUID()
    
    var name: String = "SCHOOL"
    
    // these fire `objectWillChange` which is a part of ObservableObject protocol
    // in our case school view observes these for layout changes
    @Published var classes: [Standard] = []
    @Published var totalStudents: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    func createNewStandard() {
        let newStandard = Standard(classes.count + 1)
        subscribeToStudentsCount(for: newStandard)
        classes.append(newStandard)
    }
    
    // Subscribing to custom publishers / user defined publishers for array elements
    
    private func subscribeToStudentsCount(for newStandard: Standard) {
        newStandard
            .studentCountUpdatedPublisher
            .print("Student count updater in school: \(newStandard.name)")
            .sink { _ in
                self.totalStudents += 1
            }
            .store(in: &cancellables)
    }
}

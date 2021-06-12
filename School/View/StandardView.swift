//
//  StandardView.swift
//  School
//
//  Created by Vishal Singh on 12/06/21.
//  Copyright © 2021 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct StandardView: View {
    
    @ObservedObject var standard: Standard
    
    var body: some View {
        VStack {
            Text(standard.name)
                .font(.title)
                .padding()
            HStack {
                Spacer()
                Text("Total students: \(standard.students.count)")
                    .font(.subheadline)
                    .padding()
                Text("Avg. Marks: \(standard.averageMarks)")
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            
            EditClassView(standard: standard)
                .padding([.bottom])
            
            VStack {
                ForEach(standard.students, content: StudentView.init)
            }
        }
    }
}

struct EditClassView: View {
    
    @ObservedObject var standard: Standard
    
    var body: some View {
        Button("Add new student", action: standard.createNewStudent)
            .layoutPriority(1)
    }
}

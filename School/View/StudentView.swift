//
//  StudentView.swift
//  School
//
//  Created by Vishal Singh on 12/06/21.
//  Copyright © 2021 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct StudentView: View {
    
    @ObservedObject var student: Student
    
    var body: some View {
        VStack {
            Text("\(student.name) (\(student.marks))")
                .font(.body)
            EditStudentView(student: student)
                .padding([.leading])
        }
    }
}

struct EditStudentView: View {
    
    @ObservedObject var student: Student
    
    var body: some View {
        HStack {
            Spacer()
            TextField("Student Name", text: $student.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(Color.primary)
                .padding([.trailing])
            TextField("Marks", text: $student.marks)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(Color.primary)
                .padding([.trailing])
            Spacer()
        }
    }
}

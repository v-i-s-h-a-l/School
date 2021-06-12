//
//  SchoolView.swift
//  School
//
//  Created by Vishal Singh on 12/06/21.
//  Copyright © 2021 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct SchoolView: View {
    
    @ObservedObject var school: VSSchool
    
    var body: some View {
        VStack {
            Text(self.school.name)
                .fontWeight(Font.Weight.heavy)
                .font(.largeTitle)
                .rotation3DEffect(Angle.degrees(-Double(45)), axis: (x: 1, y:0, z: 0))
                .shadow(color: Color.black, radius: 6, x: 0, y: 10)
                .padding()
            
            Text("Total Students: \(self.school.totalStudents)")
                .font(.headline)
                .padding([.bottom])
            EditSchoolView(school: self.school)
                .padding([.bottom])
            VStack {
                ForEach(self.school.classes, content: StandardView.init)
            }
        }
    }
}

struct EditSchoolView: View {
    
    @ObservedObject var school: VSSchool
    
    var body: some View {
        Button("Add new class", action: school.createNewStandard)
            .layoutPriority(1)
    }
}

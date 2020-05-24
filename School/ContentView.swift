//
//  ContentView.swift
//  School
//
//  Created by Vishal Singh on 18/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import SwiftUI

class Student: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String = ""
    @Published var marks: String = "90.0"
    
    init(_ number: Int, marks: String) {
        self.name = "Student \(number)"
        self.marks = marks
    }
}

class Standard: ObservableObject, Identifiable {
    let id = UUID()
    var name: String = ""
    @Published var students: [Student] = []
    @Published var averageMarks: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
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

class VSSchool: ObservableObject, Identifiable {
    let id = UUID()
    
    var name: String = "SCHOOL"
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
struct ContentView: View {
    
    @ObservedObject var school = VSSchool()
    
    var body: some View {
        ScrollView {
            SchoolView(school: school)
        }
        .background(Color.purple)
//                .edgesIgnoringSafeArea(.all))
        .accentColor(.orange)
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().colorScheme(.dark)
                .previewDevice(PreviewDevice.init(rawValue: "Mac"))
//            ContentView().colorScheme(.light)
//                .previewDevice(PreviewDevice.init(rawValue: "mac"))
        }
    }
}

#endif

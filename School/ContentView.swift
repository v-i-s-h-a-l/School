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
    @Published var name: String = ""
    @Published var students: [Student] = []
    @Published var averageMarks: String = ""
    
    private var cancellable: AnyCancellable?
    
    var studentCountPublisher = PassthroughSubject<Int, Never>()

    func createNewStudent() {
        let newStudent = Student(students.count + 1, marks: "0.0")
        cancellable = newStudent.objectWillChange
            .debounce(for: 0.1, scheduler: DispatchQueue.main, options: nil)
            .sink { _ in
            self.updateAverage()
        }
        students.append(newStudent)
    }

    private func updateAverage() {
        let sum = students.reduce(0.0) { sum, student in
            return sum + (Double(student.marks) ?? 0.0)
        }
        self.averageMarks = String(format: "%.2f", (sum / Double(students.count)))
        print(cancellable == nil)
    }

    init(_ number: Int) {
        self.name = "Class \(number)"
    }
}

class VSSchool: ObservableObject, Identifiable {
    
    typealias Input = Int
    typealias Failure = Never
    
    let id = UUID()

    @Published var name: String = "SCHOOL"
    @Published var classes: [Standard] = []

    func createNewStandard() {
        let newStandard = Standard(classes.count + 1)
        classes.append(newStandard)
//        newStandard.objectWillChange.receive(subscriber: <#T##Subscriber#>)
        objectWillChange.send()
    }
}


struct SchoolView: View {

    @ObservedObject var school: VSSchool

    var body: some View {
        return HStack {
            Spacer()
            VStack {
                Text(school.name)
                    .font(.largeTitle)
                    .padding()
                Text("Total Classes: \(school.classes.count)")
                    .font(.headline)
                    .padding([.bottom])
    //            Text("Total students: \(school.totalStudents)")
    //                .font(.footnote)
    //                .padding([.bottom])
                EditSchoolView(school: school)
                    .padding([.bottom])
                VStack {
                    ForEach(school.classes, content: StandardView.init)
                }
            }
            Spacer()
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
                Text("Total students: \(standard.students.count)")
                    .font(.subheadline)
                    .padding()
                Text("Avg. Marks: \(standard.averageMarks)")
                    .font(.subheadline)
                    .padding()
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
            TextField("Student Name", text: $student.name)
                .foregroundColor(Color.primary)
            TextField("Marks", text: $student.marks)
            .foregroundColor(Color.primary)
        }
    }
}

struct ContentView: View {
    
    var body: some View {
        let standard = Standard(1)

        let school = VSSchool()
        school.classes.append(standard)
        
        return ScrollView {
            Spacer()
            SchoolView(school: school)
        }
        .background(
            Color.purple
            .edgesIgnoringSafeArea(.all)
        )
        .accentColor(.orange)
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().colorScheme(.dark)
            ContentView().colorScheme(.light)
        }
    }
}

#endif

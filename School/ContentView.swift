//
//  ContentView.swift
//  School
//
//  Created by Vishal Singh on 18/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var school = VSSchool()
    
    var body: some View {
        ZStack {
            Color.purple
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                SchoolView(school: school)
            }
        }
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

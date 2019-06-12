//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Chandran, Sudha | SDTD on 11/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        VStack {
            Image("turtlerock")
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
            VStack {
                Text("Text Fonts")
                    .font(Font.largeTitle)
                Text("Title")
                    .font(Font.title)
                Text("Caption")
                    .font(Font.caption)
                Text("callout")
                    .font(Font.callout)
                Text("footnote")
                    .font(Font.footnote)
            }
            HStack {
                Text("First")
                Text("Second")
                Text("Third")
                Text("Fourth")
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

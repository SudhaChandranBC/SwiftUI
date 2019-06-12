//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Chandran, Sudha | SDTD on 11/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import SwiftUI

struct User: Identifiable {
    var id: Int
    let username, message, imageName: String
}
struct ContentView : View {
    let users: [User] = [
        .init(id: 0, username: "Bill Gates", message: "Microsoft", imageName: "bill"),
        .init(id: 1,username: "Tim Cook ", message: "Apple", imageName: "tim"),
        .init(id: 2,username: "Sundar Pichai", message: "Pichai Sundararajan, also known as Sundar Pichai, is an Indian-American business executive. He is an engineer and the chief executive officer of Google LLC.", imageName: "sundar")
    ]
    
    var body: some View {
        NavigationView {
            List {
                Text("Header").font(.largeTitle)
                ForEach(users.identified(by: \.id)) { user in
                    //User row
                    UserRow(user: user)
                }
            }.navigationBarTitle(Text("Dynamic List"))
        }
    }
}

struct UserRow: View {
    let user: User
    var body: some View {
        HStack {
            Image(user.imageName)
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .shadow(radius: 0.5)
            VStack(alignment: .leading) {
                Text(user.username).font(.headline)
                Text(user.message).lineLimit(nil)
                }.padding(.leading, 8)
            }.padding()
    }
}
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

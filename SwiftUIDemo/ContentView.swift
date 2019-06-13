//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Chandran, Sudha | SDTD on 11/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import SwiftUI
import Combine

struct User: Identifiable {
    var id: Int
    let username, company, imageName, postTime, postText, postImageName: String
}
struct ContentView : View {
    let users: [User] = [
        .init(id: 0, username: "Bill Gates", company: "Microsoft", imageName: "bill", postTime: "8h", postText:"Microsoft Corporation is an American multinational technology company with headquarters in Redmond, Washington. ", postImageName: "microsoft"),
        .init(id: 1,username: "Tim Cook ", company: "Apple", imageName: "tim", postTime: "2h", postText:"Apple Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, and online services.", postImageName:"apple"),
        .init(id: 2,username: "Sundar Pichai", company: "Microsoft", imageName: "sundar", postTime: "6h", postText:"Google LLC is an American multinational technology company that specializes in Internet-related services and products.", postImageName:"google")
    ]
    
    var body: some View {
        NavigationView {
            
            List {
                NavigationButton(destination: FormView()) {
                    Text("Form! Click Me!")
                }
                
                NavigationButton(destination: CoursesView()) {
                    Text("Fetch JSON Data!")
                }
                
                NavigationButton(destination: ZStackViews()) {
                    Text("ZStacks!!")
                }
                
                VStack(alignment: .leading) {
                    Text("Trending users..")
                    ScrollView {
                        VStack {
                            HStack {
                                ForEach(users.identified(by: \.id)) { user in
                                    NavigationButton(destination: DetailView()) {
                                        TrendingUser(user: user)
                                    }
                                }
                            }
                        }
                    }.frame(height:150)
                }
                
                
                
                Text("Users Posts...").font(.largeTitle)
                ForEach(users.identified(by: \.id)) { user in
                    //User row
                    UserPost(user: user)
                    
                }
            }.navigationBarTitle(Text("Dynamic User List"))
        }
    }
}


struct ZStackViews: View {
    @State var tapCount = 0
    
    var body : some View {
        let tap = TapGesture().onEnded { _ in
            self.tapCount += 1
        }

        return ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100, alignment: .center)
                .gesture(tap)
            Text("\(tapCount)")
                .color(.white)
                .font(.largeTitle)
        }
    }
    
}

struct CourseRow: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading) {
//            Image("apple")
//                .resizable()
//                .frame(width: 200, height: 200)
//                .clipped()
            ImageViewWidget(imageUrl: course.imageUrl)
            Text(course.name)
            Text(course.imageUrl)
        }
    }
}

class ImageLoader: BindableObject {
    var didChange = PassthroughSubject<Data, Never>()
    
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
struct ImageViewWidget: View {
    @ObjectBinding var imageLoader: ImageLoader
    
    init(imageUrl: String) {
        imageLoader = ImageLoader(imageUrl: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: (imageLoader.data.count == 0) ? UIImage(named: "apple")! : UIImage(data: imageLoader.data)!)
            .resizable()
            .frame(width: 300, height: 200)
    }
}
class NetworkManager: BindableObject {
    var didChange = PassthroughSubject<NetworkManager, Never>()
    var courses = [Course]() {
        didSet {
            didChange.send(self)
        }
    }
    
    init() {
        guard let url = URL(string: "https://api.letsbuildthatapp.com/jsondecodable/courses") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let courses = try! JSONDecoder().decode([Course].self, from: data)
            DispatchQueue.main.async {
                self.courses = courses
            }
        }.resume()
    }
}
struct Course: Decodable {
    let name, imageUrl: String
}

struct CoursesView: View {
    @State var nm = NetworkManager()
    
    var body: some View {
        NavigationView {
//            List {
            
//            }
//                Text("Hi")
            List (
                nm.courses.identified(by: \.name)
            ) {
                CourseRow(course: $0)
            }.navigationBarTitle(Text("Courses"))
        }
        
    }
}

struct FormView: View {
    
    @State var firstName = ""
    @State var lastName = ""
    @State var users = [""]
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    VStack {
                        Group {
                            TextField($firstName, placeholder: Text("First Name")).padding(12)
                            }.background(Color.white).clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(radius: 5)
                        Group {
                            TextField($lastName, placeholder: Text("Last Name")).padding(12)
                            }.background(Color.white).clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(radius: 5)
                        HStack {
                            Button(action: {
                                self.users.append("\(self.firstName) \(self.lastName)")
                                self.firstName = ""
                                self.lastName = ""
                            }) {
                                Text("Add to List").color(.white)
                                }
                                .padding(15)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            
                            Button(action: {
                                self.users.removeAll()
                            }) {
                                Text("Delete from List").color(.white)
                                }
                                .padding(15)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            }.padding(15)
                        
                    }.padding(12)
                    }.background(Color.gray)
                
                List(users .identified(by: \.self)) {
                    Text($0)
                }

            }.navigationBarTitle(Text("States in SwiftUI"))
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail View")
    }
}

struct UserPost: View {
    let user: User
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(user.imageName)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .clipped()
                VStack(alignment: .leading) {
                    Text(user.username).font(.headline)
                    Text(user.postTime)
                    }.padding(.leading, 8)
                }.padding(.leading, 16).padding(.top, 16)
            
            Text(user.postText)
                .lineLimit(nil)
                .padding(.leading, 16)
                .padding(.trailing, 100)
            Image(user.postImageName)
                .resizable()
                .frame(height: 350)
        }.padding(.leading, -20)
            .padding(.trailing, -20)
            .padding(.bottom, 0)
        
    }
}

struct TrendingUser: View {
    let user: User
    var body: some View {
        VStack (alignment: .leading) {
            Image(user.imageName)
                .renderingMode(.original)
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(8)
            Text(user.username).font(.subheadline)
            Text(user.company).font(.caption)

            }
    }
}

struct UserRow: View {
    let user: User
    var body: some View {
        HStack {
            Image(user.imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .shadow(radius: 0.5)
            VStack(alignment: .leading) {
                Text(user.username).font(.headline)
                Text(user.postText).lineLimit(nil)
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


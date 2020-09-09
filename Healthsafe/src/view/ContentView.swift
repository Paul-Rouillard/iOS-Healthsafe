//
//  ContentView.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 05/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

// All modifier are in Styles.swift

struct LoginFormView : View {
    @State private var showError: Bool = false
    @State private var showEmpty: Bool = false
    @State private var confirmation: String = ""
    @State private var showConfirmation: Bool = false

    @Binding var signInSuccess: Bool

    @ObservedObject var connexion: Connexion
    
    var body: some View {
        VStack {
            Image("Logo_healthsafe")
            Spacer()
                .frame(height: 75.0)
            VStack (alignment: .leading){
                Text("Welcome to Healthsafe")
                    .font(.title)
                    .modifier(LabelStyle())
            }
            .padding()
            Spacer()
                .frame(height: 75.0)
            VStack {
                TextField("ID", text: $connexion.emailAddr)
                    .modifier(LabelStyle())

                Spacer()
                    .frame(height: 30.0)
                SecureField("PASSWORD", text: $connexion.password)
                    .modifier(LabelStyle())
            }
            Spacer()
                .frame(height: 50.0)

//            HStack {
//                Text(" Password")
//                TextField("type here", text: $password)
//                    .textContentType(.password)
//            }.padding()

            if showError {
                Text("Incorrect username/password.").foregroundColor(Color.red)
            }
            if showEmpty {
                Text("Error: One or all fields are empty.")
            }
            VStack {
                Button(action: {
                    if (connexion.checkEmpty) {
                        do {
                            try self.connect()
                            self.signInSuccess = true
                        }
                        catch {
                            self.showError = true
                        }
                    } else {
                        self.showEmpty = true
                    }
                    
                }) {
                    Text("Connexion")
                        .modifier(ButtonStyle())
                }
                Spacer()
                    .frame(height: 25)
                NavigationLink(destination: PreSignUp()) {
                    Text("Inscription")
                        .modifier(ButtonStyle())
                }
            }
        }
    }
    
    func connect() throws {
        guard let encoded = try? JSONEncoder().encode(connexion) else {
            print("Fail to encode newMed")
            return
        }
        let url = URL(string: "https://healthsafe-api-beta.herokuapp.com/api/signin/create")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        print(String(data: encoded, encoding: .utf8)!)

        URLSession.shared.dataTask(with: request) {
            guard let data = $0 else {
                print("No data in response: \($2?.localizedDescription ?? "Unkwnon Error").")
                return
            }
            if let decoder = try? JSONDecoder().decode(Connexion.self, from: data) {
                self.confirmation = "Sign in completed!\nWelcome to Healthsafe!"
                self.showConfirmation = true
            } else {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Invalid response \(dataString)")
            }
        }.resume()
    }
}

struct ContentView: View {
    
    @State var signInSuccess = false

    var body: some View {
        return Group {
            if signInSuccess {
                Home()
            }
            else {
                LoginFormView(signInSuccess: $signInSuccess, connexion: Connexion())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

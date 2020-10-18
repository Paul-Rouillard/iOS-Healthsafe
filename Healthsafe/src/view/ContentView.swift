//
//  ContentView.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 05/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI
import Combine

struct LoginFormView: View {
    @State private var showError: Bool = false
    @State private var showEmpty: Bool = false
    @State private var showSignUp: Bool = false
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
                    .frame(width: 200.0)
                    .modifier(LabelStyle())

                Spacer()
                    .frame(height: 30.0)
                SecureField("PASSWORD", text: $connexion.password)
                    .frame(width: 200.0)
                    .modifier(LabelStyle())
            }
            Spacer()
                .frame(height: 50.0)
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
                .padding(.horizontal, 25.0)
                
                Spacer()
                    .frame(height: 25)
                Button(action: {
                    print("inscription pressed")
                    self.showSignUp = true
                }) {
                    Text("Inscription")
                        .font(.custom("Raleway", size: 20))
                        .modifier(ColourStyle())
                }.sheet(isPresented: $showSignUp, content: {
                    PreSignUp()
                })
            }
        }
    }

    func handleServerError(_ res: URLResponse?) {
        print("ERROR: Status Code: \(res!): the status code MUST be between 200 and 299")
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

        URLSession.shared.dataTask(with: url) { data, res, error in
            guard let httpResponse = res as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(res)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                if let json = try? decoder.decode(Connexion.self, from: data) {
                    print(json)
                }
                else {
                    let dataString = String(decoding: data, as: UTF8.self)
                    print("Invalid response \(dataString)")
                }
            }
        }.resume()
    }
}

struct ContentView: View {
    
    @State var signInSuccess = false

    var body: some View {
        if signInSuccess {
            return AnyView(Home())
        }
        else {
            return AnyView(LoginFormView(signInSuccess: $signInSuccess, connexion: Connexion()))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

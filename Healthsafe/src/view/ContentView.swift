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
    @State private var confirmation: String = ""
    @State private var showConfirmation: Bool = false
    @State private var showSignUp: Bool = false

    @Binding var signInSuccess: Bool
    @Binding var signUpClicked: Bool
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
                .frame(height: 70.0)
            VStack {
                TextField("E-MAIL", text: $connexion.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .frame(width: 200.0)
                    .modifier(LabelStyle())
                Divider()
                    .padding(.horizontal, 30)

                Spacer()
                    .frame(height: 30.0)
                SecureField("PASSWORD", text: $connexion.password)
                    .frame(width: 200.0)
                    .modifier(LabelStyle())
                Divider()
                    .padding(.horizontal, 30)
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
//                    self.showSignUp = true
                    self.signUpClicked = true
                }) {
                    Text("Inscription")
                        .font(.custom("Raleway", size: 20))
//                        .underline()
                        .modifier(ButtonStyleSecondary())
                }
//                .sheet(isPresented: $showSignUp, content: {
//                    PreSignUp()
//                })
            }
        }
    }

    func handleServerError(_ res: URLResponse) {
        print("ERROR: Status Code: \(res): the status code MUST be between 200 and 299")
        self.showError = true
    }

    func connect() throws {
        guard let encoded = try? JSONEncoder().encode(connexion) else {
            print("Fail to encode newMed")
            return
        }
        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/signin")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        print(String(data: encoded, encoding: .utf8)!)

        URLSession.shared.dataTask(with: url) { data, res, error in
            guard let httpResponse = res as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(res!)
                return
            }
            self.signInSuccess = true
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
    @State private var signInSuccess: Bool = false
    @State private var signUpClicked: Bool = false
    @StateObject var connexion = Connexion()

    var body: some View {
        if signInSuccess {
            return AnyView(Home())
        } else if (signUpClicked) {
            return AnyView(PreSignUp())
        } else {
            return AnyView(LoginFormView(signInSuccess: $signInSuccess, signUpClicked: $signUpClicked, connexion: connexion))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

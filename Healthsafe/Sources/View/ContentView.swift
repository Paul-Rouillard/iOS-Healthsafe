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
    @State private var showGroup: Bool = true

    @Binding var isPatientConnected: Bool
    @Binding var signInSuccess: Bool
    @Binding var signUpClicked: Bool
    @ObservedObject var connexion: Connexion

    var body: some View {
        if showGroup {
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
                        .frame(width: 300.0)
                        .modifier(LabelStyle())
                    Divider()
                        .padding(.horizontal, 30)

                    Spacer()
                        .frame(height: 30.0)
                    SecureField("PASSWORD", text: $connexion.password)
                        .frame(width: 300.0)
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
                        self.showGroup = false
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
        } else {
            VStack {
                Button(action: {
                    self.showGroup = false
                    self.isPatientConnected = false
                    if connexion.checkEmpty {
                        self.connect(url: "drSignin", onError: { err in
                            self.showError = true
                        })
                    } else {
                        self.showEmpty = true
                    }
                }) {
                    Text("Vous êtes médecin")
                        .modifier(ButtonStyle())
                }
                Button(action: {
                    self.showGroup = false
                    self.isPatientConnected = true
                    if (connexion.checkEmpty) {
                        self.connect(url: "patientSignin", onError: { err in
                            self.showError = true
                        })
                    } else {
                        self.showEmpty = true
                    }
                }) {
                    Text("Vous êtes patient")
                        .modifier(ButtonStyle())
                }
            }
        }
    }

    func handleServerError(_ res: URLResponse) {
        print("ERROR: Status Code: \(res): the status code MUST be between 200 and 299")
        self.showError = true
    }

//    func connect() throws {
    func connect(url: String, onError errorHandler: @escaping (Error?)->Void) { //<-
        let encoded: Data
        do {
            encoded = try JSONEncoder().encode(connexion)
        } catch {
            print("Fail to encode newMed: \(error)")
            return
        }
        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/\(url)")!
//        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/patientSignin")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        print("---------------\nSending connexion info ... \n\(String(data: encoded, encoding: .utf8)!)\n---------------")
        print("Resquesting on /api/\(url)")
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let error = error {
                print("error")
                errorHandler(error)
                return
            }
            guard let response = res else {
                print("error in response")
//                errorHandler(ConnexionError.invalidServerRes) //<-
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  case 200...299 = httpResponse.statusCode
            else {
                print("error in request")
                self.handleServerError(res!)
                return
            }
            self.signInSuccess = true
            guard let data = data else {
                print("data is nil")
                return
            }
            let decoder = JSONDecoder()
            // connect anyway, fix JSON !
            do {
                let json = try decoder.decode(Connexion.self, from: data)
                print(json)
                self.connexion.id = json.id
                self.connexion.token = json.token
                self.connexion.sessionID = json.sessionID
            } catch {
                let dataString = String(data: data, encoding: .utf8) ?? "Unknown encoding"
                print("Invalid response \(error) - \(dataString)")
            }
        }.resume()    }
}

struct ContentView: View {
    @State private var signInSuccess: Bool = false
    @State private var signUpClicked: Bool = false
    @State private var isPatientConnected: Bool = false
    @StateObject var connexion = Connexion()

    var body: some View {
        if signInSuccess {
            return AnyView(Home(isPatientConnected: $isPatientConnected, connexion: connexion))
        } else if (signUpClicked) {
            return AnyView(PreSignUp())
        } else {
            return AnyView(LoginFormView(isPatientConnected: $isPatientConnected, signInSuccess: $signInSuccess, signUpClicked: $signUpClicked, connexion: connexion))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

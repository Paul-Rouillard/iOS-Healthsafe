//
//  Home.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 06/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct Home: View {
    @State var data: String = ""
    @State var signOff: Bool = false
   
    var body: some View {
        if signOff {
            return AnyView(ContentView())
        } else {
            return AnyView(HomeView(signOff: $signOff, connexion: Connexion()))
        }
    }
}

struct HomeView: View {
    @State var data: String = ""
    @Binding var signOff: Bool
    @ObservedObject var connexion: Connexion

    var body: some View {
        VStack {
            Button(action: {
                print("--------------\nlogging out...\n--------------")
                do {
                    try self.Deconnexion()
                } catch {
                    print("Error while signing off")
                }
            }) {
                Text("Log out")
                    .frame(width: 325, alignment: .trailing)
                    .modifier(LabelStyle())
            }.onTapGesture(perform: {
                self.signOff = true
            })
            Spacer()
            Text("NFC").font(.largeTitle).modifier(LabelStyle())
            Spacer()
                .frame(width: 50, height: 50)
//            Text("Welcome \(name)").modifier(LabelStyle())
            Text("Please select your plateform").modifier(LabelStyle())
            Spacer()
            HStack {
                Button(action: {
                        
                }) {
                    Image("logo_tel")
                }
                Image("pc_bureau")
            }
            nfcButton(data: $data)
                    .frame(width: 75.0, height: 20.0)
                    .modifier(ButtonStyle())
            Spacer()
        }
    }

    func handleServerError(_ res: URLResponse?) {
        print("ERROR: Status Code: \(res!): the status code MUST be between 200 and 299")
    }

    func Deconnexion() throws {
        guard let encoded = try? JSONEncoder().encode(connexion) else {
            print("Fail to encode newMed")
            return
        }
        let url = URL(string: "https://healthsafe-api-beta.herokuapp.com/api/logout")!
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

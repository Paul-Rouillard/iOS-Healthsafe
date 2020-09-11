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
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        Group {
            VStack {
                Button(action: {
                    print("--------------\nlogging out...\n--------------")
                    do {
                        try self.Deconnexion()
                        self.settings.loogedIn = false
                    } catch {
                        print("error while logging out")
                    }
                }) {
                    Text("Log out")
                        .frame(width: 325, alignment: .topLeading)
                        .modifier(LabelStyle())
                }
                Spacer()
                Text("NFC").font(.largeTitle).modifier(LabelStyle())
                Spacer()
                    .frame(width: 50, height: 50)
    //            Text("Welcome \(name)").modifier(LabelStyle())
                Text("Please select your plateform").modifier(LabelStyle())
                Spacer()
                HStack {
                    Image("logo_tel")
                    Image("pc_bureau")
                }
                Text(data).background(Color.red)
                nfcButton(data: self.$data)
                    .frame(width: 75.0, height: 20.0)
                    .modifier(ButtonStyle())
                Spacer()
            }
        }
    }
    
    func Deconnexion() throws {
        guard let encoded = try? JSONEncoder().encode(settings) else {
            print("Fail to encode newMed")
            return
        }
        let url = URL(string: "https://healthsafe-api-beta.herokuapp.com/api/logout")!
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
            if let decoder = try? JSONDecoder().decode(UserSettings.self, from: data) {
                print("------------\nLogging out ...\n\(decoder.emailAddr) is logged out!")
            } else {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Invalid response \(dataString)")
            }
        }.resume()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

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
    @State var showNFCMobile: Bool = false
    @State var showNFCDesktop: Bool = false
    @State var firstUse: Bool = false
    @ObservedObject var nfcData: NFCData = NFCData()
    @ObservedObject var connexion: Connexion
    @StateObject var deconnexion = Deconnexion()
   
    var body: some View {
        if signOff {
            return AnyView(ContentView())
        } else if showNFCMobile || firstUse {
            return AnyView(NFCMobileContoler(data: $data, nfcData: nfcData))
        } else if showNFCDesktop {
            return AnyView(NFCDesktopControler(data: $data, nfcData: nfcData))
        } else {
            return AnyView(HomeView(data: $data, signOff: $signOff, showNFCMobile: $showNFCMobile, showNFCDesktop: $showNFCDesktop, firstUse: $firstUse, nfcData: nfcData, connexion: connexion, deconnexion: deconnexion))
        }
    }
}

struct HomeView: View {
    @Binding var data: String
    @Binding var signOff: Bool
    @Binding var showNFCMobile: Bool
    @Binding var showNFCDesktop: Bool
    @Binding var firstUse: Bool
    @ObservedObject var nfcData: NFCData
    @ObservedObject var connexion: Connexion
    @ObservedObject var deconnexion: Deconnexion

    var body: some View {
        VStack {
            Button(action: {
                print("--------------\nlogging out...\n--------------")
                do {
                    try self.SignOut()
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
//            Text(data)
            HStack {
                NFCButtonMobile(data: $data, showData: $showNFCMobile, storeNFC: nfcData)
//                    .frame(width: 150.0, height: 150.0)
                NFCButtonDesktop(data: $data, view: $showNFCDesktop)
//                    .frame(width: 150.0, height: 150.0)
            }
            Button(action: {
                self.firstUse = true
            }) {
                Text("Init Tag")
                    .modifier(ButtonFormStyleSecondary())
            }
            Spacer()
        }
    }

    func handleServerError(_ res: URLResponse?) {
        print("ERROR: Status Code: \(res!): the status code MUST be between 200 and 299")
    }

    func SignOut() throws {
        guard let encoded = try? JSONEncoder().encode(deconnexion) else {
            print("Fail to encode Deconnexion")
            return
        }
        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/logoutall")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        print(String(data: encoded, encoding: .utf8)!)

        URLSession.shared.dataTask(with: request) { data, res, error in
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

#if DEBUG
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(connexion: Connexion())
    }
}
#endif

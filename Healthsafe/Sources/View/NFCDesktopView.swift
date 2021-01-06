//
//  NFCDesktopView.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 03/01/2021.
//  Copyright © 2021 Healthsafe. All rights reserved.
//

import SwiftUI

struct NFCDesktopControler: View {
    @State var receivedData: Bool = false
    @State var goBack: Bool = false
    @Binding var data: String
    @Binding var nfcData: NFCData

    var body: some View {
        if goBack {
            return AnyView(Home(connexion: Connexion()))
        } else {
            return AnyView(NFCDesktopView(receivedData: $receivedData, goBack: $goBack, data: $data, nfcData: $nfcData))
        }
    }
}

struct NFCDesktopView: View {
    @State var sending: Bool = true
    @State var receiving: Bool = false
    @State var deciphered: [String:String] = [:]
//    @State var showImg: Bool = true

    @Binding var receivedData: Bool
    @Binding var goBack: Bool
    @Binding var data: String
    @Binding var nfcData: NFCData
    
    var body: some View {
        Button(action: {
            self.goBack = true
            }) {
            Image(systemName: "chevron.backward")
                .frame(alignment: .topLeading)
                .foregroundColor(.blue)
            Text("Back")
                .frame(width: 325, alignment: .topLeading)
        }
        Spacer()
        Image("sending_data")
            .resizable()
            .frame(width: 150, height: 150)
//            .visibility(hidden: $showImg)

        Spacer()
        if sending {
            Text("Your informations are about to be send...")
            Spacer()
            Button(action: {
                self.sending = false
                self.receivedData = true
            }) {
                Text("Send to desktop")
                    .modifier(ButtonFormStyle())
            }
        } else if receivedData{
            Text("Waiting for update...")
            Spacer()
            Button(action: {
//                self.showImg = false
                self.receivedData = false
            }) {
                Text("Get Back")
                    .modifier(ButtonFormStyle())
            }
        }
        else {
            Group{
            Text("Please review before writing on the chip.")
            }
            Group {
            Form {
                Section {
                    HStack {
                        Text("Last name")
                        TextField("", text: _deciphered.binding("lastName"))
                    }
                    HStack {
                        Text("First name")
                        TextField("", text: _deciphered.binding("firstName"))
                    }
                    HStack {
                        Text("Gender")
                        TextField("", text: _deciphered.binding("gender"))
                    }
                    HStack {
                        Text("Age")
                        TextField("", text: _deciphered.binding("age"))
                    }
                }
                Section {
                    HStack {
                        Text("Height")
                        TextField("", text: _deciphered.binding("height"))
                    }
                    HStack {
                        Text("Weight")
                        TextField("", text: _deciphered.binding("wight"))
                    }
                }
                Section {
                    HStack {
                        Text("Medical history")
                        TextField("", text: _deciphered.binding("medicalHistory"))
                    }
                    HStack {
                        Text("Treatement")
                        TextField("", text: _deciphered.binding("treatements"))
                    }
                    HStack {
                        Text("Allergies")
                        TextField("", text: _deciphered.binding("allergies"))
                    }
                    HStack {
                        Text("Blood type")
                        TextField("", text: _deciphered.binding("bloodType"))
                    }
                }
                Section {
                    HStack {
                        Text("Emergency nbr")
                        TextField("", text: _deciphered.binding("emergencyNumber"))
                    }
                    HStack {
                        Text("Doctor")
                        TextField("", text: _deciphered.binding("doctor"))
                    }
                    HStack {
                        Text("Social number")
                        TextField("", text: _deciphered.binding("socialNumber"))
                    }
                    HStack {
                        Text("Organ doner")
                        TextField("", text: _deciphered.binding("organDonation"))
                    }
                }
            }
                .onAppear {
                    //↓ No `var` here
                    deciphered = data.split(separator: "\n").reduce(into: [String: String]()) {
                        let str = $1.split(separator: ":")
                        if let first = str.first, let value = str.last {
                            $0[String(first)] = String(value)
                        }
                    }
                }
            }
            NFCWriteButton(data: $data, dataToWrite: $nfcData)
                .modifier(ButtonFormStyle())
        }
    }
    
    func handleServerError(_ res: URLResponse?) {
        print("ERROR: Status Code: \(res!): the status code MUST be between 200 and 299")
    }

    func sendData() throws {
        guard let encoded = try? JSONEncoder().encode(nfcData) else {
            print("Fail to encode Deconnexion")
            return
        }
        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/patientData/createSimple")! // edit URL
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
                if let json = try? decoder.decode(NFCData.self, from: data) {
                    print(json)
                }
                else {
                    let dataString = String(decoding: data, as: UTF8.self)
                    print("Invalid response \(dataString)")
                }
            }
        }.resume()
    }
    
    func recieveData() throws {
        guard let encoded = try? JSONEncoder().encode(nfcData) else {
            print("Fail to encode Deconnexion")
            return
        }
        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/patientData")! //edit URL
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.httpBody = encoded
    }
    
    
}

//#if DEBUG
//struct NFCDesktopView_Previews: PreviewProvider {
//    static var previews: some View {
//        NFCDesktopControler(data: Binding<String>)
//    }
//}
//#endif

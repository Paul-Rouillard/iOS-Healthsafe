//
//  PatientPasswdInfo.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 25/10/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct PatientPasswdInfo: View {
    @ObservedObject var patient: NewPatient

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        SecureField("Password", text: $patient.password)
                            .modifier(FormTextFieldStyle())
                        SecureField("Confirm passsword", text: $patient.confirmationPassword)
                            .modifier(FormTextFieldStyle())
                    }
                }
                Button(action: {
                    self.submit()
                    print("------------------------\nCreating the account\n------------------------")
                }) {
                    Text("Submit")
                        .modifier(ButtonStyle())
                }
            }
        }
    }
    func handleServerError(_ res: URLResponse?) {
        print("ERROR: Status Code: \(res!): the status code MUST be between 200 and 299")
    }

    func submit() {
        guard let encoded = try? JSONEncoder().encode(patient) else {
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
                    self.handleServerError(res)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                if let json = try? decoder.decode(NewPatient.self, from: data) {
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

struct PatientPasswdInfo_Previews: PreviewProvider {
    static var previews: some View {
        PatientPasswdInfo(patient: NewPatient())
    }
}

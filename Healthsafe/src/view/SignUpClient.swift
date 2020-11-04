//
//  SignUpClient.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 24/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct SignUpClient: View {
    @State private var backPressed: Bool = false

    var body: some View {
        if backPressed {
            return AnyView(PreSignUp())
        } else {
            return AnyView(SignUpClientView(backPressed: $backPressed, patient: NewPatient()))
        }
    }
}

struct SignUpClientView: View {
    @Binding var backPressed: Bool
    @State private var patientPersonnalInfo: Bool = true
    @State private var patientAddressInfo: Bool = false
    @State private var patientContactInfo: Bool = false
    @State private var patientPasswdInfo: Bool = false
    @ObservedObject var patient: NewPatient

    var body: some View {
        Button(action: {
            self.backPressed = true
            }) {
            Image(systemName: "chevron.backward")
                .frame(alignment: .topLeading)
                .foregroundColor(.blue)
            Text("Back")
                .frame(width: 325, alignment: .topLeading)
        }//.offset(x: -10.0, y:-420.0)
//        ZStack {
            if patientPersonnalInfo {
                Group {
                    Group {
                        Form {
                            Section {
                                TextField("Fisrt name", text: $patient.firstName)
                                    .modifier(FormTextFieldStyle())
                                TextField("Last Name", text: $patient.lastName)
                                    .modifier(FormTextFieldStyle())
                                DatePicker(selection: $patient.birthday, in: ...Date(), displayedComponents: .date) {
                                    Text("Birthday date")
                                        .modifier(FormStyle())
                                }
                                TextField("Age", value: $patient.age, formatter: NumberFormatter())
                                    .multilineTextAlignment(.center)
                                    .modifier(FormStyle())
                            }
                        }
                    }
                    Button (action: {
                        print("next group")
                        self.patientPersonnalInfo = false
                        self.patientAddressInfo = true
                    }){
                        Text("Suivant")
                            .modifier(ButtonFormStyle())
                    }
                }.visibility(hidden: $patientPersonnalInfo)
            } else if patientAddressInfo {
                Group {
                    Group {
                        Form {
                            Section {
                                    TextField("Building number", value: $patient.streetNumber, formatter: NumberFormatter())
                                        .keyboardType(.numberPad)
                                    .modifier(FormTextFieldStyle())
            //                        IndexSteetNbr(med: NewMed())
                                    Picker("Number ext.", selection: $patient.indexStreetNbr) {
                                        ForEach (0 ..< NewPatient.typeStreetNbr.count) {
                                            Text(NewPatient.typeStreetNbr[$0])
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())

                                    Picker("Street desc.", selection: $patient.indexStreet) {
                                        ForEach (0 ..< NewPatient.typeStrt.count) {
                                            Text(NewPatient.typeStrt[$0])
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
    //                                .navigationBarBackButtonHidden(true) //enlever le bouton retour. mais jusqu'où ça marche ?
                                    TextField("Street name", text: $patient.street)
                                        .modifier(FormAddressStyle())

                                HStack {
                                    TextField("Post code", value: $patient.zipCode, formatter: NumberFormatter())
                                       .font(.custom("Raleway", size: 16))
                                       .frame(width: 100.0, height: 30)
                                       .keyboardType(.numberPad)
                                    Text(" | ")
                                        .font(.custom("Raleway", size: 18))
                                        .foregroundColor(Color.black)
                                    TextField("City", text: $patient.city)
                                        .font(.custom("Raleway", size: 16))
                                        .frame(height: 30)
                                }
                                TextField("Country", text: $patient.country)
                                    .modifier(FormAddressStyle())
                            }
                        }
                    }
                HStack {
                    Button (action: {
                        print("Going back to Personnal info")
                        self.patientPersonnalInfo = true
                        self.patientAddressInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("next group")
                        print(self.patientPersonnalInfo)
                        self.patientAddressInfo = false
                        self.patientContactInfo = true
                    }){
                        Text("Suivant")
                            .modifier(ButtonFormStyle())
                    }
                }
            }.visibility(hidden: $patientAddressInfo)
        } else if patientContactInfo {
            Group {
                Group {
                    Form {
                        Section {
                            TextField("Phone number", text: $patient.phoneNumber)
                                .modifier(FormTextFieldStyle())
                            TextField("Email", text: $patient.emailAddr)
                                .modifier(FormTextFieldStyle())
                        }
                    }
                }
                HStack {
                    Button (action: {
                        print("Going back to address Info")
                        self.patientAddressInfo = true
                        self.patientContactInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("next group - Password Info")
                        print(self.patientPersonnalInfo)
                        self.patientContactInfo = false
                        self.patientPasswdInfo = true
                    }){
                        Text("Suivant")
                            .modifier(ButtonFormStyle())
                    }
                }
            }
        } else if patientPasswdInfo {
            Group {
                Group {
                    Form {
                        Section {
                            SecureField("Password", text: $patient.password)
                                .modifier(FormTextFieldStyle())
                            SecureField("Confirm passsword", text: $patient.confirmationPassword)
                                .modifier(FormTextFieldStyle())
                        }
                    }
                }
                HStack {
                    Button(action: {
                        print("Going back to Contact info")
                        self.patientPasswdInfo = false
                        self.patientContactInfo = true
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button(action: {
                        self.submit()
                        print("------------------------\nCreating the account\n------------------------")
                    }) {
                        Text("Submit")
                            .modifier(ButtonFormStyle())
                    }
                }
            }.visibility(hidden: $patientPasswdInfo)
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

struct SignUpClient_Previews: PreviewProvider {
    static var previews: some View {
        SignUpClient()
    }
}

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
    @StateObject var newPatient = NewPatient()
    @StateObject var address = Address()

    var body: some View {
        if backPressed {
            return AnyView(PreSignUp())
        } else {
            return AnyView(SignUpClientView(backPressed: $backPressed, patient: newPatient, address: address))
        }
    }
}

struct SignUpClientView: View {
    @Binding var backPressed: Bool
    @State private var patientPersonnalInfo: Bool = true
    @State private var patientAddressInfo: Bool = false
    @State private var patientContactInfo: Bool = false
    @State private var patientPasswdInfo: Bool = false
    @State private var steps: Int = 1
    @ObservedObject var patient: NewPatient
    @ObservedObject var address: Address

     var currentAge: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let birthdate = calendar.startOfDay(for: patient.bDay)
        let components = calendar.dateComponents([.year], from: birthdate, to: today)
        return components.year ?? 0
     }

    var body: some View {
        Button(action: {
            self.backPressed = true
            }) {
            Image(systemName: "chevron.backward")
                .frame(alignment: .topLeading)
                .foregroundColor(.blue)
            Text("Back")
                .frame(width: 325, alignment: .topLeading)
        }
        Text("\(steps) / 4")
            .modifier(FormStyle())
        if patientPersonnalInfo {
            Group {
                Group {
                    Form {
                        Section(header: Text("Informations personnelles")) {
                            TextField("First name", text: $patient.firstName)
                                .modifier(FormTextFieldStyle())
                            TextField("Last Name", text: $patient.lastName)
                                .modifier(FormTextFieldStyle())
                            DatePicker(selection: $patient.bDay, in: ...Date(), displayedComponents: .date) {
                                Text("Birthday date")
                                    .modifier(FormTextFieldStyle())
                            }
                            Text("\(currentAge)")
                        }
                    }
                }
                Button (action: {
                    print("next group: patientAddressInfo")
                    self.steps += 1
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
                        Section(header: Text("Adresse")) {
                            TextField("Building number", text: $patient.streetNumber_tmp)
                                .keyboardType(.numberPad)
                                .modifier(FormTextFieldStyle())
                            Picker("Number ext.", selection: $patient.indexStreetNbr) {
                                ForEach (0 ..< NewPatient.typeStreetNbr.count) {
                                    Text(NewPatient.typeStreetNbr[$0])
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .onAppear(perform: {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    self.patient.birthDay = dateFormatter.string(from: self.patient.bDay)
                                    self.patient.age = currentAge
                                })
                            Picker("Street desc.", selection: $patient.indexStreet) {
                                ForEach (0 ..< NewPatient.typeStrt.count) {
                                    Text(NewPatient.typeStrt[$0])
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                            TextField("Street name", text: $address.street)
                                .modifier(FormAddressStyle())

                            HStack {
                                TextField("Post code", text: $patient.zipCode_tmp)
                                   .font(.custom("Raleway", size: 16))
                                   .frame(width: 100.0, height: 30)
                                   .keyboardType(.numberPad)
                                Text(" | ")
                                    .font(.custom("Raleway", size: 18))
                                    .foregroundColor(Color.black)
                                TextField("City", text: $address.city)
                                    .font(.custom("Raleway", size: 16))
                                    .frame(height: 30)
                            }
                            TextField("Country", text: $address.country)
                                .modifier(FormAddressStyle())
                        }
                    }
                }
                HStack {
                    Button (action: {
                        self.steps -= 1
                        print("Going back to Personnal info")
                        self.patientPersonnalInfo = true
                        self.patientAddressInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        self.steps += 1
                        print("next group: patientContactInfo")
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
                        Section(header: Text("Contact")) {
                            TextField("Phone number", text: $patient.phoneNumber)
                                .onAppear(perform: {
                                    self.address.streetNumber = Int(self.patient.streetNumber_tmp)!
                                    self.address.zipCode = Int(self.patient.zipCode_tmp)!
                                    self.address.typeStreetNumber = NewPatient.typeStreetNbr[self.patient.indexStreetNbr]
                                    self.address.typeStreet = NewPatient.typeStrt[self.patient.indexStreet]
                                })
                                .modifier(FormTextFieldStyle())
                                .keyboardType(.phonePad)
                            TextField("Email", text: $patient.emailAddr)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .modifier(FormTextFieldStyle())
                        }
                    }
                }
                HStack {
                    Button (action: {
                        self.steps -= 1
                        print("Going back to address Info")
                        self.patientAddressInfo = true
                        self.patientContactInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        self.steps += 1
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
                        Section(header: Text("Mot de passe")) {
                            SecureField("Password", text: $patient.password)
                                .modifier(FormTextFieldStyle())
                            SecureField("Confirm passsword", text: $patient.confirmationPassword)
                                .modifier(FormTextFieldStyle())
                        }
                    }
                }
                HStack {
                    Button(action: {
                        self.steps -= 1
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
        
        print("""
            -----------------------------------------
            Printing JSON:
            lastName: \(patient.lastName)
            firstName: \(patient.firstName)
            birthday: \(patient.birthDay)
            age: \(patient.age)
            phoneNbr: \(patient.phoneNumber)
            email: \(patient.emailAddr)
            password: \(patient.password)
            confirpwd: \(patient.confirmationPassword)
            -----
            Address :
            streetNumber: \(address.streetNumber)
            typeStreetNumber: \(address.typeStreetNumber)
            typeStreet: \(address.typeStreet)
            street: \(address.street)
            zipCode: \(address.zipCode)
            city: \(address.city)
            country: \(address.country)

            ----------------------------------------
            END FIRST PART OF JSON
            """)
        
        
        guard let encoded = try? JSONEncoder().encode(patient) else {
            print("Fail to encode newpatient")
            return
        }
        print("\n--------------------\n encoded JSON : \(encoded)\n\n")
        print(String(data: encoded, encoding: .utf8)!)

//        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/signupProfilePatient/create")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = encoded
//
//        print(String(data: encoded, encoding: .utf8)!)
//
//        URLSession.shared.dataTask(with: url) { data, res, error in
//            guard let httpResponse = res as? HTTPURLResponse,
//                    (200...299).contains(httpResponse.statusCode) else {
//                    self.handleServerError(res)
//                return
//            }
//            if let data = data {
//                let decoder = JSONDecoder()
//                if let json = try? decoder.decode(NewPatient.self, from: data) {
//                    print(json)
//                }
//                else {
//                    let dataString = String(decoding: data, as: UTF8.self)
//                    print("Invalid response \(dataString)")
//                }
//            }
//        }.resume()
    }
}

struct SignUpClient_Previews: PreviewProvider {
    static var previews: some View {
        SignUpClient()
    }
}

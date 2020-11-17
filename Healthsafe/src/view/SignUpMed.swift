//
//  Inscrption.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 11/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct SignUpMed: View {
    @State private var backPressed: Bool = false

    var body: some View {
        if backPressed {
            return AnyView(PreSignUp())
        } else {
            return AnyView(SignUpMedView(med: NewMed(), backPressed: $backPressed))
        }
    }
}

struct SignUpMedView: View {
    @ObservedObject var med: NewMed
    @Binding var backPressed: Bool
    @State private var docPersonnalInfo: Bool = true
    @State private var docAddressInfo: Bool = false
    @State private var docContactInfo: Bool = false
    @State private var docSpecialisationInfo: Bool = false
    @State private var docPasswdInfo: Bool = false
    @State var confirmation: String = ""
    @State var showConfirmation: Bool = false

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
        if docPersonnalInfo {
            Group {
                Group {
                    Form {
                        Section {
                            TextField("First name", text: $med.firstName)
                                .modifier(FormTextFieldStyle())
                            TextField("Last Name", text: $med.lastName)
                                .modifier(FormTextFieldStyle())
//                            DatePicker(selection: $med.birthday, in: ...Date(), displayedComponents: .date) {
//                                Text("Birthday date")
//                                    .modifier(FormStyle())
//                            }
                            TextField("Age", value: $med.age, formatter: NumberFormatter())
                                .multilineTextAlignment(.center)
                                .modifier(FormStyle())
                        }
                    }
                }
                Button (action: {
                    print("next group")
                    self.docPersonnalInfo = false
                    self.docAddressInfo = true
                }){
                    Text("Suivant")
                        .modifier(ButtonFormStyle())
                }
            }.visibility(hidden: $docPersonnalInfo)
        } else if docAddressInfo {
            Group {
                Group {
                    Form {
                        Section {
                            TextField("Building number", value: $med.streetNumber, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                            .modifier(FormTextFieldStyle())
                            Picker("Number ext.", selection: $med.indexStreetNbr) {
                                ForEach (0 ..< NewMed.typeStreetNbr.count) {
                                    Text(NewMed.typeStreetNbr[$0])
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            Picker("Street desc.", selection: $med.indexStreet) {
                                ForEach (0 ..< NewMed.typeStrt.count) {
                                    Text(NewMed.typeStrt[$0])
    //                                NewMed.typeStreet = NewMed.typeStreet[$0]
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            TextField("Street name", text: $med.street)
                                .modifier(FormAddressStyle())
                            HStack {
                                TextField("Post code", value: $med.zipCode, formatter: NumberFormatter())
                                   .font(.custom("Raleway", size: 16))
                                   .frame(width: 100.0, height: 30)
                                   .keyboardType(.numberPad)
                                Text(" | ")
                                    .font(.custom("Raleway", size: 18))
                                    .foregroundColor(Color.black)
                                TextField("City", text: $med.city)
                                    .font(.custom("Raleway", size: 16))
                                    .frame(height: 30)
                            }
                            TextField("Country", text: $med.country)
                                .modifier(FormAddressStyle())
                        }
                    }
                }
                HStack {
                    Button (action: {
                        print("Going back to Personnal info")
                        self.docPersonnalInfo = true
                        self.docAddressInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("next group")
                        self.docAddressInfo = false
                        self.docContactInfo = true
                    }){
                        Text("Suivant")
                            .modifier(ButtonFormStyle())
                    }
                }
            }.visibility(hidden: $docAddressInfo)
        } else if docContactInfo {
            Group {
                Group {
                    Form {
                        Section {
                            TextField("Phone number", text: $med.phoneNumber)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.numberPad)
                            TextField("E-mail", text: $med.email)
                                .keyboardType(.emailAddress)
                                .modifier(FormTextFieldStyle())
                        }
                    }
                }
                HStack {
                    Button (action: {
                        print("Going back to Address info")
                        self.docAddressInfo = true
                        self.docContactInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("next group")
                        self.docContactInfo = false
                        self.docSpecialisationInfo = true
                    }){
                        Text("Suivant")
                            .modifier(ButtonFormStyle())
                    }
                }
            }.visibility(hidden: $docContactInfo)
        } else if docSpecialisationInfo {
            Group {
                Group {
                    Form {
                        Section {
                            TextField("Medical ID", text: $med.idNumber)
                                .modifier(FormTextFieldStyle())
                                .keyboardType(.numberPad)
                            TextField("Medical speciality", text: $med.expertiseDomain)
                                .modifier(FormTextFieldStyle())
                        }
                    }
                }
                HStack {
                    Button (action: {
                        print("Going back to Contact Info")
                        self.docPersonnalInfo = true
                        self.docSpecialisationInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("next group")
                        self.docSpecialisationInfo = false
                        self.docPasswdInfo = true
                    }){
                        Text("Suivant")
                            .modifier(ButtonFormStyle())
                    }
                }
            }.visibility(hidden: $docSpecialisationInfo)
        } else if docPasswdInfo {
            Group {
                Group {
                    Form {
                        Section {
                            SecureField("Password", text: $med.password)
                                 .modifier(FormTextFieldStyle())
                            SecureField("Confirm password", text: $med.confirmationPassword)
                                 .modifier(FormTextFieldStyle())
                    }
                }
            }
                HStack {
                    Button (action: {
                        print("Going back to Speciality Info")
                        self.docSpecialisationInfo = true
                        self.docPasswdInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("Submiting")
                        self.sendNewMed()
                    }){
                        Text("Suivant")
                            .modifier(ButtonFormStyle())
                    }
                }
            }.visibility(hidden: $docPasswdInfo)
        }
    }

    func handleServerError(_ res: URLResponse?) {
        print("ERROR: Status Code: \(res!): the status code MUST be between 200 and 299")
    }

    func sendNewMed() {
        print("""
            -----------------------------------------
            Printing JSON:
            lastName: \(med.lastName)
            firstName: \(med.firstName)
            birthday: \(med.birthday)
            age: \(med.age)
            phoneNbr: \(med.phoneNumber)
            email: \(med.email)
            password: \(med.password)
            confirpwd: \(med.confirmationPassword)
            expDomain: \(med.expertiseDomain)
            idNumber: \(med.idNumber)
            -----
            Address :
            streetNumber: \(med.streetNumber)
            typeStreetNumber: \(med.typeStreetNumber)
            typeStreet: \(med.typeStreet)
            street: \(med.street)
            zipCode: \(med.zipCode)
            city: \(med.city)
            country \(med.country)

            ----------------------------------------
            END FIRST PART OF JSON
            """)
//        guard let encoded = try? JSONEncoder().encode(med) else {
//            print("Fail to encode newMed")
//            return
//        }
//        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/signupProfile/create")!
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
//                if let json = try? decoder.decode(NewMed.self, from: data) {
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

struct Inscrption_Previews: PreviewProvider {
    static var previews: some View {
        SignUpMed()
    }
}

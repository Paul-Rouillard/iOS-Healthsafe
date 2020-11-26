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
    @StateObject var newMed = NewMed()

    var body: some View {
        if backPressed {
            return AnyView(PreSignUp())
        } else {
            return AnyView(SignUpMedView(med: newMed, backPressed: $backPressed))
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
    @State private var confirmation: String = ""
    @State private var showConfirmation: Bool = false
    @State private var steps: Int = 1

    var currentAge: Int {
       let calendar = Calendar.current
       let today = calendar.startOfDay(for: Date())
       let birthdate = calendar.startOfDay(for: med.bDay)
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
        Text("\(steps) / 5")
        if docPersonnalInfo {
            Group {
                Group {
                    Form {
                        Section {
                            TextField("First name", text: $med.firstName)
                                .modifier(FormTextFieldStyle())
                            TextField("Last Name", text: $med.lastName)
                                .modifier(FormTextFieldStyle())
                            DatePicker(selection: $med.bDay, in: ...Date(), displayedComponents: .date) {
                                Text("Birthday date")
                                    .modifier(FormTextFieldStyle())
                            }
                            Text("\(currentAge)")
                        }
                    }
                }
                Button (action: {
                    print("next group : docAddressInfo")
                    self.steps += 1
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
                        Section(header: Text("Adresse")) {
                            TextField("Building number", text: $med.streetNumber_tmp)
                                .keyboardType(.numberPad)
                                .modifier(FormTextFieldStyle())
                            Picker("Number ext.", selection: $med.indexStreetNbr) {
                                ForEach (0 ..< NewMed.typeStreetNbr.count) {
                                    Text(NewMed.typeStreetNbr[$0])
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .onAppear(perform: {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    self.med.birthDay = dateFormatter.string(from: self.med.bDay)
                                    self.med.age = currentAge
                                })
                            Picker("Street desc.", selection: $med.indexStreet) {
                                ForEach (0 ..< NewMed.typeStrt.count) {
                                    Text(NewMed.typeStrt[$0])
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                            TextField("Street name", text: $med.street_tmp)
                                .modifier(FormAddressStyle())

                            HStack {
                                TextField("Post code", text: $med.zipCode_tmp)
                                   .font(.custom("Raleway", size: 16))
                                   .frame(width: 100.0, height: 30)
                                   .keyboardType(.numberPad)
                                Text(" | ")
                                    .font(.custom("Raleway", size: 18))
                                    .foregroundColor(Color.black)
                                TextField("City", text: $med.city_tmp)
                                    .font(.custom("Raleway", size: 16))
                                    .frame(height: 30)
                            }
                            TextField("Country", text: $med.country_tmp)
                                .modifier(FormAddressStyle())
                        }
                    }
                }
                HStack {
                    Button (action: {
                        print("Going back to Personnal info")
                        self.steps -= 1
                        self.docPersonnalInfo = true
                        self.docAddressInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("next group: docContactInfo")
                        self.steps += 1
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
                                .onAppear(perform: {
                                    let add = Address()
                                    add.street = self.med.street_tmp
                                    add.city = self.med.city_tmp
                                    add.country = self.med.country_tmp
                                    add.streetNumber = Int(self.med.streetNumber_tmp)!
                                    add.zipCode = Int(self.med.zipCode_tmp)!
                                    add.typeStreetNumber = NewMed.typeStreetNbr[self.med.indexStreetNbr]
                                    add.typeStreet = NewMed.typeStrt[self.med.indexStreet]
                                    self.med.address[0] = add
                                })
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.numberPad)
                            TextField("E-mail", text: $med.email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .modifier(FormTextFieldStyle())
                        }
                        Section(header: Text("Sécurité sociale")) {
                            TextField("Nb de sécurité sociale", text: $med.scialNbr_tmp)
                                .modifier(FormTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }
                }
                HStack {
                    Button (action: {
                        print("Going back to Address info")
                        self.steps -= 1
                        self.docAddressInfo = true
                        self.docContactInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("next group")
                        self.steps += 1
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
                            TextField("Medical ID", text: $med.idNumber_tmp)
                                .onAppear(perform: {
                                    self.med.socialNumber = Int(self.med.scialNbr_tmp)!
                                })
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
                        self.steps -= 1
                        self.docPersonnalInfo = true
                        self.docSpecialisationInfo = false
                    }){
                        Text("Précédent")
                            .modifier(ButtonFormStyleSecondary())
                    }
                    Button (action: {
                        print("next group")
                        self.steps += 1
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
                                .onAppear(perform: {
                                    self.med.idNumber = Int(self.med.idNumber_tmp)!
                                })
                                .modifier(FormTextFieldStyle())
                            SecureField("Confirm password", text: $med.confirmationPassword)
                                 .modifier(FormTextFieldStyle())
                    }
                }
            }
                HStack {
                    Button (action: {
                        print("Going back to Speciality Info")
                        self.steps -= 1
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
                        Text("Submit")
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
        guard let encoded = try? JSONEncoder().encode(med) else {
            print("Fail to encode newMed")
            return
        }

        let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/drSignup/create")!
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
                if let json = try? decoder.decode(NewMed.self, from: data) {
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

struct Inscrption_Previews: PreviewProvider {
    static var previews: some View {
        SignUpMed()
    }
}

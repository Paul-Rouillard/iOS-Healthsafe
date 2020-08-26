//
//  PersonnalInfo.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 26/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct PersonnalInfo: View {
    @ObservedObject var patient: NewPatient
    @State private var confirmationMessage = ""
    @State private var showingCongirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Fisrt name", text: $patient.firstName)
                        .modifier(FormTextFieldStyle())
                    TextField("Last Name", text: $patient.lastName)
                        .modifier(FormTextFieldStyle())
                    TextField("Your age", text: $patient.age)
                        .modifier(FormTextFieldStyle())
                        .keyboardType(.numberPad)
                    DatePicker(selection: $patient.birthday, in: ...Date(), displayedComponents: .date) {
                        Text("Birthday date")
                            .modifier(FormStyle())
                    }
                }

                Section {
                    TextField("Security number", value: $patient.securityNbr, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .modifier(FormTextFieldStyle())
                    TextField("Medecin traitant", text: $patient.doctor)
                        .modifier(FormTextFieldStyle())
                }

                Section {
                    TextField("Phone number", text: $patient.phoneNumber)
                        .modifier(FormTextFieldStyle())
                    TextField("Street name", text: $patient.street)
                        .modifier(FormAddressStyle())
                    HStack {
                        TextField("Post code", text: $patient.zipCode)
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
                }

                Section {
                    HStack{
                        Spacer()
                        Button(action: {
                            print("Button Action")
                            self.submit()
                        }) {
                            Text("Submit")
                                .modifier(ButtonStyle())
                        }
                        Spacer()
                    }
                }
            }.alert(isPresented: $showingCongirmation) {
                Alert(title: Text("Welcome"), message: Text(confirmationMessage), dismissButton: .default(Text("Dismiss")))
            }
        }
            .navigationBarTitle("Patient's information", displayMode: .inline)
            .padding(.top, 20)
    }
    func submit() {
        guard let encoded = try? JSONEncoder().encode(patient)
            else {
                print("Fail to encode patient informations")
                return
        }
        let signIncreateURL = URL(string: "https://reqres.in/api/healthsafe")!
        var request = URLRequest(url: signIncreateURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        print(encoded)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if (try? JSONDecoder().decode(NewPatient.self, from: data)) != nil {
                self.confirmationMessage = "You are sign up !"
                self.showingCongirmation = true
            }
            else {
                print("invalid respose from the server !")
            }
        }.resume()
    }
}

struct PersonnalInfo_Previews: PreviewProvider {
    static var previews: some View {
        PersonnalInfo(patient: NewPatient())
    }
}

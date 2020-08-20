//
//  Inscrption.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 11/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI


struct SignUpMed: View {
    @ObservedObject var med: NewMed
    
    @State var confirmation: String = ""
    @State var showConfirmation: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Fisrt name", text: $med.firstName)
                        .modifier(FormTextFieldStyle())
                    TextField("Last Name", text: $med.lastName)
                        .modifier(FormTextFieldStyle())
                    TextField("Your age", value: $med.age, formatter: NumberFormatter())
                        .modifier(FormTextFieldStyle())
                        .keyboardType(.numberPad)
                    DatePicker(selection: $med.birthday, in: ...Date(), displayedComponents: .date) {
                        Text("Birthday date")
                            .modifier(FormStyle())
                    }
                    Picker("Gender", selection: $med.indexGender) {
                        ForEach(0 ..< NewMed.genders.count) {
                                Text(NewMed.genders[$0])
                                    .font(.custom("Raleway", size: 16))
                            }
                    }.pickerStyle(SegmentedPickerStyle())
                    TextField("Phone number", text: $med.phoneNumber)
                        .modifier(FormTextFieldStyle())
                        .keyboardType(.numberPad)
                } // end of first section
                
                Section {
                    TextField("E-mail", text: $med.email)
                        .modifier(FormTextFieldStyle())
                    SecureField("Password", text: $med.password)
                         .modifier(FormTextFieldStyle())
                    SecureField("Confirm password", text: $med.confirmationPassword)
                         .modifier(FormTextFieldStyle())
                }

                Section {
                    TextField("Phone number", text: $med.phoneNumber)
                        .modifier(FormTextFieldStyle())
                    HStack {
                        TextField("Building number", value: $med.streetNumber, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                        .modifier(FormTextFieldStyle())
                        Picker("Number ext.", selection: $med.indexStreetNbr) {
                            ForEach (0 ..< NewMed.typeStreetNumber.count) {
                                Text(NewMed.typeStreetNumber[$0])
                            }
                        }
                    }
                    HStack {
                        Picker("Street desc.", selection: $med.indexStreet) {
                            ForEach (0 ..< NewMed.typeStreet.count) {
                                Text(NewMed.typeStreet[$0])
                            }
                        }
                        TextField("Street name", text: $med.street)
                            .modifier(FormAddressStyle())
                    }
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
                }

                Section {
                    TextField("Medical ID", text: $med.idNumber)
                        .modifier(FormTextFieldStyle())
                        .keyboardType(.numberPad)
                    TextField("Medical speciality", text: $med.expertiseDomain)
                        .modifier(FormTextFieldStyle())
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Med sign up button pressed")
                            self.sendNewMed()
                        }) {
                            Text("Submit")
                                .modifier(ButtonStyle())
                        }
                        Spacer()
                    }

                }.disabled(!med.isValid)
            }
        }.navigationBarTitle(Text("Doc's personnal info"))
//            .alert(isPresented: $showConfirmation){
//            Alert(title: Text("Welocme"), message: Text(confirmation), dismissButton: .default(Text("Dismiss")))
//        }
        
    }
    
    func sendNewMed() {
        guard let encoded = try? JSONEncoder().encode(med) else {
            print("Fail to encode newMed")
            return
        }
        let url = URL(string: "https://healthsafe-api-beta.herokuapp.com/api/drProfile/create")!
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
            if let decoder = try? JSONDecoder().decode(NewMed.self, from: data) {
                self.confirmation = "Sign up completed !\nWelcome \(decoder.firstName)"
                self.showConfirmation = true
            } else {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Invalid response \(dataString)")
            }
            
        }.resume()
    }
    
}

struct Inscrption_Previews: PreviewProvider {
    static var previews: some View {
        SignUpMed(med: NewMed())
    }
}

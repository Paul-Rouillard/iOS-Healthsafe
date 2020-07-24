//
//  Inscrption.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 11/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI


struct Inscrption: View {
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
                    TextField("Your age", text: $med.age)
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
                } // end of first section
                
                Section {
                    TextField("E-mail", text: $med.emailAddr)
                        .modifier(FormTextFieldStyle())
                    SecureField("Password", text: $med.passwd)
                         .modifier(FormTextFieldStyle())
                    SecureField("Confirm password", text: $med.passwd2)
                         .modifier(FormTextFieldStyle())
                }

                Section {
                    TextField("Phone number", text: $med.phoneNbr)
                        .modifier(FormTextFieldStyle())
                    TextField("Street name", text: $med.streetName)
                        .modifier(FormAddressStyle())
                    HStack {
                        TextField("Post code", text: $med.zipCode)
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
                }

                Section {
                    TextField("Medical ID", text: $med.medicalID)
                        .modifier(FormTextFieldStyle())
                        .keyboardType(.numberPad)
                    TextField("Medical speciality", text: $med.expMedicale)
                        .modifier(FormTextFieldStyle())
                }
                
                Section {
                    Button(action: {
                        print("Button Action")
                        self.med.alertIsVisible = true
                    }) {
                        Text("Submit")
                            .modifier(ButtonStyle())
                    }
//                    .alert(isPresented: $med.alertIsVisible) { () ->
//                        Alert in
//                        return Alert(title: Text("DEBUG"), message: Text("\(self.med.firstName)\n"), dismissButton: .default(Text("ok")))
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
        let url = URL(string: "https://reques.in/api/newMed")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
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
        Inscrption(med: NewMed())
    }
}

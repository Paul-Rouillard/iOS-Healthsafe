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
    var body: some View {
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
                    TextField("Security number", text: $patient.securityNbr)
                        .keyboardType(.numberPad)
                        .modifier(FormTextFieldStyle())
                    TextField("Medecin traitant", text: $patient.doctor)
                        .modifier(FormTextFieldStyle())
                }

                Section {
                    TextField("Phone number", text: $patient.phoneNbr)
                        .modifier(FormTextFieldStyle())
                    TextField("Street name", text: $patient.streetName)
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
                            self.patient.alertIsVisible = true
                        }) {
                            Text("Submit")
                                .modifier(ButtonStyle())
                        }
                        Spacer()
                    }
                }
        }
    }
}

struct PersonnalInfo_Previews: PreviewProvider {
    static var previews: some View {
        PersonnalInfo(patient: NewPatient())
    }
}

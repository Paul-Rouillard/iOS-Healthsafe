//
//  PatientAddressInfo.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 26/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct PatientAddressInfo: View {
    @ObservedObject var patient: NewPatient
    @State private var confirmationMessage = ""
    @State private var showingCongirmation = false

    var body: some View {
            ZStack {
                Form {
                    Section {
                        TextField("Phone number", text: $patient.phoneNumber)
                            .modifier(FormTextFieldStyle())
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
                    }
                }

                NavigationLink(destination: PatientContactInfo(patient: NewPatient())) {
                    Text("Suivant")
                }
                    .modifier(ButtonStyle())
    //            Button(action: {
    //                print("Button Action")
    //                self.submit()
    //            }) {
    //                Text("Submit")
    //                    .modifier(ButtonStyle())
    //            }
            }
        }

}

struct PersonnalInfo_Previews: PreviewProvider {
    static var previews: some View {
        PatientAddressInfo(patient: NewPatient())
    }
}

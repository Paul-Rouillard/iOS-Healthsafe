//
//  SignUpClient.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 24/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct SignUpClient: View {
    @ObservedObject var patient: NewPatient

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $patient.emailAddr)
                        .modifier(FormTextFieldStyle())
                    SecureField("Password", text: $patient.password)
                        .modifier(FormTextFieldStyle())
                    SecureField("Confirm passsword", text: $patient.confirmationPassword)
                        .modifier(FormTextFieldStyle())
                }
                Section {
                    NavigationLink(destination: PersonnalInfo(patient: NewPatient())){
                        Text("Next")
                    }
                        .modifier(ButtonStyle())
                }
            }
        }.navigationBarTitle("Identifiant")
    }
}

struct SignUpClient_Previews: PreviewProvider {
    static var previews: some View {
        SignUpClient(patient: NewPatient())
    }
}

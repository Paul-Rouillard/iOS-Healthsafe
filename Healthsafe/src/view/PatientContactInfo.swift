//
//  PatientContactInfo.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 25/10/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct PatientContactInfo: View {
    @ObservedObject var patient: NewPatient

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        TextField("Phone number", text: $patient.phoneNumber)
                            .modifier(FormTextFieldStyle())
                        TextField("Email", text: $patient.emailAddr)
                            .modifier(FormTextFieldStyle())
                    }

                }

                NavigationLink(destination: PatientPasswdInfo(patient: NewPatient())) {
                    Text("Suivant")
                        .modifier(ButtonStyle())
                }
            }
        }
    }
}

struct PatientContactInfo_Previews: PreviewProvider {
    static var previews: some View {
        PatientContactInfo(patient: NewPatient())
    }
}

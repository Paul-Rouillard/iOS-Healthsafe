//
//  PatientPersonnalInfo.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 02/11/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct PatientPersonnalInfo: View {
    @ObservedObject private var patient = NewPatient()
    var body: some View {
        Group {
            Form {
                Section {
                    TextField("Fisrt name", text: $patient.firstName)
                        .modifier(FormTextFieldStyle())
                    TextField("Last Name", text: $patient.lastName)
                        .modifier(FormTextFieldStyle())
                    DatePicker(selection: $patient.birthday, in: ...Date(), displayedComponents: .date) {
                        Text("Birthday date")
                            .modifier(FormStyle())
                    }
                    TextField("Age", value: $patient.age, formatter: NumberFormatter())
                        .multilineTextAlignment(.center)
                        .modifier(FormStyle())
                }
            }
            Button (action: {
                print("next group")
                self.patientPersonnalInfo = false
                self.patientAddressInfo = true
            }){
                Text("Suivant")
                    .modifier(ButtonFormStyle())
            }
        }
}

struct PatientPersonnalInfo_Previews: PreviewProvider {
    static var previews: some View {
        PatientPersonnalInfo()
    }
}

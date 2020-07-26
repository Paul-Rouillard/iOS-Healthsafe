//
//  PreSignUp.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 24/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct PreSignUp: View {
    var body: some View {
        VStack {
            NavigationLink(destination: SignUpClient(patient: NewPatient())){
                Text("Vous êtes un patient")
            }
                .modifier(ButtonStyle())
            Spacer()
                .frame(height: 100)
            NavigationLink(destination: Inscrption(med: NewMed())) {
                    Text("Vous êtes un medecin")
            }
                .modifier(ButtonStyle())
        }
    }
}

struct PreSignUp_Previews: PreviewProvider {
    static var previews: some View {
        PreSignUp()
    }
}

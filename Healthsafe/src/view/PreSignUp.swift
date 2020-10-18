//
//  PreSignUp.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 24/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct PreSignUp: View {
    @State private var isPatient: Bool = false
    @State private var isDoctor: Bool = false

    var body: some View {
        if isPatient {
            return AnyView(SignUpClient(patient: NewPatient()))
        } else if isDoctor {
            return AnyView(SignUpMed(med: NewMed()))
        } else {
            return AnyView(PreSignUpView(isPatient: $isPatient, isDoctor: $isDoctor))
        }
    }
}

struct PreSignUpView: View {
    @Binding var isPatient: Bool
    @Binding var isDoctor: Bool

    var body: some View {
        VStack {
//            NavigationLink(destination: SignUpClient(patient: NewPatient())) {
//                Text("Vous êtes un patient")
//                    .modifier(ButtonStyle())
//            }
            
            Button(action: {
                self.isPatient = true
                print("")
            }) {
                Text("Vous êtes un patient")
                    .modifier(ButtonStyle())
            }
            Spacer()
                .frame(height: 100)
//            NavigationLink(destination: SignUpMed(med: NewMed())) {
//                Text("Vous êtes un médecin")
//                    .modifier(ButtonStyle())
//            }
            Button(action: {
                self.isDoctor = true
                print("")
            }) {
                Text("Vous êtes un medecin")
                    .modifier(ButtonStyle())
            }
        }
    }
}

struct PreSignUp_Previews: PreviewProvider {
    static var previews: some View {
        PreSignUp()
    }
}

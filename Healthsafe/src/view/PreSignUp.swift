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
    @State private var backPressed: Bool = false

    var body: some View {
        if isPatient {
            return AnyView(SignUpClient())
//            return AnyView(SignUpClient(patient: NewPatient()))
        } else if isDoctor {
            return AnyView(SignUpMed())
        } else if (backPressed){
            return AnyView(ContentView())
        } else {
            return AnyView(PreSignUpView(isPatient: $isPatient, isDoctor: $isDoctor, backPressed: $backPressed))
        }
    }
}

struct PreSignUpView: View {
    @Binding var isPatient: Bool
    @Binding var isDoctor: Bool
    @Binding var backPressed: Bool

    var body: some View {
        Button(action: {
            print("back pressed - Returning to first View")
            self.backPressed = true
            }) {
            Image(systemName: "chevron.backward")
                .frame(alignment: .topLeading)
                .foregroundColor(.blue)
            Text("Back")
                .frame(width: 325, alignment: .topLeading)
        }
        Spacer()
        VStack {
            Button(action: {
                self.isPatient = true
                print("")
            }) {
                Text("Vous êtes un patient")
                    .modifier(ButtonStyle())
            }
            Spacer()
                .frame(height: 100)
            Button(action: {
                self.isDoctor = true
                print("")
            }) {
                Text("Vous êtes un medecin")
                    .modifier(ButtonStyle())
            }
        }
        Spacer()
    }
}


struct PreSignUp_Previews: PreviewProvider {
    static var previews: some View {
        PreSignUp()
    }
}

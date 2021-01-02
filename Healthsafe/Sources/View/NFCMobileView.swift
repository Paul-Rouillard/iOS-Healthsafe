//
//  NFCMobileView.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 18/12/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct NFCMobileView: View {
    @Binding var data: String
    @State var deciphered: [String:String] = [:] //<- Make this a Dictionary type

    var body: some View {
        ZStack {
            Form {
                Section {
                    HStack {
                        Text("Last name")
                        TextField("", text: _deciphered.binding("lastName"))
                    }
                    HStack {
                        Text("First name")
                        TextField("", text: _deciphered.binding("firstName"))
                    }
                    HStack {
                        Text("Gender")
                        TextField("", text:  _deciphered.binding("gender"))
                    }
                    HStack {
                        Text("Age")
                        TextField("", text:  _deciphered.binding("age"))
                    }
                }
                Section {
                    HStack {
                        Text("Height")
                        TextField("", text:  _deciphered.binding("height"))
                    }
                    HStack {
                        Text("Weight")
                        TextField("", text:  _deciphered.binding("wight"))
                    }
                }
                Section {
                    HStack {
                        Text("Medical history")
                        TextField("", text:  _deciphered.binding("medicalHistory"))
                    }
                    HStack {
                        Text("Treatement")
                        TextField("", text:  _deciphered.binding("treatements"))
                    }
                    HStack {
                        Text("Allergies")
                        TextField("", text:  _deciphered.binding("allergies"))
                    }
                    HStack {
                        Text("Blood type")
                        TextField("", text:  _deciphered.binding("bloodType"))
                    }
                }
                Section {
                    HStack {
                        Text("Emergency nbr")
                        TextField("", text:  _deciphered.binding("emergencyNumber"))
                    }
                    HStack {
                        Text("Doctor")
                        TextField("", text:  _deciphered.binding("doctor"))
                    }
                    HStack {
                        Text("Social number")
                        TextField("", text:  _deciphered.binding("socialNumber"))
                    }
                    HStack {
                        Text("Organ doner")
                        TextField("", text:  _deciphered.binding("organDonation"))
                    }
                }
            }
            .onAppear {
                //↓ No `var` here
                deciphered = data.split(separator: "\n").reduce(into: [String: String]()) {
                    let str = $1.split(separator: ":")
                    if let first = str.first, let value = str.last {
                        $0[String(first)] = String(value)
                    }
                }
            }
            Spacer()
            VStack {
                Button(action: {
                    
                }) {
                    Text("Modifier")
                        .modifier(ButtonStyleSecondary())
                }
                Button(action: {
                    
                }) {
                    Text("Update")
                        .modifier(ButtonStyle())
                }
            }
        }
    }
}

//#if DEBUG
//struct NFCMobileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NFCMobileView(data: <#Binding<String>#>)
//    }
//}
//#endif

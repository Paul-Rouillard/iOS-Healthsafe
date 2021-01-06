//
//  NFCMobileView.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 18/12/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI
struct NFCMobileContoler: View {
    @State var backPressed: Bool = false
    @Binding var data: String
    @Binding var nfcData: NFCData

    var body: some View {
        if backPressed {
            return AnyView(Home(connexion: Connexion()))
        } else {
            return AnyView(NFCMobileView(data: $data, nfcData: $nfcData, backPressed: $backPressed))
        }
    }
}

struct NFCMobileView: View {
    @State var allowModifications: Bool = true
    @Binding var data: String
    @Binding var nfcData: NFCData
    @Binding var backPressed: Bool
//    @State var deciphered: [String:String] = [:] //<- Make this a Dictionary type

    var body: some View {
        Button(action: {
            self.backPressed = true
            }) {
            Image(systemName: "chevron.backward")
                .frame(alignment: .topLeading)
                .foregroundColor(.blue)
            Text("Back")
                .frame(width: 325, alignment: .topLeading)
        }
        Form {
            Section {
                HStack {
                    Text("Last name")
                    TextField("", text: $nfcData.lastName)
                }
                HStack {
                    Text("First name")
                    TextField("", text: $nfcData.firstName)
                }
                HStack {
                    Text("Gender")
                    TextField("", text: $nfcData.gender)
                }
                HStack {
                    Text("Age")
                    TextField("", text: $nfcData.age)
                }
            }
            Section {
                HStack {
                    Text("Height")
                    TextField("", text: $nfcData.height)
                }
                HStack {
                    Text("Weight")
                    TextField("", text: $nfcData.weight)
                }
            }
            Section {
                HStack {
                    Text("Medical history")
                    TextField("", text: $nfcData.medicalHistory)
                }
                HStack {
                    Text("Treatement")
                    TextField("", text: $nfcData.treatments)
                }
                HStack {
                    Text("Allergies")
                    TextField("", text: $nfcData.allergies)
                }
                HStack {
                    Text("Blood type")
                    TextField("", text: $nfcData.bloodType)
                }
            }
            Section {
                HStack {
                    Text("Emergency number")
                    TextField("", text: $nfcData.emergencyNumber)
                }
                HStack {
                    Text("Doctor")
                    TextField("", text: $nfcData.doctor)
                }
                HStack {
                    Text("Social number")
                    TextField("", text: $nfcData.socialNumber)
                }
                HStack {
                    Text("Organ doner")
                    TextField("", text: $nfcData.organDonation)
                }
            }
        }.disabled(allowModifications)
//            .onAppear {
//                //↓ No `var` here
//                deciphered = data.split(separator: "\n").reduce(into: [String: String]()) {
//                    let str = $1.split(separator: ":")
//                    if let first = str.first, let value = str.last {
//                        $0[String(first)] = String(value)
//                    }
//                }
//            }
        HStack {
            Button(action: {
                self.allowModifications = false
            }) {
                Text("Modifier")
                    .modifier(ButtonFormStyleSecondary())
            }
//            Button(action: {
//                print("\(self.nfcData.lastName)")
//                print(self.data)
//                self.data = "allergies:\(self.nfcData.allergies)\nlastName:\(self.nfcData.lastName)\n\n"
//                print(self.data)
//            }) {
//                Text("UPDATE - test")
//            }
            NFCWriteButton(data: $data, dataToWrite: $nfcData)
                .modifier(ButtonFormStyle())
//                .onTapGesture {
//                    self.data = "allergies:\(self.nfcData.allergies)\nlastName:\(self.nfcData.lastName)\ngender:\(self.nfcData.gender)\nweight:\(self.nfcData.weight)\nsocialNumber:\(self.nfcData.socialNumber)\nemergencyNumber:\(self.nfcData.emergencyNumber)\nbloodType:\(self.nfcData.bloodType)\ntreatments:\(self.nfcData.treatments)\ndoctor:\(self.nfcData.doctor)\nfirstName:\(self.nfcData.firstName)\norganDonation:\(self.nfcData.organDonation)\nId:\(self.nfcData.Id)\nmedicalHistory:\(self.nfcData.medicalHistory)\nage:\(self.nfcData.age)\nheight:\(self.nfcData.height)\n"
//                    print(".onTapGesture\n\(self.data)\n")
//                }
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

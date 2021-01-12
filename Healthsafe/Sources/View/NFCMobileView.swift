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
    @ObservedObject var nfcData: NFCData

    var body: some View {
        if backPressed {
            return AnyView(Home(connexion: Connexion()))
        } else {
            return AnyView(NFCMobileView(data: $data, backPressed: $backPressed, nfcData: nfcData))
        }
    }
}

struct NFCMobileView: View {
    @State private var allowModifications: Bool = true
    @State private var showMedHistory : Bool = false
    @Binding var data: String
    @Binding var backPressed: Bool
    @ObservedObject var nfcData: NFCData
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
                        .keyboardType(.numberPad)
                }
                DatePicker(selection: $nfcData.bDay, in: ...Date(), displayedComponents: .date) {
                    Text("Birthday")
                        .modifier(FormTextFieldStyle())
                }
            }
            Section {
                HStack {
                    Text("Height")
                    TextField("", text: $nfcData.height)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("Weight")
                    TextField("", text: $nfcData.weight)
                        .keyboardType(.numberPad)
                }
            }
            Section {
                    Button(action: {
                        self.showMedHistory = true
                    }) {
                        Text("Medical history")//, destination: NFCMedicalHistory())
                    }.sheet(isPresented: $showMedHistory, content: {
                        NFCMedicalHistory(data: nfcData)
                    })

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
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("Doctor")
                    TextField("", text: $nfcData.doctor)
                }
                HStack {
                    Text("Social number")
                    TextField("", text: $nfcData.socialNumber)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("Organ donor")
                    TextField("", text: $nfcData.organDonation)
                        .autocapitalization(.none)
                }
            }
        }.disabled(allowModifications)
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
            NFCWriteButton(data: $data, dataToWrite: nfcData)
                .modifier(ButtonFormStyle())
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

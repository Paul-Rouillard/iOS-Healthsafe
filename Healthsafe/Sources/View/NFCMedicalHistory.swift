//
//  NFCMedicalHistory.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 09/01/2021.
//  Copyright © 2021 Healthsafe. All rights reserved.
//

import SwiftUI

struct NFCMedicalHistory: View {
    @State private var addToHistory: String = ""
    @State private var editMode: EditMode = EditMode.inactive
    @ObservedObject var data: NFCData

    var body: some View {
        VStack {
            Text("").padding()
                EditButton()
                    .frame(width: 325, alignment: .topLeading)
                    .padding()
                
                Text("History list")
                    .font(.largeTitle)
            TextField("", text: $addToHistory, onCommit: addNewWord)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            List {
                ForEach(self.data.medicalHistory, id: \.self) { medHistory in
                    Text(medHistory)
                }
                .onDelete(perform: onDelete)
            }
        }
    }

    private func onDelete(offsets: IndexSet) {
        data.medicalHistory.remove(atOffsets: offsets)
    }

    private func addRow() {
        self.data.medicalHistory.append("test")
    }

    func addNewWord() {
        data.medicalHistory.append(addToHistory.trimmingCharacters(in: .whitespacesAndNewlines))
        addToHistory = ""
    }
}

//struct NFCMedicalHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        NFCMedicalHistory()
//    }
//}

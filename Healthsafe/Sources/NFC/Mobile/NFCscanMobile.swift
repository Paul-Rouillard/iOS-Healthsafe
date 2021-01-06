//
//  NFCscanMobile.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 19/08/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI
import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

struct NFCButtonMobile : UIViewRepresentable {
    @Binding var data: String
    @Binding var showData: Bool
    @Binding var storeNFC: NFCData

    func makeUIView(context: UIViewRepresentableContext<NFCButtonMobile>) -> UIButton {
        let button = UIButton()

//        let image = UIImage(named: "phoneFinal")
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        let image = UIImage(named: "logo_tel")
        
        button.setImage(image, for: .normal)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.beginScan(_:)), for: .touchUpInside)
        return button
    }


    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<NFCButtonMobile>) {
        // Do nothing
    }

    func makeCoordinator() -> NFCButtonMobile.Coordinator {
        return Coordinator(data: $data, view: $showData, storeNFC: $storeNFC)
    }


    class Coordinator : NSObject, NFCNDEFReaderSessionDelegate {
        @Binding var data: String
        @Binding var showData: Bool
        @Binding var storeNFC: NFCData

        var session : NFCNDEFReaderSession?

        @objc func beginScan(_ sender: Any) {
            guard NFCNDEFReaderSession.readingAvailable else {
                print("error: Scanning not support")
                return
            }
            session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: true)
            session?.alertMessage = "Hold your iphone near to scan."
            session?.begin()
        }

        init(data: Binding<String>, view: Binding<Bool>, storeNFC: Binding<NFCData>) {
            _data = data
            _showData = view
            _storeNFC = storeNFC
        }

        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            // Check the invalidation reason from the returned error.
            if let readerError = error as? NFCReaderError {
                // Show an alert when the invalidation reason is not because of a
                // successful read during a single-tag read session, or because the
                // user canceled a multiple-tag read session from the UI or
                // programmatically using the invalidate method call.
                if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                    && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                    print("Error nfc read: \(readerError.localizedDescription)")
                }
            }
            // To read new tags, a new session instance is required.
            self.session = nil
        }

        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
            let payload = String(data: messages.first!.records.first!.payload, encoding: .utf8)
            print("scanning ...")
            print("\(payload as Any)\n this was the payload")
            self.data = payload!

            //go to Mobile view.
            self.showData = true
            
            //make a dictionary
            let deciphered = self.data.split(separator: "\n").reduce(into: [String: String]()) {
                let str = $1.split(separator: ":")
                if let first = str.first, let value = str.last {
                    $0[String(first)] = String(value)
                }
            }
            
            //save the dictionaty's value inside a structure
            self.storeNFC.Id = deciphered["Id"]!
            self.storeNFC.lastName = deciphered["lastName"]!
            self.storeNFC.firstName = deciphered["firstName"]!
            self.storeNFC.gender = deciphered["gender"]!
            self.storeNFC.age = deciphered["age"]!
            self.storeNFC.height = deciphered["height"]!
            self.storeNFC.weight = deciphered["weight"]!
            self.storeNFC.medicalHistory = deciphered["medicalHistory"]!
            self.storeNFC.treatments = deciphered["treatments"]!
            self.storeNFC.allergies = deciphered["allergies"]!
            self.storeNFC.bloodType = deciphered["bloodType"]!
            self.storeNFC.emergencyNumber = deciphered["emergencyNumber"]!
            self.storeNFC.doctor = deciphered["doctor"]!
            self.storeNFC.socialNumber = deciphered["socialNumber"]!
            self.storeNFC.organDonation = deciphered["organDonation"]!
        }

        func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {    }

    }
}

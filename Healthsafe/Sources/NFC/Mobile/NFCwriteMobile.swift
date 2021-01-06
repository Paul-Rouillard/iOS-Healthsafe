//
//  NFCwriteMobile.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 02/01/2021.
//  Copyright © 2021 Healthsafe. All rights reserved.
//

import SwiftUI
import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

struct NFCWriteButton : UIViewRepresentable {
    @Binding var data: String
    @Binding var dataToWrite: NFCData

    func updateUIView(_ uiView: UIButton, context: Context) {
        // Do nothing
    }
    
    func makeUIView(context: UIViewRepresentableContext<NFCWriteButton>) -> UIButton {
        let button = UIButton()
        button.setTitle("Write on Tag", for: .normal)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.beginScan(_:)), for: .touchUpInside)
        return button
    }

    func makeCoordinator() -> NFCWriteButton.Coordinator {
        return Coordinator(data: $data, toWrite: $dataToWrite)
    }

    class Coordinator: NSObject, NFCNDEFReaderSessionDelegate {
        var session : NFCNDEFReaderSession?
        @Binding var data: String
        @Binding var nfcData: NFCData

        @objc func beginScan(_ sender: Any) {
            guard NFCNDEFReaderSession.readingAvailable else {
                print("error: Scanning not support")
                return
            }
            session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: true)
            session?.alertMessage = "Hold your iphone near to scan."
            session?.begin()
        }

        init(data: Binding<String>, toWrite: Binding<NFCData>) {
            _data = data
            _nfcData = toWrite
        }

        func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
            // Do nothing here unless want to add extra action
            // This function is to silence the warning in the console
        }

        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            // Nothing here but you can implement your own error
        }

        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
            // Nothing here since we won't be using it.
            
        }

        func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
            if tags.count > 1 {
                // Restart polling in 2000 milliseconds.
                let retryInterval = DispatchTimeInterval.milliseconds(2000)
                session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                })
                return
            }
            // Connect to the found tag and write an NDEF message to it.
            //messages: [NFCNDEFMessage]) {
            //let payload = String(data: messages.first!.records.first!.payload, encoding: .utf8)
            let tag = tags.first!
            print("Get first tag")
            session.connect(to: tag, completionHandler: { (error: Error?) in
                if nil != error {
                    session.alertMessage = "Unable to connect to tag."
                    session.invalidate()
                    print("Error connect to tag")
                    return
                }
                tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                    guard error == nil else {
                        session.alertMessage = "Unable to query the NDEF status of tag."
                        session.invalidate()
                        print("unable to query ndef status of bag")
                        return
                    }

                    self.data = "allergies:\(self.nfcData.allergies)\nlastName:\(self.nfcData.lastName)\ngender:\(self.nfcData.gender)\nweight:\(self.nfcData.weight)\nsocialNumber:\(self.nfcData.socialNumber)\nemergencyNumber:\(self.nfcData.emergencyNumber)\nbloodType:\(self.nfcData.bloodType)\ntreatments:\(self.nfcData.treatments)\ndoctor:\(self.nfcData.doctor)\nfirstName:\(self.nfcData.firstName)\norganDonation:\(self.nfcData.organDonation)\nId:\(self.nfcData.Id)\nmedicalHistory:\(self.nfcData.medicalHistory)\nage:\(self.nfcData.age)\nheight:\(self.nfcData.height)\n"

                    switch ndefStatus {
                    case .notSupported:
                        print("Not Support")
                        session.alertMessage = "Tag is not NDEF compliant."
                        session.invalidate()
                    case .readOnly:
                        print("Read Only")
                        session.alertMessage = "Tag is read only."
                        session.invalidate()
                    case .readWrite:
                        // implement our code
                        print("Writing Available")
                        let payLoad : NFCNDEFPayload?
                        guard !self.data.isEmpty else {
                               session.alertMessage = "Empty Data"
                               session.invalidate(errorMessage: "Empty Text Data")
                               return
                        }
                        
                        print(self.data)
                        
                        payLoad = NFCNDEFPayload(format: .nfcWellKnown, type: "T".data(using: .utf8)! , identifier: "Text".data(using: .utf8)!,payload: "\(self.data)".data(using: .utf8)!)

//↓ c'est ici qu'il faut mettre le registre pour enregistrer le payload au bon endoit ↓
                        let NFCMessage = NFCNDEFMessage(records: [payLoad!])
//
                        print(NFCMessage as Any)
                        tag.writeNDEF(NFCMessage, completionHandler: { (error: Error?) in
                            if nil != error {
                                session.alertMessage = "Write NDEF message fail: \(error!)"
                                print("fails: \(error!.localizedDescription)")
                            } else {
                                session.alertMessage = "Write NDEF message successful."
                                print("successs")
                            }
                            session.invalidate()
                        })
                    @unknown default:
                        print("Unknow Error")
                        session.alertMessage = "Unknown NDEF tag status."
                        session.invalidate()
                    }
                })
            })
        }
    }
}

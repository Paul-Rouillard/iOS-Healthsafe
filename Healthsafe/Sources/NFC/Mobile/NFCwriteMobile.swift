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
    @ObservedObject var dataToWrite: NFCData

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
        return Coordinator(data: $data, toWrite: _dataToWrite)
    }

    class Coordinator: NSObject, NFCNDEFReaderSessionDelegate {
        var session : NFCNDEFReaderSession?
        @ObservedObject var dataToWrite: NFCDataSec = NFCDataSec()
        @Binding var data: String
        @ObservedObject var nfcData: NFCData

        @objc func beginScan(_ sender: Any) {
            guard NFCNDEFReaderSession.readingAvailable else {
                print("error: Scanning not support")
                return
            }
            session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: true)
            session?.alertMessage = "Hold your iphone near to scan."
            session?.begin()
        }

        init(data: Binding<String>, toWrite: ObservedObject<NFCData>) {
            _data = data
            _nfcData = toWrite
        }

        func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {    }

        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {    }

        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {    }

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
                    // getting back from front
                    self.dataToWrite.Id = self.nfcData.Id
                    self.dataToWrite.lastName = self.nfcData.lastName
                    self.dataToWrite.firstName = self.nfcData.firstName
                    self.dataToWrite.gender = self.nfcData.gender
                    self.dataToWrite.age = Int(self.nfcData.age)!
                    self.dataToWrite.height = Int(self.nfcData.height)!
                    self.dataToWrite.weight = Int(self.nfcData.weight)!
                    self.dataToWrite.medicalHistory = self.nfcData.medicalHistory
                    self.dataToWrite.treatments = self.nfcData.treatments
                    self.dataToWrite.allergies = self.nfcData.allergies
                    self.dataToWrite.bloodType = self.nfcData.bloodType
                    self.dataToWrite.emergencyNumber = self.nfcData.emergencyNumber
                    self.dataToWrite.doctor = self.nfcData.doctor
                    self.dataToWrite.socialNumber = Int(self.nfcData.socialNumber)!
                    self.dataToWrite.organDonation = Bool(self.nfcData.organDonation)!

                    // Date format
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    self.dataToWrite.birthDay = dateFormatter.string(from: self.nfcData.bDay)
                    self.nfcData.birthDay = dateFormatter.string(from: self.nfcData.bDay)

                    print(self.dataToWrite.age)
                    do {
                        print("---------------\nwaiting for secrured Data ...")
                        try self.SecuringData()
                        sleep(4)
                        print("---------------\n")
                    } catch{
                        exit(-1)
                    }
                    // Array to String
                    let medHistToString: String = self.dataToWrite.medicalHistory.joined(separator: "#")

                    self.data = "allergies:\(self.dataToWrite.allergies)\nlastName:\(self.dataToWrite.lastName)\ngender:\(self.dataToWrite.gender)\nweight:\(self.dataToWrite.stringWeight.replacingOccurrences(of: "\"", with: ""))\nsocialNumber:\(self.dataToWrite.stringSocialNumber.replacingOccurrences(of: "\"", with: ""))\nemergencyNumber:\(self.dataToWrite.emergencyNumber)\nbloodType:\(self.dataToWrite.bloodType)\ntreatments:\(self.dataToWrite.treatments)\ndoctor:\(self.dataToWrite.doctor)\nfirstName:\(self.dataToWrite.firstName)\norganDonation:\(self.dataToWrite.stringOrganDonation.replacingOccurrences(of: "\"", with: ""))\nId:\(self.dataToWrite.Id)\nmedicalHistory:\(medHistToString)\nage:\(self.dataToWrite.stringAge.replacingOccurrences(of: "\"", with: ""))\nheight:\(self.dataToWrite.stringHeight.replacingOccurrences(of: "\"", with: ""))\nbirthDay:\(self.dataToWrite.birthDay)\n"
                    print(self.data)

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
                        
                        payLoad = NFCNDEFPayload(format: .nfcWellKnown, type: "T".data(using: .utf8)! , identifier: "Text".data(using: .utf8)!,payload: "\(self.data)".data(using: .utf8)!)
                        let NFCMessage = NFCNDEFMessage(records: [payLoad!])
                        print("\n---------------\nThis will be print:\(NFCMessage)\n---------------\n")

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
        
        func handleServerError(_ res: URLResponse?) {
            print("ERROR: Status Code: \(res!): the status code MUST be between 200 and 299")
        }

        func SecuringData() throws {
            guard let encoded = try? JSONEncoder().encode(dataToWrite) else {
                print("Fail to encode SecuringData - NFCDataSec")
                return
            }
            let url = URL(string: "https://x2021healthsafe1051895009000.northeurope.cloudapp.azure.com:5000/api/sendToChip")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            print("Encoded data: \(String(data: encoded, encoding: .utf8)!)\n")

            URLSession.shared.dataTask(with: request) { data, res, error in
                guard let httpResponse = res as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                        self.handleServerError(res)
                    return
                }
                if let data = data {
                    let decoder = JSONDecoder()
                    let jsonData = String(decoding: data, as: UTF8.self)
                    if let json = try? decoder.decode(NFCDataSec.self, from: data) {
                        print(json)
                        let deciphered = jsonData.split(separator: ",").reduce(into: [String: String]()) {
                            let str = $1.split(separator: ":")
                            if let first = str.first, let value = str.last {
                                $0[String(first)] = String(value)
                            }
                        }
                        // store in class from the API's retreived data
                        self.dataToWrite.lastName = json.lastName
                        self.dataToWrite.firstName = json.firstName
                        self.dataToWrite.gender = json.gender
                        self.dataToWrite.stringAge = deciphered["\"age\""]!
                        self.dataToWrite.birthDay = json.birthDay
                        self.dataToWrite.stringHeight = deciphered["\"height\""]!
                        self.dataToWrite.stringWeight = deciphered["\"weight\""]!
                        self.dataToWrite.medicalHistory = json.medicalHistory
                        self.dataToWrite.treatments = json.treatments
                        self.dataToWrite.allergies = json.allergies
                        self.dataToWrite.bloodType = json.bloodType
                        self.dataToWrite.emergencyNumber = json.emergencyNumber
                        self.dataToWrite.doctor = json.doctor
                        self.dataToWrite.stringSocialNumber = deciphered["\"socialNumber\""]!
                        self.dataToWrite.stringOrganDonation = deciphered["\"organDonation\""]!
                    }
                    else {
                        let dataString = String(decoding: data, as: UTF8.self)
                        print("Invalid response \(dataString)")
                    }
                }
            }.resume()
        }
        
    }
}

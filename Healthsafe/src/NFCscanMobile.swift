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

struct nfcButton : UIViewRepresentable {
    @Binding var data: String

    func makeUIView(context: UIViewRepresentableContext<nfcButton>) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "logo_tel"), for: .normal)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.beginScan(_:)), for: .touchUpInside)
        return button
    }


    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<nfcButton>) {
        // Do nothing
    }

    func makeCoordinator() -> nfcButton.Coordinator {
        return Coordinator(data: $data)
    }


    class Coordinator : NSObject, NFCNDEFReaderSessionDelegate {
        @Binding var data: String
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

        init(data: Binding<String>) {
            _data = data
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
//            for message in messages {
//                    for record in message.records {
//                        if let string = String(data: record.payload, encoding: .ascii) {
//                            print(string)
//                        }
//                    }
//                }
            guard
                let nfcMess = messages.first,
                let record = nfcMess.records.first,
                record.typeNameFormat == .absoluteURI || record.typeNameFormat == .nfcWellKnown,
                let payload = String(data: record.payload, encoding: .utf8)
            else {
                return
            }
            print(payload)
            self.data = payload
            }

        func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
            
        }
        
    }
}

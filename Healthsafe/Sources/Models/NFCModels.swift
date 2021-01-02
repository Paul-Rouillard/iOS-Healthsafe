//
//  NFCModels.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 30/12/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import Foundation

// This structure will not be used. It allows to know what should we get form the NDEF tag and the order to display information.
struct NFCData {
    var Id: String = ""
    var lastName: String = ""
    var firstName: String = ""
    var gender: String = ""
    var age: String = ""
    var height: String = ""
    var weight: String = ""
    var medicalHistory: String = ""
    var treatments: String = ""
    var allergies: String = ""
    var bloodType: String = ""
    var emergencyNumber: String = ""
    var doctor: String = ""
    var socialNumber: String = ""
    var organDonation: String = ""
}

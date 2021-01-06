//
//  NFCModels.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 30/12/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import Foundation

struct NFCData: Codable {
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

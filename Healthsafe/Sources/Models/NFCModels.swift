//
//  NFCModels.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 30/12/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import Foundation

class NFCData: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case Id, firstName, lastName, gender, age, birthDay, height, weight, medicalHistory, treatments, allergies, bloodType, emergencyNumber, doctor, socialNumber, organDonation
    }

    @Published var Id: String = ""
    @Published var lastName: String = ""
    @Published var firstName: String = ""
    @Published var gender: String = ""
    @Published var bDay = Date()
    @Published var birthDay: String = ""
    @Published var age: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var medicalHistory = [String]()
    @Published var treatments: String = ""
    @Published var allergies: String = ""
    @Published var bloodType: String = ""
    @Published var emergencyNumber: String = ""
    @Published var doctor: String = ""
    @Published var socialNumber: String = ""
    @Published var organDonation: String = ""

    init() {    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try container.decode(String.self, forKey: .lastName)
        firstName = try container.decode(String.self, forKey: .firstName)
        gender = try container.decode(String.self, forKey: .gender)
        age = try container.decode(String.self, forKey: .age)
        birthDay = try container.decode(String.self, forKey: .birthDay)
        height = try container.decode(String.self, forKey: .height)
        weight = try container.decode(String.self, forKey: .weight)
        medicalHistory = try container.decode([String].self, forKey: .medicalHistory)
        treatments = try container.decode(String.self, forKey: .treatments)
        allergies = try container.decode(String.self, forKey: .allergies)
        bloodType = try container.decode(String.self, forKey: .bloodType)
        emergencyNumber = try container.decode(String.self, forKey: .emergencyNumber)
        doctor = try container.decode(String.self, forKey: .doctor)
        socialNumber = try container.decode(String.self, forKey: .socialNumber)
        organDonation = try container.decode(String.self, forKey: .organDonation)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(gender, forKey: .gender)
        try container.encode(age, forKey: .age)
        try container.encode(birthDay, forKey: .birthDay)
        try container.encode(height, forKey: .height)
        try container.encode(weight, forKey: .weight)
        try container.encode(medicalHistory, forKey: .medicalHistory)
        try container.encode(treatments, forKey: .treatments)
        try container.encode(allergies, forKey: .allergies)
        try container.encode(bloodType, forKey: .bloodType)
        try container.encode(emergencyNumber, forKey: .emergencyNumber)
        try container.encode(doctor, forKey: .doctor)
        try container.encode(socialNumber, forKey: .socialNumber)
        try container.encode(organDonation, forKey: .organDonation)
    }
}

class NFCDataSec: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case Id, firstName, lastName, gender, age, birthDay, height, weight, medicalHistory, treatments, allergies, bloodType, emergencyNumber, doctor, socialNumber, organDonation
    }

    @Published var Id: String = ""
    @Published var lastName: String = ""
    @Published var firstName: String = ""
    @Published var gender: String = ""
    @Published var age: Int = 0
    @Published var stringAge: String = ""
    @Published var bDay = Date()
    @Published var birthDay: String = ""
    @Published var height: Int = 0
    @Published var stringHeight: String = ""
    @Published var weight: Int = 0
    @Published var stringWeight: String = ""
    @Published var medicalHistory = [String]()
    @Published var treatments: String = ""
    @Published var allergies: String = ""
    @Published var bloodType: String = ""
    @Published var emergencyNumber: String = ""
    @Published var doctor: String = ""
    @Published var socialNumber: Int = 0
    @Published var stringSocialNumber: String = ""
    @Published var organDonation: Bool = false
    @Published var stringOrganDonation: String = ""

    init() {    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try container.decode(String.self, forKey: .lastName)
        firstName = try container.decode(String.self, forKey: .firstName)
        gender = try container.decode(String.self, forKey: .gender)
        stringAge = try container.decode(String.self, forKey: .age)
        birthDay = try container.decode(String.self, forKey: .birthDay)
        stringHeight = try container.decode(String.self, forKey: .height)
        stringWeight = try container.decode(String.self, forKey: .weight)
        medicalHistory = try container.decode([String].self, forKey: .medicalHistory)
        treatments = try container.decode(String.self, forKey: .treatments)
        allergies = try container.decode(String.self, forKey: .allergies)
        bloodType = try container.decode(String.self, forKey: .bloodType)
        emergencyNumber = try container.decode(String.self, forKey: .emergencyNumber)
        doctor = try container.decode(String.self, forKey: .doctor)
        stringSocialNumber = try container.decode(String.self, forKey: .socialNumber)
        stringOrganDonation = try container.decode(String.self, forKey: .organDonation)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(gender, forKey: .gender)
        try container.encode(age, forKey: .age)
        try container.encode(birthDay, forKey: .birthDay)
        try container.encode(height, forKey: .height)
        try container.encode(weight, forKey: .weight)
        try container.encode(medicalHistory, forKey: .medicalHistory)
        try container.encode(treatments, forKey: .treatments)
        try container.encode(allergies, forKey: .allergies)
        try container.encode(bloodType, forKey: .bloodType)
        try container.encode(emergencyNumber, forKey: .emergencyNumber)
        try container.encode(doctor, forKey: .doctor)
        try container.encode(socialNumber, forKey: .socialNumber)
        try container.encode(organDonation, forKey: .organDonation)
    }
}

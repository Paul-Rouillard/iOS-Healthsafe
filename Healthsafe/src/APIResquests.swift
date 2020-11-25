//
//  APIResquests.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 08/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import Foundation

class NewMed: ObservableObject, Codable {

    enum CodingKeys: String, CodingKey {
        case lastName, firstName, age, phoneNumber, email, password, confirmationPassword, address, streetNumber, street, typeStreetNumber, typeStreet, zipCode, city, country, idNumber, expertiseDomain
    }

    static let genders = ["Male", "Female"]
    @Published var indexGender = 0
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: Int?
    @Published var birthday: Date = Date()
    @Published var phoneNumber: String = ""

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmationPassword: String = ""

    @Published var streetNumber: Int?

    @Published var street: String = ""
    static let typeStreetNbr = ["", "bis", "ter"]
    @Published var typeStreetNumber: String = ""
    @Published var indexStreetNbr = 0
    static let typeStrt = ["rue", "boulevard", "avenue", "chemin"]
    @Published var typeStreet: String = ""
    @Published var indexStreet = 0

    @Published var zipCode: Int?
    @Published var city: String = ""
    @Published var country: String = ""

    @Published var idNumber: String = ""
    @Published var expertiseDomain: String = ""

    var isValid: Bool  {
        if (firstName.isEmpty || lastName.isEmpty || age != nil || email.isEmpty || password.isEmpty || confirmationPassword.isEmpty || streetNumber != nil || street.isEmpty || zipCode != nil || city.isEmpty || country.isEmpty || idNumber.isEmpty) {
            return false
        }
        return true
    }

    init( ) {    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try container.decode(String.self, forKey: .lastName)
        firstName = try container.decode(String.self, forKey: .firstName)
        age = try container.decode(Int.self, forKey: .age)
//        birthday = try container.decode(Date.self, forKey: .birthday)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        confirmationPassword = try container.decode(String.self, forKey: .confirmationPassword)
        let address = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .address)
        streetNumber = try address.decode(Int.self, forKey: .streetNumber)
        street = try address.decode(String.self, forKey: .street)
        typeStreetNumber = try address.decode(String.self, forKey: .typeStreetNumber)
        typeStreet = try address.decode(String.self, forKey: .typeStreet)
        zipCode = try address.decode(Int.self, forKey: .zipCode)
        city = try address.decode(String.self, forKey: .city)
        country = try address.decode(String.self, forKey: .country)
        idNumber = try container.decode(String.self, forKey: .idNumber)
        expertiseDomain = try container.decode(String.self, forKey: .expertiseDomain)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(age, forKey: .age)
//        try container.encode(birthday, forKey: .birthday)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(confirmationPassword, forKey: .confirmationPassword)
        var address = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .address)
        try address.encode(streetNumber, forKey: .streetNumber)
        try address.encode(street, forKey: .street)
        try address.encode(typeStreetNumber, forKey: .typeStreetNumber)
        try address.encode(typeStreet, forKey: .typeStreet)
        try address.encode(zipCode, forKey: .zipCode)
        try address.encode(city, forKey: .city)
        try address.encode(country, forKey: .country)
        try container.encode(idNumber, forKey: .idNumber)
        try container.encode(expertiseDomain, forKey: .expertiseDomain)
    }
//    func update() {
//        objectWillChange.send()
//    }

}

class Address: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case streetNumber, street, typeStreetNumber, typeStreet, zipCode, city, country
    }
    @Published var streetNumber: Int = 0
    @Published var typeStreetNumber: String = ""
    @Published var street: String = ""
    @Published var typeStreet: String = ""
    @Published var zipCode: Int = 0
    @Published var city: String = ""
    @Published var country: String = ""
    
    init() {    }

    required init(from decoder: Decoder) throws {
        let address = try decoder.container(keyedBy: CodingKeys.self)
        streetNumber = try address.decode(Int.self, forKey: .streetNumber)
        street = try address.decode(String.self, forKey: .street)
        typeStreetNumber = try address.decode(String.self, forKey: .typeStreetNumber)
        typeStreet = try address.decode(String.self, forKey: .typeStreet)
        zipCode = try address.decode(Int.self, forKey: .zipCode)
        city = try address.decode(String.self, forKey: .city)
        country = try address.decode(String.self, forKey: .country)
    }
    
    func encode(to encoder: Encoder) throws {
        var address = encoder.container(keyedBy: CodingKeys.self)
        try address.encode(streetNumber, forKey: .streetNumber)
        try address.encode(street, forKey: .street)
        try address.encode(typeStreetNumber, forKey: .typeStreetNumber)
        try address.encode(typeStreet, forKey: .typeStreet)
        try address.encode(zipCode, forKey: .zipCode)
        try address.encode(city, forKey: .city)
        try address.encode(country, forKey: .country)
    }
    
}


class NewPatient: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case lastName, firstName, age, birthDay, phoneNumber, emailAddr = "email", password, confirmationPassword, address, socialNumber
    }

    @Published var address = [Address]()
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var bDay = Date()
    @Published var birthDay: String = ""
    @Published var age: Int = 0
    @Published var emailAddr: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var confirmationPassword: String = ""

    static let typeStreetNbr = ["", "bis", "ter"]
    @Published var indexStreetNbr = 0

    static let typeStrt = ["rue", "boulevard", "avenue", "chemin"]
    @Published var indexStreet = 0
    
    @Published var socialNumber: Int = 123456789012345
    
    @Published var zipCode_tmp: String = ""
    @Published var streetNumber_tmp: String = ""
    

    var isValid: Bool  {
        if (firstName.isEmpty || lastName.isEmpty || age > 18 || emailAddr.isEmpty || password.isEmpty || confirmationPassword.isEmpty || phoneNumber.isEmpty) {
            return false
        }
        return true
    }

    init() {    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try container.decode(String.self, forKey: .lastName)
        firstName = try container.decode(String.self, forKey: .firstName)
        birthDay = try container.decode(String.self, forKey: .birthDay)
        age = try container.decode(Int.self, forKey: .age)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        emailAddr = try container.decode(String.self, forKey: .emailAddr)
        password = try container.decode(String.self, forKey: .password)
        confirmationPassword = try container.decode(String.self, forKey: .confirmationPassword)
        socialNumber = try container.decode(Int.self, forKey: .socialNumber)
        address = try container.decode([Address].self, forKey: .address)
//        let address = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .address)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(birthDay, forKey: .birthDay)
        try container.encode(age, forKey: .age)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(emailAddr, forKey: .emailAddr)
        try container.encode(password, forKey: .password)
        try container.encode(confirmationPassword, forKey: .confirmationPassword)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(socialNumber, forKey: .socialNumber)
        try container.encode(address, forKey: .address) //-----
    }

    func checkPasswd(p1: String, p2: String) -> Bool {
        if (p1 != p2) {
            print("Error: password not the same.")
            return false
        }
        return true
    }

}

class Connexion: Codable, ObservableObject {
    enum CodingKeys: String, CodingKey {
        case email, password, _id, token, tokens
    }

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var token: String = ""
    @Published var _id: String = ""
    
    var checkEmpty: Bool {
        if (email.isEmpty || password.isEmpty) {
            return false
        }
        return true
    }
    
    init() {    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        let tokens = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tokens)
        token = try tokens.decode(String.self, forKey: .token)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
}


class UserSettings: Codable, ObservableObject {
    enum CodingKeys: String, CodingKey {
        case email, password, token
    }

    @Published var loogedIn: Bool = false
    @Published var signIn: Bool = false
    @Published var isDoctor: Bool = false
    @Published var isPatient: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    var token: String?
    
    var checkEmpty: Bool {
        if (email.isEmpty || password.isEmpty) {
            return false
        }
        return true
    }
    
    var checkEmail: Bool {
        if (!email.isValidEmail) {
            return false
        }
        return true
    }

    var checkPasswd: Bool {
        if (!password.isValidPasswd) {
            return false
        }
        return true
    }

    init() {    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        token = try container.decode(String.self, forKey: .token)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
}


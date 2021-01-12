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
        case lastName, firstName, age, birthDay, phoneNumber, email, password, confirmationPassword, address, streetNumber, socialNumber, street, typeStreetNumber, typeStreet, zipCode, city, country, idNumber, expertiseDomain
    }

    @Published var address: [Address] = [.init()]
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var bDay = Date()
    @Published var birthDay: String = ""
    @Published var age: Int = 0
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var confirmationPassword: String = ""

    static let typeStreetNbr = ["", "bis", "ter"]
    @Published var indexStreetNbr = 0

    static let typeStrt = ["rue", "boulevard", "avenue", "chemin"]
    @Published var indexStreet = 0
    
    @Published var socialNumber: Int = 0
    
    @Published var zipCode_tmp: String = ""
    @Published var streetNumber_tmp: String = ""
    @Published var street_tmp: String = ""
    @Published var city_tmp: String = ""
    @Published var country_tmp: String = ""
    @Published var scialNbr_tmp: String = ""
    @Published var idNumber_tmp: String = ""


    @Published var idNumber: Int = 0
    @Published var expertiseDomain: String = ""

    var isValid: Bool  {
        if (firstName.isEmpty || lastName.isEmpty || age > 17 || email.isEmpty || password.isEmpty || confirmationPassword.isEmpty) {
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
        birthDay = try container.decode(String.self, forKey: .birthDay)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        confirmationPassword = try container.decode(String.self, forKey: .confirmationPassword)
        idNumber = try container.decode(Int.self, forKey: .idNumber)
        expertiseDomain = try container.decode(String.self, forKey: .expertiseDomain)
        address = try container.decode([Address].self, forKey: .address)
        socialNumber = try container.decode(Int.self, forKey: .socialNumber)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(age, forKey: .age)
        try container.encode(birthDay, forKey: .birthDay)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(confirmationPassword, forKey: .confirmationPassword)
        try container.encode(idNumber, forKey: .idNumber)
        try container.encode(expertiseDomain, forKey: .expertiseDomain)
        try container.encode(address, forKey: .address)
        try container.encode(socialNumber, forKey: .socialNumber)
    }
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

    @Published var address: [Address] = [.init()]
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
    
    @Published var socialNumber: Int = 0
    
    @Published var zipCode_tmp: String = ""
    @Published var streetNumber_tmp: String = ""
    @Published var street_tmp: String = ""
    @Published var city_tmp: String = ""
    @Published var country_tmp: String = ""
    @Published var scialNbr_tmp: String = ""

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
        try container.encode(address, forKey: .address)
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
        case email, password, id, token, sessionID
    }
//    @Published var token: [Token] = [.init()]
//    @Published var sessionID: [SessionID] = [.init()]

    @Published var token: String = ""
    @Published var sessionID: String = ""
    @Published var id: String = ""
    
    @Published var email: String = ""
    @Published var password: String = ""

    init() {    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        sessionID = try container.decode([SessionID].self, forKey: .sessionID)
//        token = try container.decode([Token].self, forKey: .token)
        sessionID = try container.decode(String.self, forKey: .sessionID)
        token = try container.decode(String.self, forKey: .token)
        id = try container.decode(String.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }

    var checkEmpty: Bool {
        if (email.isEmpty || password.isEmpty) {
            return false
        }
        return true
    }
}

class Token: ObservableObject, Codable {
    enum CodingKeys : String, CodingKey {
        case token
    }
    @Published var token: String = ""

    init() {    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
    }
}

class SessionID: ObservableObject, Codable {
    enum CodingKeys : String, CodingKey {
        case sessionID, _id = "id"
    }
    @Published var sessionID: String = ""
    @Published var _id: String = ""

    init() {    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionID = try container.decode(String.self, forKey: .sessionID)
        _id = try container.decode(String.self, forKey: ._id)

    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionID, forKey: .sessionID)
        try container.encode(_id, forKey: ._id)

    }
}

class Deconnexion: ObservableObject, Encodable {
    var token = [Token]()
    var _id: String = ""
    var sessionID: String = ""
    
    enum CodingKeys : String, CodingKey {
        case _id = "id", token, sessionID
    }

    init() {    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        sessionID = try container.decode(String.self, forKey: .sessionID)
        token = try container.decode([Token].self, forKey: .token)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(sessionID, forKey: .sessionID)
        try container.encode(token, forKey: .token)
    }

}


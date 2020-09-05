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
        case lastName, firstName, age, phoneNumber, birthday,  email, password, address, idNumber, expertiseDomain
    }

    struct Address: Codable {
        var streetNumber: Int = 0
//        enum typeStreetNumber: String, CaseIterable {
//            case NO = ""
//            case bis = "bis"
//            case ter = "ter"
//        }
        var street: String = ""
//        enum typeStreet: String, CaseIterable {
//            case rue = "rue"
//            case boulevard = "boulevard"
//            case avenue = "avenue"
//            case chemin = "chemin"
//        }
        static let typeStreetNumber = ["", "bis", "ter"]
//        var indexStreetNbr = 0
        static let typeStreet = ["rue", "boulevard", "avenue", "chemin"]
//        var indexStreet = 0

        var zipCode: Int = 0
        var city: String = ""
        var country: String = ""
    }

    static let genders = ["Male", "Female"]
    @Published var indexGender = 0
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: Int = 0
    @Published var birthday: Date = Date()
    @Published var phoneNumber: String = ""

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmationPassword: String = ""

    @Published var address: Address?

    @Published var streetNumber: Int = 0
    static let typeStreetNumber = ["", "bis", "ter"]
    @Published var indexStreetNbr = 0
    static let typeStreet = ["rue", "boulevard", "avenue", "chemin"]
    @Published var indexStreet = 0
    @Published var zipCode: Int = 0
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var street: String = ""

    @Published var idNumber: String = ""
    @Published var expertiseDomain: String = ""

    var isValid: Bool  {
        if (firstName.isEmpty || lastName.isEmpty || age >= 18 || email.isEmpty || password.isEmpty || confirmationPassword.isEmpty || address!.street.isEmpty || address!.zipCode > 1000 || address!.city.isEmpty || idNumber.isEmpty) {
            return false
        }
        return true
    }

    init() {    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try container.decode(String.self, forKey: .lastName)
        firstName = try container.decode(String.self, forKey: .firstName)
        age = try container.decode(Int.self, forKey: .age)
        birthday = try container.decode(Date.self, forKey: .birthday)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        address = try container.decode(Address.self, forKey: .address)
        idNumber = try container.decode(String.self, forKey: .idNumber)
        expertiseDomain = try container.decode(String.self, forKey: .expertiseDomain)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(age, forKey: .age)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(address, forKey: .address)
        try container.encode(idNumber, forKey: .idNumber)
        try container.encode(expertiseDomain, forKey: .expertiseDomain)
    }
//    func update() {
//        objectWillChange.send()
//    }

}

class NewPatient: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case emailAddr, password
    }

    static let genders = ["Male", "Female"]
    @Published var indexGender = 0
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: String = ""
    @Published var birthday = Date()
    @Published var phoneNumber: String = ""

    @Published var emailAddr: String = ""
    @Published var password: String = ""
    @Published var confirmationPassword: String = ""

    @Published var streetNumber: Int = 0
    @Published var doctor: String = ""
    @Published var street: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    @Published var securityNbr: Int?

    var isValid: Bool  {
        if (firstName.isEmpty || lastName.isEmpty || age.isEmpty || emailAddr.isEmpty || password.isEmpty || confirmationPassword.isEmpty || phoneNumber.isEmpty || street.isEmpty || zipCode.isEmpty || city.isEmpty || country.isEmpty || securityNbr != 150000000000000) {
            return false
        }
        return true
    }

    init() {    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        firstName = try container.decode(String.self, forKey: .firstName)
//        lastName = try container.decode(String.self, forKey: .lastName)
//        age = try container.decode(String.self, forKey: .age)
//        birthday = try container.decode(Date.self, forKey: .birthday)
//        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        emailAddr = try container.decode(String.self, forKey: .emailAddr)
        password = try container.decode(String.self, forKey: .password)
//        securityNbr = try container.decode(Int.self, forKey: .securityNbr)
//        doctor = try container.decode(String.self, forKey: .doctor)
//        streetNumber = try container.decode(Int.self, forKey: .streetNumber)
//        street = try container.decode(String.self, forKey: .street)
//        zipCode = try container.decode(String.self, forKey: .zipCode)
//        city = try container.decode(String.self, forKey: .city)
//        country = try container.decode(String.self, forKey: .country)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(firstName, forKey: .firstName)
//        try container.encode(lastName, forKey: .lastName)
//        try container.encode(age, forKey: .age)
//        try container.encode(birthday, forKey: .birthday)
//        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(emailAddr, forKey: .emailAddr)
        try container.encode(password, forKey: .password)
//        try container.encode(phoneNumber, forKey: .phoneNumber)
//        try container.encode(securityNbr, forKey: .securityNbr)
//        try container.encode(doctor, forKey: .doctor)
//        try container.encode(streetNumber, forKey: .streetNumber)
//        try container.encode(street, forKey: .street)
//        try container.encode(zipCode, forKey: .zipCode)
//        try container.encode(city, forKey: .city)
//        try container.encode(country, forKey: .country)
    }

    func checkPasswd(p1: String, p2: String) -> Bool {
        if (p1 != p2) {
            print("Error: password not the same.")
            return false
        }
        return true
    }

//    func update() {
//        objectWillChange.send()
//    }
}

struct Connexion {
    //String url = getResources().getString(R.string.connection);
    private let url: String = ""

    func checkConnxion(id: String, pass: String) -> Bool {
        

        return false
    }

//    private func loadJson(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
//        if let url = URL(string: urlString) {
//            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    completion(.failure(error))
//                }
//
//                if let data = data {
//                    completion(.success(data))
//                }
//            }
//
//            urlSession.resume()
//        }
//    }


}

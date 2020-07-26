//
//  DBConnexion.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 08/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import Foundation

class NewMed: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, age, birthday, phoneNbr, emailAddr, passwd, streetName, zipCode, city, medicalID, expMedicale
    }

    static let genders = ["Male", "Female"]
    @Published var indexGender = 0
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: String = ""
    @Published var birthday = Date()
    @Published var phoneNbr: String = ""

    @Published var emailAddr: String = ""
    @Published var passwd: String = ""
    @Published var passwd2: String = ""
    @Published var streetName: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""
    @Published var medicalID: String = ""
    @Published var expMedicale: String = ""

    var alertIsVisible: Bool = false

    var isValid: Bool  {
        if (firstName.isEmpty || lastName.isEmpty || age.isEmpty || emailAddr.isEmpty || passwd.isEmpty || passwd2.isEmpty || streetName.isEmpty || zipCode.isEmpty || city.isEmpty || expMedicale.isEmpty) {
            return false
        }
        return true
    }

    init() {    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        age = try container.decode(String.self, forKey: .age)
        birthday = try container.decode(Date.self, forKey: .birthday)
        phoneNbr = try container.decode(String.self, forKey: .phoneNbr)
        emailAddr = try container.decode(String.self, forKey: .emailAddr)
        passwd = try container.decode(String.self, forKey: .passwd)
        streetName = try container.decode(String.self, forKey: .streetName)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        city = try container.decode(String.self, forKey: .city)
        medicalID = try container.decode(String.self, forKey: .medicalID)
        expMedicale = try container.decode(String.self, forKey: .expMedicale)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(age, forKey: .age)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(phoneNbr, forKey: .phoneNbr)
        try container.encode(emailAddr, forKey: .emailAddr)
        try container.encode(passwd, forKey: .passwd)
        try container.encode(streetName, forKey: .streetName)
        try container.encode(zipCode, forKey: .zipCode)
        try container.encode(city, forKey: .city)
        try container.encode(medicalID, forKey: .medicalID)
        try container.encode(expMedicale, forKey: .expMedicale)
    }
//    func update() {
//        objectWillChange.send()
//    }

}

class NewPatient: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, age, birthday, phoneNbr, emailAddr, passwd, streetName, zipCode, city, securityNbr, doctor
    }

    static let genders = ["Male", "Female"]
    @Published var indexGender = 0
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: String = ""
    @Published var birthday = Date()
    @Published var phoneNbr: String = ""

    @Published var emailAddr: String = ""
    @Published var passwd: String = ""
    @Published var passwd2: String = ""

    @Published var securityNbr: String = ""
    @Published var doctor: String = ""
    @Published var streetName: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""

    var alertIsVisible: Bool = false

    var isValid: Bool  {
        if (firstName.isEmpty || lastName.isEmpty || age.isEmpty || emailAddr.isEmpty || passwd.isEmpty || passwd2.isEmpty || streetName.isEmpty || zipCode.isEmpty || city.isEmpty || securityNbr.isEmpty/* != 150000000000000*/) {
            return false
        }
        return true
    }

    init() {    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        age = try container.decode(String.self, forKey: .age)
        birthday = try container.decode(Date.self, forKey: .birthday)
        phoneNbr = try container.decode(String.self, forKey: .phoneNbr)
        emailAddr = try container.decode(String.self, forKey: .emailAddr)
        passwd = try container.decode(String.self, forKey: .passwd)
        securityNbr = try container.decode(String.self, forKey: .securityNbr)
        doctor = try container.decode(String.self, forKey: .doctor)
        streetName = try container.decode(String.self, forKey: .streetName)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        city = try container.decode(String.self, forKey: .city)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(age, forKey: .age)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(phoneNbr, forKey: .phoneNbr)
        try container.encode(emailAddr, forKey: .emailAddr)
        try container.encode(passwd, forKey: .passwd)
        try container.encode(securityNbr, forKey: .securityNbr)
        try container.encode(doctor, forKey: .doctor)
        try container.encode(streetName, forKey: .streetName)
        try container.encode(zipCode, forKey: .zipCode)
        try container.encode(city, forKey: .city)
    }

    func checkPasswd(p1: String, p2: String) -> String {
        let errorPwd = "Error: password not the same."
        if (p1 == p2) {
            return p1
        }
        return errorPwd
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

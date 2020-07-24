//
//  SignUp.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 06/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import Combine
import SwiftUI

// All modifier are in Styles.swift

class Gender: ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    static let genderOptions = ["Male", "Female"]
    var index = 0 { didSet { update() } }
    
    func update() {
        didChange.send()
        
    }
    
}

struct SignUp: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var age: String = ""
    @State var birthday = Date()
    @ObservedObject var gender = Gender()
    @State var genderOptions = ["Male", "Female"]
    @State var selectedGenderIndex: Int = 0
    
    @State var emailAddr: String = ""
    @State var passwd: String = ""
    @State var passwd2: String = ""
    @State var streetName: String = ""
    @State var streetName2: String = ""
    @State var zipCode: String = ""
    @State var city: String = ""
    @State var medicalID: String = ""
    @State var expMedicale: String = ""

    //debug purpose
    @State var alertIsVisible: Bool = false

    var body: some View {
//        NavigationView {
            VStack {
    //            Spacer()
                Form {
                    Section {
                        TextField("First Name", text: $firstName)
                            .modifier(FormTextFieldStyle())
                        TextField("Last Name", text: $lastName)
                            .modifier(FormTextFieldStyle())
                        TextField("Your age", text: $age)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.numberPad)
                        DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date) {
                            Text("Birthday date")
                                .modifier(FormStyle())
                        }
//                        Picker(selection: $gender.genderOptions, label: Text("Gender")) {
//                            ForEach(0 ..< Gender.index.count) {
//                                Text(Gender.genderOptions[$0].tag[$0])
//                                    .font(.custom("Raleway", size: 16))
//                            }
//                        }
                        Picker("Gender", selection: $selectedGenderIndex) {
                            ForEach(0..<genderOptions.count) {
                                Text(self.genderOptions[$0])
                                    .font(.custom("Raleway", size: 16))
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    Section {
                        TextField("Email Address", text: $emailAddr)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.emailAddress)
                        SecureField("Password", text: $passwd)
                            .modifier(FormTextFieldStyle())
                        SecureField("Confirm password", text: $passwd2)
                            .modifier(FormTextFieldStyle())
                    }
                    Section {
                        VStack{
                            TextField("Street name", text: $streetName)
                                .modifier(FormAddressStyle())
                            TextField("Street name", text: $streetName2)
                                .modifier(FormAddressStyle())
                            HStack {
                                TextField("Post code", text: $zipCode)
                                   .font(.custom("Raleway", size: 16))
                                   .frame(width: 100.0, height: 30)
                                   .keyboardType(.numberPad)
                                Text(" | ")
                                    .font(.custom("Raleway", size: 18))
                                    .foregroundColor(Color.black)
                                TextField("City", text: $city)
                                    .font(.custom("Raleway", size: 16))
                                    .frame(height: 30)
                            }
                        }
                    }
                    Section {
                        TextField("Medical ID", text: $medicalID)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.numberPad)
                        TextField("Medical speciality", text: $expMedicale)
                            .modifier(FormTextFieldStyle())
                    }
                    Section {
                        Button(action: {
                            print("Button Action")
                            self.alertIsVisible = true
                        }) {
                            Text("Submit")
                                .modifier(ButtonStyle())
                        }
                        .alert(isPresented: $alertIsVisible) { () ->
                            Alert in
                            return Alert(title: Text("DEBUG"), message: Text("\(self.firstName)\n\(self.lastName)\n\(self.age)\n\(self.birthday)\n\(self.selectedGenderIndex)\n\(self.emailAddr)\n\(self.streetName) \(self.streetName2)\n\(self.zipCode)\n\(self.city)\n\(self.medicalID)\n\(self.expMedicale)"), dismissButton: .default(Text("ok")))
                        }
                            
                    }

            }
        }//end first VStack
//        }
//            .navigationBarTitle("Personnal information").modifier(ColourStyle())
    }
    
}

//struct CreateJson: Codable {
//        
//    private func postJson() {
//        let jsonData = jsonString.data(encoding: .utf8)!
//        let decoder = JSONDecoder()
//        let person = try! decoder.decode(CreateJson.self, for: jsonData)
//    }
//}


struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

//
//  Inscrption.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 11/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI


struct SignUpMed: View {
    @ObservedObject var med: NewMed
    
    @State var confirmation: String = ""
    @State var showConfirmation: Bool = false
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }

    var currentAge: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let birthdate = calendar.startOfDay(for: med.birthday)
        let components = calendar.dateComponents([.year], from: birthdate, to: today)
        return components.year ?? 0
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Fisrt name", text: $med.firstName)
                        .modifier(FormTextFieldStyle())
                    TextField("Last Name", text: $med.lastName)
                        .modifier(FormTextFieldStyle())
                    DatePicker(selection: $med.birthday, in: ...Date(), displayedComponents: .date) {
                        Text("Birthday date")
                            .modifier(FormStyle())
                    }
                    Text("\(currentAge)")
                        .multilineTextAlignment(.center)
                        .modifier(FormStyle())
//                    Picker("Gender", selection: $med.indexGender) {
//                        ForEach(0 ..< NewMed.genders.count) {
//                                Text(NewMed.genders[$0])
//                                    .font(.custom("Raleway", size: 16))
//                            }
//                    }.pickerStyle(SegmentedPickerStyle())
                    TextField("Phone number", text: $med.phoneNumber)
                        .modifier(FormTextFieldStyle())
                        .keyboardType(.numberPad)
                } // end of first section
                
                Section {
                    TextField("E-mail", text: $med.email)
                        .keyboardType(.emailAddress)
                        .modifier(FormTextFieldStyle())
                    SecureField("Password", text: $med.password)
                         .modifier(FormTextFieldStyle())
                    SecureField("Confirm password", text: $med.confirmationPassword)
                         .modifier(FormTextFieldStyle())
                }

                Section {
                    HStack {
                        TextField("Building number", value: $med.streetNumber, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                        .modifier(FormTextFieldStyle())
//                        IndexSteetNbr(med: NewMed())
                        Picker("Number ext.", selection: $med.indexStreetNbr) {
                            ForEach (0 ..< NewMed.typeStreetNbr.count) {
                                Text(NewMed.typeStreetNbr[$0])
                            }
                        }
                    }
                    HStack {
                        Picker("Street desc.", selection: $med.indexStreet) {
                            ForEach (0 ..< NewMed.typeStrt.count) {
                                Text(NewMed.typeStrt[$0])
//                                NewMed.typeStreet = NewMed.typeStreet[$0]
                            }
                        }
                        .navigationBarBackButtonHidden(true) //enlever le bouton retour. mais jusqu'où ça marche ?
//                        IndexSteet(med: NewMed())
                        TextField("Street name", text: $med.street)
                            .modifier(FormAddressStyle())
                    }
                    HStack {
                        TextField("Post code", value: $med.zipCode, formatter: NumberFormatter())
                           .font(.custom("Raleway", size: 16))
                           .frame(width: 100.0, height: 30)
                           .keyboardType(.numberPad)
                        Text(" | ")
                            .font(.custom("Raleway", size: 18))
                            .foregroundColor(Color.black)
                        TextField("City", text: $med.city)
                            .font(.custom("Raleway", size: 16))
                            .frame(height: 30)
                    }
                    TextField("Country", text: $med.country)
                        .modifier(FormAddressStyle())
                }

                Section {
                    TextField("Medical ID", text: $med.idNumber)
                        .modifier(FormTextFieldStyle())
                        .keyboardType(.numberPad)
                    TextField("Medical speciality", text: $med.expertiseDomain)
                        .modifier(FormTextFieldStyle())
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Med sign up button pressed")
                            self.sendNewMed()
                        }) {
                            Text("Submit")
                                .modifier(ButtonStyle())
                        }
                        Spacer()
                    }

                }.disabled(!med.isValid)
            }
        }
            .navigationBarTitle("Doc's personnal info", displayMode: .inline)
//            .padding(.top, 20)
//            .alert(isPresented: $showConfirmation){
//            Alert(title: Text("Welocme"), message: Text(confirmation), dismissButton: .default(Text("Dismiss")))
//        }
        
    }
    
    func sendNewMed() {
        med.age = currentAge
//        print("""
//            -----------------------------------------
//            Printing JSON:
//            lastName: \(med.lastName)
//            firstName: \(med.firstName)
//            birthday: \(med.birthday)
//            age: \(med.age)
//            phoneNbr: \(med.phoneNumber)
//            email: \(med.email)
//            password: \(med.password)
//            confirpwd: \(med.confirmationPassword)
//            expDomain: \(med.expertiseDomain)
//            idNumber: \(med.idNumber)
//            -----
//            Address :
//            streetNumber: \(med.streetNumber)
//            typeStreetNumber: \(med.typeStreetNumber)
//            typeStreet: \(med.typeStreet)
//            street: \(med.street)
//            zipCode: \(med.zipCode)
//            city: \(med.city)
//            country \(med.country)
//
//            ----------------------------------------
//            END FIRST PART OF JSON
//            """)
        guard let encoded = try? JSONEncoder().encode(med) else {
            print("Fail to encode newMed")
            return
        }
        let url = URL(string: "https://healthsafe-api-beta.herokuapp.com/api/drProfile/create")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        print(String(data: encoded, encoding: .utf8)!)

        URLSession.shared.dataTask(with: request) {
            guard let data = $0 else {
                print("No data in response: \($2?.localizedDescription ?? "Unkwnon Error").")
                return
            }
            if let decoder = try? JSONDecoder().decode(NewMed.self, from: data) {
                self.confirmation = "Sign up completed !\nWelcome \(decoder.firstName)"
                self.showConfirmation = true
            } else {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Invalid response \(dataString)")
            }

        }.resume()
    }
}

struct IndexSteet: View {
    @State var expand: Bool = false
    @ObservedObject var med: NewMed


    var body: some View {
        VStack{
            HStack {
                Text("Extension")
                Image(systemName: expand ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: 13, height: 6)
            }.onTapGesture(perform: {
                self.expand.toggle()
            })
            if expand {
                Button(action: {
                    print("chemain")
//                    med.typeStreet = "chemin"
                    self.expand.toggle()
                }) {
                    Text("Chemin")
                }
                Button(action: {
                    print("rue")
//                    med.typeStreet = "rue"
                    self.expand.toggle()
                }) {
                    Text("Rue")
                }
                Button(action: {
                    print("avenue")
//                    med.typeStreet = "avenue"
                    self.expand.toggle()
                }) {
                    Text("Avenue")
                }
                Button(action: {
                    print("boulevard")
//                    med.typeStreet = "boulevard"
                    self.expand.toggle()
                }) {
                    Text("Boulevard")
                }
            }
        }
    }
}

struct IndexSteetNbr: View {
    @State var expand: Bool = false
    @ObservedObject var med: NewMed


    var body: some View {
        VStack{
            HStack {
                Text("Extension")
                Image(systemName: expand ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: 13, height: 6)
            }.onTapGesture(perform: {
                self.expand.toggle()
            })
            if expand {
                Button(action: {
                    print("N/A")
//                    med.typeStreetNumber = ""
                    self.expand.toggle()
                }) {
                    Text(" ")
                }
                Button(action: {
                    print("bis")
//                    med.typeStreetNumber = "bis"
                    self.expand.toggle()
                }) {
                    Text("Bis")
                }
                Button(action: {
                    print("ter")
//                    med.typeStreetNumber = "ter"
                    self.expand.toggle()
                }) {
                    Text("ter")
                }
            }
        }
    }
}

struct Inscrption_Previews: PreviewProvider {
    static var previews: some View {
        SignUpMed(med: NewMed())
    }
}

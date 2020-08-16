//
//  ContentView.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 05/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

// All modifier are in Styles.swift

struct LoginFormView : View {

    @State private var userName: String = ""
    @State private var passwd: String = ""

    @State private var showError = false

    @Binding var signInSuccess: Bool

    var body: some View {
        VStack {
            Image("Logo_healthsafe")
            Spacer()
                .frame(height: 75.0)
            VStack (alignment: .leading){
                Text("Welcome to Healthsafe")
                    .font(.title)
                    .modifier(LabelStyle())
            }
            .padding()
            Spacer()
                .frame(height: 75.0)
            VStack {
                TextField("ID", text: $userName)
                    .modifier(LabelStyle())

                Spacer()
                    .frame(height: 30.0)
                SecureField("PASSWORD", text: $passwd)
                    .modifier(LabelStyle())
            }
            Spacer()
                .frame(height: 50.0)

//            HStack {
//                Text(" Password")
//                TextField("type here", text: $password)
//                    .textContentType(.password)
//            }.padding()

            if showError {
                Text("Incorrect username/password").foregroundColor(Color.red)
            }
            VStack {
                Button(action: {
                    // Your auth logic
                    if(self.userName == self.passwd) {
                        self.signInSuccess = true
                    }
                    else {
                        self.showError = true
                    }

                }) {
                    Text("Connexion")
                        .modifier(ButtonStyle())
                }
                Spacer()
                    .frame(height: 25)
                NavigationLink(destination: PreSignUp()) {
                    Text("Inscription")
                        .modifier(ButtonStyle())
                }
            }

        }
    }
}

struct ContentView: View {
    
    @State var signInSuccess = false

    var body: some View {
        return Group {
            if signInSuccess {
                Home()
            }
            else {
                LoginFormView(signInSuccess: $signInSuccess)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

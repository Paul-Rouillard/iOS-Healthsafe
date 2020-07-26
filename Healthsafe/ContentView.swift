//
//  ContentView.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 05/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

// All modifier are in Styles.swift

struct ContentView: View {
    @State var IdConnexion: String = ""
    @State var Passwd: String = ""
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
                TextField("ID", text: $IdConnexion)
                    .modifier(LabelStyle())

                Spacer()
                    .frame(height: 30.0)
                SecureField("PASSWORD", text: $Passwd)
                    .modifier(LabelStyle())
            }
            Spacer()
                .frame(height: 75.0)

            VStack {
                NavigationLink(destination: Home()){
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
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

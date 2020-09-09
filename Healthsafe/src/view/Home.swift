//
//  Home.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 06/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct Home: View {
    @State var data: String = ""
   
    var body: some View {
//        let name: String = "Paul"
        Group {
            VStack {
                Button(action: {
                    print("--------------\nlogging out...\n--------------")
                    self.Deconnexion()
                }
                ) {
                    Text("Log out")
                        .frame(width: 325, alignment: .topLeading)
                        .modifier(LabelStyle())
                }.onTapGesture(perform: {
                    ContentView()
                })
                Spacer()
                Text("NFC").font(.largeTitle).modifier(LabelStyle())
                Spacer()
                    .frame(width: 50, height: 50)
    //            Text("Welcome \(name)").modifier(LabelStyle())
                Text("Please select your plateform").modifier(LabelStyle())
                Spacer()
                HStack {
                    Image("logo_tel")
                    Image("pc_bureau")
                }
                Text(data).background(Color.red)
                nfcButton(data: self.$data)
                    .frame(width: 75.0, height: 20.0)
                    .modifier(ButtonStyle())
                Spacer()
            }
        }
    }
    
    func Deconnexion() {
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

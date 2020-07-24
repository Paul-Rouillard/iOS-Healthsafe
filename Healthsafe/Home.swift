//
//  Home.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 06/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct Home: View {
    var body: some View {
//        let name: String = "Paul"
        VStack {
            Spacer()
            Text("NFC").font(.largeTitle).modifier(LabelStyle())
            Spacer()
//            Text("Welcome \(name)").modifier(LabelStyle())
            Text("Please select your plateform").modifier(LabelStyle())
            Spacer()
            HStack {
                Image("logo_tel")
                Image("pc_bureau")
            }
            Spacer()
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

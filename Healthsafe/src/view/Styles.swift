//
//  Styles.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 08/07/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import SwiftUI

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .modifier(ColourStyle())
            .font(.custom("Raleway", size: 18))
            .multilineTextAlignment(.center)
            .frame(width: 300.0)
    }
}

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(width: 250, height: 30, alignment: .center)
            .font(.custom("Raleway", size: 25))
            .padding()
            .foregroundColor(Color.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.init(red: 255/255, green: 28/255, blue: 78/255), Color.init(red: 255/255, green: 137/255, blue: 133/255)]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(50.0)
    }
}

struct ButtonStyleSecondary: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(width: 250, height: 30, alignment: .center)
            .font(.custom("Raleway", size: 25))
            .padding()
            .modifier(ColourStyle())
            .overlay(RoundedRectangle(cornerRadius: 50.0)
                        .stroke(Color.init(red: 255/255, green: 88/255, blue: 108/255))
            )
    }
}
struct ButtonFormStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(width: 150, height: 20, alignment: .center)
            .font(.custom("Raleway", size: 18))
            .padding()
            .foregroundColor(Color.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.init(red: 255/255, green: 28/255, blue: 78/255), Color.init(red: 255/255, green: 137/255, blue: 133/255)]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(50.0)
    }
}
struct ButtonFormStyleSecondary: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(width: 150, height: 20, alignment: .center)
            .font(.custom("Raleway", size: 18))
            .padding()
            .modifier(ColourStyle())
            .overlay(RoundedRectangle(cornerRadius: 50.0)
                        .stroke(Color.init(red: 255/255, green: 88/255, blue: 108/255))
            )
    }
}

struct FormStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .modifier(ColourStyle())
            .modifier(FontStyle())
    }
}

struct FormTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .multilineTextAlignment(.center)
            .font(.custom("Raleway", size: 16))
    }
}
struct FormAddressStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .multilineTextAlignment(.center)
            .font(.custom("Raleway", size: 16))
            .frame(height: 30)
    }
}

struct FontStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.custom("Raleway", size: 18))
    }
}

struct ColourStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.init(red: 255/255, green: 137/255, blue: 133/255))
    }
}


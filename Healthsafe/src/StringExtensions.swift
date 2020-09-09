//
//  StringExtensions.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 09/09/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regex)

        return testEmail.evaluate(with: self)
    }

    var isValidPasswd: Bool {
        let regex = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        let testPasswd = NSPredicate(format: "SELF MATCHES %@", regex)

        return testPasswd.evaluate(with: self)
    }
}

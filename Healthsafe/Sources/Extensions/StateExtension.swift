//
//  StateExtension.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 02/01/2021.
//  Copyright © 2021 Healthsafe. All rights reserved.
//

import Foundation
import SwiftUI

extension State
where Value == Dictionary<String, String> {
    /// Returns Binding for non-Optional
    func binding(_ key: String) -> Binding<String> {
        return Binding<String>(
            get: {self.wrappedValue[key] ?? ""},
            set: {self.wrappedValue[key] = $0}
        )
    }
}

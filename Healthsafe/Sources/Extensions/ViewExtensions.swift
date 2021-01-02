//
//  ViewExtensions.swift
//  Healthsafe
//
//  Created by Paul Rouillard on 02/11/2020.
//  Copyright © 2020 Healthsafe. All rights reserved.
//

import Foundation
import SwiftUI

struct VisibilityStyle: ViewModifier {
   
   @Binding var hidden: Bool
   func body(content: Content) -> some View {
      Group {
         if !hidden {
            content.hidden()
         } else {
            content
         }
      }
   }
}

extension View {
   func visibility(hidden: Binding<Bool>) -> some View {
      modifier(VisibilityStyle(hidden: hidden))
   }
}

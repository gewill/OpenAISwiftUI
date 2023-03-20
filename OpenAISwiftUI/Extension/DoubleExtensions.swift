//
//  DoubleExtensions.swift
//  OpenAISwiftUI
//
//  Created by will on 20/03/2023.
//

import Foundation

let oneDigitsFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  formatter.maximumFractionDigits = 1
  formatter.usesGroupingSeparator = false
  return formatter
}()

extension Double {
  var oneDigitsFormat: String {
    oneDigitsFormatter.string(from: NSNumber(value: self)) ?? description
  }
}

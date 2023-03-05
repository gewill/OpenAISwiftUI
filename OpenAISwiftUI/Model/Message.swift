//
//  Message.swift
//  OpenAISwiftUI
//
//  Created by will on 05/03/2023.
//

import Foundation
import SwiftUI

struct Message: Identifiable {
  enum Role: String {
    case user, system
  }

  let id: UUID = .init()
  let role: Role
  var text: String

  var isInteracting: Bool
  var errorText: String
}

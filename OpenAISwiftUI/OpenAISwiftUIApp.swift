//
//  OpenAISwiftUIApp.swift
//  OpenAISwiftUI
//
//  Created by will on 02/03/2023.
//

import Glassfy
import SwiftUI

@main
struct OpenAISwiftUIApp: App {
  init() {
    IAPManager.shared.configure()
  }

  var body: some Scene {
    WindowGroup {
      ChatView()
    }
  }
}

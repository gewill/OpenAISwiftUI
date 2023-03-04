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
  @AppStorage("hasApiKey") var hasApiKey: Bool = false

  init() {
    Glassfy.initialize(apiKey: "90074cc3c28947d3a5c89fada49c4316", watcherMode: false)
  }

  var body: some Scene {
    WindowGroup {
      if hasApiKey {
        ChatView()
      } else {
        SetupView()
      }
    }
  }
}

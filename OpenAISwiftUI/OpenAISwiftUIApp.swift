//
//  OpenAISwiftUIApp.swift
//  OpenAISwiftUI
//
//  Created by will on 02/03/2023.
//

import SwiftUI

@main
struct OpenAISwiftUIApp: App {
  @AppStorage("hasApiKey") var hasApiKey: Bool = false

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

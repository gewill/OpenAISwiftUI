//
//  SetupView.swift
//  OpenAISwiftUI
//
//  Created by will on 05/03/2023.
//

import SwiftUI

struct SetupView: View {
  @AppStorage("apiKey") var apiKey: String = ""
  @AppStorage("hasApiKey") var hasApiKey: Bool = false

  var body: some View {
    VStack(alignment: .leading, spacing: 20.0) {
      Text("Hi, there").font(.title)
      Text("To proceed, an active OpenAI account is required.").font(.headline)
      Divider()

      Text("Follow these steps:")
      Text("1. Visit ")
      Link(destination: URL(string: "https://platform.openai.com/account/api-keys")!) {
        Text("https://platform.openai.com/account/api-keys")
      }
      Text("2. Click \"Create new secret key\" button")
      Text("3. Copy and paste the generated API key.")

      HStack {
        TextField("API key", text: $apiKey)
          .textFieldStyle(.roundedBorder)
        Button {
          if let string = getClipboardString(),
             string.isEmpty == false
          {
            apiKey = string
          }
        } label: {
          Image(systemName: "doc.on.clipboard")
        }
        .buttonStyle(.borderedProminent)
      }

      HStack {
        Spacer()
        Button {
          if apiKey.isEmpty == false {
            hasApiKey = true
          }
        } label: {
          Text("Submit")
            .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        Spacer()
      }
    }
    .padding()
  }
}

struct SetupView_Previews: PreviewProvider {
  static var previews: some View {
    SetupView()
  }
}

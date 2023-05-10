//
//  SetupView.swift
//  OpenAISwiftUI
//
//  Created by will on 05/03/2023.
//

import SwiftUI

struct SetupView: View {
  @Binding var isPresented: Bool
  @AppStorage("apiKey") var apiKey: String = ""

  var body: some View {
    VStack(alignment: .leading, spacing: 20.0) {
      HStack {
        Spacer()
        Button {
          isPresented.toggle()
        } label: {
          Image(systemName: "xmark")
        }
        .buttonStyle(.borderedProminent)
        .keyboardShortcut("w")
      }

      Text("Hi, there").font(.title)
      Text("Welcome to VoiceAI Chat")
      Text("an [open source](https://github.com/gewill/OpenAISwiftUI) chat app that uses voice to AI.")
      Divider()

      Group {
        Text("To proceed, an active OpenAI account is required.").font(.headline)
        Text("For the fee bill of OpenAI API, please refer to [https://openai.com/pricing](https://openai.com/pricing).")

        Text("Follow these steps:")
        Text("1. Visit [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys)")
        Text("2. Click \"Create new secret key\" button")
        Text("3. Copy and paste the generated \"API key\"")
      }

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
            isPresented.toggle()
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
    .tint(.accent)
  }
}

struct SetupView_Previews: PreviewProvider {
  static var previews: some View {
    SetupView(isPresented: .constant(true))
  }
}

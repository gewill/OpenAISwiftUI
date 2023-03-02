//
//  ViewModel.swift
//  AI
//
//  Created by will on 02/03/2023.
//

import ChatGPTSwift
import SwiftUI

struct Message: Identifiable {
  enum Role: String {
    case user, system
  }

  enum Status: String {
    case loading, success, error
  }

  let id: UUID = .init()
  let role: Role
  let text: String
  var status: Status
}

class ViewModel: ObservableObject {
  var openAI: ChatGPTAPI { ChatGPTAPI(apiKey: token) }
  @AppStorage("token") var token: String = ""
  @Published var prompt: String = ""
  @Published var messages: [Message] = []
  @Published var scrollId: UUID?
  @Published var isLoading: Bool = false

  let errorMessage = "\nPlease check token and network."

  func requestAI() {
    guard token.isEmpty == false else {
      showErrorMessage(text: errorMessage)
      return
    }
    guard prompt.isEmpty == false else {
      showErrorMessage(text: "Prompt can't be empty.")
      return
    }
    isLoading = true

    let prompt = self.prompt
    self.prompt = ""

    Task.detached {
      do {
        let response = try await self.openAI.sendMessage(text: prompt)
        await self.updateMessages(to: [Message(role: .system, text: response, status: .success)])
      } catch {
        await self.updateMessages(to: [Message(role: .system, text: error.localizedDescription + self.errorMessage, status: .error)])
      }
    }

    let promptMessage = Message(role: .user, text: prompt, status: .success)
    messages.append(promptMessage)
    messages.append(Message(role: .system, text: "", status: .loading))
    scrollId = promptMessage.id
  }

  @MainActor
  func updateMessages(to messages: [Message]) {
    if let last = self.messages.last,
       last.status == .loading
    {
      self.messages.removeLast()
    }
    self.messages += messages
    scrollId = messages.last?.id
    isLoading = false
  }

  func showErrorMessage(text: String) {
    let message = Message(role: .system, text: text, status: .error)
    messages.append(message)
    scrollId = message.id
  }
}

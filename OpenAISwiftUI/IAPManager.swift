import Foundation
import Glassfy
import SwiftUI

enum FreeFeature: String, CaseIterable, Identifiable {
  case chat = "Chat"
  case basicParameters = "Basic parameters settings"
  case voice = "Voice response"
  case speechRecognizer = "Speech recognizer"
  case markdown = "Markdown render"

  var image: Image {
    switch self {
    case .basicParameters: return Image(systemName: "ellipsis.circle")
    case .chat: return Image(systemName: "ellipsis.message")
    case .voice: return Image(systemName: "speaker.wave.2.circle")
    case .speechRecognizer: return Image(systemName: "mic.circle")
    case .markdown: return Image("markdown")
    }
  }

  var color: Color { Color.primary }

  var id: FreeFeature { self }
}

enum ProFeature: String, CaseIterable, Identifiable {
  case codeSyntaxHighligher = "Code syntax highligher"
  case newFeaturesInFuture = "New features in future"

  var image: Image {
    switch self {
    case .codeSyntaxHighligher: return Image(systemName: "curlybraces.square")
    case .newFeaturesInFuture: return Image(systemName: "wand.and.stars.inverse")
    }
  }

  var color: Color { Color.primary }

  var id: ProFeature { self }
}

final class IAPManager {
  enum Sku: String {
    case ios_voiceaichat_pro_lifetime_3
  }

  enum Permission: String {
    case pro_lifetime
  }

  enum Offering: String {
    case pro_lifetime
  }

  static let shared = IAPManager()

  private init() {}

  func configure() {
    Glassfy.initialize(apiKey: "90074cc3c28947d3a5c89fada49c4316")
  }

  func checkProLifetime(completion: @escaping (Bool) -> Void) {
    Glassfy.permissions { permissions, error in
      guard let permissions = permissions, error == nil else {
        completion(false)
        return
      }

      if let permission = permissions[Permission.pro_lifetime.rawValue],
         permission.isValid
      {
        completion(true)
      } else {
        completion(false)
      }
    }
  }

  func purchase(sku: Glassfy.Sku) {
    Glassfy.purchase(sku: sku) { transaction, error in
      guard let t = transaction, error == nil else {
        return
      }
    }
  }

  func getPermissions() {
    Glassfy.permissions { permissions, error in
      guard let permissions = permissions, error == nil else {
        return
      }
    }
  }

  func restorePurchases() {
    Glassfy.restorePurchases { permissions, error in
      guard let permissions = permissions, error == nil else {
        return
      }
    }
  }
}

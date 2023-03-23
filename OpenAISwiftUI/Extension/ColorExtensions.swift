import Foundation
import SwiftUI

extension Color {
  /// Fix accentColor not work on macOS
  static let accent = Color("AccentColor")
  static let separator = Color("separator")
  static let placeholderText = Color("placeholderText")
  static let systemBackground = Color("systemBackground")
}

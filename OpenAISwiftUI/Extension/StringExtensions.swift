import Foundation
import SwiftUI

extension String {
  /// SwifterSwift: String with no spaces or new lines in beginning and end.
  ///
  ///    "   hello  \n".trimmed -> "hello"
  ///
  var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var localizedStringKey: LocalizedStringKey {
    LocalizedStringKey(self)
  }
}

func copyToClipboard(text: String) {
  #if os(iOS)
  UIPasteboard.general.string = text
  #endif

  #if os(macOS)
  let pasteBoard = NSPasteboard.general
  pasteBoard.clearContents()
  pasteBoard.setString(text, forType: .string)
  #endif
}

func getClipboardString() -> String? {
  #if os(iOS)
  return UIPasteboard.general.string
  #endif

  #if os(macOS)
  let pasteBoard = NSPasteboard.general
  return pasteBoard.string(forType: .string)
  #endif
}

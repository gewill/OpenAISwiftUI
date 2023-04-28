import SwiftUI

struct CopyButton: View {
  @State private var copied: Bool = false
  var text: String
  var title: String = "Copy"

  var body: some View {
    Button(action: {
      copyToClipboard(text: text)
      copied = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        copied = false
      }
    }) {
      if copied {
        Label("Copied!", systemImage: "checkmark")
      } else {
        Label(title, systemImage: "doc.on.doc")
      }
    }
    .disabled(copied)
    .frame(height: 24)
  }
}

struct CopyButton_Previews: PreviewProvider {
  static var previews: some View {
    CopyButton(text: "Copy")
  }
}

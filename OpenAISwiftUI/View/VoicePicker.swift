//
//  VoicePicker.swift
//  OpenAISwiftUI
//
//  Created by will on 03/03/2023.
//

import AVFoundation
import SwiftUI

struct VoicePicker: View {
  let voices = AVSpeechSynthesisVoice.speechVoices()
  var languageGroups: [String: [AVSpeechSynthesisVoice]] {
    Dictionary(grouping: voices, by: { $0.language })
  }

  @Binding var selectedVoice: AVSpeechSynthesisVoice?

  var body: some View {
    Group {
      Text("Voice")
      Picker(selection: $selectedVoice, label: Text("")) {
        ForEach(languageGroups.sorted(by: { $0.key < $1.key }), id: \.key) { language, voices in
          Section(header: Text(language)) {
            ForEach(voices, id: \.identifier) { voice in
              Text(voice.name + "\(voice.gender.title)").tag(voice as AVSpeechSynthesisVoice?)
            }
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

public extension AVSpeechSynthesisVoiceGender {
  var title: String {
    switch self {
    case .male: return " - male"
    case .female: return " - female"
    default: return ""
    }
  }
}

//
//  ModelPicker.swift
//  OpenAISwiftUI
//
//  Created by will on 2024/2/1.
//

import SwiftUI

struct ModelPicker: View {
  @Binding var selectedModel: String

  var body: some View {
    Group {
      Text("Model")
      Picker(selection: $selectedModel, label: Text("")) {
        Section {
          ForEach(OpenAIModelType.allCases) { model in
            Text(model.rawValue).tag(model.rawValue)
          }
        }
        Section {
          ForEach(PplxModelType.allCases) { model in
            Text(model.rawValue).tag(model.rawValue)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  ModelPicker(selectedModel: .constant(OpenAIModelType.defaultModel.rawValue))
}

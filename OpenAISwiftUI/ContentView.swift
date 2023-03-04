//
//  ContentView.swift
//  OpenAISwiftUI
//
//  Created by will on 02/03/2023.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("hasApiKey") var hasApiKey: Bool = false
  @ObservedObject var viewModel = ViewModel()
  @FocusState var isFocus: Bool

  // MARK: - life cycle

  var body: some View {
    VStack {
      ScrollViewReader { scrollViewReader in
        ScrollView {
          LazyVStack {
            ForEach(viewModel.messages) { message in
              HStack(alignment: .top, spacing: 6) {
                VStack {
                  switch message.role {
                  case .user:
                    Image(systemName: "person.circle")
                    Text("You")
                  case .system:
                    Image(systemName: "person.icloud")
                    Text("AI")
                  }
                }
                .font(.headline)
                VStack(alignment: .leading) {
                  Text(message.text)
                  Text(message.errorText)
                    .foregroundColor(Color.pink)
                  if message.isInteracting {
                    LoadingView()
                  }
                }
                Spacer()
                Button {
                  copyToClipboard(text: message.text.trimmed)
                } label: {
                  Image(systemName: "doc.on.doc")
                }
              }
              .padding()
              .background(message.role == .user ? Color.clear : Color.gray.opacity(0.1))
            }
          }
        }
        .onTapGesture {
          isFocus = false
        }
        .onChange(of: viewModel.scrollId) { newValue in
          if let newValue {
            withAnimation {
              scrollViewReader.scrollTo(newValue)
            }
          }
        }
      }
      VStack(alignment: .leading) {
        HStack {
          if viewModel.showMoreOptions {
            Button {
              viewModel.showMoreOptions.toggle()
            } label: {
              Image(systemName: "chevron.compact.down")
                .padding(.vertical, 6)
            }
          } else {
            Button {
              viewModel.showMoreOptions.toggle()
            } label: {
              Image(systemName: "chevron.compact.up")
                .padding(.vertical, 6)
            }
          }
          Button {
            viewModel.clearMessages()
          } label: {
            Image(systemName: "trash.circle.fill")
          }
          .tint(.pink)
          Button {
            hasApiKey = false
          } label: {
            Image(systemName: "gear")
          }
          if viewModel.showMoreOptions == false {
            muteButton
          }
          Spacer()
        }
        if viewModel.showMoreOptions {
          HStack {
            VoicePicker(selectedVoice: $viewModel.selectedVoice)
            muteButton
          }
        }
        HStack {
          Group {
            if #available(iOS 16.0, macOS 13.0, *) {
              TextField("prompt", text: $viewModel.prompt, axis: .vertical)
                .lineLimit(1 ... 5)
            } else {
              TextField("prompt", text: $viewModel.prompt)
            }
          }
          .onSubmit {
            viewModel.requestAI()
          }
          .focused($isFocus)
          .textFieldStyle(.roundedBorder)
          Button {
            isFocus = false
            viewModel.requestAI()
          } label: {
            Text("Send")
          }
        }
        .disabled(viewModel.isLoading)
      }
    }
    .padding()
    .tint(.accent)
    .buttonStyle(.borderedProminent)
    .task {
      isFocus = true
    }
  }

  var muteButton: some View {
    Button {
      viewModel.isEnableSpeech.toggle()
    } label: {
      if viewModel.isEnableSpeech {
        Image(systemName: "speaker.wave.2.circle.fill")
      } else {
        Image(systemName: "speaker.slash.circle.fill")
      }
    }
    .tint(viewModel.isEnableSpeech ? Color.green : Color.pink)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

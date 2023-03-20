//
//  ChatView.swift
//  OpenAISwiftUI
//
//  Created by will on 02/03/2023.
//

import MarkdownUI
import SwiftUI

struct ChatView: View {
  @AppStorage("hasApiKey") var hasApiKey: Bool = false
  @ObservedObject var viewModel = ViewModel()
  @FocusState var isFocus: Bool
  @State var isPresentedTipView: Bool = false
  @State private var animateMicCircle = false
  @State private var showingTemperaturePopover = false

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
                  if viewModel.isMarkdown {
                    Markdown(message.text)
                    Markdown(message.errorText)
                      .foregroundColor(Color.pink)
                  } else {
                    Text(message.text)
                    Text(message.errorText)
                      .foregroundColor(Color.pink)
                  }
                  if message.isInteracting {
                    LoadingView()
                      .padding(.top)
                  }
                }
                .markdownTheme(Theme.gitHubCustom)

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
        .onChange(of: viewModel.messages.last?.text) { _ in
          scrollToBottom(proxy: scrollViewReader)
        }
        .onChange(of: viewModel.messages.last?.errorText) { _ in
          scrollToBottom(proxy: scrollViewReader)
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
            .keyboardShortcut(.downArrow)
          } else {
            Button {
              viewModel.showMoreOptions.toggle()
            } label: {
              Image(systemName: "chevron.compact.up")
                .padding(.vertical, 6)
            }
            .keyboardShortcut(.upArrow)
          }
          Button {
            hasApiKey = false
          } label: {
            Image(systemName: "gear")
          }
          .keyboardShortcut(",")
          Button {
            isPresentedTipView.toggle()
          } label: {
            Image(systemName: "cup.and.saucer")
          }
          .keyboardShortcut("t")
          .sheet(isPresented: $isPresentedTipView) {
            TipView(isPresented: $isPresentedTipView)
          }
          Button {
            viewModel.resetSetttings()
          } label: {
            Image(systemName: "slider.horizontal.2.rectangle.and.arrow.triangle.2.circlepath")
          }
          .keyboardShortcut("r")
          Button {
            viewModel.clearMessages()
          } label: {
            Image(systemName: "trash.circle.fill")
          }
          .tint(.pink)
          .keyboardShortcut("d")

          if viewModel.showMoreOptions == false {
            muteButton
          }
          Spacer()
        }
        if viewModel.showMoreOptions {
          HStack {
            Text("System Prompt")
            TextField("", text: $viewModel.systemPrompt)
              .textFieldStyle(.roundedBorder)
          }
          HStack {
            Text("Model")
            Picker(selection: $viewModel.modelType, label: Text("")) {
              ForEach(OpenAIModelType.allCases) { model in
                Text(model.rawValue)
              }
            }
          }
          HStack {
            Text("Temperature: \(viewModel.temperature.oneDigitsFormat)")
            Button {
              showingTemperaturePopover = true
            } label: {
              Image(systemName: "questionmark.circle")
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showingTemperaturePopover) {
              Text("Defaults to 1. \nWhat sampling temperature to use, between 0 and 2. \nHigher values like 0.8 will make the output more random, \nwhile lower values like 0.2 will make it more focused and deterministic.")
                .font(.headline)
                .padding()
            }
            Slider(value: $viewModel.temperature, in: 0 ... 2, step: 0.1)
          }

          HStack {
            VoicePicker(selectedVoice: $viewModel.selectedVoice)
            muteButton
          }

          Toggle("Render Markdown", isOn: $viewModel.isMarkdown)
            .toggleStyle(.switch)
        }

        HStack {
          micButton
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
    .keyboardShortcut("v", modifiers: .shift)
  }

  var micButton: some View {
    ZStack {
      Circle()
        .foregroundColor(Color.red.opacity(0.3))
        .frame(width: 50, height: 50)
        .scaleEffect(animateMicCircle ? 0.9 : 1.2)
        .animation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: false), value: animateMicCircle)
        .onAppear {
          self.animateMicCircle.toggle()
        }
        .opacity(viewModel.isRecording ? 1 : 0)
      Button {
        if viewModel.isRecording {
          viewModel.stopSpeechRecognizer()
        } else {
          isFocus = false
          viewModel.startSpeechRecognizer()
        }
      } label: {
        ZStack {
          Circle()
            .frame(width: 40, height: 40)
            .foregroundColor(viewModel.isRecording ? .red : .accent)

          Image(systemName: "mic").foregroundColor(.white)
        }
      }
    }
    .buttonStyle(.borderless)
    .frame(width: 60, height: 50)
    .keyboardShortcut("m", modifiers: .shift)
  }

  // MARK: - private methods

  private func scrollToBottom(proxy: ScrollViewProxy) {
    guard let id = viewModel.messages.last?.id else { return }
    proxy.scrollTo(id, anchor: .bottomTrailing)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}

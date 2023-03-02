//
//  ContentView.swift
//  OpenAISwiftUI
//
//  Created by will on 02/03/2023.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()
  @FocusState var isFocus: Bool

  // MARK: - life cycle

  var body: some View {
    VStack {
      ScrollViewReader { scrollViewReader in
        ScrollView {
          LazyVStack {
            TextField("API key", text: $viewModel.apiKey)
            ForEach(viewModel.messages) { message in
              HStack(alignment: .top) {
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
                if message.status == .loading {
                  ProgressView()
                    .progressViewStyle(.circular)
                    .padding(.horizontal)
                } else {
                  Text(message.text.trimmed)
                    .foregroundColor(message.status == .error ? Color.pink : Color.primary)
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
        .padding()
        .onChange(of: viewModel.scrollId) { newValue in
          if let newValue {
            withAnimation {
              scrollViewReader.scrollTo(newValue, anchor: .top)
            }
          }
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
        .onAppear {
          isFocus = true
        }
        .textFieldStyle(.roundedBorder)
        Button {
          isFocus = false
          viewModel.requestAI()
        } label: {
          Text("Send")
        }
        .buttonStyle(.bordered)
      }
      .disabled(viewModel.isLoading)
      .padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

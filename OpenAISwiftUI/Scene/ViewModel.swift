//
//  ViewModel.swift
//  AI
//
//  Created by will on 02/03/2023.
//

import AVFoundation
import ChatGPTSwift
import SwiftUI

struct Message: Identifiable {
  enum Role: String {
    case user, system
  }

  let id: UUID = .init()
  let role: Role
  var text: String

  var isInteracting: Bool
  var errorText: String
}

class ViewModel: NSObject, ObservableObject {
  var openAI: ChatGPTAPI!
  @AppStorage("apiKey") var apiKey: String = "" {
    didSet { openAI = ChatGPTAPI(apiKey: apiKey) }
  }

  @Published var prompt: String = ""
  @Published var messages: [Message] = []
  @Published var isLoading: Bool = false
  @AppStorage("showMoreOptions") var showMoreOptions: Bool = true

  let errorMessage = "\nPlease check API key and network."

  // MARK: - Speech properties

  let synthesizer = AVSpeechSynthesizer()
  let speechOperationQueue = OperationQueue()

  @AppStorage("isEnableSpeech") var isEnableSpeech: Bool = true {
    didSet {
      if isEnableSpeech == false {
        stopSpeak()
      }
    }
  }

  @Published var selectedVoice: AVSpeechSynthesisVoice? {
    didSet {
      selectedVoiceIdentifier = selectedVoice?.identifier ?? ""
    }
  }

  @AppStorage("selectedVoiceIdentifier") var selectedVoiceIdentifier = ""

  // MARK: - life cycle

  override init() {
    super.init()

    self.openAI = .init(apiKey: apiKey)
    setPlaybackMode()
    self.selectedVoice = AVSpeechSynthesisVoice(identifier: selectedVoiceIdentifier) ?? AVSpeechSynthesisVoice(language: "en-US")
    synthesizer.delegate = self
    speechOperationQueue.maxConcurrentOperationCount = 1
  }

  // MARK: - Request Open API

  func requestAI() {
    guard apiKey.isEmpty == false else {
      showErrorMessage(text: errorMessage)
      return
    }
    guard prompt.isEmpty == false else {
      showErrorMessage(text: "Prompt can't be empty.")
      return
    }

    let prompt = self.prompt
    self.prompt = ""

    let promptMessage = Message(role: .user, text: prompt, isInteracting: false, errorText: "")
    messages.append(promptMessage)

    Task {
      await send(text: prompt)
    }
  }

  func clearMessages() {
    withAnimation { [weak self] in
      self?.messages = []
    }
    clearSpeak()
    openAI.deleteHistoryList()
    openAI = .init(apiKey: apiKey)
  }

  // MARK: - private methods

  @MainActor
  private func send(text: String) async {
    isLoading = true

    var streamText = ""
    var message = Message(role: .system, text: "", isInteracting: true, errorText: "")
    messages.append(message)

    do {
      let stream = try await openAI.sendMessageStream(text: text)
      for try await text in stream {
        streamText += text
        message.text = streamText.trimmed
        messages[messages.count - 1] = message
      }
    } catch {
      message = Message(role: .system, text: "", isInteracting: false, errorText: error.localizedDescription + errorMessage)
    }

    message.isInteracting = false
    messages[messages.count - 1] = message
    isLoading = false
    addToQueue(message.text + message.errorText)
  }

  private func showErrorMessage(text: String) {
    let message = Message(role: .system, text: "", isInteracting: false, errorText: text)
    messages.append(message)
    addToQueue(text)
  }
}

extension ViewModel: AVSpeechSynthesizerDelegate {
  // MARK: - Speech methods

  func speak(_ text: String) {
    activePlayback()

    let utterance = AVSpeechUtterance(string: text)
    utterance.rate = 0.5
    utterance.pitchMultiplier = 0.8
    utterance.postUtteranceDelay = 0.2
    utterance.voice = selectedVoice
    synthesizer.speak(utterance)
  }

  func addToQueue(_ text: String) {
    guard isEnableSpeech else { return }

    speechOperationQueue.addOperation { [weak self] in
      self?.speak(text)
    }
  }

  func stopSpeak() {
    synthesizer.stopSpeaking(at: .immediate)
    deactivePlayback()
    speechOperationQueue.cancelAllOperations()
  }

  func clearSpeak() {
    stopSpeak()
  }

  // MARK: - AVAudioSession PlaybackMode

  func setPlaybackMode() {
    #if os(iOS)
      do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [.mixWithOthers, .duckOthers])
      } catch {
        print(error)
      }
    #endif
  }

  func activePlayback() {
    #if os(iOS)
      do {
        try AVAudioSession.sharedInstance().setActive(true)
      } catch {
        print(error)
      }
    #endif
  }

  func deactivePlayback() {
    #if os(iOS)
      do {
        try AVAudioSession.sharedInstance().setActive(false)
      } catch {
        print(error)
      }
    #endif
  }

  // MARK: - AVSpeechSynthesizerDelegate

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    print("synthesizer didStart")
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
//    print("synthesizer willSpeakRange")
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    print("synthesizer didPause")
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
    print("synthesizer didContinue")
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    print("synthesizer didFinish")
    // Speak the next utterance in the queue
    deactivePlayback()
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    print("synthesizer didCancel")
    deactivePlayback()
  }
}

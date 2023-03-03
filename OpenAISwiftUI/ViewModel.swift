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

  enum Status: String {
    case loading, success, error
  }

  let id: UUID = .init()
  let role: Role
  let text: String
  var status: Status
}

class ViewModel: NSObject, ObservableObject {
  var openAI: ChatGPTAPI!
  @AppStorage("apiKey") var apiKey: String = "" {
    didSet { openAI = ChatGPTAPI(apiKey: apiKey) }
  }

  @Published var prompt: String = ""
  @Published var messages: [Message] = []
  @Published var scrollId: UUID?
  @Published var isLoading: Bool = false
  @AppStorage("showMoreOptions") var showMoreOptions: Bool = true

  let errorMessage = "\nPlease check API key and network."

  // MARK: - Speech properties

  let synthesizer = AVSpeechSynthesizer()
  var speechTexts = [String]()
  let speechQueueDispatch = DispatchQueue(label: "org.gewill.speechQueue", qos: .userInteractive)

  @AppStorage("isEnableSpeech") var isEnableSpeech: Bool = true {
    didSet {
      if isEnableSpeech == false {
        stopSpeak()
        speechTexts = []
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
    isLoading = true

    let prompt = self.prompt
    self.prompt = ""

    Task.detached {
      do {
        let response = try await self.openAI.sendMessage(text: prompt)
        await self.updateMessages(to: [Message(role: .system, text: response, status: .success)])
      } catch {
        await self.updateMessages(to: [Message(role: .system, text: error.localizedDescription + self.errorMessage, status: .error)])
      }
    }

    let promptMessage = Message(role: .user, text: prompt, status: .success)
    messages.append(promptMessage)
    messages.append(Message(role: .system, text: "", status: .loading))
    scrollId = promptMessage.id
  }

  @MainActor
  func updateMessages(to messages: [Message]) {
    if let last = self.messages.last,
       last.status == .loading
    {
      self.messages.removeLast()
    }
    self.messages += messages
    scrollId = messages.last?.id
    isLoading = false
    messages.forEach {
      if $0.role == .system {
        addToQueue($0.text)
      }
    }
  }

  func showErrorMessage(text: String) {
    let message = Message(role: .system, text: text, status: .error)
    messages.append(message)
    scrollId = message.id
    addToQueue(text)
  }

  func clearMessages() {
    messages = []
    clearSpeak()
    openAI.deleteHistoryList()
    openAI = .init(apiKey: apiKey)
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

    speechQueueDispatch.async {
      self.speechTexts.append(text)
      if !self.synthesizer.isSpeaking {
        self.speakNext()
      }
    }
  }

  func speakNext() {
    speechQueueDispatch.async {
      guard !self.speechTexts.isEmpty else {
        self.deactivePlayback()
        return
      }
      let text = self.speechTexts.removeFirst()
      self.speak(text)
    }
  }

  func stopSpeak() {
    synthesizer.stopSpeaking(at: .immediate)
    deactivePlayback()
  }

  func clearSpeak() {
    speechTexts = []
    stopSpeak()
  }

  // MARK: - AVAudioSession PlaybackMode

  func setPlaybackMode() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [.mixWithOthers, .duckOthers])
    } catch {
      print(error)
    }
  }

  func activePlayback() {
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print(error)
    }
  }

  func deactivePlayback() {
    do {
      try AVAudioSession.sharedInstance().setActive(false)
    } catch {
      print(error)
    }
  }

  // MARK: - AVSpeechSynthesizerDelegate

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    print("synthesizer didStart")
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    print("synthesizer willSpeakRange")
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
    speakNext()
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    print("synthesizer didCancel")
  }
}

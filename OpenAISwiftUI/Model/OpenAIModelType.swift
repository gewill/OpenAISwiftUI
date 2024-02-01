//
//  OpenAIModelType.swift
//  OpenAISwiftUI
//
//  Created by will on 20/03/2023.
//

import Foundation

/// OpenAI model
/// https://platform.openai.com/docs/models/overview
enum OpenAIModelType: String, CaseIterable, Identifiable {
  case gpt_3_5_turbo = "gpt-3.5-turbo"
  case gpt_3_5_turbo_1106 = "gpt-3.5-turbo-1106"
  case gpt_3_5_turbo_16k = "gpt-3.5-turbo-16k"
  case gpt_4_vision_preview = "gpt-4-vision-preview"
  case gpt_4 = "gpt-4"
  case gpt_4_32k = "gpt-4-32k"

  var id: OpenAIModelType { self }
  
  static var defaultModel = OpenAIModelType.gpt_3_5_turbo
}

/// The name of the model that will complete your prompt.
/// https://docs.perplexity.ai/reference/post_chat_completions
enum PplxModelType: String, CaseIterable, Identifiable {
  case pplx_7b_chat = "pplx-7b-chat"
  case pplx_70b_chat = "pplx-70b-chat"
  case pplx_7b_online = "pplx-7b-online"
  case pplx_70b_online = "pplx-70b-online"
  case llama_2_70b_chat = "llama-2-70b-chat"
  case codellama_34b_instruct = "codellama-34b-instruct"
  case codellama_70b_instruct = "codellama-70b-instruct"
  case mistral_7b_instruct = "mistral-7b-instruct"
  case mixtral_8x7b_instruct = "mixtral-8x7b-instruct"

  var id: Self { self }
}

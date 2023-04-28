//
//  ThemeExtensions.swift
//  OpenAISwiftUI
//
//  Created by will on 20/03/2023.
//

import CodeViewer
import MarkdownUI
import SwiftUI

public extension Theme {
  /// A theme that mimics the GitHub style.
  ///
  /// Style | Preview
  /// --- | ---
  /// Inline text | ![](GitHubInlines)
  /// Headings | ![](GitHubHeading)
  /// Blockquote | ![](GitHubBlockquote)
  /// Code block | ![](GitHubCodeBlock)
  /// Image | ![](GitHubImage)
  /// Task list | ![](GitHubTaskList)
  /// Bulleted list | ![](GitHubNestedBulletedList)
  /// Numbered list | ![](GitHubNumberedList)
  /// Table | ![](GitHubTable)
  static let gitHubCustom = Theme()
    .text {
      ForegroundColor(.text)
      BackgroundColor(.background)
      FontSize(16)
    }
    .code {
      FontFamilyVariant(.monospaced)
      FontSize(.em(0.85))
      BackgroundColor(.secondaryBackground)
    }
    .strong {
      FontWeight(.semibold)
    }
    .link {
      ForegroundColor(.link)
    }
    .heading1 { label in
      VStack(alignment: .leading, spacing: 0) {
        label
          .relativePadding(.bottom, length: .em(0.3))
          .relativeLineSpacing(.em(0.125))
          .markdownMargin(top: 24, bottom: 16)
          .markdownTextStyle {
            FontWeight(.semibold)
            FontSize(.em(2))
          }
        Divider().overlay(Color.divider)
      }
    }
    .heading2 { label in
      VStack(alignment: .leading, spacing: 0) {
        label
          .relativePadding(.bottom, length: .em(0.3))
          .relativeLineSpacing(.em(0.125))
          .markdownMargin(top: 24, bottom: 16)
          .markdownTextStyle {
            FontWeight(.semibold)
            FontSize(.em(1.5))
          }
        Divider().overlay(Color.divider)
      }
    }
    .heading3 { label in
      label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1.25))
        }
    }
    .heading4 { label in
      label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
        }
    }
    .heading5 { label in
      label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.875))
        }
    }
    .heading6 { label in
      label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.85))
          ForegroundColor(.tertiaryText)
        }
    }
    .paragraph { label in
      label
        .relativeLineSpacing(.em(0.25))
        .markdownMargin(top: 0, bottom: 16)
    }
    .blockquote { label in
      HStack(spacing: 0) {
        RoundedRectangle(cornerRadius: 6)
          .fill(Color.border)
          .relativeFrame(width: .em(0.2))
        label
          .markdownTextStyle { ForegroundColor(.secondaryText) }
          .relativePadding(.horizontal, length: .em(1))
      }
      .fixedSize(horizontal: false, vertical: true)
    }
    .codeBlock { configuration in
      VStack {
        HStack {
          Text(configuration.language ?? "")
          Spacer()
          CopyButton(text: configuration.content)
            .buttonStyle(.plain)
        }
        Divider()
        ScrollView(.horizontal) {
          configuration.label
            .relativeLineSpacing(.em(0.225))
            .markdownTextStyle {
              FontFamilyVariant(.monospaced)
              FontSize(.em(0.85))
            }
        }
      }
      .padding(16)
      .background(Color.secondaryBackground)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .markdownMargin(top: 0, bottom: 16)
    }
    .listItem { label in
      label.markdownMargin(top: .em(0.25))
    }
    .taskListMarker { configuration in
      Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(Color.checkbox, Color.checkboxBackground)
        .imageScale(.small)
        .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
    }
    .table { label in
      label
        .markdownTableBorderStyle(.init(color: .border))
        .markdownTableBackgroundStyle(
          .alternatingRows(Color.background, Color.secondaryBackground)
        )
        .markdownMargin(top: 0, bottom: 16)
    }
    .tableCell { configuration in
      configuration.label
        .markdownTextStyle {
          if configuration.row == 0 {
            FontWeight(.semibold)
          }
          BackgroundColor(nil)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 13)
        .relativeLineSpacing(.em(0.25))
    }
    .thematicBreak {
      Divider()
        .relativeFrame(height: .em(0.25))
        .overlay(Color.border)
        .markdownMargin(top: 24, bottom: 24)
    }

  /// A theme that mimics the GitHub style.
  ///
  /// Style | Preview
  /// --- | ---
  /// Inline text | ![](GitHubInlines)
  /// Headings | ![](GitHubHeading)
  /// Blockquote | ![](GitHubBlockquote)
  /// Code block | ![](GitHubCodeBlock)
  /// Image | ![](GitHubImage)
  /// Task list | ![](GitHubTaskList)
  /// Bulleted list | ![](GitHubNestedBulletedList)
  /// Numbered list | ![](GitHubNumberedList)
  /// Table | ![](GitHubTable)
  static let gitHubCodeViewer = Theme()
    .text {
      ForegroundColor(.text)
      BackgroundColor(.background)
      FontSize(16)
    }
    .code {
      FontFamilyVariant(.monospaced)
      FontSize(.em(0.85))
      BackgroundColor(.secondaryBackground)
    }
    .strong {
      FontWeight(.semibold)
    }
    .link {
      ForegroundColor(.link)
    }
    .heading1 { label in
      VStack(alignment: .leading, spacing: 0) {
        label
          .relativePadding(.bottom, length: .em(0.3))
          .relativeLineSpacing(.em(0.125))
          .markdownMargin(top: 24, bottom: 16)
          .markdownTextStyle {
            FontWeight(.semibold)
            FontSize(.em(2))
          }
        Divider().overlay(Color.divider)
      }
    }
    .heading2 { label in
      VStack(alignment: .leading, spacing: 0) {
        label
          .relativePadding(.bottom, length: .em(0.3))
          .relativeLineSpacing(.em(0.125))
          .markdownMargin(top: 24, bottom: 16)
          .markdownTextStyle {
            FontWeight(.semibold)
            FontSize(.em(1.5))
          }
        Divider().overlay(Color.divider)
      }
    }
    .heading3 { label in
      label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1.25))
        }
    }
    .heading4 { label in
      label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
        }
    }
    .heading5 { label in
      label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.875))
        }
    }
    .heading6 { label in
      label
        .relativeLineSpacing(.em(0.125))
        .markdownMargin(top: 24, bottom: 16)
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.85))
          ForegroundColor(.tertiaryText)
        }
    }
    .paragraph { label in
      label
        .relativeLineSpacing(.em(0.25))
        .markdownMargin(top: 0, bottom: 16)
    }
    .blockquote { label in
      HStack(spacing: 0) {
        RoundedRectangle(cornerRadius: 6)
          .fill(Color.border)
          .relativeFrame(width: .em(0.2))
        label
          .markdownTextStyle { ForegroundColor(.secondaryText) }
          .relativePadding(.horizontal, length: .em(1))
      }
      .fixedSize(horizontal: false, vertical: true)
    }
    .codeBlock { configuration in
      VStack {
        HStack {
          Text(configuration.language ?? "")
          Spacer()
          CopyButton(text: configuration.content, title: "Copy code")
            .buttonStyle(.plain)
        }
        CodeViewer(content: .constant(configuration.content), mode: CodeWebView.Mode(rawValue: configuration.language ?? "") ?? .text, darkTheme: .tomorrow_night_eighties, lightTheme: .tomorrow, isReadOnly: true, fontSize: 14, lineHeight: 1.3)
          .frame(height: CGFloat(configuration.content.components(separatedBy: .newlines).count) * 14 * 1.3)
      }
      .padding(16)
      .background(Color.secondaryBackground)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .markdownMargin(top: 0, bottom: 16)
    }
    .listItem { label in
      label.markdownMargin(top: .em(0.25))
    }
    .taskListMarker { configuration in
      Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(Color.checkbox, Color.checkboxBackground)
        .imageScale(.small)
        .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
    }
    .table { label in
      label
        .markdownTableBorderStyle(.init(color: .border))
        .markdownTableBackgroundStyle(
          .alternatingRows(Color.background, Color.secondaryBackground)
        )
        .markdownMargin(top: 0, bottom: 16)
    }
    .tableCell { configuration in
      configuration.label
        .markdownTextStyle {
          if configuration.row == 0 {
            FontWeight(.semibold)
          }
          BackgroundColor(nil)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 13)
        .relativeLineSpacing(.em(0.25))
    }
    .thematicBreak {
      Divider()
        .relativeFrame(height: .em(0.25))
        .overlay(Color.border)
        .markdownMargin(top: 24, bottom: 24)
    }
}

private extension Color {
  static let text = Color(
    light: Color(rgba: 0x0606_06ff), dark: Color(rgba: 0xfbfb_fcff)
  )
  static let secondaryText = Color(
    light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x9294_a0ff)
  )
  static let tertiaryText = Color(
    light: Color(rgba: 0x6b6e_7bff), dark: Color(rgba: 0x6d70_7dff)
  )
  static let background = Color(
    light: .clear, dark: .clear
  )
  static let secondaryBackground = Color(
    light: Color(rgba: 0xf7f8_faff), dark: Color(rgba: 0x171b_22ff)
  )
  static let link = Color(
    light: Color(rgba: 0x2c65_cfff), dark: Color(rgba: 0x4c8e_f8ff)
  )
  static let border = Color(
    light: Color(rgba: 0xe4e4_e8ff), dark: Color(rgba: 0x4244_4eff)
  )
  static let divider = Color(
    light: Color(rgba: 0xd0d0_d3ff), dark: Color(rgba: 0x3334_38ff)
  )
  static let checkbox = Color(rgba: 0xb9b9_bbff)
  static let checkboxBackground = Color(rgba: 0xeeee_efff)
}

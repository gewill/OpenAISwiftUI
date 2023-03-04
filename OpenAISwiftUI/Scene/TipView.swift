//
//  TipView.swift
//  OpenAISwiftUI
//
//  Created by will on 05/03/2023.
//

import Glassfy
import SwiftUI

struct TipView: View {
  enum Permission: String {
    case coffee
  }

  enum Offering: String {
    case coffee
  }

  @Binding var isPresented: Bool
  @State var isPay: Bool = false
  @State var skus: [Glassfy.Sku] = []

  var body: some View {
    VStack {
      ZStack {
        Text("Enjoy VoiceAI Chat?").font(.title)
        HStack {
          Spacer()
          Button {
            isPresented.toggle()
          } label: {
            Image(systemName: "xmark")
          }
          .buttonStyle(.borderedProminent)
        }
      }
      Divider()
      if isPay {
        Text("Thanks for your support. 😊")
      }
      Spacer()

      ForEach(skus, id: \.skuId) { sku in
        VStack {
          Text(sku.product.localizedTitle)
            .font(.headline)
          Text(sku.product.localizedDescription)
          Button {
            Glassfy.purchase(sku: sku) { transaction, error in
              guard let t = transaction, error == nil else {
                return
              }
              if t.permissions[Permission.coffee.rawValue]?.isValid == true {
                print("Pay success")
                self.isPay = true
              }
            }
          } label: {
            Text("Support \(sku.product.priceLocale.currencySymbol ?? "")\(sku.product.price)")
          }
          .buttonStyle(.borderedProminent)
        }
      }

      Spacer()
    }
    .padding()
    .frame(minWidth: 300, minHeight: 300)
    .task {
      Glassfy.offerings { offers, _ in
        if let offering = offers?[Offering.coffee.rawValue] {
          skus = offering.skus
        }
      }
    }
  }
}

struct TipView_Previews: PreviewProvider {
  static var previews: some View {
    TipView(isPresented: .constant(true))
  }
}

//
//  TipView.swift
//  OpenAISwiftUI
//
//  Created by will on 05/03/2023.
//

import ConfettiSwiftUI
import Glassfy
import Lottie
import LottieUI
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
  @State private var confettiCounter: Int = 0

  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button {
          isPresented.toggle()
        } label: {
          Image(systemName: "xmark")
        }
        .buttonStyle(.borderedProminent)
        .keyboardShortcut("w")
      }
      ScrollView {
        LottieView(LottieFiles.buyMeACoffee)
          .loopMode(LottieLoopMode.loop)
          .frame(width: 200, height: 200)

        Text("Hey, if you enjoy this app, please buy me a coffee.")
          .font(.headline)
          .lineLimit(nil)

        if isPay {
          Text("Thanks for your support. 😊")
          Button("🎉🎉🎉") {
            confettiCounter += 1
          }
          .onAppear {
            confettiCounter += 1
          }
          .confettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
        }

        Divider()

        ForEach(skus, id: \.skuId) { sku in
          VStack {
            Text(sku.product.localizedTitle.localizedStringKey)
              .font(.headline)
            // Text(sku.product.localizedDescription)
            Button {
              Glassfy.purchase(sku: sku) { transaction, error in
                guard let t = transaction, error == nil else {
                  return
                }
                if t.permissions[Permission.coffee.rawValue]?.isValid == true {
                  print("Pay success")
                  self.isPay = true
                  confettiCounter += 1
                }
              }
            } label: {
              Text("Support ") + Text("\(sku.product.priceLocale.currencySymbol ?? "")\(sku.product.price)")
            }
            .buttonStyle(.borderedProminent)
          }
        }
      }
      Spacer()
    }
    .padding()
    .frame(minWidth: 300, idealWidth: 500, minHeight: 400, idealHeight: 600)
    .task {
      Glassfy.offerings { offers, _ in
        if let offering = offers?[Offering.coffee.rawValue] {
          skus = offering.skus
        }
      }
      Glassfy.permissions { permissions, _ in
        if permissions?[Permission.coffee.rawValue]?.isValid == true {
          self.isPay = true
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

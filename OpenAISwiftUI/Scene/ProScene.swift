import Glassfy
import SwiftUI

struct ProScene: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State var skus: [Glassfy.Sku] = []
  @State var permissions: [Glassfy.Permission] = []
  @AppStorage("isPro") var isPro: Bool = false
  @State var isLoading: Bool = false
  @State var errorMessage: String = ""

  // MARK: - life cycle

  var body: some View {
    ZStack(alignment: .top) {
      VStack(spacing: 10) {
        navi
        list
      }
      .padding(.top, presentationMode.wrappedValue.isPresented ? 10 * 2 : 0)
    }
  }

  var navi: some View {
    ZStack {
      Text("Pro")
        .font(.title)
      HStack {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image(systemName: "chevron.backward")
        }
        Spacer()
        Button {
          self.isLoading = true
          Glassfy.restorePurchases { permissions, error in
            self.showError(message: error?.localizedDescription)
            self.setPermissions(permissions?.all)
            self.isLoading = false
          }
        } label: {
          Text("Restore")
        }
        .disabled(self.isLoading)
      }
      .padding(.horizontal)
    }
  }

  var list: some View {
    ZStack(alignment: .center) {
      ScrollView {
        if self.errorMessage.isEmpty == false {
          Text(self.errorMessage).foregroundColor(.pink)
        }

        if self.isPro {
          proView
        } else {
          skuView
        }

        featuresView
      }
      .padding()
      if self.isLoading {
        ProgressView()
          .progressViewStyle(.circular)
          .scaleEffect(2)
      }
    }
    .onAppear {
      self.updateOfferingsAndPermissions()
    }
  }

  var featuresView: some View {
    Group {
      VStack(alignment: .leading, spacing: 10) {
        Text("Pro features: ")
          .font(.headline)
        ForEach(ProFeature.allCases) { feature in
          Divider()
          HStack {
            feature.image
              .resizable()
              .renderingMode(.template)
              .foregroundColor(feature.color)
              .frame(width: 24, height: 24)
            Text(feature.rawValue.localizedStringKey)
          }
        }
      }
      .foregroundColor(.primary)

      VStack(alignment: .leading, spacing: 10) {
        Text("Free features: ")
          .font(.headline)
        ForEach(FreeFeature.allCases) { feature in
          Divider()
          HStack {
            feature.image
              .resizable()
              .renderingMode(.template)
              .foregroundColor(feature.color)
              .frame(width: 24, height: 24)
            Text(feature.rawValue.localizedStringKey)
          }
        }
      }
      .foregroundColor(.primary)
    }
    .frame(minWidth: 300)
    .padding(10 * 2)
    .background(
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .stroke(Color.separator, lineWidth: 0.5)
    )
  }

  var proView: some View {
    VStack {
      VStack(spacing: 20) {
        Text("pro_lifetime")
          .font(.title)
        Text("Thanks for your support!")
      }
      .foregroundColor(.yellow)
    }
  }

  var skuView: some View {
    ForEach(skus, id: \.skuId) { sku in
      if sku.productId == IAPManager.Sku.ios_voiceaichat_pro_lifetime_3.rawValue {
        VStack(spacing: 10) {
          VStack(spacing: 10) {
            Text("pro_lifetime")
              .font(.title)
            Text("pro_lifetime_des")
              .font(.headline)
            Text(sku.product.localizedPrice)
              .font(.title)
          }
          .frame(minWidth: 300)
          .padding(10 * 2)
          .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
              .stroke(Color.separator, lineWidth: 0.5)
          )

          Button {
            self.isLoading = true
            Glassfy.purchase(sku: sku) { transaction, error in
              self.showError(message: error?.localizedDescription)
              self.isLoading = false
              guard let t = transaction, error == nil else {
                return
              }
              self.setPermissions(t.permissions.all)
            }
          } label: {
            Text("Buy Now")
              .font(.title3)
          }
          .buttonStyle(.borderedProminent)
          .disabled(self.isLoading)
          .padding(.bottom, 10)
        }
      }
    }
  }

  // MARK: -

  func updateOfferingsAndPermissions() {
    guard isPro == false else { return }

    isLoading = true
    let group = DispatchGroup()
    group.enter()
    Glassfy.offerings { offers, error in
      self.showError(message: error?.localizedDescription)
      group.leave()
      self.skus = offers?.all.flatMap { $0.skus } ?? []
    }
    group.enter()
    Glassfy.permissions { permissions, error in
      self.showError(message: error?.localizedDescription)
      group.leave()
      self.setPermissions(permissions?.all)
    }
    group.notify(queue: .main) {
      self.isLoading = false
    }
  }

  func updateOfferings() {
    isLoading = true
    Glassfy.offerings { offers, error in
      self.showError(message: error?.localizedDescription)
      self.isLoading = false
      self.skus = offers?.all.flatMap { $0.skus } ?? []
    }
  }

  func updatePermissions() {
    Glassfy.permissions { permissions, error in
      self.showError(message: error?.localizedDescription)
      self.setPermissions(permissions?.all)
    }
  }

  func setPermissions(_ permissions: [Glassfy.Permission]?) {
    if let permissions,
       permissions.contains(where: { $0.isValid && $0.permissionId == IAPManager.Permission.pro_lifetime.rawValue })
    {
      isPro = true
    } else {
      isPro = false
    }

    self.permissions = permissions ?? []
  }

  func showError(message: String?) {
    if let message, message.isEmpty == false {
      errorMessage = message
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.errorMessage = ""
      }
    }
  }
}

struct ProScene_Previews: PreviewProvider {
  static var previews: some View {
    ProScene()
  }
}

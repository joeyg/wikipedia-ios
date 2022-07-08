import SwiftUI
import PassKit
import UIKit

struct ApplePayDonateButton: UIViewRepresentable {

    func makeUIView(context: Context) -> PKPaymentButton {
        return PKPaymentButton(paymentButtonType: .donate, paymentButtonStyle: .black)
    }

    func updateUIView(_ uiView: PKPaymentButton, context: UIViewRepresentableContext<ApplePayDonateButton>) {
    }
}

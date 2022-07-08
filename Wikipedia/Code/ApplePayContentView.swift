import SwiftUI

struct ApplePayDefaultOptionButton: View {
    let text: String
    let font = Font.body
    var body: some View {
        Button(text) {
            print("Button tapped!")
        }
        .font(font)
        .frame(width: 109, height: 46)
        .foregroundColor(.base10)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 200/255, green: 204/255, blue: 209/255), lineWidth: 1)
        )
    }
}

struct Formatters {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currencyCode
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

extension Color {
    static let base10 = Color(red: 32/255, green: 33/255, blue: 34/255)
    static let selectedBlue = Color(red: 51/255, green: 102/255, blue: 204/255)
}

struct ApplePayContentView: View {
    
    @SwiftUI.State private var displayAmount: String = ApplePayTextField.initialDisplayAmount
    @SwiftUI.State private var amount: Double = ApplePayTextField.initialAmount
    @SwiftUI.State private var checked = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 9) {
                ApplePayDefaultOptionButton(text: "$10")
                ApplePayDefaultOptionButton(text: "$20")
                ApplePayDefaultOptionButton(text: "$30")
            }
            HStack(spacing: 9) {
                ApplePayDefaultOptionButton(text: "$50")
                ApplePayDefaultOptionButton(text: "$100")
                ApplePayDefaultOptionButton(text: "$300")
            }
            Spacer()
                .frame(height: 16)
            ApplePayTextField(displayAmount: $displayAmount, amount: $amount)
            let availableWidth = CGFloat((109 * 3) + (9 * 2))
            Divider()
                .frame(width: availableWidth)
                .background(Color(red: 162/255, green: 169/255, blue: 177/255))
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(checked ? .selectedBlue : Color.secondary)
                            .onTapGesture {
                                self.checked.toggle()
                            }
                // TODO: localize, convert $2 amount
                Text("I’ll generously add $2 to cover the transaction fees so you can keep 100% of my donation.")
                    .font(Font.caption)
                    .foregroundColor(.base10)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: availableWidth)
            ApplePayDonateButton()
                .frame(width: availableWidth)

        }
        .padding([.top, .bottom], 20)
        .background(Color(red: 248/255, green: 249/255, blue: 250/255))
    }
}

struct ApplePayContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScrollView(.vertical, showsIndicators: true) {
                ApplePayContentView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
            .previewDisplayName("iPhone 13 mini")
            
            ScrollView(.vertical, showsIndicators: true) {
                ApplePayContentView()
            }
            .environment(\.sizeCategory, .large)
            .previewDevice("iPhone SE (3rd generation)")
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            .previewDisplayName("iPhone SE")
            
            ScrollView(.vertical, showsIndicators: true) {
                                   ApplePayContentView()
            }
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
                               .previewDevice(PreviewDevice(rawValue: "iPad 2"))
                               .previewDisplayName("iPad Pro (12.9-inch)")
            
            if #available(iOS 15.0, *) {
                ScrollView(.vertical, showsIndicators: true) {
                    ApplePayContentView()
                }
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
                .previewDisplayName("iPhone 13 Pro Max (landscape)")
                .previewInterfaceOrientation(.landscapeLeft)
            } else {
                // Fallback on earlier versions
            }
                                 

        }
    }
}

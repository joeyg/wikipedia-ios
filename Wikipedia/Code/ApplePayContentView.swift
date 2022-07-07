import SwiftUI

struct ApplePayPriceButton: View {
    let text: String
    let font = Font.body
    var body: some View {
        Button(text) {
            print("Button tapped!")
        }
        .font(font)
        .frame(width: 109, height: 46)
        .foregroundColor(.black)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 1)
        )
    }
}

struct ApplePayContentView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 9) {
                ApplePayPriceButton(text: "$10")
                ApplePayPriceButton(text: "$20")
                ApplePayPriceButton(text: "$30")
            }
            HStack {
                ApplePayPriceButton(text: "$50")
                ApplePayPriceButton(text: "$100")
                ApplePayPriceButton(text: "$300")
            }
        }
        
        .padding([.top, .bottom], 20)
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
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            .previewDisplayName("iPhone SE")
            
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
                                 
            ScrollView(.vertical, showsIndicators: true) {
                                   ApplePayContentView()
                               }
                               .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)"))
                               .previewDisplayName("iPad Pro (12.9-inch)")
        }
    }
}

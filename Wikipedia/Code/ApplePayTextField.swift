import SwiftUI

struct ApplePayTextField: View {
    @SwiftUI.Binding var displayAmount: String
    @SwiftUI.Binding var amount: Double
    
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

    var body: some View {
        TextField("Please work", text: $displayAmount, onEditingChanged: onEditingChanged(_:))
        .foregroundColor(.base10)
        .lineLimit(1)
        .multilineTextAlignment(.center)
        .keyboardType(.decimalPad)
        .font(Font.title.weight(.semibold))
    }

    func onEditingChanged(_ changed: Bool) {
        if changed {
            NotificationCenter.default.post(name: .textfieldDidBeginEditing, object: nil)
        } else {
            scrubAmount()
            NotificationCenter.default.post(name: .textfieldDidEndEditing, object: nil)
        }
    }
    
    static var initialAmount: Double {
        return decimalFormatter.number(from: "0")?.doubleValue ?? 0.00
    }
    
    static var initialDisplayAmount: String {
        return currencyFormatter.string(from: NSNumber(value: initialAmount)) ?? "0"
    }
    
    func scrubAmount() {
        let strippedDisplayAmount = displayAmount.filter { "0123456789.".contains($0) }
        
        guard strippedDisplayAmount.count > 0 else {
            
            if displayAmount != Self.initialDisplayAmount || amount != Self.initialAmount {
                displayAmount = Self.initialDisplayAmount
                amount = Self.initialAmount
            }
            
            return
        }
        
        guard let newAmount = Self.decimalFormatter.number(from: strippedDisplayAmount),
              let newDisplayAmount = Self.currencyFormatter.string(from: newAmount) else {
            
            if displayAmount != Self.initialDisplayAmount || amount != Self.initialAmount {
                displayAmount = Self.initialDisplayAmount
                amount = Self.initialAmount
            }
            
            return
        }
        
        if displayAmount != newDisplayAmount || amount != newAmount.doubleValue {
            displayAmount = newDisplayAmount
            amount = newAmount.doubleValue
        }
    }
}

struct ApplePayTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        ApplePayTextField(displayAmount: .constant("$0.00"), amount: .constant(0.00))
    }
}

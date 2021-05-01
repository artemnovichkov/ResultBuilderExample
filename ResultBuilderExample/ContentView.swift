//
//  Created by Artem Novichkov on 28.04.2021.
//

import SwiftUI

enum SpecialIngredient: String, Identifiable, CaseIterable {
    
    case olives = "🫒"
    case avocado = "🥑"
    
    var id: String {
        rawValue
    }
}

struct ContentView: View {
    
    @State private var ingredients: [String] = []
    @State private var likeCucumbers = true
    @State private var isActionSheetPresented = false
    
    var body: some View {
        VStack {
            Text(ingredients.joined())
                .font(.system(.title))
            Toggle("I love cucumbers", isOn: $likeCucumbers)
            Spacer()
                .frame(height: 16)
            Button("Make a sandwich") {
                isActionSheetPresented = true
            }
        }
        .padding()
        .actionSheet(isPresented: $isActionSheetPresented) {
            ActionSheet(title: Text("Select an ingredient"), message: nil, buttons: buttons)
        }
    }
    
    @ButtonsBuilder
    private func buttons() -> [ActionSheet.Button] {
        ActionSheet.Button.default(Text("🍞")) {
            ingredients.append("🍞")
        }
        for topping in ["🧀", "🥓"] {
            ActionSheet.Button.default(Text(topping)) {
                ingredients.append(topping)
            }
        }
        if likeCucumbers {
            ActionSheet.Button.default(Text("🥒")) {
                ingredients.append("🥒")
            }
        }
        else {
            ActionSheet.Button.default(Text("🍅")) {
                ingredients.append("🍅")
            }
        }
        #if targetEnvironment(macCatalyst)
        ActionSheet.Button.default(Text("🍟")) {
            ingredients.append("🍟")
        }
        #endif
        ForEach(2..<4) { index in
            ActionSheet.Button.default(Text("x\(index)")) {
                ingredients.append("x\(index)")
            }
        }
        ForEach(["🧅", "🧄"], id: \.self) { string in
            ActionSheet.Button.default(Text(string)) {
                ingredients.append(string)
            }
        }
        ForEach(SpecialIngredient.allCases) { item in
            ActionSheet.Button.default(Text(item.rawValue)) {
                ingredients.append(item.rawValue)
            }
        }
        ActionSheet.Button.cancel()
    }
}

extension ActionSheet {
    
    init(title: Text, message: Text? = nil, @ButtonsBuilder buttons: () -> [ActionSheet.Button]) {
        self.init(title: title, message: message, buttons: buttons())
    }
}

@resultBuilder
struct ButtonsBuilder {
    
    static func buildBlock(_ components: ButtonsConvertible...) -> [ButtonsConvertible] {
        components
    }
    
    static func buildOptional(_ components: [ButtonsConvertible]?) -> [ButtonsConvertible] {
        components ?? []
    }
    
    static func buildEither(first components: [ButtonsConvertible]) -> [ButtonsConvertible] {
        components
    }
    
    static func buildEither(second components: [ButtonsConvertible]) -> [ButtonsConvertible] {
        components
    }
    
    static func buildArray(_ components: [[ButtonsConvertible]]) -> [ButtonsConvertible] {
        components.flatMap { $0 }
    }
    
    static func buildLimitedAvailability(_ components: [ButtonsConvertible]) -> [ButtonsConvertible] {
        components
    }
    
    static func buildFinalResult(_ components: [ButtonsConvertible]) -> [ActionSheet.Button] {
        components.flatMap(\.buttons)
    }
}

protocol ButtonsConvertible {
    
    var buttons: [ActionSheet.Button] { get }
}

extension ActionSheet.Button: ButtonsConvertible {
    
    var buttons: [ActionSheet.Button] {
        [self]
    }
}

extension Array: ButtonsConvertible where Element == ButtonsConvertible {
    
    var buttons: [ActionSheet.Button] { self.flatMap(\.buttons) }
}

extension ForEach: ButtonsConvertible where Content == ActionSheet.Button {
    
    var buttons: [ActionSheet.Button] {
        data.map(content)
    }
}

extension ActionSheet.Button: View {
    
    public var body: Never {
        fatalError()
    }
}

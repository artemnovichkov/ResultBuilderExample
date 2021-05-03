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

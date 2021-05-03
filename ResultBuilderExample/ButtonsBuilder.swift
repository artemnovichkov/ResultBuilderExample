//
//  Created by Artem Novichkov on 03.05.2021.
//

import SwiftUI

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

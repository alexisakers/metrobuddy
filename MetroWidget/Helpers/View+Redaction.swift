import SwiftUI

extension View {
    func enableRedaction(_ isRedacted: Bool) -> AnyView {
        if isRedacted {
            return self.redacted(reason: .placeholder)
                .eraseToAnyView()
        } else {
            return self.unredacted()
                .eraseToAnyView()
        }
    }
}


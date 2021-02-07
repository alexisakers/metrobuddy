import SwiftUI

/// The screen that displays the list of transactions by the user.
struct HistoryScreen: View {
    @EnvironmentObject var viewModel: HistoryViewModel

    var body: some View {
        FullWidthScrollView(bounce: [.vertical]) {
            VStack(spacing: 0) {
                NavigationBar(title: "History", subtitle: nil)
                    .padding(.bottom, 12)
                    .accessibility(sortPriority: 0)

                if case let .history(items) = viewModel.content {
                    ForEach(Array(items.enumerated()), id: \.1.id) { (index, item) -> Row<BalanceUpdateRowContent> in
                        let isLast = index == items.endIndex - 1
                        var roundedCorners: UIRectCorner = []

                        if index == items.startIndex {
                            roundedCorners.insert([.topLeft, .topRight])
                        }

                        if isLast {
                            roundedCorners.insert([.bottomLeft, .bottomRight])
                        }

                        return Row(
                            needsSeparator: !isLast,
                            roundedCorners: roundedCorners,
                            content: { BalanceUpdateRowContent(item: item) }
                        )
                    }
                }
            }
            .padding(.all, 16)
            .background(BackgroundView())
        }
        .accessibilityElement(children: .contain)
    }
}

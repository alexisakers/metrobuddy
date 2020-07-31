import Foundation

extension String {
    /// A list of shared localization formats.
    public enum LocalizationFormats {
        /// A string format to display how many swipes are remaining. The argument is an `Int` value.
        public static var remainingSwipes: String {
            NSLocalizedString("remaining_swipes", tableName: nil, bundle: .metroKit, comment: "")
        }
    }
}

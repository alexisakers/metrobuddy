import Foundation

extension String {
    /// A list of shared localization formats.
    public enum LocalizationFormats {
        /// A string format to display how many rides are remaining. The argument is an `Int` value.
        public static var remainingRides: String {
            NSLocalizedString("remaining_rides", tableName: nil, bundle: .metroKit, comment: "")
        }
    }
}

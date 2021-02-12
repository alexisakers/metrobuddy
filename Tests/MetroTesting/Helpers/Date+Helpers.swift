import Foundation

extension Date {
    static func test(_ year: Int, _ month: Int, _ day: Int) -> Date {
        let components = DateComponents(calendar: .current, year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

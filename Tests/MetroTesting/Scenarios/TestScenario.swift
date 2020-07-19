import Foundation
import MetroKit

public protocol TestScenario: NSObjectProtocol {
    static func makeDataStore() -> MetroCardDataStore
}

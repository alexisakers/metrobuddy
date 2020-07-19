import Foundation
import MetroKit

/// Simulates a data state where the user only has one swipe left.
@objc(OneSwipeLeftTestScenario)
public final class OneSwipeLeftTestScenario: ReturningUserTestScenario {
    override class var balance: Decimal { 2.75 }
    override class var fare: Decimal { 2.75 }
}

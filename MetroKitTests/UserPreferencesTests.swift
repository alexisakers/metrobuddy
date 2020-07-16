import XCTest
@testable import MetroKit

fileprivate struct TestKey: UserPreferenceKey {
    static let name: String  = "SelectedAnimal"
    static let defaultValue: String = "Panda"
}

final class UserPreferencesTests: XCTestCase {
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: UUID().uuidString)
    }
    
    override func tearDown() {
        super.tearDown()
        userDefaults = nil
    }
    
    func testThatItReturnsDefaultValueWhenNeverSet() {
        XCTAssertEqual(userDefaults.value(forKey: TestKey.self), "Panda")
    }
    
    func testThatItReturnsExistingValueWhenSet() {
        userDefaults.set("Shark", forKey: "SelectedAnimal")
        XCTAssertEqual(userDefaults.value(forKey: TestKey.self), "Shark")
    }
    
    func testThatItSetsValue() {
        userDefaults.setValue("Brown Cow", forKey: TestKey.self)
        XCTAssertEqual(userDefaults.string(forKey: "SelectedAnimal"), "Brown Cow")
    }
}

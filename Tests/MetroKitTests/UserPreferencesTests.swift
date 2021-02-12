import XCTest
@testable import MetroKit

extension UserPreferenceKey {
    static var testKey: UserPreferenceKey<String> {
        UserPreferenceKey<String>(name: "SelectedAnimal", defaultValue: "Panda")
    }
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
        XCTAssertEqual(userDefaults.value(forKey: .testKey), "Panda")
    }
    
    func testThatItReturnsExistingValueWhenSet() {
        userDefaults.set("Shark", forKey: "SelectedAnimal")
        XCTAssertEqual(userDefaults.value(forKey: .testKey), "Shark")
    }
    
    func testThatItSetsValue() {
        userDefaults.setValue("Brown Cow", forKey: .testKey)
        XCTAssertEqual(userDefaults.string(forKey: "SelectedAnimal"), "Brown Cow")
    }

    func testThatItFallsBackToDefaultValue() {
        // #1: Unknown value
        do {
            userDefaults.setValue("0_0_0", forKey: UserPreferenceKey<ModelVersion>.dataModelVersion.name)
            XCTAssertEqual(userDefaults.value(forKey: .dataModelVersion), UserPreferenceKey<ModelVersion>.dataModelVersion.defaultValue)
        }

        // #2: Wrong type
        do {
            userDefaults.setValue(false, forKey: UserPreferenceKey<ModelVersion>.dataModelVersion.name)
            XCTAssertEqual(userDefaults.value(forKey: .dataModelVersion), UserPreferenceKey<ModelVersion>.dataModelVersion.defaultValue)
        }
    }
}

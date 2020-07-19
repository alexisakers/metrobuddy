import XCTest

class FileBasedTestCase: XCTestCase {
    var fileManager: MockFileManager!
    var testURL: URL!
    
    override func setUpWithError() throws {
        super.setUp()
        fileManager = MockFileManager()
        testURL = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try fileManager.createDirectory(at: testURL, withIntermediateDirectories: true)
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        if fileManager.isDeletableFile(atPath: testURL.path) {
            try fileManager.removeItem(at: testURL)
        }
        fileManager = nil
    }
}

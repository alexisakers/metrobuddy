import XCTest
@testable import MetroKit

final class SymbolicLocationTests: FileBasedTestCase {    
    func testThatItResolvesURL() throws {
        // GIVEN
        let folder = testURL.appendingPathComponent("test")
        let sut = SymbolicLocation.url(folder)
        
        // WHEN
        let resolvedURL = try fileManager.resolve(sut)
        
        // THEN
        XCTAssertEqual(resolvedURL, folder)
        assertDirectoryExists(at: resolvedURL)
    }

    func testThatItResolvesExistingDirectoryWithoutOverriding() throws {
        // GIVEN
        let sut = SymbolicLocation.url(testURL)
        let subfolder = testURL.appendingPathComponent("subfolder")
        try fileManager.createDirectory(at: subfolder, withIntermediateDirectories: true)
        
        // WHEN
        let resolvedURL = try fileManager.resolve(sut)
        
        // THEN
        XCTAssertEqual(resolvedURL, testURL)
        assertDirectoryExists(at: resolvedURL)
        assertDirectoryExists(at: subfolder)
    }
    
    func testThatItResolvesDocumentsFolder() throws {
        // GIVEN
        fileManager.mockDocumentsDirectoryURL = testURL
        let sut = SymbolicLocation.documentsFolder(path: ["test", "result"])
        
        // WHEN
        let resolvedURL = try fileManager.resolve(sut)
        
        // THEN
        let expectedURL = testURL
            .appendingPathComponent("test/result", isDirectory: true)

        XCTAssertEqual(resolvedURL, expectedURL)
        assertDirectoryExists(at: resolvedURL)
    }
    
    func testThatItResolvesAuthorizedContainer() throws {
        // GIVEN
        fileManager.mockContainerURL = testURL
        let sut = SymbolicLocation
            .securityGroupContainer(id: "group.test", path: ["test", "result"])
        
        // WHEN
        let resolvedURL = try fileManager.resolve(sut)
        
        // THEN
        let expectedURL = testURL
            .appendingPathComponent("test/result", isDirectory: true)
        
        XCTAssertEqual(resolvedURL, expectedURL)
        assertDirectoryExists(at: resolvedURL)
    }
    
    func testThatItFailsWhenResolvingAFile() {
        // GIVEN
        let fileURL = testURL.appendingPathComponent("file.txt")
        fileManager.createFile(atPath: fileURL.path, contents: nil)
        let sut = SymbolicLocation.url(fileURL)
        
        // THEN
        XCTAssertThrowsError(try fileManager.resolve(sut)) {
            assertCocoaError($0, code: .fileReadCorruptFile)
        }
    }
    
    func testThatItFailsWhenContainerIsNotAuthorized() {
        // GIVEN
        fileManager.mockContainerURL = nil
        let sut = SymbolicLocation
            .securityGroupContainer(id: "group.test", path: ["test"])
        
        // THEN
        XCTAssertThrowsError(try fileManager.resolve(sut)) {
            assertCocoaError($0, code: .fileReadNoPermission)
        }
    }
    
    // MARK: - Helpers
    
    func assertDirectoryExists(at url: URL, file: StaticString = #filePath, line: UInt = #line) {
        var isDirectory: ObjCBool = false
        XCTAssertTrue(fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory), file: file, line: line)
        XCTAssertTrue(isDirectory.boolValue, file: file, line: line)
    }
    
    func assertCocoaError(_ error: Error, code: CocoaError.Code, file: StaticString = #filePath, line: UInt = #line) {
        if let cocoaError = error as? CocoaError {
            XCTAssertEqual(cocoaError.code, code, file: file, line: line)
        } else {
            XCTFail("Error is not a Cocoa Error: \(error)")
        }
    }
}

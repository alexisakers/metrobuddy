import Foundation

class MockFileManager: FileManager {
    var mockContainerURL: URL?
    var mockDocumentsDirectoryURL: URL?
    
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        if let mockDocumentsDirectoryURL = mockDocumentsDirectoryURL {
            if directory == .documentDirectory && domainMask == .userDomainMask {
                return [mockDocumentsDirectoryURL]
            }
        }
        
        return super.urls(for: directory, in: domainMask)
    }
    
    override func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL? {
        return mockContainerURL
    }
}

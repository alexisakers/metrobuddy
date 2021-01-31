import Foundation

/// A list of well-known directories on disk that can be accessed through a file manager.
public enum SymbolicLocation {
    /// A location inside the app's documents folder, at the specified path.
    ///
    /// For example, `.documentsFolder(path: ["User", "Data"]` resolves to `{App}/Documents/User/Data`.
    /// - parameter path: The list of subdirectories needed to reach the location, starting at the root folder.
    case documentsFolder(path: [String])
    
    /// A location inside the app's shared folder by ID, at the specified path.
    ///
    /// For example, `.securityGroupContainer(id: "group.app", path: ["User", "Data"]` resolves to `{Containers}/group.app/Documents/User/Data`.
    /// - parameter path: The list of subdirectories needed to reach the location, starting at the root folder.
    case securityGroupContainer(id: String, path: [String])
    
    /// An already existing URL.
    case url(URL)
}

extension FileManager {
    /// Converts the symbolic location description to a URL, and creates the folders if needed.
    /// - parameter location: The location to resolve to an actual URL.
    /// - throws: `CocoaError(.fileReadNoPermission)` if the app doesn't have access
    /// to the specified shared container,  `CocoaError(.fileReadCorruptFile)` if the location resolves to an
    /// existing path, or any error thrown by the file manager when creating a directory.
    /// - returns: The read/writable URL that was resolved from the symbolic location
    func resolve(_ location: SymbolicLocation) throws -> URL {
        let url: URL
        switch location {
        case .documentsFolder(let path):
            url = urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(path.joined(separator: "/"), isDirectory: true)
        case .securityGroupContainer(let id, let path):
            guard let containerURL = containerURL(forSecurityApplicationGroupIdentifier: id) else {
                throw CocoaError(.fileReadNoPermission)
            }
            
            url = containerURL.appendingPathComponent(path.joined(separator: "/"), isDirectory: true)
        case .url(let existingURL):
            url = existingURL
        }
        
        var isDirectory: ObjCBool = false
        if fileExists(atPath: url.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue != true {
                throw CocoaError(.fileReadCorruptFile)
            }
        } else {
            try! createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        return url
    }
}

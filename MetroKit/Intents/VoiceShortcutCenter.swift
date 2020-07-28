import Intents

/// A protocol for objects that can provide access to the user's saved voice shortcuts. Typically, you'd use a `INVoiceShortcutsCenter` object to
/// access the real data.
public protocol VoiceShortcutsCenter {
    /// Retrieves all shortcuts added to Siri for the app.
    /// - parameter completionHandler: The block invoked on a background thread after the system retrieves the list of shortcuts.
    /// This block has no return value and takes the following parameters:
    func getSavedShortcuts(completion completionHandler: @escaping (Result<[INVoiceShortcut], NSError>) -> Void)
}

extension INVoiceShortcutCenter: VoiceShortcutsCenter {
    public func getSavedShortcuts(completion completionHandler: @escaping (Result<[INVoiceShortcut], NSError>) -> Void) {
        getAllVoiceShortcuts { shortcuts, error in
            if let error = error {
                completionHandler(.failure(error as NSError))
            }

            completionHandler(.success(shortcuts ?? []))
        }
    }
}

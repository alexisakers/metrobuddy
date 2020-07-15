import Foundation

struct ErrorMessage: Identifiable {
    enum ErrorID: String {
        case cannotSave
    }
    
    let id: ErrorID
    let title: String
    let message: String
}

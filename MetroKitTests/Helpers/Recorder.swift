import Combine
import Foundation

class Recorder<Source: Publisher>: NSObject {
    var recordedElements: [Source.Output] = [] {
        didSet {
            didChangeValue(for: \.recordedElementsCount)
        }
    }
    
    var completion: Subscribers.Completion<Source.Failure>? = nil {
        didSet {
            didChangeValue(for: \.isCompleted)
        }
    }
    
    @objc var isCompleted: Bool {
        return completion != nil
    }
    
    @objc var recordedElementsCount: NSNumber {
        return recordedElements.count as NSNumber
    }
    
    private let source: Source
    private var recordingTask: AnyCancellable?
    
    init(source: Source) {
        self.source = source
        super.init()

        recordingTask = source
            .sink(
                receiveCompletion: {
                    self.completion = $0
                },
                receiveValue: {
                    self.recordedElements.append($0)
                }
            )
    }
    
    var completionPredicate: NSPredicate {
        return NSPredicate(format: "%K == TRUE", #keyPath(isCompleted))
    }
    
    func countPredicate(_ count: Int) -> NSPredicate {
        return NSPredicate(format: "%K == %@", #keyPath(recordedElementsCount), count as NSNumber)
    }
}

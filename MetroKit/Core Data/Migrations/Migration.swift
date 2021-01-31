import CoreData

/// A protocol for objects that can perform a single migration inside a managed object context.
protocol Migration {
    func apply(in context: NSManagedObjectContext) throws
}

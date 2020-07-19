import Foundation

public enum MetroTesting {
    public enum EnvironmentKeys {
        public static let scenarioName = "MetroTestingScenarioName"
    }

    public enum UserInfoKeys {
        public static let cardUpdates = "cardUpdates"
    }

    public static let testDidEmitExternalChangeNotification = Notification.Name("testDidEmitExternalChangeNotification")
}


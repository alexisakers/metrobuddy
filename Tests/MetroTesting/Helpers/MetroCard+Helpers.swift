import Foundation
import MetroKit

extension MetroCard {
    /// Creates a new Metro Card object with a different balance.
    func applyingUpdate(_ balanceUpdate: BalanceUpdate) -> MetroCard {
        return MetroCard(
            id: self.id,
            balance: balance - balanceUpdate.amount,
            expirationDate: self.expirationDate,
            serialNumber: self.serialNumber,
            fare: self.fare
        )
    }

    /// Creates a new Metro Card object with a different expiration date.
    func withExpirationDate(_ expirationDate: Date?) -> MetroCard {
        return MetroCard(
            id: self.id,
            balance: self.balance,
            expirationDate: expirationDate,
            serialNumber: self.serialNumber,
            fare: self.fare
        )
    }

    /// Creates a new Metro Card object with a different serial number.
    func withSerialNumber(_ serialNumber: String?) -> MetroCard {
        return MetroCard(
            id: self.id,
            balance: self.balance,
            expirationDate: self.expirationDate,
            serialNumber: serialNumber,
            fare: self.fare
        )
    }

    /// Creates a new Metro Card object with a different fare.
    func withFare(_ fare: Decimal) -> MetroCard {
        return MetroCard(
            id: self.id,
            balance: self.balance,
            expirationDate: self.expirationDate,
            serialNumber: self.serialNumber,
            fare: fare
        )
    }
}

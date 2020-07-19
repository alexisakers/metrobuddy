import MetroKit

extension MetroCard {
    func withBalance(_ balance: Decimal) -> MetroCard {
        return MetroCard(
            id: self.id,
            balance: balance,
            expirationDate: self.expirationDate,
            serialNumber: self.serialNumber,
            fare: self.fare
        )
    }

    func withExpirationDate(_ expirationDate: Date?) -> MetroCard {
        return MetroCard(
            id: self.id,
            balance: self.balance,
            expirationDate: expirationDate,
            serialNumber: self.serialNumber,
            fare: self.fare
        )
    }

    func withSerialNumber(_ serialNumber: String?) -> MetroCard {
        return MetroCard(
            id: self.id,
            balance: self.balance,
            expirationDate: self.expirationDate,
            serialNumber: serialNumber,
            fare: self.fare
        )
    }

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

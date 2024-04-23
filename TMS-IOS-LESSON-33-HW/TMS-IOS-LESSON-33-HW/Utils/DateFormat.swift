import Foundation

class DateFormat {
    static let dateFormatter = DateFormatter()
    
    static func convertCurrentDateToISO(withFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String {
        let date = Date()
        dateFormatter.dateFormat = withFormat
        return dateFormatter.string(from: date)
    }
    
    static func compareISODateWithCurrentDate(date: String?) -> Int? {
        guard let date else { return nil }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let convertedDate = dateFormatter.date(from: date)
        
        let diff = Calendar(identifier: .gregorian).numberOfDaysBetween(convertedDate!, and: Date())
        
        return diff
    }
}

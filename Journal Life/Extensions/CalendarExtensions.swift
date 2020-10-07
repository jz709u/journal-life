import UIKit

// MARK: - Date Extension

extension Date {
    func formatedString() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: self)
    }
    
    func add(component: Calendar.Component, value: Int, calendar: Calendar = Calendar.autoupdatingCurrent) -> Date? {
        calendar.date(byAdding: component, value: value, to: self, wrappingComponents: true)
    }
}

// MARK: - Calendar Extension

extension Calendar {
    
    /// Get First day from month for this year
    func getFirstDateOf(month: Int, from date: Date = Date()) -> Date? {
        guard let sixMonthsBefore = self.date(byAdding: .month,
                                              value: month,
                                              to: date) else { return nil }
        let comps = dateComponents([.month, .year], from: sixMonthsBefore)
        return self.date(from: comps)
    }
    
    func isLeapYear(_ year: Int) -> Bool { ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)) }
    func isLeapYear(_ date: Date = Date()) -> Bool {
        guard let year = dateComponents([.year], from: date).year else { return false }
        return isLeapYear(year)
    }
    
    func start(of component: Calendar.Component,
               date: Date = Date()) -> Date? {
        
        var dateComps = dateComponents(in: timeZone, from: date)
        switch component {
        case .year:
            dateComps.month = 1
            fallthrough
        case .month, .weekday:
            if component == .month || component == .year {
                dateComps.day = 1
            } else {
                dateComps.weekday = 1
            }
            fallthrough
        case .day:
            dateComps.hour = 0
            fallthrough
        case .hour:
            dateComps.minute = 0
            fallthrough
        case .minute:
            dateComps.second = 0
            fallthrough
        case .second:
            dateComps.nanosecond = 0
        default:
            return nil
        }
        
        return self.date(from: dateComps)
    }
    
    func group<T: DateRepresentable>(dateRepresentables: [T],
                                     component: Calendar.Component) -> [Date: [T]] {
        var returnGroups = [Date: [T]]()
        for datable in dateRepresentables {

            guard let startDateOfComponent = start(of: component, date: datable.date) else { continue }

            if var existingDatables = returnGroups[startDateOfComponent] {
                existingDatables.append(datable)
                
                returnGroups[startDateOfComponent] = existingDatables.sorted(by: >)
                
            } else {
                returnGroups[startDateOfComponent] = [datable]
            }
        }

        return returnGroups
    }
}

// MARK: - DateRepresentable

protocol DateRepresentable: Comparable {
    var date: Date { get }
}

extension DateRepresentable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.date < rhs.date
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.date <= rhs.date
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.date >= rhs.date
    }

    static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.date > rhs.date
    }
}

extension Date: DateRepresentable {
    var date: Date { self }
}

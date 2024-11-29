//
//  Date+Ext.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 1/9/24.
//

import Foundation

extension Date {
    
    private var timeFormater: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    private var dateFormater: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "MM:dd:yy"
        return formatter
    }
    
    private func timeString() -> String {
        return timeFormater.string(from: self)
    }
    
    private func dateString() -> String {
        return dateFormater.string(from: self)
    }
    
    func timestampString() -> String {
        if Calendar.current.isDateInToday(self) {
            return timeString()
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return dateString()
        }
    }
}

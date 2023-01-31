///
///  DateHelper.swift
///
///  DateHelper - A utility/helper to work with dates.
///
///  Apple recommends using the Logger/OSLog instead of print.
///  Logger/OSLog has a low-performance overhead and is archived on the device for
///  later retrieval. Logger is only available from iOS 14, prior versions have to
///  use OSLog. Raise an issue if required.
///
///  Created by Rajai kumar on 01/02/23.
///

import Foundation
import os.log

struct DateHelper{
  
  static let dateFormatterOnce: DateFormatter? = {
    var formatter = DateFormatter()
    formatter.locale = NSLocale.current
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    return formatter
  }()
  
  static func dateFormatter() -> DateFormatter? {
    
    return dateFormatterOnce
  }
  
  static let weekdayFormatterOnce: DateFormatter? = {
    var formatter = DateFormatter()
    formatter.locale = NSLocale.current
    formatter.setLocalizedDateFormatFromTemplate("EEEE")
    return formatter
  }()
  
  static func weekdayFormatter() -> DateFormatter? {
    return weekdayFormatterOnce
  }
  
  static let monthAndDayFormatterOnce: DateFormatter? = {
    var formatter = DateFormatter()
    formatter.locale = NSLocale.current
    formatter.setLocalizedDateFormatFromTemplate("M/d")
    return formatter
  }()
  
  static func monthAndDayFormatter() -> DateFormatter? {
    return monthAndDayFormatterOnce
  }
  
  static let shortDayOfWeekFormatterOnce: DateFormatter? = {
    var formatter = DateFormatter()
    formatter.locale = NSLocale.current
    formatter.dateFormat = "E"
    return formatter
  }()
  
  static func shortDayOfWeekFormatter() -> DateFormatter? {
    return shortDayOfWeekFormatterOnce
  }
  
  
  // Returns the difference in days, ignoring hours, minutes, seconds.
  // If both dates are the same date, returns 0.
  // If firstDate is a day before secondDate, returns 1.
  //
  // Note: Assumes both dates use the "current" calendar.
  
  static func daysFrom(firstDate: Date, toSecondDate secondDate: Date) -> Int {
    let calendar = Calendar.current
    guard let days = calendar.dateComponents([.day],
                                             from: calendar.startOfDay(for: firstDate),
                                             to: calendar.startOfDay(for: secondDate)).day else {
      return 0
    }
    return days
  }
  // Returns the difference in years, ignoring shorter units of time.
  // If both dates fall in the same year, returns 0.
  // If firstDate is from the year before secondDate, returns 1.
  //
  // Note: Assumes both dates use the "current" calendar.
  static func yearsFrom(firstDate: Date, toSecondDate secondDate: Date) -> Int {
    let calendar = Calendar.current
    let units: Set<Calendar.Component> = [.era, .year]
    var components1 = calendar.dateComponents(units, from: firstDate)
    var components2 = calendar.dateComponents(units, from: secondDate)
    components1.hour = 12
    components2.hour = 12
    guard let date1 = calendar.date(from: components1),
          let date2 = calendar.date(from: components2) else {
      Logger.logError("Invalid date.")
      return 0
    }
    guard let result = calendar.dateComponents([.year], from: date1, to: date2).year else {
      Logger.logError("Missing result.")
      return 0
    }
    return result
  }
  
 //Check for future dates and change future date to now if any.
 //Pass the past and present dates as it is.
  private static func changeFutureDateToNow(_ date: Date) -> Date {
      let nowDate = Date()
      return date < nowDate ? date : nowDate
  }
  
  static func dateIsOlderThanToday(_ date: Date?, now: Date?) -> Bool {
    let dayDifference = self.daysFrom(firstDate: date!, toSecondDate: now!)
    return dayDifference > 0
  }
  static func dateIsOlderThanToday(_ date: Date?) -> Bool {
      return self.dateIsOlderThanToday(date, now: Date())
  }

  static func dateIsOlderThanYesterday(_ date: Date?) -> Bool {
      return self.dateIsOlderThanYesterday(date, now: Date())
  }

  static func dateIsOlderThanYesterday(_ date: Date?, now: Date?) -> Bool {
    let dayDifference = self.daysFrom(firstDate: date!, toSecondDate: now!)
      return dayDifference > 1
  }
  
  static func dateIsToday(_ date: Date?) -> Bool {
      return self.dateIsToday(date!, now: Date())
  }

  static func dateIsToday(_ date: Date?, now: Date?) -> Bool {
    let dayDifference = self.daysFrom(firstDate: date!, toSecondDate: now!)
      return dayDifference == 0
  }
}

extension Logger {
  private static var subsystem = Bundle.main.bundleIdentifier!
  
  static let errorLogs = Logger(subsystem: subsystem, category: "errorlogs")
  
  static func logError(_ errorMessage:String){
    Logger.errorLogs.error("\(errorMessage)")
    
  }
  
}

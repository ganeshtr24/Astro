//
//  Date+Extension.swift
//  Astro
//
//  Created by Ganesh TR on 26/03/23.
//

import Foundation

extension Date {
    func getDate(_ format: String = "dd.MM.yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

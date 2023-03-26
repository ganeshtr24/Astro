//
//  String+Extension.swift
//  Astro
//
//  Created by Ganesh TR on 26/03/23.
//

import UIKit

extension Optional where Wrapped == String {
    func validUrl() -> Bool {
        if let urlString = self {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}


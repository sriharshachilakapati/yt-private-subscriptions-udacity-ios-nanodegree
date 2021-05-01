//
//  StringUtils.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 01/05/21.
//

import Foundation

extension String {
    var htmlUnescaped: String {
        guard let attributedString = try? NSAttributedString(
                data: Data(utf8),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil)
        else { return self }

        return attributedString.string
    }
}

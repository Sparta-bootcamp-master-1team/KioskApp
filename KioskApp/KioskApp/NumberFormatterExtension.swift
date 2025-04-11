//
//  NumberFormatterExtension.swift
//  KioskApp
//
//  Created by 양원식 on 4/10/25.
//

import Foundation

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}

extension Int {
    /// 숫자를 천 단위로 구분된 문자열로 변환해주는 프로퍼티입니다.
    var formattedWithSeparator: String {
        return NumberFormatter.decimalFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

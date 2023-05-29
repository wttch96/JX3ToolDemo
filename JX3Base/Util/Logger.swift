//
//  Logger.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation

#if os(iOS)
func logger(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    print(items, separator: separator, terminator: terminator)
}
#endif

#if os(OSX)
func logger(_ format: String, _ args: CVarArg...) {
    print(format)
}
#endif

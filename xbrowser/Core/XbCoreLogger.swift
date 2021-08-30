//
//  XbCoreLogger.swift
//  xbrowser
//
//  Created by Zhang Xiang on 2021/8/27.
//  Copyright © 2021 Zhang Xiang. All rights reserved.
//

import Foundation
import OSLog

class XbCoreLogger : NSObject {
    
    let LOG_LEVEL_DEBUG = 0x01
    let LOG_LEVEL_INFO = 0x01<<1
    let LOG_LEVEL_WARNING = 0x01<<2

    var logLevel = 0x07
    
    public static let Logger = XbCoreLogger()
    
    override init() {
        super.init()
        #if DEBUG
        self.logLevel = self.logLevel | self.LOG_LEVEL_DEBUG
        #endif
    }
    
    func debug(_ format: String, _ vals: CVarArg..., file: String = #file, function: String = #function, line: Int = #line ) {
        if self.LOG_LEVEL_DEBUG & self.logLevel > 0 {
            let subMsg = String(format:format, arguments: vals)
            debugPrint(wrap("DEBUG", subMsg, file:file, function:function, line:line))
        }
    }
    
    func info(_ format: String, _ vals: CVarArg..., file: String = #file, function: String = #function, line: Int = #line ) {
        if self.LOG_LEVEL_INFO & self.logLevel > 0 {
            let subMsg = String(format:format, arguments: vals)
            debugPrint(wrap("INFO", subMsg, file:file, function:function, line:line))        }
    }
    
    func warning(_ format: String, _ vals: CVarArg..., file: String = #file, function: String = #function, line: Int = #line ) {
        if self.LOG_LEVEL_WARNING & self.logLevel > 0 {
            let subMsg = String(format:format, arguments: vals)
            debugPrint(wrap("WARNING", subMsg, file:file, function:function, line:line))        }
    }
    
    private func wrap(_ level: String, _ message: String, file file: String, function function: String, line line: Int) -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short

        // get the date time String from the date object
        formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
        
        let dt = formatter.string(from: currentDateTime)
        //return String(format: "%s %s:%d %s [%s] - %s",
        //              arguments:[dt, file, line, function, level, message])
        
        let fparts = file.split(separator: "/")
        
        var stripFile = file
        if (fparts.count > 2){
            stripFile = "\(fparts[fparts.count - 2])/\(fparts[fparts.count - 1])"
        }
        return "\(dt) \(stripFile):\(line) \(function) [\(level)] - \(message)"
    }
}

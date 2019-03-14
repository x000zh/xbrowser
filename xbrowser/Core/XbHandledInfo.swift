//
//  XbHandledInfo.swift
//  xbrowser
//
//  Created by Zhang Xiang on 2019/3/14.
//  Copyright © 2019 Zhang Xiang. All rights reserved.
//

import Cocoa

class XbHandledInfo: NSObject {
    var url: String
    var bundleIdentifier: String
    
    override init(){
        url = ""
        bundleIdentifier = ""
        super.init()
    }
    
    func toString()->String {
        return String.init(format: "[url: %@, bundleIdentifier: %@]", url, bundleIdentifier)
    }
}

//
//  XbUtil.swift
//  xbrowser
//
//  Created by Zhang Xiang on 2019/3/14.
//  Copyright © 2019 Zhang Xiang. All rights reserved.
//

import Cocoa

class XbUtil: NSObject {
    
    static func getString(_ s: String?) -> String{
        if nil == s {
            return ""
        }else{
            return s as! String
        }
    }
}

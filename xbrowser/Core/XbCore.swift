//
//  XbCore.swift
//  xbrowser
//
//  Created by Zhang Xiang on 2019/3/14.
//  Copyright © 2019 Zhang Xiang. All rights reserved.
//

import Cocoa
import JavaScriptCore

class XbCore: NSObject{

    var ctx:JSContext
    
    
    override init(){
        ctx = JSContext()
        super.init()
        if let xbrowserPath = Bundle.main.path(forResource: "XBrowser", ofType: "js") {
            let lib = try! String(contentsOfFile: xbrowserPath)
            ctx.evaluateScript(lib)
            NSLog("load lib")
            logException()
        }else {
            NSLog("load lib failed")
        }
        loadConfig()
    }
    
    func loadConfig(){
        let configPath = ("~/.xbrowser.js" as NSString).standardizingPath
        do{
            NSLog(configPath)
            let config = try String(contentsOfFile: configPath, encoding: String.Encoding.utf8)
            ctx.evaluateScript(config)
            NSLog("load conf")
            logException()
        }catch let configError as NSError {
            NSLog("load config failed")
        }
    }
    
    func handleUrl(_ url: URL, app: NSApplication) -> XbHandledInfo?{
        //NSLog(url.absoluteString)
        let xBrowser = ctx.objectForKeyedSubscript("xBrowser")
        logException()
        let val = xBrowser?.invokeMethod("getHandledInfo", withArguments: [url.absoluteString, nil])
        logException()
        return parseValue(val)
    }
    
    func parseValue(_ val: JSValue?) -> XbHandledInfo?{
        if(nil == val){
            return nil
        }else{
            let info = XbHandledInfo()
            info.url = getString(val?.forProperty("url"))
            info.bundleIdentifier = getString(val?.forProperty("bundleIdentifier"))
            logException()
            return info
        }
    }
    
    func getString(_ val: JSValue?) -> String {
        if(nil == val){
            return ""
        }else{
            return val?.toString() as! String
        }
    }
    
    func logException() {
        if(nil != ctx.exception){
            NSLog("Exception: %@", getString(ctx.exception))
        }
    }

}

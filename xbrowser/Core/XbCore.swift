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
    
    static var xBrowserKey = "xBrowser"
    
    override init(){
        ctx = JSContext()
        super.init()
        if let xbrowserPath = Bundle.main.path(forResource: "XBrowser", ofType: "js") {
            let lib = try! String(contentsOfFile: xbrowserPath)
            ctx.evaluateScript(lib)
            XbCoreLogger.Logger.info("load lib finished")
            logException()
        }else {
            XbCoreLogger.Logger.warning("load lib failed")
        }
        loadConfig()
    }
    
    func loadConfig(){
        let configPath = ("~/.xbrowser.js" as NSString).standardizingPath
        do{
            XbCoreLogger.Logger.debug("config path: %@", configPath)
            let config = try String(contentsOfFile: configPath, encoding: String.Encoding.utf8)
            ctx.evaluateScript(config)
            XbCoreLogger.Logger.debug("conf loaded")
            logException()
        }catch {
            NSLog("load config failed")
        }
    }
    
    func reloadConfig(){
        let xBrowser = ctx.objectForKeyedSubscript(XbCore.xBrowserKey)
        xBrowser?.invokeMethod("clearHandler", withArguments:nil)
        loadConfig()
    }
    
    func handleUrl(_ url: URL, app: NSApplication) -> XbHandledInfo?{
        //NSLog(url.absoluteString)
        let xBrowser = ctx.objectForKeyedSubscript(XbCore.xBrowserKey)
        logException()
        let opt = makeOpt(url: url, app: app)
        var urlInfo = ""
        do {
            var urlData = Data.init()
            let encoder = JSONEncoder.init()
            
            var urlInfoDic: [String: String] = [
                "hash": "", //#asd
                "hostname": "", //localhost
                "pathname": "",  // /aaa/a.html
                "port": "", //8080
                "protocol": "", // file, https, http
                "username": "", //
                "password": "", //
                "href": url.absoluteURL.absoluteString
            ]
            urlInfoDic["protocol"] = String(format: "%@", arguments: [url.scheme!])
            urlInfoDic["pathname"] = url.path
            if (!url.isFileURL) {
                if (nil != url.host) {
                    urlInfoDic["hostname"] = url.host
                }
                else {
                    urlInfoDic["hostname"] = urlInfoDic["href"]?.replacingOccurrences(of: String(format:"%@:", arguments:[urlInfoDic["protocol"]!]), with: "")
                }
                urlInfoDic["hash"] = XbUtil.getString(url.fragment)
                urlInfoDic["username"] = XbUtil.getString(url.user)
                urlInfoDic["password"] = XbUtil.getString(url.password)
                urlInfoDic["pathname"] = url.path
                if (url.port != nil) {
                    urlInfoDic["port"] = String(format:"%d", url.port!)
                }
            }
            
            
            urlData = try! JSONSerialization.data(withJSONObject: urlInfoDic, options: [])
            urlInfo = String(data: urlData, encoding: String.Encoding.utf8)!
            XbCoreLogger.Logger.debug("urlInfo: %@", [urlInfo])
            let val = xBrowser?.invokeMethod("getHandledInfo",
                                             withArguments: [urlInfo, opt])
            logException()
            return parseValue(val)

        } catch EncodingError.invalidValue(let err, let ctx) {
            print(err)
        } catch {
            
        }
        
        // 没有命中规则
        let info = XbHandledInfo()
        info.url = url.absoluteString
        info.bundleIdentifier = "com.apple.Safari"
        logException()
        return info
    }
    
    func makeOpt(url: URL, app: NSApplication) -> XbHandleOpt? {
        return nil;
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
            XbCoreLogger.Logger.warning("Exception: %@", getString(ctx.exception))
        }
    }

}

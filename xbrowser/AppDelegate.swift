//
//  AppDelegate.swift
//  xbrowser
//
//  Created by Zhang Xiang on 2019/3/13.
//  Copyright © 2019 Zhang Xiang. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var xbCore: XbCore!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let bundleId = Bundle.main.bundleIdentifier!  as CFString
        LSSetDefaultHandlerForURLScheme("http" as CFString, bundleId)
        LSSetDefaultHandlerForURLScheme("https" as CFString, bundleId)
        
        _ = toggleDockIcon(false)
        checkStatusBarItem()
    }
    
    func checkStatusBarItem(){
        let iconSize = NSStatusBar.system.thickness * 0.9
        statusBarItem = NSStatusBar.system.statusItem(
            withLength: NSStatusBar.system.thickness)
        let img = NSImage.init(named: "AppIcon")
        img?.size = NSSize.init(width: iconSize , height: iconSize)
        statusBarItem.button?.image = img
        
        let menu = NSMenu.init()
        menu.addItem(NSMenuItem.init(title: "Reload Config", action: #selector(reloadConfig), keyEquivalent: "R"))
        menu.addItem(NSMenuItem.init(title: "Quit", action: #selector(quit), keyEquivalent: "Q"))
        
        statusBarItem.menu = menu;
    }
    
    @objc func reloadConfig(){
        xbCore.reloadConfig()
    }
    
    @objc func quit(){
        NSApp.terminate(nil)
    }
    
    func applicationWillFinishLaunching(_ aNotification: Notification) {
        xbCore = XbCore()
        window.setIsVisible(false)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        let openInBackground = false
        for url in urls{
            let info = xbCore.handleUrl(url, app: application)
            if(nil != info) {
                NSLog("%@", XbUtil.getString(info?.toString()))
                NSWorkspace.shared.open(
                    [url],
                    withAppBundleIdentifier: info?.bundleIdentifier,
                    options: openInBackground ? NSWorkspace.LaunchOptions.withoutActivation : NSWorkspace.LaunchOptions.default,
                    additionalEventParamDescriptor: nil,
                    launchIdentifiers: nil
                )
            }
        }
    }
    
    @objc func toggleDockIcon(_ state: Bool) -> Bool {
        var result: Bool
        if state {
            result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.regular)
        }
        else {
            result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
        }
        return result
    }
}


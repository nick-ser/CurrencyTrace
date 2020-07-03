//
//  AppDelegate.swift
//  CurrencyTracer
//
//  Created by LoRD on 03.06.2020.
//  Copyright © 2020 LoRD. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem
    var viewController: ViewController?
    
    override init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.viewController = storyboard.instantiateController(withIdentifier: "ViewController")
            as? ViewController
        if(self.viewController == nil) {
            fatalError("Couldn't find ViewController.")
        }
        self.viewController!.configurate(statusItem: statusItem)
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showPopup)
        self.viewController!.startCurrencyTracing()
    }
    
    @objc func showPopup(){
        
        guard let btn = statusItem.button else {
            fatalError("Couldn't find a button.")
        }
        let popoverView = NSPopover()
        popoverView.contentViewController = viewController!
        popoverView.behavior = .transient
        popoverView.show(relativeTo: btn.bounds, of: btn, preferredEdge: .maxY)
        self.viewController!.updateMarketData()
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


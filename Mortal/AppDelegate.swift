//
//  AppDelegate.swift
//  Mortal
//
//  Created by Wanzhang Sheng on 4/24/15.
//  Copyright (c) 2015 Wanzhang Sheng. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var menu: NSMenu!

    var statusItem : NSStatusItem? = nil
    lazy var formatter : NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy-mm-dd"
        return f
    }()
    lazy var life : Life = {
        let date: NSDate = self.formatter.dateFromString("1991-05-11")!
        return Life(birthDate: date)
    }()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusItem!.highlightMode = true
        statusItem!.menu = menu

        updateProgress()
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        timer.fire()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    func currentProgress() -> String {
        return String(format: "%.4f%%, %d hours", life.percentageLived(), life.lifeLeftInHours())
    }

    func updateProgress() {
        let font = NSFont(name: "Lucida Grande", size: 13)
        let dict = [NSFontAttributeName:font!] as [NSObject:AnyObject]
        let title = NSMutableAttributedString(string: currentProgress(), attributes: dict)
        statusItem?.attributedTitle = title
    }

    @IBAction func quit(sender: NSMenuItem) {
        exit(0)
    }

}


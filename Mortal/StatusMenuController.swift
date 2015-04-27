//
//  StatusMenuController.swift
//  Mortal
//
//  Created by Wanzhang Sheng on 4/26/15.
//  Copyright (c) 2015 Wanzhang Sheng. All rights reserved.
//

import Foundation
import Cocoa

class StatusMenuController: NSObject, PreferencesDelegate {

    @IBOutlet weak var menu: NSMenu!

    @IBAction func openPrefs(sender: NSMenuItem) {
        preferencesController.showWindow(nil)
    }

    @IBAction func quit(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }

    lazy var statusItem : NSStatusItem = {
        return NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        }()

    lazy var timer : NSTimer = {
        return NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        }()

    lazy var formatter : NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy-mm-dd"
        return f
        }()

    lazy var life : Life = {
        return Life(birthDate: NSDate())
        }()


    override func awakeFromNib() {
        statusItem.highlightMode = true
        statusItem.menu = menu

        preferencesController.delegate = self

        loadPreferences()
        if (!timer.valid) {
            timer.fire()
        }
    }

    func currentProgress() -> String {
        return String(format: "%.4f%%, %d days left", life.percentageLived(), life.lifeLeftInDays())
    }

    func updateProgress() {
        let font = NSFont(name: "Lucida Grande", size: 13)
        let dict = [NSFontAttributeName:font!] as [NSObject:AnyObject]
        let title = NSMutableAttributedString(string: currentProgress(), attributes: dict)
        statusItem.attributedTitle = title
    }

    // Preferences
    lazy var preferencesController: PreferencesController = {
        return PreferencesController()
        }()

    func loadPreferences() {
        let date = NSUserDefaults.standardUserDefaults().valueForKey("birthday") as? NSDate ?? NSDate()
        life = Life(birthDate: date)
        updateProgress()
    }

    func preferencesDidUpdate() {
        loadPreferences()
    }

}

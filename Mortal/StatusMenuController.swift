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

    lazy var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    lazy var life = Life(birthDate: NSDate())

    override func awakeFromNib() {
        statusItem.highlightMode = true
        statusItem.menu = menu
        preferencesController.delegate = self

        loadPreferences()
        if (!timer.valid) {
            timer.fire()
        }
    }


    // Timer to update progress
    static let UPDATE_INTERVAL: NSTimeInterval = 60 * 60

    lazy var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(StatusMenuController.UPDATE_INTERVAL, target: self, selector: "updateProgress", userInfo: nil, repeats: true)

    func currentProgress() -> String {
        return String(format: "%.4f%%, %d days left", life.percentageLived(), life.lifeLeftInDays())
    }

    func updateProgress() {
        let font = NSFont(name: "Lucida Grande", size: 13)
        let attrsDict = [NSFontAttributeName:font!]
        let title = NSMutableAttributedString(string: currentProgress(), attributes: attrsDict)
        statusItem.attributedTitle = title
    }


    // Preferences
    lazy var preferencesController = PreferencesController()

    func loadPreferences() {
        let date = preferencesController.loadBirthday()
        life = Life(birthDate: date)
        updateProgress()
    }

    func preferencesDidUpdate() {
        loadPreferences()
    }

}

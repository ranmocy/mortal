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

    @IBAction func openPrefs(_ sender: NSMenuItem) {
        preferencesController.showWindow(nil)
    }

    @IBAction func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    lazy var statusItem = NSStatusBar.system.statusItem(withLength: -1)
    lazy var life = Life(birthDate: Date())

    override func awakeFromNib() {
        statusItem.button?.cell?.isHighlighted = true
        statusItem.menu = menu
        preferencesController.delegate = self

        loadPreferences()
        if (!timer.isValid) {
            timer.fire()
        }
    }


    // Timer to update progress
    static let UPDATE_INTERVAL: TimeInterval = 60 * 60

    lazy var timer: Timer = Timer.scheduledTimer(
        timeInterval: StatusMenuController.UPDATE_INTERVAL,
        target: self,
        selector: #selector(StatusMenuController.updateProgress),
        userInfo: nil,
        repeats: true)

    func currentProgress() -> String {
        return String(format: "%.4f%%, %d days left", life.percentageLived(), life.lifeLeftInDays())
    }

    @objc func updateProgress() {
        let font = NSFont(name: "Lucida Grande", size: 13)
        let attrsDict = [NSAttributedString.Key.font:font!]
        let title = NSMutableAttributedString(string: currentProgress(), attributes: attrsDict)
        statusItem.button?.attributedTitle = title
    }


    // Preferences
    lazy var preferencesController : PreferencesController = PreferencesController()

    func loadPreferences() {
        let date = preferencesController.loadBirthday()
        life = Life(birthDate: date)
        updateProgress()
    }

    func preferencesDidUpdate() {
        loadPreferences()
    }

}

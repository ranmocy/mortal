//
//  PreferencesController.swift
//  Mortal
//
//  Created by Wanzhang Sheng on 4/26/15.
//  Copyright (c) 2015 Wanzhang Sheng. All rights reserved.
//

import Cocoa

protocol PreferencesDelegate {
    func preferencesDidUpdate()
}

class PreferencesController: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var birthdayPicker: NSDatePicker!

    var delegate: PreferencesDelegate?

    override var windowNibName : String! {
        return "PreferencesController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)

        birthdayPicker.dateValue = NSUserDefaults.standardUserDefaults().valueForKey("birthday") as? NSDate ?? NSDate()
    }

    func windowWillClose(notification: NSNotification) {
        let date = birthdayPicker.dateValue
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(date, forKey: "birthday")
        delegate?.preferencesDidUpdate()
    }
    
}

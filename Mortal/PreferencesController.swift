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

    override var windowNibName : String! {
        return "PreferencesController"
    }

    override func windowDidLoad() {
        self.window?.center()
        super.windowDidLoad()
        birthdayPicker.dateValue = loadBirthday()
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        self.window?.makeKeyAndOrderFront(sender)
        NSApp.activate(ignoringOtherApps: true)
    }


    // Delegation for saving when close
    var delegate: PreferencesDelegate?

    func windowWillClose(_ notification: Notification) {
        saveBirthday(birthdayPicker.dateValue)
        delegate?.preferencesDidUpdate()
    }


    // get/set birthday with UserDefaults
    static let BIRTHDAY_KEY_NAME = "birthday"

    func loadBirthday() -> Date {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: PreferencesController.BIRTHDAY_KEY_NAME) as? Date ?? Date()
    }

    func saveBirthday(_ date: Date) {
        let defaults = UserDefaults.standard
        defaults.setValue(date, forKey: PreferencesController.BIRTHDAY_KEY_NAME)
    }

}

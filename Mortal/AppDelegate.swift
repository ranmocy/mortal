//
//  AppDelegate.swift
//  Mortal
//
//  Created by Mocy Sheng on 4/24/15.
//  Copyright (c) 2015-2024 Mocy Sheng. All rights reserved.
//

import SwiftUI

private let DEFAULT_LIFESPAN: Int = 60
private let UPDATE_INTERVAL: TimeInterval = 60 * 60  // 1h

@main
struct MortalApp: App {

    // MARK: States

    @AppStorage("birthday") private var birthday = Date.now

    @AppStorage("lifespan") private var lifespan: Int = DEFAULT_LIFESPAN

    @State private var life = Life(birthdate: Date.now, lifespan: DEFAULT_LIFESPAN)

    @State private var progress: String = "Loading..."

    private var timer: Timer?

    init() {
        // Intialize the @State variables directly,
        // otherwise they are initialized independently with their own initial value
        _life = State(initialValue: Life(birthdate: birthday, lifespan: lifespan))
        _progress = State(initialValue: life.toString())

        timer = Timer.scheduledTimer(withTimeInterval: UPDATE_INTERVAL, repeats: true) { [self] _ in
            Task { @MainActor [self] in
                self.progress = self.life.toString()
            }
        }
    }

    // MARK: UI

    @Environment(\.openWindow) private var openWindow

    var body: some Scene {

        // MARK: Menu bar

        MenuBarExtra(progress) {
            Button("Preferences") {
                openWindow(id: "preferences")
                NSApp.activate(ignoringOtherApps: true)
            }.keyboardShortcut("p")

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .onChange(of: birthday) { newBirthday in
            life = Life(birthdate: newBirthday, lifespan: lifespan)
        }
        .onChange(of: lifespan) { newLifespan in
            life = Life(birthdate: birthday, lifespan: newLifespan)
        }
        .onChange(of: life) { newLife in
            progress = newLife.toString()
        }

        // MARK: Preferences window

        let window = Window("Preferences", id: "preferences") {
            VStack(spacing: 20) {
                DatePicker(
                    "Birthday",
                    selection: $birthday,
                    displayedComponents: .date
                )

                HStack {
                    Text("Lifespan")
                    Stepper(
                        value: $lifespan,
                        in: 1...150,
                        step: 1
                    ) {
                        Text("\(lifespan) years")
                    }
                }
            }
            .frame(width: 300, height: 150, alignment: .center)
            .padding()
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)

        if #available(macOS 15.0, *) {
            window.windowLevel(.floating)
        }
    }
}

extension Life {
    func toString() -> String {
        String(format: "%.2f%%, %dd left", self.percentageLived(), self.lifeLeftInDays())
    }
}

extension Date: @retroactive RawRepresentable {
    public var rawValue: Int {
        Int(self.timeIntervalSinceReferenceDate)
    }

    public init?(rawValue: Int) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue))
    }
}

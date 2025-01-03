//
//  Life.swift
//  Mortal
//
//  Created by Mocy Sheng on 4/24/15.
//  Copyright (c) 2015-2024 Mocy Sheng. All rights reserved.
//

import Foundation

struct Life: Equatable {
    static let DAYS_PER_YEAR = 365
    static let HOURS_PER_DAY = 24
    static let SECONDS_PER_HOUR = 60 * 60

    static let HOURS_PER_YEAR = HOURS_PER_DAY * DAYS_PER_YEAR
    static let SECONDS_PER_DAY = SECONDS_PER_HOUR * HOURS_PER_DAY

    let birthdate: Date
    let lifespan: Int

    func percentageLived() -> Double {
        return Double(self.lifeLivedInSeconds()) * 100.0
            / Double(self.lifeSpanInSeconds())
    }

    func lifeSpanInDays() -> Int {
        return Life.DAYS_PER_YEAR * self.lifespan
    }

    func lifeSpanInHours() -> Int {
        return Life.HOURS_PER_DAY * self.lifeSpanInDays()
    }

    func lifeSpanInSeconds() -> Int {
        return Life.SECONDS_PER_HOUR * self.lifeSpanInHours()
    }

    func lifeLivedInSeconds() -> Int {
        return Int(Date().timeIntervalSince(self.birthdate))
    }

    func lifeLivedInHours() -> Int {
        return self.lifeLivedInSeconds() / Life.SECONDS_PER_HOUR
    }

    func lifeLivedInDays() -> Int {
        return self.lifeLivedInHours() / Life.HOURS_PER_DAY
    }

    func lifeLeftInDays() -> Int {
        return self.lifeSpanInDays() - self.lifeLivedInDays()
    }

    func lifeLeftInHours() -> Int {
        return self.lifeSpanInHours() - self.lifeLivedInHours()
    }

    func lifeLeftInSeconds() -> Int {
        return self.lifeSpanInSeconds() - self.lifeLivedInSeconds()
    }
}

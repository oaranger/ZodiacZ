//
//  Broadcast.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 4/4/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    var date: String?
    var week: String?
    var month: String?
    var year: String?
    let sunsign: String?
    let horoscope: String?
}


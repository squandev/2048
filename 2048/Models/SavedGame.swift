//
//  SavedGame.swift
//  2048
//
//  Created by Илья on 08.11.2020.
//

import Foundation

struct SavedGame: Codable {
    var field: [[Int]]
    var counts: Int
    var topCounts: Int
}

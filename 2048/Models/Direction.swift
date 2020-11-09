//
//  Direction.swift
//  2048
//
//  Created by Илья on 06.11.2020.
//

import UIKit

protocol Direction {
    
}

enum directionX: Int, Direction{
    case directionLeft = 1
    case directionRight = -1
}

enum directionY: Int, Direction {
    case directionUp = 1
    case directionDown = -1
}


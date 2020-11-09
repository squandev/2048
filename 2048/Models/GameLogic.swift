//
//  File.swift
//  2048
//
//  Created by Илья on 06.11.2020.
//

import UIKit

protocol GameLogicDelegate {
    /// Pre-launch setting
    func newGame()
    /// Passes the value after vertical swipe one at a time
    func slidingRow(item: ReplacementItem)
    /// Passes the value after horizontal swipe one at a time
    func slidingColumn(item: ReplacementItem)
    /// Passes new random value
    func didRecieveNewValue(point: ItemPoint, value: Int)
    /// Passes new score
    func updateScore(counts: Int)
    /// Passes new top score
    func updateTopScore(count: Int)
    /// Loading past field.
    /// This function passes a value one at a time and passes value only greater than 0
    func loadPreviousGame(point: ItemPoint, value: Int)
    /// Notification about game over
    func gameOver()
}

class GameLogic {
    private(set) static var shared: GameLogic = {
        let gameLogic = GameLogic()
        return gameLogic
    }()
    
    private var field: [[Int]] = []
    var delegate: GameLogicDelegate?
    /// score in current moment
    private(set) var score: Int = 0 {
        willSet {
            delegate?.updateScore(counts: newValue)
        }
    }
    /// top score in current moment
    private(set) var topScore: Int = 0 {
        willSet {
            delegate?.updateTopScore(count: newValue)
        }
    }
    
    private var isGameOver: Bool {
        let up = slide(isChange: false, direction: directionY.directionUp)
        let down = slide(isChange: false, direction: directionY.directionDown)
        let left = slide(isChange: false, direction: directionX.directionLeft)
        let right = slide(isChange: false, direction: directionX.directionRight)
        return !(up || down || left || right)
    }

    /// First start game.
    /// If the previous game exists then it will be loaded.
    func startGame() {
        delegate?.newGame()
        if loadPreviousGame() {
            print("Loaded previous game")
        } else {
            createNewField()
            createNewItem(direction: nil)
            score = 0
            topScore = 0
            print("Creating new game (First Launch)")
        }
    }
    
    /// Laucn restart game
    func restartGame() {
        field = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        if score > topScore {
            topScore = score
        }
        score = 0
        delegate?.newGame()
        createNewItem(direction: nil)
        saveGame()
    }
    
    /// Make a horizontal or vertical move
    func makeMove(direction: Direction) {
        let isCompleted = slide(isChange: true, direction: direction)
        if isCompleted {
            createNewItem(direction: direction)
        }
        if isGameOver {
            print("GameOver")
            if score > topScore {
                topScore = score
            }
            createNewField()
            delegate?.gameOver()
        }
    }
    
    /// Use only on exit. GameLogic himself save game when called function restartGame
    func saveGame() {
        let savedData: SavedGame = SavedGame(field: field, counts: score, topCounts: topScore)
        if let encoded = try? JSONEncoder().encode(savedData) {
            UserDefaults.standard.setValue(encoded, forKey: "savedGame")
        }
    }
}

extension GameLogic {

    private func createNewField() {
        field = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    }
    
    private func initialField(completionHandler: @escaping (ItemPoint, Int) -> Void) {
        for i in 0...3 {
            for j in 0...3 {
                completionHandler(ItemPoint(x: i, y: j), field[i][j])
            }
        }
    }
    
    private func loadPreviousGame() -> Bool {
        if let data = UserDefaults.standard.data(forKey: "savedGame"), let savedData = try? JSONDecoder().decode(SavedGame.self, from: data) {
            field = savedData.field
            score = savedData.counts
            topScore = savedData.topCounts
            initialField { (point, value) in
                self.delegate?.loadPreviousGame(point: point, value: value)
            }
            return true
        }
        return false
    }
    
    private func slide(isChange: Bool, direction: Direction) -> Bool {
        var isCompleted: Bool!
        
        if let direction = direction as? directionX {
            isCompleted = slideDirectionX(isChange: isChange, direction: direction)
        }
        
        if let direction = direction as? directionY {
            isCompleted = slideDirectionY(isChange: isChange, direction: direction)
        }

        return isCompleted
    }
    
    private func createNewItem(direction: Direction?) {
        var x: Int
        var y: Int
        var startX: Int
        var endX: Int
        var startY: Int
        var endY: Int
        
        switch direction {
        case directionY.directionUp?:
            startX = 2
            endX = 3
            startY = 0
            endY = 3
        case directionY.directionDown?:
            startX = 0
            endX = 1
            startY = 0
            endY = 3
        case directionX.directionLeft?:
            startX = 0
            endX = 3
            startY = 2
            endY = 3
        case directionX.directionRight?:
            startX = 0
            endX = 3
            startY = 0
            endY = 1
        default:
            startX = 0
            endX = 0
            startY = 0
            endY = 0
        }
        repeat {
            x = Int.random(in: startX...endX)
            y = Int.random(in: startY...endY)
        } while field[x][y] != 0
        let probalityValue = Int.random(in: 1...10)
        var value: Int
        if probalityValue == 10 {
            value = 4
        } else {
            value = 2
        }
        
        field[x][y] = value
        score += value
        delegate?.didRecieveNewValue(point: ItemPoint(x: x, y: y), value: value)
    }

    private func slideDirectionX(isChange: Bool, direction: directionX) -> Bool {
        /**Взависимости от направления свайпа ряд будет складываться в одну из сторон
           Ряд начинает складываться с конца, например при свайпе вправо ряд будет складываться справа налево
           Это выполнено для того, чтобы все значения заняли свои места и далее нужные значения уже складывались
        **/
        var isCompleted: Bool = false
        let start: Int
        let end: Int
        let offset = direction.rawValue
        if direction == .directionRight {
            start = 3
            end = 0
        } else {
            start = 0
            end = 3
        }
        for row in 0...3 {
            var maxIndex = start
            for i in stride(from: start, through: end, by: offset){
                let oldPoint = ItemPoint(x: row, y: i)
                if field[row][i] != 0 {
                    var value = field[row][i]
                    var indexNewPlace = i   //Место, в которое будет занесено старое или новое значение
                    for j in stride(from: i - offset, through: maxIndex, by: -offset){
                        if field[row][j] == value {
                            indexNewPlace = j
                            value += field[row][j]
                            maxIndex = j+offset
                            break
                        } else if field[row][j] == 0 {
                            indexNewPlace = j
                        } else {
                            break
                        }
                    }
                    if i != indexNewPlace {
                        if isChange {
                            let replacementItem = ReplacementItem(oldPoint: oldPoint, newPoint: ItemPoint(x: row, y: indexNewPlace), value: value)
                            delegate?.slidingRow(item: replacementItem)
                            field[row][i] = 0
                            field[row][indexNewPlace] = value
                        }
                        isCompleted = true
                    }
                }
            }
        }
        return isCompleted
    }
    
    private func slideDirectionY(isChange: Bool, direction: directionY) -> Bool {
        var isCompleted: Bool = false
        let start: Int
        let end: Int
        let offset = direction.rawValue
        var maxIndex: Int
        if direction == .directionUp {
            start = 0
            end = 3
        } else {
            start = 3
            end = 0
        }
        for column in 0...3 {
            maxIndex = start
            for i in stride(from: start, through: end, by: offset){
                let oldPoint = ItemPoint(x: i, y: column)
                if field[i][column] != 0 {
                    var value = field[i][column]
                    var indexNewPlace = i   //Место, в которое будет занесено старое или новое значение
                    for j in stride(from: i - offset, through: maxIndex, by: -offset){
                        if field[j][column] == value {
                            indexNewPlace = j
                            value += field[j][column]
                            maxIndex = j+offset
                            break
                        } else if field[j][column] == 0 {
                            indexNewPlace = j
                        } else {
                            break
                        }
                    }
                    if i != indexNewPlace {
                        if isChange {
                            let replacementItem = ReplacementItem(oldPoint: oldPoint, newPoint: ItemPoint(x: indexNewPlace, y: column), value: value)
                            delegate?.slidingColumn(item: replacementItem)
                            field[i][column] = 0
                            field[indexNewPlace][column] = value
                        }
                        isCompleted = true
                    }
                }
            }
        }
        return isCompleted
    }
}

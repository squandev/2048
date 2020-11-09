//
//  ViewController.swift
//  2048
//
//  Created by Илья on 30.10.2020.
//

import UIKit

class GameViewController: UIViewController {

    lazy var restartButton: UIButton = {
        let buttonRestart = UIButton()
        buttonRestart.translatesAutoresizingMaskIntoConstraints = false
        buttonRestart.setImage(UIImage(named: "restart"), for: .normal)
        buttonRestart.addTarget(self, action: #selector(pressedRestart), for: .touchUpInside)
        return buttonRestart
    }()
    
    lazy var currentCount: CountView = {
        let currentCount = CountView()
        currentCount.backgroundColor = Color.item8
        currentCount.labelCount.textColor = UIColor.black
        currentCount.labelName.textColor = UIColor.black
        currentCount.translatesAutoresizingMaskIntoConstraints = false
        currentCount.layer.cornerRadius = 5
        currentCount.labelName.text = "SCORE"
        return currentCount
    }()
    
    lazy var topCount: CountView = {
        let topCount = CountView()
        topCount.backgroundColor = Color.item8
        topCount.labelCount.textColor = UIColor.black
        topCount.labelName.textColor = UIColor.black
        topCount.translatesAutoresizingMaskIntoConstraints = false
        topCount.layer.cornerRadius = 5
        topCount.labelName.text = "TOP SCORE"
        return topCount
    }()
    
    var fieldView: FieldView!
    
    weak var gameLogic: GameLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        gameLogic = GameLogic.shared
        gameLogic.delegate = self
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameLogic.startGame()
    }

    func setupViews() {
        self.view.addSubview(currentCount)
        self.view.addSubview(restartButton)
        self.view.addSubview(topCount)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([topCount.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                                     topCount.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                                     topCount.widthAnchor.constraint(equalTo: currentCount.widthAnchor)])
        
        NSLayoutConstraint.activate([restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                                     restartButton.leadingAnchor.constraint(equalTo: currentCount.trailingAnchor, constant: 50),
//                                     buttonRestart.widthAnchor.constraint(equalToConstant: 50),
                                     restartButton.heightAnchor.constraint(equalTo: restartButton.widthAnchor),
                                     restartButton.trailingAnchor.constraint(equalTo: topCount.leadingAnchor, constant: -50)])
        
        NSLayoutConstraint.activate([currentCount.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                                     currentCount.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                                     currentCount.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)])
    }
    
    func createFieldView() {
        // Отступ между items и от края field
        let indentBetweenItems: CGFloat = 10
        //Размер одной стороны field (field является квадратом)
        let fieldSideSize = self.view.bounds.width - indentBetweenItems * 2
        // Размер field
        let sizeField = CGSize(width: fieldSideSize, height: fieldSideSize)
        // Точка для размещения field
        let pointField = CGPoint(x: indentBetweenItems, y: self.view.bounds.height / 2 - sizeField.height / 2)
        //размер item
        let itemSize: CGFloat = (sizeField.width  - indentBetweenItems * 5) / 4
        fieldView = FieldView(frame: CGRect(origin: pointField, size: sizeField), indentBetweenItems: indentBetweenItems, itemSize: itemSize)
        fieldView.backgroundColor = Color.field
        fieldView.layer.cornerRadius = indentBetweenItems
        view.addSubview(fieldView)
    }
    
    func setupGestures() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        
        upSwipe.direction = .up
        downSwipe.direction = .down
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        fieldView.addGestureRecognizer(upSwipe)
        fieldView.addGestureRecognizer(downSwipe)
        fieldView.addGestureRecognizer(leftSwipe)
        fieldView.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                gameLogic.makeMove(direction: directionY.directionUp)
            case .down:
                gameLogic.makeMove(direction: directionY.directionDown)
            case .left:
                gameLogic.makeMove(direction: directionX.directionLeft)
            case .right:
                gameLogic.makeMove(direction: directionX.directionRight)
            default:
                print("impossible")
            }
        }
    }
    
    @objc func pressedRestart() {
        gameLogic.restartGame()
    }
}

extension GameViewController: GameLogicDelegate {
    func newGame() {
        createFieldView()
        setupGestures()
    }
    
    func loadPreviousGame(point: ItemPoint, value: Int) {
        fieldView.initialField(point: point, value: value)
    }
    
    func slidingRow(item: ReplacementItem) {
        fieldView.changeValue(oldPoint: item.oldPoint, newPoint: item.newPoint, value: item.value)
    }
    
    func slidingColumn(item: ReplacementItem) {
        fieldView.changeValue(oldPoint: item.oldPoint, newPoint: item.newPoint, value: item.value)
    }
    
    func updateScore(counts: Int) {
        currentCount.labelCount.text = String(counts)
    }
    
    func updateTopScore(count: Int) {
        topCount.labelCount.text = String(count)
    }
    
    func gameOver() {
        view.willRemoveSubview(fieldView)
        let alert = UIAlertController(title: "Game Over", message: "Your score is \(gameLogic.score).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (alertAction) in
            self.gameLogic.restartGame()
            print("New Game")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didRecieveNewValue(point: ItemPoint, value: Int) {
        fieldView.createItem(point: point, value: value)
    }
}


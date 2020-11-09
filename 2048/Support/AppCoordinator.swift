//
//  AppCoordinator.swift
//  2048
//
//  Created by Илья on 08.11.2020.
//

import UIKit

class AppCoordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        launchGame()
    }
    
    private func launchGame() {
        window.rootViewController = GameViewController()
        window.makeKeyAndVisible()
    }
}

//
//  ViewController.swift
//  Skullibrista
//
//  Created by Abner Lima on 29/04/23.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var street: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var vGameOver: UIView!
    @IBOutlet weak var lbTimePlayed: UILabel!
    @IBOutlet weak var lbInstructions: UILabel!
    
    var isMoving: Bool = false
    var gameTimer: Timer!
    lazy var motionManager = CMMotionManager()
    var startDate: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        vGameOver.isHidden = true
        prepareStreet()
        preparePlayer()
        animatePlayer()
        
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { timer in
            self.start()
        }
    }
    
    func prepareStreet() {
        street.frame.size.width = view.frame.size.width * 2
        street.frame.size.height = view.frame.size.height * 2
        street.center = view.center
    }
    
    func preparePlayer() {
        player.center = view.center
    }
    
    func animatePlayer() {
        player.animationImages = []
        
        for i in 0...7 {
            let image = UIImage(named: "player\(i)")!
            player.animationImages?.append(image)
        }
        
        player.animationDuration = 0.5
        player.startAnimating()
    }
    
    func start() {
        lbInstructions.isHidden = true
        vGameOver.isHidden = true
        isMoving = false
        player.transform = CGAffineTransform(rotationAngle: 0)
        street.transform = CGAffineTransform(rotationAngle: 0)
        startDate = Date()
              
        useMotionManager()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { timer in
            self.rotateWorld()
        })
    }
    
    func useMotionManager() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { data, error in
                if error == nil {
                    if let data = data {
                        self.rotatePlayer(x: data.gravity.x, y: data.gravity.y)
                        
                        if !self.isMoving {
                            self.checkGameOver()
                        }
                    }
                }
            }
        }
    }
    
    func rotatePlayer(x: Double, y: Double) {
        let angle = atan2(x, y) - .pi
        player.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
    }
    
    func rotateWorld() {
        let randomAngle = Double(arc4random_uniform(120)) / 100 - 0.6
        isMoving = true
        UIView.animate(withDuration: 0.75, animations: {
            self.street.transform = CGAffineTransform(rotationAngle: randomAngle)
        }) { success in
            self.isMoving = false
        }
    }
    
    func checkGameOver() {
        let worldAngle = atan2(street.transform.a, street.transform.b)
        let playerAngle = atan2(player.transform.a, player.transform.b)
        let difference = abs(worldAngle - playerAngle)
        
        if difference > 0.25 {
            gameTimer.invalidate()
            vGameOver.isHidden = false
            motionManager.stopDeviceMotionUpdates()
            presentSecondsPlayed()
        }
    }
    
    func presentSecondsPlayed() {
        let secondsPlayed = round(Date().timeIntervalSince(startDate))
        lbTimePlayed.text = "Você jogou durante \(secondsPlayed) segundos."
    }

    @IBAction func playAgain(_ sender: UIButton) {
        start()
    }
    
}


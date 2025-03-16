//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let eggTimes = ["Soft": 360, "Medium": 540, "Hard": 720]
    var timer: Timer?
    var player: AVAudioPlayer?
    var totalTime = 0
    var secondsPassed = 0
    var alertShown = false // Flag to track whether the alert has been shown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0.0
        progressLabel.text = "Ready to Begin"
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        resetTimer()
        alertShown = false
        let hardness = sender.currentTitle! // Soft, Medium, Hard
        totalTime = eggTimes[hardness]!
        
        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = hardness
        progressLabel.text = "0 %"
        
        // Start a new timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            playSound(soundName: "ticking-timer", soundFileExtension: "mp3" )
            secondsPassed += 1
            let progress = Float(secondsPassed) / Float(totalTime)
            progressBar.progress = progress
            
            let percentage = Int(progress * 100)
            
            if percentage != 100 {
                progressLabel.text = "In Progress : \(percentage) %"
            } else {
                progressLabel.text = "Completed! : \(percentage) %"
            }
            
        } else {
            resetTimer() // Reset the timer when done
            titleLabel.text = "DONE ! 👍"
            
            playSound(soundName: "completion-alarm", soundFileExtension: "mp3" )
            
            // Alert when done
            if !alertShown {
                showAlert()
                alertShown = true // Set the flag to true after showing the alert
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Yippee... 🙌🏻", message: "Your eggs are ready to be served!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Start another Timer", style: .default, handler: { _ in
            self.stopSound()
            self.resetUI()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func playSound(soundName: String, soundFileExtension: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: soundFileExtension)
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch {
            print("Error initializing audio player: \(error)")
        }
    }
    
    func stopSound() {
        player?.stop()
        player = nil
    }
    
    func resetUI() {
        progressBar.progress = 0.0
        progressLabel.text = "Ready to Begin"
        secondsPassed = 0
        titleLabel.text = "How do you like your eggs?"
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}


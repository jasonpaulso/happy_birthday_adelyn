//
//  ViewController.swift
//  Happy Birthday Adelyn!
//
//  Created by Jason Southwell on 5/29/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit
import WARDoorView
import Spring
import SwiftVideoBackground
import AVKit
import AVFoundation
import Twinkle
import SAConfettiView

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var keyNumberOne: SpringButton!
    @IBOutlet var keyNumberTwo: SpringButton!
    @IBOutlet var keyNumberThree: SpringButton!
    @IBOutlet var topVideoFrame: UIView!
    @IBOutlet var bottomVideoFrame: UIView!
    @IBOutlet var cardDoorsView: WARDoorView!
    @IBOutlet var celebrationView: UIView!
    @IBOutlet var balloon_1: SpringImageView!
    @IBOutlet var balloon_2: SpringImageView!
    @IBOutlet var balloon_3: SpringImageView!
    @IBOutlet var balloon_4: SpringImageView!
    @IBOutlet var balloon_5: SpringImageView!
    @IBOutlet var balloon_6: SpringImageView!
    @IBOutlet var balloon_7: SpringImageView!
    @IBOutlet var balloon_8: SpringImageView!
    @IBOutlet var balloon_9: SpringImageView!
    @IBOutlet var balloon_10: SpringImageView!
    @IBOutlet var balloon_11: SpringImageView!
    @IBOutlet var balloon_12: SpringImageView!
    @IBOutlet var topUnclesLabel: UIImageView!
    @IBOutlet var bottomUnclesLabel: UIImageView!
    @IBOutlet var interiorKeyOutlet: UIButton!
    @IBOutlet var lockButtonOutlet: SpringButton!
    @IBOutlet var happyBanner: UIImageView!
    @IBOutlet var birthdayBanner: SpringImageView!
    @IBOutlet var adelynBanner: UIImageView!
    @IBOutlet var quizPopup: UIView!
    @IBOutlet var muteButtonOutlet: UIButton!
    @IBOutlet var topPlayButton: UIButton!
    @IBOutlet var bottomPlayButton: UIButton!
    
    @IBAction func lockButtonAction(_ sender: Any) {
        quizPopup.isHidden = false
        lockTimer?.invalidate()
        lockButtonOutlet.repeatCount = 0
        lockButtonOutlet.animate()
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {_ in
            self.quizPopup.alpha = 1.0},
                       completion: {_ in})
    }
    
    @IBAction func keyNumberOneAction(_ sender: Any) {
        keyNumberOne.animation = "wobble"
        keyNumberOne.animate()
        thunkSoundPlayer?.seek(to: kCMTimeZero)
        thunkSoundPlayer?.play()
    }
    @IBAction func keyNumberTwoAction(_ sender: Any) {
        keyNumberTwo.animation = "wobble"
        keyNumberTwo.animate()
        thunkSoundPlayer?.seek(to: kCMTimeZero)
        thunkSoundPlayer?.play()
    }
    @IBAction func muteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.audioPlayer?.volume = 0
        } else {
            self.audioPlayer?.volume = 0.2
        }
    }
    @IBAction func topPlayButtonAction(_ sender: Any) {
        topPlayButton.isHidden = true
        topUnclesLabel.isHidden = true
        audioPlayer?.setVolume(0.05, fadeDuration: 1.5)
        topPlayer?.play()
    }
    
    
    @IBAction func bottomPlayButtonAction(_ sender: Any) {
        
        bottomPlayButton.isHidden = true
        bottomUnclesLabel.isHidden = true
        audioPlayer?.setVolume(0.05, fadeDuration: 1.5)
        bottomPlayer?.play()
        
    }
    
    @IBAction func doorOpenButton(_ sender: UIButton) {
        doorsAreOpen = !doorsAreOpen
        if !doorsAreOpen {
            self.keyNumberThree.animate()
            self.fairyWandSoundPlayer?.seek(to: kCMTimeZero)
            self.fairyWandSoundPlayer?.play()
 
            UIView.animate(withDuration: 1, animations: {
                animate in
                self.quizPopup.alpha = 0.0
                self.lockButtonOutlet.alpha = 0.0
                self.cardDoorsView.backgroundColor = .clear
                self.celebrationView.isUserInteractionEnabled = false
            }, completion: {
                completion in
                self.lockButtonOutlet.isHidden = true
                self.quizPopup.isHidden = true
                self.animateBannerOut()
                self.cardDoorsView.open(90, duration: 5, delay: 0, completion: {open in })
                self.animateBalloonsIn()
                UIView.animate(withDuration: 1, delay: 5, options: [.curveEaseIn], animations: {_ in
                    self.interiorKeyOutlet.alpha = 1.0
                    self.muteButtonOutlet.alpha = 1.0
                }, completion: {_ in})
            })
        } else {
            cardDoorsView.close(5, delay: 0, completion: {open in
           
                self.lockButtonOutlet.isHidden = false
                UIView.animate(withDuration: 1, animations: {
                    animate in
                    self.lockButtonOutlet.alpha = 1.0
                    self.cardDoorsView.backgroundColor = self.doorsBackGroundColor
                    self.celebrationView.isUserInteractionEnabled = true
                }, completion: {
                    completion in
                    self.celebrationView.isHidden = false
                    self.interiorKeyOutlet.alpha = 0.0
                    self.muteButtonOutlet.alpha = 0.0
                    self.animateBannerIn()
                    self.startLockAnimationTimer()
                })
                
            }
            )
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHeight = view.bounds.height
        animateBannerIn()
        doorsBackGroundColor = cardDoorsView.backgroundColor
        
        setUpAudioPlayer()
        setupVideoPlayers()
        setUpTwinklingElements()
        hideBanners()
        hideBalloons()
        quizPopup.alpha = 0.0
        interiorKeyOutlet.alpha = 0.0
        muteButtonOutlet.alpha = 0.0
        
        startLockAnimationTimer()
        
        fairyWandSound = Bundle.main.url(forResource: "fairy", withExtension: "wav")
        fairyWandSoundPlayer = AVPlayer(url: fairyWandSound!)
        
        thunkSound = Bundle.main.url(forResource: "thunk", withExtension: "wav")
        thunkSoundPlayer = AVPlayer(url: thunkSound!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUpTwinklingElements), name:
            NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var doorsBackGroundColor: UIColor?
    var viewHeight: CGFloat!
    var doorsAreOpen = true
    var lockTimer: Timer?
    var fairyWandSound: URL?
    var fairyWandSoundPlayer: AVPlayer?
    var thunkSound: URL?
    var thunkSoundPlayer: AVPlayer?
    var topVideoUrl: URL?
    var bottomVideoUrl: URL?
    var topPlayer: AVPlayer?
    var bottomPlayer: AVPlayer?
    var audioPlayer: AVAudioPlayer?
    
    
    private func startLockAnimationTimer() {
        lockTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true, block: {_ in
            self.lockButtonOutlet.delay = 3
            self.lockButtonOutlet.animation = "wobble"
            self.lockButtonOutlet.force = 0.5
            self.lockButtonOutlet.curve = "easeInOut"
            self.lockButtonOutlet.animate()
            
            
        })
    }
    
    @objc private func setUpTwinklingElements() {
        
        Twinkle.twinkle(self.lockButtonOutlet, infiniteRepeat: true)
        Twinkle.twinkle(self.interiorKeyOutlet, infiniteRepeat: true)
        
        
    }
    
    @objc private func audioPlayerDidFinishPlaying() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayerDidFinishPlaying()

    }
    
    
    private func setUpAudioPlayer() {
        
        let audioItemUrl = Bundle.main.url(forResource: "song", withExtension: "mp3")
    
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioItemUrl!)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)

        }
        catch{
            print(error)
        }
        audioPlayer?.delegate = self
        audioPlayer?.volume = 0.3
        audioPlayer?.play()
        
        
    }
    
    
    
    private func setupVideoPlayers() {
        
        topVideoUrl = Bundle.main.url(forResource: "m&c", withExtension: "MOV")
        bottomVideoUrl = Bundle.main.url(forResource: "Anton & Jason HBDA", withExtension: "mp4")
        
        topPlayer = AVPlayer(playerItem: AVPlayerItem(url: topVideoUrl!))
        bottomPlayer = AVPlayer(playerItem: AVPlayerItem(url: bottomVideoUrl!))
        
        let topPlayerLayer = AVPlayerLayer(player: topPlayer)
        topPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        topPlayerLayer.masksToBounds = true
        self.topVideoFrame.layer.addSublayer(topPlayerLayer)
        topPlayerLayer.frame = self.topVideoFrame.bounds
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.topPlayerDidFinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: topPlayer?.currentItem)
        let bottomPlayerLayer = AVPlayerLayer(player: bottomPlayer)
        bottomPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        bottomPlayerLayer.masksToBounds = true
        self.bottomVideoFrame.layer.addSublayer(bottomPlayerLayer)
        bottomPlayerLayer.frame = self.bottomVideoFrame.bounds
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.bottomPlayerDidFinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: bottomPlayer?.currentItem)
        
    }
    
    @objc private func topPlayerDidFinishPlaying(note: NSNotification) {
        topPlayButton.isHidden = false
        topUnclesLabel.isHidden = false
        topPlayer?.seek(to: kCMTimeZero)
        
        audioPlayer?.setVolume(0.2, fadeDuration: 3)
        
    }
    @objc private func bottomPlayerDidFinishPlaying(note: NSNotification) {
        bottomPlayButton.isHidden = false
        bottomUnclesLabel.isHidden = false
        bottomPlayer?.seek(to: kCMTimeZero)
        
        audioPlayer?.setVolume(0.2, fadeDuration: 3)
    }
    
    
    
    private func hideBanners() {
        happyBanner.center.y -= viewHeight
        birthdayBanner.center.y -= viewHeight
        adelynBanner.center.y -= viewHeight
    }
    
    private func hideBalloons() {
        balloon_1.center.y += viewHeight
        balloon_2.center.y += viewHeight
        balloon_3.center.y += viewHeight
        balloon_4.center.y += viewHeight
        balloon_5.center.y += viewHeight
        balloon_6.center.y += viewHeight
        balloon_7.center.y += viewHeight
        balloon_8.center.y += viewHeight
        balloon_9.center.y += viewHeight
        balloon_10.center.y += viewHeight
        balloon_11.center.y += viewHeight
        balloon_12.center.y += viewHeight
    }
    
    private func animateBannerIn() {
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {_ in
            self.happyBanner.center.y += self.viewHeight
        }, completion: {_ in
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {_ in
                self.birthdayBanner.center.y += self.viewHeight
            }, completion: {_ in
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {_ in
                    self.adelynBanner.center.y += self.viewHeight
                }, completion: {_ in
                })
                
            })
            
        })
        
        
    }
    private func animateBannerOut() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {_ in
            self.happyBanner.center.y -= self.viewHeight
        }, completion: {_ in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {_ in
                self.birthdayBanner.center.y -= self.viewHeight
            }, completion: {_ in
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {_ in
                    self.adelynBanner.center.y -= self.viewHeight
                }, completion: {_ in
                })
                
            })
            
        })
        
        
    }
    
    private func animateBalloonsIn() {
        let confettiView = SAConfettiView(frame: view.bounds)
        confettiView.startConfetti()
        confettiView.isUserInteractionEnabled = false
        view.addSubview(confettiView)
        UIView.animate(withDuration: 15, delay: 0.2, options: [.curveEaseOut], animations: {_ in
            
            self.balloon_1.animation = "wobble"
            self.balloon_1.duration = 20
            self.balloon_1.animate()
            self.balloon_1.center.y -= (self.view.bounds.height * 2)
            self.balloon_1.center.x += 3
            delay(delay: 1, closure: {})
            self.balloon_12.animation = "wobble"
            self.balloon_12.duration = .infinity
            self.balloon_12.animate()
            self.balloon_12.center.y -= (self.view.bounds.height * 2)
            self.balloon_12.center.x += 3
            
        }, completion: {_ in
            self.balloon_1.center.y += (self.view.bounds.height * 2)
            self.balloon_12.center.y += (self.view.bounds.height * 2)
        })
        UIView.animate(withDuration: 15, delay: 0.4, options: [.curveEaseOut], animations: {_ in
            self.balloon_2.animation = "wobble"
            self.balloon_2.duration = .infinity
            self.balloon_2.animate()
            self.balloon_2.center.y -= (self.view.bounds.height * 2)
            self.balloon_2.center.x -= 10
            delay(delay: 2, closure: {})
            self.balloon_11.animation = "wobble"
            self.balloon_11.duration = 20
            self.balloon_11.animate()
            self.balloon_11.center.y -= (self.view.bounds.height * 2)
            self.balloon_11.center.x -= 10
            
        }, completion: {_ in
            self.balloon_2.center.y += (self.view.bounds.height * 2)
            self.balloon_11.center.y += (self.view.bounds.height * 2)
        })
        UIView.animate(withDuration: 15, delay: 0.1, options: [.curveEaseOut], animations: {_ in
            self.balloon_3.animation = "wobble"
            self.balloon_3.duration = 20
            self.balloon_3.animate()
            self.balloon_3.center.y -= (self.view.bounds.height * 2)
            self.balloon_3.center.x += 4
            delay(delay: 1, closure: {})
            self.balloon_10.animation = "wobble"
            self.balloon_10.duration = 20
            self.balloon_10.animate()
            self.balloon_10.center.y -= (self.view.bounds.height * 2)
            self.balloon_10.center.x += 4
        }, completion: {_ in
            self.balloon_3.center.y += (self.view.bounds.height * 2)
            self.balloon_10.center.y += (self.view.bounds.height * 2)
        })
        UIView.animate(withDuration: 15, delay: 0.3, options: [.curveEaseOut], animations: {_ in
            self.balloon_4.animation = "wobble"
            self.balloon_4.duration = 20
            self.balloon_4.animate()
            self.balloon_4.center.y -= (self.view.bounds.height * 2)
            self.balloon_4.center.x += 12
            delay(delay: 3, closure: {})
            self.balloon_9.animation = "wobble"
            self.balloon_9.duration = 20
            self.balloon_9.animate()
            self.balloon_9.center.y -= (self.view.bounds.height * 2)
            self.balloon_9.center.x += 12
        }, completion: {_ in
            self.balloon_4.center.y += (self.view.bounds.height * 2)
            self.balloon_9.center.y += (self.view.bounds.height * 2)
        })
        UIView.animate(withDuration: 15, delay: 0.2, options: [.curveEaseOut], animations: {_ in
            self.balloon_5.animation = "wobble"
            self.balloon_5.duration = 20
            self.balloon_5.animate()
            self.balloon_5.center.y -= (self.view.bounds.height * 2)
            self.balloon_5.center.x -= 5
            delay(delay: 0.5, closure: {})
            self.balloon_8.animation = "wobble"
            self.balloon_8.duration = 20
            self.balloon_8.animate()
            self.balloon_8.center.y -= (self.view.bounds.height * 2)
            self.balloon_8.center.x -= 5
        }, completion: {_ in
            self.balloon_5.center.y += (self.view.bounds.height * 2)
            self.balloon_8.center.y += (self.view.bounds.height * 2)
        })
        UIView.animate(withDuration: 15, delay: 0.5, options: [.curveEaseOut], animations: {_ in
            self.balloon_6.animation = "wobble"
            self.balloon_6.duration = 20
            self.balloon_6.animate()
            self.balloon_6.center.y -= (self.view.bounds.height * 2)
            self.balloon_6.center.x -= 10
            delay(delay: 2, closure: {})
            self.balloon_7.animation = "wobble"
            self.balloon_7.duration = 20
            self.balloon_7.animate()
            self.balloon_7.center.y -= (self.view.bounds.height * 2)
            self.balloon_7.center.x -= 10
        }, completion: {_ in
            self.balloon_6.center.y += (self.view.bounds.height * 2)
            self.balloon_7.center.y += (self.view.bounds.height * 2)
            self.celebrationView.isHidden = true
            confettiView.stopConfetti()
            
        })
    }
    
    
    
}


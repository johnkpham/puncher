//
//  ViewController.swift
//  punching_bag
//
//  Created by John Pham on 9/9/16.
//  Copyright © 2016 John Pham. All rights reserved.
//

import UIKit
// allows us to use speakers on iphone
import AVFoundation
import MapKit
import CoreLocation
import CoreMotion
class ViewController: UIViewController {
    @IBOutlet weak var blueBall: UIImageView!
    @IBOutlet weak var redBall: UIImageView!
    @IBOutlet weak var bag: UIImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet weak var scorecounterlabel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var timertracker: UILabel!
    @IBOutlet weak var highscore: UILabel!
    @IBOutlet weak var newhighscore: UIView!
    @IBOutlet weak var challengestartText: UILabel!
    @IBOutlet weak var challengewintext: UILabel!
    
    @IBAction func changeBag(sender: UIButton) {
        if !isDonald{
            challengewintext.text = "YOU SAVED AMERICA"
            challengestartText.text = "STOP DONALD"
            bag.image = UIImage(named: "donald.png")
            isDonald = true
            ryuaudioplayer.stop()
            quoteaudioplayer.play()
            delay = 6.5
            timertrackervariable = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(highScore), userInfo: nil, repeats: false)
        }
        else{
            challengewintext.text = "NEW HIGH SCORE"
            challengestartText.text = "HIT THE BAG AS FAST AS YOU CAN"
            bag.image = UIImage(named: "everlast_pb.png")
            isDonald = false
        }
    }
    
    var imageArray=[UIImage]()
    @IBOutlet weak var challengestart: UIView!
    // need gloves to be on top of the punching bag
    // need to fix return/final (after animation) destination of gloves
    // hold OPTION and left click over syntax for better understanding if questions remain
    
    @IBAction func leftButtonPressed(sender: UIButton) {
        leftPunch()
        bagPunch()
    }
    func leftPunch(){
        self.blueBall.center.x = self.view.center.x - 10 // Starting point of animation (not to be confused with return.
        self.blueBall.center.y = self.view.center.y - 10
        
        UIView.animateWithDuration(3.5,
                                   delay: 0,
                                   usingSpringWithDamping: 5, // spring with damping is like a recoil effect
            initialSpringVelocity: 5.0,
            options: [],
            animations: ({
                self.blueBall.center.x = self.view.frame.width / 10
                self.blueBall.center.y = self.view.frame.height / 1.15
            }),
            completion: nil
        )
        if isDonald{
            s5audioplayer.currentTime = 0
            s5audioplayer.play()
        }
    } // end of leftPunch()
    
    
    @IBAction func rightButtonPressed(sender: UIButton) {
        rightPunch()
        bagPunch()
    }
    func rightPunch(){
        redBall.center.x = self.view.center.x + 10
        redBall.center.y = self.view.center.y + 10
        
        UIView.animateWithDuration(3.5,
                                   delay: 0,
                                   usingSpringWithDamping: 2,
                                   initialSpringVelocity: 5.0,
                                   options: [],
                                   animations: ({
                                    self.redBall.center.x = (self.view.frame.width / 10) * 9 // final position after animation - horizontal. Will need to tweak so that the initial and return destination matches.
                                    self.redBall.center.y = self.view.frame.height / 1.15 //like the comment above but it's for vertical.
                                   }), completion: nil)
        if isDonald{
            s4audioplayer.currentTime = 0
            s4audioplayer.play()
        }
    }
    func bagPunch() {
        self.bag.transform = CGAffineTransformMakeScale(0.6, 0.6)
        UIView.animateWithDuration(1.5,
                                   delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 8.0,
                                   options: [],
                                   animations: ({
                                    self.bag.transform = CGAffineTransformIdentity;
                                   }), completion: nil)
        if gamerunning{
            scorecounter += 1
            scorecounterlabel.text = String(scorecounter)
        }
    }
    //initialize motion manager
    var motionManager = CMMotionManager() //accel AND rot
    //initialize slap noise
    var buttonaudiourl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("slap", ofType: ".mp3")!)
    var buttonaudioplayer = AVAudioPlayer()
    //initialize punch noise
    var punchurl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("punch", ofType: ".mp3")!)
    var punchaudioplayer = AVAudioPlayer()
    //initialize kiss noise
    var kissurl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kiss", ofType: ".mp3")!)
    var kissaudioplayer = AVAudioPlayer()
    var ryuaudiourl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ryu", ofType: ".mp3")!)
    var ryuaudioplayer = AVAudioPlayer()
    var bellstartaudiourl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bellstart", ofType: ".mp3")!)
    var bellstartaudioplayer = AVAudioPlayer()
    var bellendaudiourl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bellend", ofType: ".mp3")!)
    var bellendaudioplayer = AVAudioPlayer()
    var victoryaudiourl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("victory", ofType: ".mp3")!)
    var victoryaudioplayer = AVAudioPlayer()
    var quoteaudiourl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("quote", ofType: ".mp3")!)
    var quoteaudioplayer = AVAudioPlayer()
    var s4audiourl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("s4", ofType: ".mp3")!)
    var s4audioplayer = AVAudioPlayer()
    var s5audiourl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("s5", ofType: ".mp3")!)
    var s5audioplayer = AVAudioPlayer()
    //these variables store motion sensor data.
    var gyrox:Double = 0.0
    var gyroy:Double = 0.0
    var gyroz:Double = 0.0
    var accx:Double = 0.0
    var accy:Double = 0.0
    var accz:Double = 0.0
    //Score counter variables
    var scorecounter = 0
    var highscorecounter = 0
    var gamerunning = false
    var timer = 0.0
    //timers to delay actions
    var timertrackervariable = NSTimer()
    var delay = 2.0
    
    var isDonald = false
    
    @IBAction func start(sender: AnyObject) {
        //code for the game start
        timertrackervariable.invalidate()
        ryuaudioplayer.stop()
        bellstartaudioplayer.play()
        challengestart.hidden = false
        self.challengestart.transform = CGAffineTransformMakeScale(0.2, 0.2)
        UIView.animateWithDuration(1.5,
                                   delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 10.0,
                                   options: [],
                                   animations: ({
                                    self.challengestart.transform = CGAffineTransformIdentity;
                                   }), completion: nil)
//        sleep(2)
        delay = 2.5
        timertrackervariable = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(startGame), userInfo: nil, repeats: false)
//        challengestart.hidden = true
//        ryuaudioplayer.play()
//        gamerunning = true
//        timer = 13.0
//        timertracker.hidden = false
//        scorecounterlabel.text = "0"
//        scorecounter = 0
    }
    func startGame() {
        challengestart.hidden = true
        ryuaudioplayer.play()
        gamerunning = true
        timer = 10.0
        timertracker.hidden = false
        scorecounterlabel.text = "0"
        scorecounter = 0
    }
    //executes when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonaudioplayer = try! AVAudioPlayer(contentsOfURL: buttonaudiourl, fileTypeHint: nil)
        punchaudioplayer = try! AVAudioPlayer(contentsOfURL: punchurl, fileTypeHint: nil)
        bellstartaudioplayer = try! AVAudioPlayer(contentsOfURL: bellstartaudiourl, fileTypeHint: nil)
        bellendaudioplayer = try! AVAudioPlayer(contentsOfURL: bellendaudiourl, fileTypeHint: nil)
        kissaudioplayer = try! AVAudioPlayer(contentsOfURL: kissurl, fileTypeHint: nil)
        ryuaudioplayer = try! AVAudioPlayer(contentsOfURL: ryuaudiourl, fileTypeHint: nil)
        victoryaudioplayer = try! AVAudioPlayer(contentsOfURL: victoryaudiourl, fileTypeHint: nil)
        quoteaudioplayer = try! AVAudioPlayer(contentsOfURL: quoteaudiourl, fileTypeHint: nil)
        s4audioplayer = try! AVAudioPlayer(contentsOfURL: s4audiourl, fileTypeHint: nil)
        s5audioplayer = try! AVAudioPlayer(contentsOfURL: s5audiourl, fileTypeHint: nil)
        ryuaudioplayer.volume = 0.2
        ryuaudioplayer.numberOfLoops = 3
        ryuaudioplayer.play()
        motionManager.gyroUpdateInterval = 0.2
        motionManager.accelerometerUpdateInterval = 0.2
//        scorelabel.hidden = true
//        scorecounterlabel.hidden = true
        timertracker.hidden = true
        challengestart.hidden = true
        newhighscore.hidden = true
        //Start Recording Data
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            self.outputAccData(accelerometerData!.acceleration) // this is the function that gets executed every 0.2 seconds
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
            self.outputRotData(gyroData!.rotationRate)
            if (NSError != nil){
                print("\(NSError)")
            }
        })
        mainScrollView.frame = view.frame
        imageArray = [UIImage(named: "white.png")!, UIImage(named: "gym7.jpg")!, UIImage(named: "gym8.jpg")!, UIImage(named: "gym4.jpg")!]
        for i in 0..<imageArray.count{
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .ScaleToFill
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
    } // end of viewDidLoad()
    
    func outputAccData(acceleration: CMAcceleration){
        //update the values so that we can access them from any method
        accx = acceleration.x
        accy = acceleration.y
        accz = acceleration.z
    } // end of outputAccData()
    func highScore(){
        ryuaudioplayer.play()
        newhighscore.hidden = true
    }
    func outputRotData(rotation: CMRotationRate){
        gyrox = rotation.x
        gyroy = rotation.y
        gyroz = rotation.z
        if gamerunning{
            if timer <= 0 {
                gamerunning = false
                timertracker.text = "0.0"
                ryuaudioplayer.stop()
                bellendaudioplayer.play()
                sleep(2)
                if scorecounter > highscorecounter{
                    highscorecounter = scorecounter
                    highscore.text = String(highscorecounter)
                    newhighscore.hidden = false
                    self.newhighscore.transform = CGAffineTransformMakeScale(0.2, 0.2)
                    victoryaudioplayer.play()
                    UIView.animateWithDuration(1.5,
                                               delay: 0,
                                               usingSpringWithDamping: 1,
                                               initialSpringVelocity: 10.0,
                                               options: [],
                                               animations: ({
                                                self.newhighscore.transform = CGAffineTransformIdentity;
                                               }), completion: nil)
                    timertrackervariable = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(highScore), userInfo: nil, repeats: false)
                }
                ryuaudioplayer.play()
            }
            else{
                timer -= 0.2
                timer = round((timer*10))/10
                timertracker.text = String(timer)
            }
        }
        //this is the right punch action
        if inputAboveThreshold() == 1{
            rightPunch()
            bagPunch()
            buttonaudioplayer.stop()
            buttonaudioplayer.currentTime = 0.1
            buttonaudioplayer.play()
        }
        //This is the left punch action
        if inputAboveThreshold() == 2 {
            leftPunch()
            bagPunch()
            punchaudioplayer.stop()
            punchaudioplayer.currentTime = 0.1
            punchaudioplayer.play()
        }
    } // end of outputRotData
    //this function handles the logic of determining whether the sensor data passed the threshold
    func inputAboveThreshold() -> Int {
        if gyrox > 3 {
            return 1
        }
        if gyrox < -3 {
            return 2
        }
        return 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


//
//  PlayViewController.swift
//  tesnavigate
//
//  Created by IOS on 14/06/22.
//

import UIKit
import AVFoundation
import FirebaseCore
import FirebaseDatabase

class PlayViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet var soundButton: [UIButton]!
    
    var sound1Player:AVAudioPlayer!
    var sound2Player:AVAudioPlayer!
    var sound3Player:AVAudioPlayer!
    var sound4Player:AVAudioPlayer!
    
    var playerturn = false
    var level = 1
    var r = [Int]()
    var index = 0
    var count = 0
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioFiles()
        ref = Database.database(url: "https://tes2ios-94675-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        // Do any additional setup after loading the view.
    }
    
    func setupAudioFiles (){
        
        let soundpath = Bundle.main.path(forResource: "SoundMemory_1", ofType: "wav")
        let soundfileURL = URL(fileURLWithPath: soundpath!)
        
        let soundpath2 = Bundle.main.path(forResource: "SoundMemory_2", ofType: "wav")
        let soundfileURL2 = URL(fileURLWithPath: soundpath2!)
        
        let soundpath3 = Bundle.main.path(forResource: "SoundMemory_3", ofType: "wav")
        let soundfileURL3 = URL(fileURLWithPath: soundpath3!)
        
        let soundpath4 = Bundle.main.path(forResource: "SoundMemory_4", ofType: "wav")
        let soundfileURL4 = URL(fileURLWithPath: soundpath4!)
        
        do {
            try sound1Player = AVAudioPlayer(contentsOf: soundfileURL)
            try sound2Player = AVAudioPlayer(contentsOf: soundfileURL2)
            try sound3Player = AVAudioPlayer(contentsOf: soundfileURL3)
            try sound4Player = AVAudioPlayer(contentsOf: soundfileURL4)
        } catch {
            print(error)
        }
        
        sound1Player.delegate = self
        sound2Player.delegate = self
        sound3Player.delegate = self
        sound4Player.delegate = self
        
        sound1Player.numberOfLoops = 0
        sound2Player.numberOfLoops = 0
        sound3Player.numberOfLoops = 0
        sound4Player.numberOfLoops = 0
    }
    
    @IBAction func startgame(_ sender: Any) {
        scorelabel.text = "Level 1"
        statuslabel.text = "Wait"
        disablebtn()
        let rand = Int(arc4random_uniform(4)+1)
        r.append(rand)
        playnext()
    }
    func nextround() {
        level += 1
        scorelabel.text = "Level \(level)"
        playerturn = false
        count = 0
        index = 0
        statuslabel.text = "Wait"
        disablebtn()
        
        let rand = Int(arc4random_uniform(4)+1)
        r.append(rand)
        playnext()

    }
   
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (index <= r.count-1) {
            playnext()
        } else {
            playerturn = true
            resetButtonHIghlight()
            statuslabel.text = "Your Turn"
            enablebtn()
        }
    }
    
    func resetgame() {
        disablebtn()
        let val = ["Score": level]
        ref.child("Leaderboard").childByAutoId().setValue(val)
        scorelabel.text = "Level \(level)"
        level = 1
        playerturn = false
        count = 0
        index = 0
        r = [Int]()
        statuslabel.text = "GAME OVER"
    }
    
    @IBAction func pressSoundButton(_ sender: Any) {
        if(playerturn == true){
        let button = sender as! UIButton
        if(button.tag == 1) {
            highlightButtonWithTag(tag: 1)
            sound1Player.play()
            check(buttonPressed: 1)
        } else if(button.tag == 2){
            highlightButtonWithTag(tag: 2)
            sound2Player.play()
            check(buttonPressed: 2)
        } else if(button.tag == 3){
            highlightButtonWithTag(tag: 3)
            sound3Player.play()
            check(buttonPressed: 3)
        } else if(button.tag == 4){
            highlightButtonWithTag(tag: 4)
            sound4Player.play()
            check(buttonPressed: 4)
        }
        
    }
    }
    
    func check(buttonPressed:Int) {
        if (buttonPressed == r[count]) {
            if (count == r.count-1){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.nextround()
                }
            }
            count += 1
        } else {
            resetgame()
        }
    }
    
    func playnext() {
        let selectedbtn = r[index]
        
        if(selectedbtn == 1) {
            highlightButtonWithTag(tag: 1)
            sound1Player.play()
        } else if(selectedbtn == 2){
            highlightButtonWithTag(tag: 2)
            sound2Player.play()
        } else if(selectedbtn == 3){
            highlightButtonWithTag(tag: 3)
            sound3Player.play()
        } else if(selectedbtn == 4){
            highlightButtonWithTag(tag: 4)
            sound4Player.play()
        }
        
        index+=1
    }
    
    func highlightButtonWithTag (tag:Int) {
        if(tag == 1) {
            resetButtonHIghlight()
            soundButton[tag-1].setImage(UIImage(named:"darkred"), for: .normal)
        } else if(tag == 2) {
            resetButtonHIghlight()
            soundButton[tag-1].setImage(UIImage(named:"darkblue"), for: .normal)
        } else if(tag == 3) {
            resetButtonHIghlight()
            soundButton[tag-1].setImage(UIImage(named:"darkgreen"), for: .normal)
        } else if(tag == 4) {
            resetButtonHIghlight()
            soundButton[tag-1].setImage(UIImage(named:"darkyellow"), for: .normal)
        }
    }
    
    func resetButtonHIghlight() {
        soundButton[0].setImage(UIImage(named:"red"), for: .normal)
        soundButton[1].setImage(UIImage(named:"blue"), for: .normal)
        soundButton[2].setImage(UIImage(named:"green"), for: .normal)
        soundButton[3].setImage(UIImage(named:"yellow"), for: .normal)
    }

    func disablebtn () {
            for button in soundButton {
                button.isUserInteractionEnabled = false
            }
        }
        
    func enablebtn () {
            for button in soundButton {
                button.isUserInteractionEnabled = true
            }
        }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



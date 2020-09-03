//
//  SpeechViewController.swift
//  conanSpeech
//
//  Created by 方芸萱 on 2020/8/6.
//

import UIKit
import AVFoundation

class SpeechViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var speech: UITextField!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!

    var sentence = ""
    var speechUtterance = AVSpeechUtterance()
    let synthesizer = AVSpeechSynthesizer()
    var playButtonStatus:status = .statusPlay
    enum status{
        case statusPlay, statusPause, statusPlayAfterPause
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        initial()
    }
    
    func initial(){
        //rate 0-1
        speedSlider.maximumValue = 10
        speedSlider.minimumValue = 1
        speedSlider.setValue(6, animated: true)
        speedLabel.text = String(format: "語速%.1f", speedSlider.value)
        //pitchMultiplier 0.5-2
        pitchSlider.maximumValue = 17
        pitchSlider.minimumValue = 8
        pitchSlider.setValue(12, animated: true)
        pitchLabel.text = String(format: "音調%.1f", pitchSlider.value-7)
        //volume 0-1
        volumeSlider.maximumValue = 10
        volumeSlider.minimumValue = 1
        volumeSlider.setValue(8, animated: true)
        volumeLabel.text = String(format: "音量%.1f", volumeSlider.value)
    }
    
    @IBAction func editSpeech(_ sender: UITextField) {
        //Did End on Exit
    }
    @IBAction func play(_ sender: UIButton) {
        
        if playButtonStatus == .statusPlay{
            autoPlay()
        }else if playButtonStatus == .statusPause{
            print("press pause button")
            playButtonStatus = .statusPlayAfterPause
            sender.setImage(UIImage(systemName: "play"), for: .normal)
            synthesizer.pauseSpeaking(at: .immediate)
        }else{
            print("press play button after pause")
            playButtonStatus = .statusPause
            sender.setImage(UIImage(systemName: "pause"), for: .normal)
            synthesizer.continueSpeaking()
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        print("press stop button")
        playButtonStatus = .statusPlay
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
        synthesizer.stopSpeaking(at: .immediate)
    }
    @IBAction func changeSpeed(_ sender: UISlider) {
        speedLabel.text = String(format: "語速%.1f", sender.value)
    }
    @IBAction func changePitch(_ sender: UISlider) {
        pitchLabel.text = String(format: "音調%.1f", sender.value-7)
    }
    @IBAction func changeVolume(_ sender: UISlider) {
        volumeLabel.text = String(format: "音量%.1f", sender.value)
    }
    func selectModel(sayIt:String, speed:Float, pitch:Float, volume:Float){
        speech.text = sayIt
        speedSlider.setValue(speed, animated: true)
        speedLabel.text = String(format: "語速%.1f", speedSlider.value)
        pitchSlider.setValue(pitch, animated: true)
        pitchLabel.text = String(format: "音調%.1f", pitchSlider.value-7)
        volumeSlider.setValue(volume, animated: true)
        volumeLabel.text = String(format: "音量%.1f", volumeSlider.value)
        autoPlay()
    }
    func autoPlay(){
        print("auto play")
        //en-US zh-TW ja-JP
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        playButtonStatus = .statusPause
        playButton.setImage(UIImage(systemName: "pause"), for: .normal)
        sentence = speech.text ?? ""
        speechUtterance = AVSpeechUtterance(string: sentence)
        speechUtterance.rate = Float(speedSlider.value/10)
        speechUtterance.pitchMultiplier = Float(pitchSlider.value/10)
        speechUtterance.volume = Float(volumeSlider.value/10)
        synthesizer.speak(speechUtterance)
    }
    
    @IBAction func model_man(_ sender: UIButton) {
        selectModel(sayIt: "Got you! We all know what you did!", speed: 2, pitch: 8, volume: 10)
    }
    @IBAction func model_woman(_ sender: UIButton) {
        selectModel(sayIt: "Dinner together？ How about I dinner you", speed: 6, pitch: 17, volume: 7)
    }
    @IBAction func model_pig(_ sender: UIButton) {
        selectModel(sayIt: "oink oink oink, I am only a small pig", speed: 3, pitch: 9, volume: 5)
    }
    @IBAction func model_cat(_ sender: UIButton) {
        selectModel(sayIt: "meow meow, I saw pig did that dirty thing", speed: 4, pitch: 15, volume: 6)
    }
    @IBAction func model_duck(_ sender: UIButton) {
        selectModel(sayIt: "quack quack quack quack, somebody is lying", speed: 8, pitch: 13, volume: 5)
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

extension SpeechViewController:AVSpeechSynthesizerDelegate{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish")
        playButtonStatus = .statusPlay
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
    }
}

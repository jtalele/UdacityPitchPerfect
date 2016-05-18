//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Jitendr Talele on 5/3/16.
//  Copyright © 2016 JTalele. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordBotton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    
/*    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/ 

    func setUICondition(isRecording:Bool, recordingText:String)
    {
        recordingLabel.text=recordingText
        stopRecordingButton.enabled = isRecording
        recordBotton.enabled = !isRecording
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        print("Record button pressed")
        /*
        recordingLabel.text="Recording In Process"
        recordBotton.enabled=false
        stopRecordingButton.enabled=true
        */
        setUICondition(true, recordingText:"Recoding In Progress" )
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("Stop recording button presses")
        /*
        recordBotton.enabled=true
        stopRecordingButton.enabled=false
        recordingLabel.text="Tap To Record"
        */
        setUICondition(false, recordingText:"Tap To Record" )
        audioRecorder.stop()
        let audiosession = AVAudioSession.sharedInstance()
        try! audiosession.setActive(false)
    }
    
    

    override func viewWillAppear(animated: Bool) {
        print("View will appear called")
        stopRecordingButton.enabled=false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio recorder finished recording")
        if (flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }else {
            print("Saving of recording failed")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}



//
//  RecordSoundsViewController.swift
//  PitchPerfect_ND
//
//  Created by Dean Martindale on 3/15/16.
//  Copyright © 2016 Dean Martindale. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

	@IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopRecordingButton: UIButton!
	
	var audioRecorder: AVAudioRecorder!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func recordAudio(sender: AnyObject) {
		recordingLabel.text = "Recording In Progress"
		recordButton.enabled = false
		stopRecordingButton.enabled = true
		
		let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
		
		let recordingName = "recordedVoice.wav"
		let pathArray = [dirPath, recordingName]
		let filePath = NSURL.fileURLWithPathComponents(pathArray)
		
		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
		
		try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
		audioRecorder.delegate = self
		audioRecorder.meteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}

	@IBAction func stopRecording(sender: AnyObject) {
		recordingLabel.text = "Tap To Record"
		recordButton.enabled = true
		stopRecordingButton.enabled = false
		
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
	}
	
	override func viewWillAppear(animated: Bool) {
		stopRecordingButton.enabled = false
	}
	
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
		if (flag){
			self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
		} else {
			print("Saving of recording failed")
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == "stopRecording"){
			let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
			let recordedAudioURL = sender as! NSURL
			playSoundsVC.recordedAudioURL = recordedAudioURL
		}
	}
}


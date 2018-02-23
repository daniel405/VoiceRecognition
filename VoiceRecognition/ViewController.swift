//
//  ViewController.swift
//  VoiceRecognition
//
//  Created by Daniel Katz on 2018-02-23.
//  Copyright © 2018 Daniel Katz. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBAction func talkBtn(_ sender: UIButton) {
        self.recordAndRecognizeSpeech()
    }
    
    @IBOutlet weak var speechResultLabel: UILabel!
    
    // Processes the audio stream. It will give updates when the mic is receiving audio.
    let audioEngine = AVAudioEngine()
    
    // Does the actual speech recognition.
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()

    // Allocates speech as the user speaks in real-time and controls the buffering.
    let request = SFSpeechAudioBufferRecognitionRequest()
    
    // Used to manage, cancel, or stop the current recognition task.
    var recognitionTask: SFSpeechRecognitionTask?
    
    // Performs the speech recognition
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            buffer, _ in self.request.append(buffer)
        }
        audioEngine.prepare()
        
        // Useful for error checking/handling
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        // Checks to make sure the recognizer is available for the device and for the locale
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in if let result = result {
             let bestString = result.bestTranscription.formattedString
                self.speechResultLabel.text = bestString
        } else if let error = error { print (error) } })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.speechResultLabel.text = ""

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  SmartCamera
//
//  Created by Daval Cato on 2/17/18.
//  Copyright © 2018 Daval Cato. All rights reserved.
//

import UIKit
import AVKit
import Vision
import CoreMedia

@available(iOS 11.0, *)
class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start the camera here
        
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        captureSession.addInput(input)
        
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput();dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)
        

    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
       // print("Camera was able to capture a frame:", Data())
        
        guard let _: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
            
        }
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            return
        }
        let request = VNCoreMLRequest(model: model){ (finishedReq, err) in
            
            //perhaps check the err
            
           // print(finishedReq.results)
            
            guard let results = finishedReq.results as?
                [VNClassificationObservation] else {
                    return
            }
            
            guard let firstObservation = results.first else {
                return
                
            }
            print(firstObservation.identifier, firstObservation.confidence)
    
            
            
        }
        
        try? VNImageRequestHandler(cvPixlerBuffer: CVPixelBuffer, options: [:]).perform([request])
        
    }


}


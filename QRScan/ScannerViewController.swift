//
//  ScannerViewController.swift
//  QRScan
//
//  Created by Antonino Febbraro on 9/22/16.
//  Copyright © 2016 Antonino Febbraro. All rights reserved.
//

/*
    CODE THAT DEALS WITH THE QR SCANNER AND CAMERA FUNCTIONALITY
 */

import Foundation
import AVFoundation
import UIKit


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var contButn: UIButton!
    @IBOutlet weak var ScanCompLabel: UILabel!
    
    struct Constants{
        static var TitleArray = [String]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contButn.isHidden = true
        contButn.isEnabled = false
        ScanCompLabel.isHidden = true
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        // put it behind all other subviews
        self.view.layer.insertSublayer(previewLayer, at: 0)
        // or, put it underneath your buttons, as long as you know which one is the lowest subview
        self.view.layer.insertSublayer(previewLayer, below: contButn.layer)
        self.view.layer.insertSublayer(previewLayer, below: ScanCompLabel.layer)
        
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue);
        }
        
        dismiss(animated: true)
    }
    
    //Function where you would find the data that was scanned from QR Code
    func found(code: String) {
        print(code)
        Constants.TitleArray.append(code)
        
        contButn.isHidden = false
        contButn.isEnabled = true
        ScanCompLabel.isHidden = false
        

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func ContinueScanning(_ sender: AnyObject) {
        if (captureSession?.isRunning == false) {
            
            contButn.isHidden = true
            contButn.isEnabled = false
            ScanCompLabel.isHidden = true
            captureSession.startRunning();
        }
    }
    
    
    
   
    
}

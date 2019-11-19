//
//  BarcodeViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 19/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit



class BarcodeViewController: UIViewController {
    
    @IBOutlet weak var scannerView: QRScannerView! {
         didSet {
                   scannerView.delegate = self
               }
    }
    
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
//                self.performSegue(withIdentifier: "detailSeuge", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }

}


extension BarcodeViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
//        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
//        scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func qrScanningDidFail() {
//        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
//        self.qrData = QRData(codeString: str)
    }
    
    
    
}

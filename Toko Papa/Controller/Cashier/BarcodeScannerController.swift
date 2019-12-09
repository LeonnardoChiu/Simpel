//
//  BarcodeScannerController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 20/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class BarcodeScannerController: UIViewController {

    // MARK: - Variable
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                self.performSegue(withIdentifier: "backToCashier", sender: self)
            }
        }
    }
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// start scan barcode view
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    // MARK: -viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// stop scan barcode view
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
}

// MARK: - Extension untuk barcode scanner
extension BarcodeScannerController: QRScannerViewDelegate {
    func qrScanningDidStop() {
        
    }
    
    /// if scan fail
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning failed. Please try again")
    }
    /// if scan success
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
    
    
}

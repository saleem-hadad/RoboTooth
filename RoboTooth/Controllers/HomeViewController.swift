import UIKit
import Foundation
import CoreMotion
import CoreBluetooth
import SimpleAnimation
import RevealingSplashView

class HomeViewController: UIViewController {
    // MARK: properties
    private var isReady: Bool = false {
        didSet{
            guard isReady else {
                rightButtonOutlet.isEnabled = true
                topButtonOutlet.isEnabled = true
                bottomButtonOutlet.isEnabled = true
                leftButtonOutlet.isEnabled = true
                
                yButtonOutlet.isEnabled = true
                bButtonOutlet.isEnabled = true
                aButtonOutlet.isEnabled = true
                xButtonOutlet.isEnabled = true
                return
            }
            
            rightButtonOutlet.isEnabled = false
            topButtonOutlet.isEnabled = false
            bottomButtonOutlet.isEnabled = false
            leftButtonOutlet.isEnabled = false
            
            yButtonOutlet.isEnabled = false
            bButtonOutlet.isEnabled = false
            aButtonOutlet.isEnabled = false
            xButtonOutlet.isEnabled = false
        }
    }
    
    // MARK: outlines
    @IBOutlet weak var rightButtonOutlet: UIButton!
    @IBOutlet weak var topButtonOutlet: UIButton!
    @IBOutlet weak var bottomButtonOutlet: UIButton!
    @IBOutlet weak var leftButtonOutlet: UIButton!
    @IBOutlet weak var yButtonOutlet: UIButton!
    @IBOutlet weak var bButtonOutlet: UIButton!
    @IBOutlet weak var aButtonOutlet: UIButton!
    @IBOutlet weak var xButtonOutlet: UIButton!
    
    //MARK: - life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        serial = BLE(delegate: self)
        serial.writeType = .withoutResponse
        isReady = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isReady = serial.isReady
        showSplashScreen()
    }
    
    // MARK: - UI
    fileprivate func showSplashScreen() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "robot"), iconInitialSize: CGSize(width: 150, height: 150), backgroundColor: UIColor(red: 249, green: 246, blue: 254, alpha: 1))
        window.addSubview(revealingSplashView)
        revealingSplashView.startAnimation() { }
    }
    
    // MARK: - Actions
    @IBAction func disconnectBLE(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.disconnect()
    }
    
    @IBAction func rightAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.sendBytesToDevice(bytes: [80])
    }
    
    @IBAction func forwardAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.sendBytesToDevice(bytes: [85])
    }
    
    @IBAction func backwardAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.sendBytesToDevice(bytes: [90])
    }
    
    @IBAction func leftAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.sendBytesToDevice(bytes: [75])
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        serial.sendBytesToDevice(bytes: [100])
    }
    
    @IBAction func xAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.sendBytesToDevice(bytes: [75])
        xButtonOutlet.imageView?.image = #imageLiteral(resourceName: "x-active")
    }
    
    @IBAction func aAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.sendBytesToDevice(bytes: [75])
        aButtonOutlet.imageView?.image = #imageLiteral(resourceName: "a-active")
    }
    
    @IBAction func bAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.sendBytesToDevice(bytes: [75])
        bButtonOutlet.imageView?.image = #imageLiteral(resourceName: "b-active")
    }
    
    @IBAction func yAction(_ sender: UIButton) {
        guard serial.isReady else { return }
        sender.popIn()
        serial.sendBytesToDevice(bytes: [75])
        yButtonOutlet.imageView?.image = #imageLiteral(resourceName: "y-active")
    }
    
    @IBAction func resetRightButtonsUI(_ sender: UIButton) {
        yButtonOutlet.imageView?.image = #imageLiteral(resourceName: "y-not-active")
        bButtonOutlet.imageView?.image = #imageLiteral(resourceName: "b-not-active")
        aButtonOutlet.imageView?.image = #imageLiteral(resourceName: "a-not-active")
        xButtonOutlet.imageView?.image = #imageLiteral(resourceName: "x-not-active")
        
        sender.popIn()
    }
    
    @IBAction func resetLeftButtonsUI(_ sender: UIButton) {
        rightButtonOutlet.imageView?.image = #imageLiteral(resourceName: "right-not-active")
        topButtonOutlet.imageView?.image = #imageLiteral(resourceName: "top-not-active")
        bottomButtonOutlet.imageView?.image = #imageLiteral(resourceName: "bottom-not-active")
        leftButtonOutlet.imageView?.image = #imageLiteral(resourceName: "left-not-active")
        
        sender.popIn()
    }
}

extension HomeViewController: BLEDelegate {
    func serialDidDisconnect(peripheral: CBPeripheral, error: NSError?) {
        isReady = false
    }
    
    func serialDidConnect(peripheral: CBPeripheral) {
        isReady = true
    }
    
    func serialDidFailToConnect(peripheral: CBPeripheral, error: NSError?) {
        isReady = false
    }
    
    func serialDidChangeState(newState: CBManagerState) {
        if newState == .poweredOff {
            isReady = false
        }
    }
}

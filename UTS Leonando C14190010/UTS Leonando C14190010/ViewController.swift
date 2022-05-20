//
//  ViewController.swift
//  UTS Leonando C14190010
//
//  Created by IOS on 02/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    var banksoal = ["ALARM", "BREAD", "CLASS", "DRINK", "ENEMY", "FIGHT", "GLASS", "HOUSE", "IMAGE", "JUDGE", "KNOWN", "LEMON", "MELON", "NEVER", "OTHER", "PLANE", "QUEEN", "ROYAL", "SCOPE", "TASTE", "UNION", "VISIT", "WORLD", "XENON", "YOUTH", "ZEBRA"]
    
    var soal = ""
    var positioncounter = 0
    var minpositioncounter = 0
    
    @IBOutlet var wordview: [UILabel]!
    @IBOutlet var keyboardButton: [UIButton]!
    
    @IBOutlet weak var timerlabel: UILabel!
    
    var timer:Timer = Timer()
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        soal = String(banksoal[Int.random(in: 0...(banksoal.count - 1))])
        print("Soal : " + soal)
        print("Position counter : " + String(positioncounter))
        print("")
        
        starttimer()
    }
    
    @IBAction func clickKeyboard(_ sender: UIButton) {
        print("Keyboard pressed : " + sender.titleLabel!.text!)
        
        if(sender.titleLabel?.text == "⏎") {
            if(positioncounter % 5 == 0 && positioncounter != 0 && positioncounter - minpositioncounter != 0) {
                
                var answer : String! = ""
                for i in (minpositioncounter ... (positioncounter - 1)) {
                    answer += wordview[i].text!
                }
                print("Answer : " + answer)
                
                var iswin = false
                var counterindices = minpositioncounter
                for x in answer.indices {
                    if(soal == answer) {
                        for i in (minpositioncounter ... (positioncounter - 1)) {
                            wordview[i].textColor = UIColor.green
                        }
                        iswin = true
                        winstate()
                    }
                    else {
                        if(soal.contains(answer[x])) {
                            wordview[counterindices].textColor = UIColor.orange
                        }
                        else{
                            wordview[counterindices].textColor = UIColor.darkGray
                        }
                        if(soal[x] == answer[x]) {
                            wordview[counterindices].textColor = UIColor.green
                        }
                    }
                    if(minpositioncounter == 20 && !iswin) {
                        losestate()
                    }
                    counterindices += 1
                }
                
                
                minpositioncounter += 5
                print("ENTER SUCCESS!")
            }
            else {
                showToast(message: "Not enough letter!")
            }
        }
        else if(sender.titleLabel?.text == "⌫") {
            if(positioncounter > minpositioncounter) {
                positioncounter -= 1
                wordview[positioncounter].text = ""
            }
            else {
                showToast(message: "Word Empty!")
            }
        }
        else {
            if(positioncounter - minpositioncounter < 5) {
                wordview[positioncounter].text = sender.titleLabel?.text
                positioncounter += 1
            }
            else {
                showToast(message: "Word Full!")
            }
        }
        print("Position counter : " + String(positioncounter))
        print("Min position counter : " + String(minpositioncounter))
        print("")
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Restart Game?", message: "Are you sure want to restart the game?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in}))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            self.restartgame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func starttimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timercounter), userInfo: nil, repeats: true)
    }
    
    func stoptimer() {
        timer.invalidate()
    }
    
    @objc func timercounter() -> Void {
        count += 1
        let time = secondsToHourMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerlabel.text = timeString
    }
    
    func secondsToHourMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    func restartgame() {
        count = 0
        
        stoptimer()
        timerlabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
        starttimer()
        
        soal = String(banksoal[Int.random(in: 0...25)])
        
        for i in (0 ... 24) {
            wordview[i].text = ""
        }
        positioncounter = 0
        minpositioncounter = 0
        for button in keyboardButton {
            button.isUserInteractionEnabled = true
        }
        timerlabel.textColor = UIColor.white
        for text in wordview {
            text.textColor = UIColor.white
        }
        
        print("Reseted!")
        print("Soal : " + soal)
        print("Position counter : " + String(positioncounter))
        print("")
    }
    
    func winstate() {
        stoptimer()
        timerlabel.textColor = UIColor.green
        for button in keyboardButton {
            button.isUserInteractionEnabled = false
        }
        showGreenToast(message: "YOU WIN!")
    }
    
    func losestate() {
        stoptimer()
        timerlabel.textColor = UIColor.red
        for button in keyboardButton {
            button.isUserInteractionEnabled = false
        }
        showToast(message: "YOU LOSE!")
    }
}

extension ViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height - 200, width: 150, height: 40))
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.red
        toastLabel.textColor = UIColor.white
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }) { (isCompleted) in
            toastLabel.removeFromSuperview()
        }
    }
    func showGreenToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 75, y: self.view.frame.height - 200, width: 150, height: 40))
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.green
        toastLabel.textColor = UIColor.white
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }) { (isCompleted) in
            toastLabel.removeFromSuperview()
        }
    }
}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

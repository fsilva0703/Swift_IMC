//
//  ViewController.swift
//  IMC
//
//  Created by Fabio Silva on 13.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var viResult: UIView!
    @IBOutlet weak var tfWeight: UITextField!
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var ivResult: UIImageView!
    
    
    var imc: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func calculate(_ sender: Any) {
        
        if (tfWeight.text! == "" || tfHeight.text! == "") {
            showToast(Toast.ToastWeightHeight.rawValue);
            
            return;
        
        }
        if let weight = Double(tfWeight.text!), let height = Double(tfHeight.text!) {
            
            imc = weight / (height*height)
            showResult()
        }
    }
    
    func showResult() {
        var result: String = ""
        var image: String = ""
        switch imc {
        case 0..<16:
            result = BodyMass.Thinness.rawValue
            image = BodyImage.Thinness.rawValue
        case 16..<18.5:
            result = BodyMass.Under_Weight.rawValue
            image = BodyImage.Under_Weight.rawValue
        case 18.5..<25:
            result = BodyMass.Ideal_Weight.rawValue
            image = BodyImage.Ideal_Weight.rawValue
        case 25..<30:
            result = BodyMass.Overweight.rawValue
            image = BodyImage.Overweight.rawValue
        default:
            result = BodyMass.Obesity.rawValue
            image = BodyImage.Obesity.rawValue
        }
        lbResult.text = result
        ivResult.image = UIImage(named: image)
        viResult.isHidden = false
        view.endEditing(true)
    }
}

class ToastLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)

        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension UIViewController {
    static let DELAY_SHORT = 1.5
    static let DELAY_LONG = 3.0

    func showToast(_ text: String, delay: TimeInterval = DELAY_LONG) {
        let label = ToastLabel()
        label.backgroundColor = UIColor(red: 10, green: 0, blue: 0, alpha: 0.5)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.alpha = 0
        label.text = text
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        label.numberOfLines = 0
        label.textInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        let saveArea = view.safeAreaLayoutGuide
        label.centerXAnchor.constraint(equalTo: saveArea.centerXAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(greaterThanOrEqualTo: saveArea.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(lessThanOrEqualTo: saveArea.trailingAnchor, constant: -15).isActive = true
        label.bottomAnchor.constraint(equalTo: saveArea.bottomAnchor, constant: -30).isActive = true

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            label.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
                label.alpha = 0
            }, completion: {_ in
                label.removeFromSuperview()
            })
        })
    }
}

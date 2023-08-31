//
//  ViewController.swift
//  BMI
//
//  Created by 김선규 on 2023/08/31.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainLable: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    var bmi: Double?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }

    func makeUI() {
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        mainLable.text = "키와 몸무게를 입력해 주세요"
        
        calculateButton.clipsToBounds = true
        calculateButton.layer.cornerRadius = 5
        calculateButton.setTitle("BMI 계산하기", for: .normal)
        
        heightTextField.placeholder = "cm 단위로 입력해주세요"
        weightTextField.placeholder = "kg 단위로 입력해주세요"
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        bmi = calculateBMI(height: heightTextField.text!, weight: weightTextField.text!)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if heightTextField.text == "" || weightTextField.text == "" {
            mainLable.text = "키와 몸무게를 입력하셔야만 합니다!!!"
            mainLable.textColor = .red
            return false
        }
        mainLable.text = "키와 몸무게를 입력해 주세요"
        mainLable.textColor = .black
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSecondVC" {
            let secondVC = segue.destination as! SecondViewController
            secondVC.bmiNumber = self.bmi
            secondVC.bmiColor = getBackgroundColor()
            secondVC.adviceString = getBMIAdviceString()
        }
        
        heightTextField.text = ""
        weightTextField.text = ""
    }
    
    func calculateBMI(height: String, weight: String) -> Double {
        guard
            let height = Double(height),
            let weight = Double(weight)
        else { return 0.0 }
        
        var bmi = weight / (height * height) * 10000
        bmi = round(bmi*10) / 10
        return bmi
    }
    
    func getBackgroundColor() -> UIColor {
        guard let bmi = bmi else { return UIColor.black }
        switch bmi {
            case ..<18.6:
                return UIColor(displayP3Red: 22/255, green: 231/255, blue: 207/255, alpha: 1)
            case 18.6..<23.0:
                return UIColor(displayP3Red: 212/255, green: 251/255, blue: 121/255, alpha: 1)
            case 23.0..<25.0:
                return UIColor(displayP3Red: 218/255, green: 127/255, blue: 163/255, alpha: 1)
            case 25.0..<30.0:
                return UIColor(displayP3Red: 255/255, green: 150/255, blue: 141/255, alpha: 1)
            case 30.0...:
                return UIColor(displayP3Red: 255/255, green: 100/255, blue: 78/255, alpha: 1)
            default:
                return UIColor.black
        }
    }
    
    func getBMIAdviceString() -> String {
        guard let bmi = bmi else { return "" }
        switch bmi {
            case ..<18.6:
                return "저체중"
            case 18.6..<23.0:
                return "표준"
            case 23.0..<25.0:
                return "과체중"
            case 25.0..<30.0:
                return "중도비만"
            case 30.0...:
                return "고도비만"
            default:
                return ""
        }
    }
    
}


// MARK: - extension
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if Int(string) != nil || string == "" {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if heightTextField.text != "", weightTextField.text != "" {
            weightTextField.resignFirstResponder()
            return true
        } else if heightTextField.text != "" {
            weightTextField.becomeFirstResponder()
            return true
        }
        return false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
    }
}

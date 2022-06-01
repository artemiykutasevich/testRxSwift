//
//  ViewController.swift
//  testRxSwift
//
//  Created by Artem Kutasevich on 1.06.22.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var acceptTermsSwitch: UISwitch!
    @IBOutlet weak var mainButton: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isLoginValid = loginTextField.rx.text
            .map { [unowned self] in isValid(login: $0) }
        
        let isPasswordValid = passwordTextField.rx.text
            .map { [unowned self] in isValid(password: $0) }
        
        let isPasswordsEqual = Observable
            .combineLatest(passwordTextField.rx.text, confirmPasswordTextField.rx.text)
            .map { [unowned self] in isPassword($0, equalTo: $1)}
        
        let agreement = acceptTermsSwitch.rx.isOn
        
        Observable
            .combineLatest(isLoginValid, isPasswordValid, isPasswordsEqual, agreement)
            .map { $0 && $1 && $2 && $3 }
            .distinctUntilChanged()
            .bind(to: mainButton.rx.isEnabled)
            .disposed(by: bag)
    }
    
    private func isValid(login: String?) -> Bool {
        guard let login = login else { return false }
        return login.count > 5
    }
    
    private func isValid(password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count > 7
    }
    
    private func isPassword(_ password: String?, equalTo password2: String?) -> Bool {
        return password == password2
    }
}


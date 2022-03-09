//
//  LoginViewController.swift
//  RocketReserver
//
//  Created by Christopher DeVito on 3/6/22.
//

import UIKit

class LoginViewController: UIViewController {

    static let loginKeychainKey = "login"

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.errorLabel.text = nil
        self.enableSubmitButton(true)
    }

    @IBAction private func cancelTapped() {
        self.dismiss(animated: true)
    }

    @IBAction private func submitTapped() {
        self.errorLabel.text = nil
        self.enableSubmitButton(false)
        guard let email = self.emailTextField.text else {
            self.errorLabel.text = "Please enter an email address."
            self.enableSubmitButton(true)
            return
        }

        guard self.validate(email: email) else {
            self.errorLabel.text = "Please enter a valid email."
            self.enableSubmitButton(true)
            return
        }
    }

    private func validate(email: String) -> Bool {
        return email.contains("@")
    }

    private func enableSubmitButton(_ isEnabled: Bool) {
        self.submitButton.isEnabled = isEnabled
        if isEnabled {
            self.submitButton.setTitle("Submit", for: .normal)
        } else {
            self.submitButton.setTitle("Submitting...", for: .normal)
        }
    }
}

//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Prashant Dwivedi on 3/6/18.
//  Copyright © 2018 Prashant Dwivedi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleChangeInput), for: .editingChanged)
        return tf
    }()
    let usernameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleChangeInput), for: .editingChanged)
        return tf
    }()
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleChangeInput), for: .editingChanged)
        return tf
    }()
    
    @objc func handleChangeInput() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let signupButton : UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let userName = usernameTextField.text, userName.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user:User?, error:Error?) in
            if let err = error {
                print ("failed to create user",err)
                return
            }
            print("Successfully created user:",user?.uid ?? "")
            
            guard let uid = user?.uid else {return}
            let values = [uid:1]
            Database.database().reference().child("users").setValue(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.anchor(top: view.topAnchor, paddingTop: 50, left: nil, paddingLeft: 0, bottom: nil, paddingBottom: 0, right: nil, paddingRight: 0, width: 140, height: 140)
        
        setupInputFields ()
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signupButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually      
        stackView.axis = .vertical
        stackView.spacing = 10
        
         view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, paddingTop: 30, left: view.leftAnchor, paddingLeft: 30, bottom: nil, paddingBottom: 0, right: view.rightAnchor, paddingRight: -30, width: 0, height: 200)
        
    }
}

extension UIView {
    func anchor (top:NSLayoutYAxisAnchor?, paddingTop:CGFloat, left:NSLayoutXAxisAnchor?, paddingLeft:CGFloat, bottom:NSLayoutYAxisAnchor?, paddingBottom:CGFloat, right:NSLayoutXAxisAnchor?, paddingRight:CGFloat, width:CGFloat, height:CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        
    }
}


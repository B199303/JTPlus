//
//  ChangePasswordInputView.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/13.
//

import UIKit

class ChangePasswordInputView: UIView {
    let nameLabel = UILabel()
    let inputTextField = UITextField()
    let bottomLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(name:String, place:String){
        nameLabel.text = name
        inputTextField.placeholder = place
    }
    
    func initUI(){
        nameLabel.font = .textFont_14_medium
        nameLabel.textAlignment = .left
        nameLabel.textColor = .blackColor
        addSubview(nameLabel)
        
        inputTextField.placeholder = "输入当前密码"
        inputTextField.setPlaceHolderTextColor(.grayColor99)
        inputTextField.textAlignment = .left
        inputTextField.textColor = .blackColor22
        inputTextField.font = .textFont_14_regular
        inputTextField.returnKeyType = .done
        inputTextField.delegate = self
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        addSubview(inputTextField)
        
        bottomLine.backgroundColor = .grayColorEE
        addSubview(bottomLine)
        
        nameLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
            $0.width.equalTo(66*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        inputTextField.snp.makeConstraints{
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalToSuperview().offset(96*CGFloat.widthSize())
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        bottomLine.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.height.equalTo(CGFloat.widthSize())
            $0.top.equalToSuperview().offset(56*CGFloat.widthSize())
            $0.bottom.equalToSuperview()
        }
    }
    
}

extension ChangePasswordInputView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

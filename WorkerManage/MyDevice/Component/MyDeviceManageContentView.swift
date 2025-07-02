//
//  MyDeviceManageContentView.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/12.
//

import UIKit

class MyDeviceManageContentView: UIView {
    let title = UILabel()
    let inputBg = UIView()
    let inputTextField = UITextField()
    var limitNum:Int = 15

    init(){
        super.init(frame: .zero)
        self.initUI()
    }
    
    func initUI(){
        title.textAlignment = .left
        title.textColor = .blackColor
        title.font = .textFont_14_bold
        title.text = "设备名称"
        addSubview(title)
        
        inputBg.backgroundColor = .grayColorF6
        inputBg.cornerRadius = 8*CGFloat.widthSize()
        addSubview(inputBg)
        
        inputTextField.placeholder = "请输入设备位置"
        inputTextField.setPlaceHolderTextColor(.grayColor66)
        inputTextField.textAlignment = .left
        inputTextField.textColor = .blackColor22
        inputTextField.font = .textFont_14_bold
        inputTextField.returnKeyType = .done
        inputTextField.delegate = self
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        inputBg.addSubview(inputTextField)
        
        title.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalToSuperview()
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        inputBg.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.height.equalTo(42*CGFloat.widthSize())
            $0.top.equalTo(title.snp.bottom).offset(10*CGFloat.widthSize())
            $0.bottom.equalToSuperview()
        }
        
        inputTextField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(12*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20*CGFloat.widthSize())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyDeviceManageContentView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= limitNum
        }
}

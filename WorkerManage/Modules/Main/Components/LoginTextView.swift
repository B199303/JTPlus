//
//  LoginTextView.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/19.
//

import UIKit

class LoginTextView: UIView {
    let ima = UIImageView()
    let inputText = UITextField()
    let line = UIView()
    let hideBtn = ExpandedTouchAreaButton()

    init() {
        super.init(frame: .zero)
        addSubview(ima)
        ima.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-12*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.height.equalTo(23*CGFloat.widthSize())
            $0.width.equalTo(20*CGFloat.widthSize())
        }
        
        inputText.placeholder = "请输入账号"
        inputText.autocapitalizationType = .none
        inputText.autocorrectionType = .no
        inputText.setPlaceHolderTextColor(.grayColor99)
        inputText.textColor = .blackColor
        inputText.font = .textFont_14_medium
        inputText.clearButtonMode = .always
        inputText.returnKeyType = .done
        inputText.delegate = self
        addSubview(inputText)
        inputText.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(46*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
            $0.centerY.equalTo(ima)
            $0.trailing.equalToSuperview().offset(-40*CGFloat.widthSize())
        }
        
        let hideIma = CommonIconFont.iconfontToImage(iconText: IconFontName.nosee.rawValue, fontSize: 20, fontColor: .grayColorCC)
        hideBtn.setImage(hideIma.image, for: .normal)
        addSubview(hideBtn)
        hideBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-10*CGFloat.widthSize())
            $0.centerY.equalTo(ima)
            $0.height.width.equalTo(20*CGFloat.widthSize())
        }
        
        line.backgroundColor = .grayColorEE
        addSubview(line)
        line.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(CGFloat.widthSize())
        }
    }
    
    func setName(){
        ima.snp.remakeConstraints{
            $0.bottom.equalToSuperview().offset(-12*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.height.equalTo(23*CGFloat.widthSize())
            $0.width.equalTo(20*CGFloat.widthSize())
        }
        
        inputText.placeholder = "请输入账号"
        inputText.isSecureTextEntry = false
        let headIma = CommonIconFont.iconfontToImage(iconText: IconFontName.my.rawValue, fontSize: 20, fontColor: .blackColor55)
        ima.image = headIma.image
        hideBtn.isHidden = true
    }
    
    func setPassword(){
        ima.snp.remakeConstraints{
            $0.bottom.equalToSuperview().offset(-12*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
            $0.width.equalTo(20*CGFloat.widthSize())
        }
        
        inputText.placeholder = "请输入密码"
        inputText.isSecureTextEntry = true
        let headIma = CommonIconFont.iconfontToImage(iconText: IconFontName.key.rawValue, fontSize: 20, fontColor: .blackColor55)
        ima.image = headIma.image
        hideBtn.isHidden = false
        hideBtn.addTarget(self, action: #selector(touchHide), for: .touchUpInside)
    }
    
    @objc func touchHide(){
        var hideIma = CommonIconFont.iconfontToImage(iconText: IconFontName.nosee.rawValue, fontSize: 20, fontColor: .grayColorCC)
        if inputText.isSecureTextEntry{
            inputText.isSecureTextEntry = false
            hideIma = CommonIconFont.iconfontToImage(iconText: IconFontName.see.rawValue, fontSize: 20, fontColor: .grayColorCC)
        }else{
            inputText.isSecureTextEntry = true
            hideIma = CommonIconFont.iconfontToImage(iconText: IconFontName.nosee.rawValue, fontSize: 20, fontColor: .grayColorCC)
        }
        hideBtn.setImage(hideIma.image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginTextView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

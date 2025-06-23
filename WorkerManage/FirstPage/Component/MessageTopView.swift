//
//  MessageTopView.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/21.
//

import UIKit

class MessageTopView: UIView {
    let inputBgView = UIView()
    let inputTextField = UITextField()
    let inputIma = UIImageView()
    let filterIma = ExpandedTouchAreaButton()
    let filterTime = UILabel()

    init(){
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        inputBgView.cornerRadius = 4
        inputBgView.borderWidth = 1
        inputBgView.borderColor = .grayColorD0
        addSubview(inputBgView)
        inputBgView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-65)
            $0.top.equalToSuperview().offset(11)
            $0.height.equalTo(30)
        }
        
        inputTextField.placeholder = "请输入设备型号、设备ID查询"
        inputTextField.setPlaceHolderTextColor(.grayColor80)
        inputTextField.textAlignment = .left
        inputTextField.textColor = .grayColorC4
        inputTextField.font = .textFont_12_regular
        inputTextField.clearButtonMode = .always
        inputTextField.returnKeyType = .done
        inputTextField.delegate = self
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        inputBgView.addSubview(inputTextField)
        inputTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-36)
            $0.height.equalTo(28)
        }
        
        inputIma.image = UIImage(named: "common_search")
        inputBgView.addSubview(inputIma)
        inputIma.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-4)
            $0.height.width.equalTo(28)
            $0.centerY.equalToSuperview()
        }
        
        filterIma.setImage(UIImage(named: "common_time"), for: .normal)
        addSubview(filterIma)
        filterIma.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-19)
            $0.height.width.equalTo(28)
            $0.centerY.equalTo(inputBgView)
        }
        
        filterTime.text = "2023.05.01至2023.11.11"
        filterTime.textColor = .whiteColor
        filterTime.textAlignment = .center
        filterTime.font = .textFont_13_regular
        filterTime.isHidden = true
        addSubview(filterTime)
        filterTime.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(inputBgView.snp.bottom).offset(6)
        }
    }

}

extension MessageTopView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  ChangePasswordViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/13.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SwiftyRSA

class ChangePasswordViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = NetProvider()
    
    let buttonEnableRelay = BehaviorRelay<Bool>(value: false)
    let updataResultRelay = BehaviorRelay<LoginResult?>(value: nil)
    
    let logOutRelay = BehaviorRelay<LoginResult?>(value: nil)
    
    override init() {
        super.init()
    }
    
    func boolBtnEnable(now:String? = nil, first:String? = nil, sec:String? = nil){
        if now != "" && now != nil && first != "" && first != nil && sec != "" && sec != nil{
            self.buttonEnableRelay.accept(true)
        }else{
            self.buttonEnableRelay.accept(false)
        }
    }
    
    func boolSaveBtnEnable(name:String? = nil){
        if name != "" && name != nil{
            self.buttonEnableRelay.accept(true)
        }else{
            self.buttonEnableRelay.accept(false)
        }
    }
    
    func rsa_decrypt(_ str:String, key:String) -> String{
        var resultStr = ""
        do{
            let rsa_publicKey = try PublicKey(pemEncoded: key)
            let clear = try ClearMessage(string: str, using: .utf8)
            resultStr = try clear.encrypted(with: rsa_publicKey, padding: .PKCS1).base64String
        }catch{
            print("encode lose")
        }
        
        return resultStr
    }
    
    func getRsaKey(now:String, new:String) {
        dataProvider.getRsaKey().subscribe(onSuccess: { [weak self] data in
            guard let `self` = self else {return}
            let data = data.data
            let nowPassEncript =  self.rsa_decrypt(now, key: data)
            let newPassEncript =  self.rsa_decrypt(new, key: data)
            self.changePassword(now: nowPassEncript, new: newPassEncript)
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func changePassword(now:String, new:String){
        dataProvider.updateClientUserInfo(password: now, newPassword: new).subscribe(onSuccess: { [weak self] result in
            self?.updataResultRelay.accept(result)
        },onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func change(name:String){
        dataProvider.updateClientUserInfo(name: name).subscribe(onSuccess: { [weak self] result in
            self?.updataResultRelay.accept(result)
        },onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func change(sex:Int){
        dataProvider.updateClientUserInfo(sex: sex).subscribe(onSuccess: { [weak self] result in
            self?.updataResultRelay.accept(result)
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func logOut(){
        dataProvider.loginOut().subscribe(onSuccess: { [weak self] result in
            self?.logOutRelay.accept(result)
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func containsDigit(_ password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
    
    func containsLowercase(_ password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil
    }
    
    func containsUppercase(_ password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil
    }
    
    func containsSpecialCharacter(_ password: String) -> Bool {
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()-_=+")
        return password.rangeOfCharacter(from: specialCharacters) != nil
    }
    
    func validatePassword(_ password: String) -> Bool {
        // 检查长度
        if !(password.count >= 8 && password.count <= 20) { return false }
        // 检查是否包含数字、小写字母、大写字母和特殊字符（根据需要选择）
        if !containsDigit(password) { return false }
        if !containsLowercase(password) { return false }
        if !containsUppercase(password) { return false }
        if !containsSpecialCharacter(password) { return false } // 可选，根据需求启用或禁用此行代码
        return true // 所有条件都满足时返回true
    }
}

extension ChangePasswordViewModel{
    var buttonEnableDriver:Driver<Bool>{
        buttonEnableRelay.asDriver()
    }
    
    var updataResultDriver:Driver<LoginResult?>{
        updataResultRelay.asDriver()
    }
    
    var logOutDriver: Driver<LoginResult?>{
        logOutRelay.asDriver()
    }
}

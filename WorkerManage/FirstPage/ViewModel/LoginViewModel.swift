//
//  LoginViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/22.
//

import RxSwift
import RxRelay
import RxCocoa
import SwiftyRSA

class LoginViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = NetProvider()
    private let loginDataRelay = BehaviorRelay<LoginResult?>(value: nil)
    let userInfoRelay = BehaviorRelay<UserInfoData?>(value: nil)
    let isLoginRelay = BehaviorRelay<Bool>(value: false)
    let msgRelay = BehaviorRelay<String>(value: "")
    
    override init() {
        super.init()
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
    
    func getRsaKey(account:String, password:String) {
        dataProvider.getRsaKey().subscribe(onSuccess: { [weak self] data in
            guard let `self` = self else {return}
            let data = data.data
            let passEncript =  self.rsa_decrypt(password, key: data)
            self.login(account: account, passEncript: passEncript)
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func login(account: String, passEncript:String){
        dataProvider.login(account: account, pwd: passEncript).subscribe(onSuccess: { [weak self] data in
            guard let `self` = self else {return}
            if data.code == 20000 {
                UserDefaults.standard.set(data.data, forKey: "token")
                UserDefaults.standard.set(account, forKey: "account")
                UserDefaults.standard.set(passEncript, forKey: "pass")
                self.getUser()
                
            }else{
                self.msgRelay.accept(data.msg)
            }
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func getUser(){
        dataProvider.userInfo().subscribe(onSuccess: { [weak self] data in
            if data.code == 20000 {
                if let info = data.data{
                    let dataDic:[String:Any] = info.toJSON()
                    UserDefaults.standard.setValue(dataDic, forKey: "userInfo")
                    self?.userInfoRelay.accept(data.data)
                    self?.isLoginRelay.accept(true)
                }
            }else if data.code == 10010{
                NotificationCenter.default.post(name: Notification.Name("versionDate"),
                                                object: nil,
                                                userInfo: nil)
            }
            
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension LoginViewModel {
    var isLoginDriver: Driver<Bool> {
        isLoginRelay.asDriver()
    }
    
    var msgDriver: Driver<String> {
        msgRelay.asDriver()
    }
    
    var userInfoDriver: Driver<UserInfoData?> {
        userInfoRelay.asDriver()
    }
}

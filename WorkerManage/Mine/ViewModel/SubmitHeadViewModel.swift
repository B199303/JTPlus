//
//  SubmitHeadViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/16.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class SubmitHeadViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = NetProvider()
    
    let updataResultRelay = BehaviorRelay<LoginResult?>(value: nil)
    
    var imaStr = ""

    override init() {
        super.init()
    }
    
    func submitImage(image:UIImage){
        guard let imageData = image.compressedData(quality: 0.1) else {return}
        let imageName = "\(Int(Date().timeIntervalSince1970))_head.jpg"
        NetAPI.uploadImage(data: imageData, fileName: imageName)
            .request()
            .subscribe(onSuccess: { [weak self] (response) in
                if let json = try? response.mapJSON(), let dict = json as? [String: Any] {
                    //                    print(dict["data"] as Any )
                    guard let imaStr = dict["data"] as? String else {return}
                    self?.imaStr = imaStr
                    self?.change(headImage: imaStr)
                }
            },onFailure: { err in
                
            }).disposed(by: disposeBag)
    }
    
    func change(headImage:String){
        dataProvider.updateClientUserInfo(avatar: headImage).subscribe(onSuccess: { [weak self] result in
            self?.updataResultRelay.accept(result)
        },onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension SubmitHeadViewModel{
    var updataResultDriver:Driver<LoginResult?>{
        updataResultRelay.asDriver()
    }
}

//
//  MyDeviceListViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/11.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MyDeviceListViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = DeviceProvider()
    let productListRelay = BehaviorRelay<[ProductListData]>(value: [])
    let bindResultRelay = BehaviorRelay<LoginResult?>(value: nil)
    
    override init() {
        super.init()
    }
    
    func getProductList(userId:Int){
        dataProvider.getProductList(userId: userId).subscribe(onSuccess: { [weak self] data in
            if data.code == 20000{
                self?.productListRelay.accept(data.data)
            }
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func bindDevice(productIdentify:String, deviceIdentify:String, qrCodeKey:String){
        dataProvider.bindDevice(deviceIdentify: deviceIdentify, productIdentify: productIdentify, qrCodeKey: qrCodeKey).subscribe(onSuccess: { [weak self] data in
            self?.bindResultRelay.accept(data)
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension MyDeviceListViewModel {
    
    var productListDriver: Driver<[ProductListData]> {
        productListRelay.asDriver()
    }
    
    var bindResultDriver: Driver<LoginResult?> {
        bindResultRelay.asDriver()
    }
    
}

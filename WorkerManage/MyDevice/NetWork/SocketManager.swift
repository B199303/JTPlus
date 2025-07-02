//
//  SocketManager.swift
//  WorkerManage
//
//  Created by BL L on 2023/7/13.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay
import RxCocoa
import Starscream

class SocketManager {
    var socket: WebSocket?
    let disposeBag = DisposeBag()
    public var tempDataRelay = BehaviorRelay<[SocketMessageData]>(value: [])
    
    deinit {
//        socket?.stop()
        socket = nil
    }
    
    init() {
        self.connect()
        
        let timer = Timer.scheduledTimer(withTimeInterval: 50.0, repeats: true) { [weak self] timer in
            guard let `self` = self else {return}
            print("这个操作每50秒执行一次")
            self.socket?.write(string: "PING") {
                print("Message sent")
            }
        }
    }
    
    func connect() {
        if let token = UserDefaults.standard.string(forKey: "token")  {
            var request = URLRequest(url: URL(string: "\(App.shared.appConfigProvider.wsURL)/jt/im?token=\(token)")!)
            request.timeoutInterval = 5
            socket = WebSocket(request: request)
            socket?.delegate = self
            socket?.connect()
        }
    }
    
    
    func stop(){
        socket?.disconnect()
        socket = nil
    }

}

extension SocketManager:WebSocketDelegate{
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
            case .connected(let headers):
//                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
//                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
            self.resolve(text: string)
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
            print("1111")
//                isConnected = false
            case .error(let error):
            print("22222:\(error)")
//                isConnected = false
//                handleError(error)
            case .peerClosed:
            print("33333")
        }
    }
    
    
    func resolve(text: String) {
        if let jsonData: Data = text.data(using: .utf8){
            if let dict = try? JSONSerialization.jsonObject(with: jsonData,
                                                            options: .mutableContainers) as? Dictionary<String,Any> {
                if let temp = Mapper<SocketMessageData>().map(JSONObject: dict) {
                    var list = self.tempDataRelay.value
                    list.append(temp)
                    self.tempDataRelay.accept(list)
                }
            }
        }
    }

}

extension SocketManager{
    var tempDataDriver: Driver<[SocketMessageData]> {
        tempDataRelay.asDriver()
    }
}

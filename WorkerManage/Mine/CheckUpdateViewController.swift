//
//  CheckUpdateViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/15.
//

import UIKit
import RxSwift

class CheckUpdateViewController: CustomNavigationBarController {
    let noUpdateView = UIView()
    let imaBg = UIView()
    let ima = UIImageView()
    let contentLabel = UILabel()
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let disposeBag = DisposeBag()
    let viewModel = CheckUpdateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.checkVersion()
        initUI()
        
        subscribe(disposeBag, self.viewModel.checkDataDriver){ [weak self] data in
            guard let `self` = self else {return}
            if data == nil{
                self.tableView.isHidden = true
                self.noUpdateView.isHidden = false
            }else{
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.noUpdateView.isHidden = true
            }
        }
    }
    
    @objc func rightButtonTouch(){
        let vc = CheckUpdateHistoryViewController()
        self.navigationController?.pushViewController(vc)
    }
    
    func initUI(){
        self.title = "检查更新"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF
        self.view.backgroundColor = .whiteColorFA
        
        let rightIma = UIImageView()
        rightIma.image = CommonIconFont.iconfontToImage(iconText: IconFontName.record.rawValue, fontSize: 20, fontColor: .blackColor48).image
        self.navBar.rightBtn.isHidden = false
        self.navBar.rightBtn.addSubview(rightIma)
        self.navBar.rightBtn.addTarget(self, action: #selector(rightButtonTouch), for: .touchUpInside)
        rightIma.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-5*CGFloat.widthSize())
            $0.centerY.equalTo(self.navBar.backIma)
            $0.width.height.equalTo(20*CGFloat.widthSize())
        }
        
        initNoUpdateView()
        initTable()
    }
    
    func initNoUpdateView(){
        noUpdateView.isHidden = true
        noUpdateView.backgroundColor = .clear
        view.addSubview(noUpdateView)
        
        imaBg.backgroundColor = .greenColorEF
        imaBg.cornerRadius = 40*CGFloat.widthSize()
        noUpdateView.addSubview(imaBg)
        
        ima.image = UIImage(named: "mine_check")
        imaBg.addSubview(ima)
            
        contentLabel.textColor = .grayColor88
        contentLabel.textAlignment = .center
        contentLabel.font = .textFont_14_medium
        contentLabel.text = "已是最新版本"
        noUpdateView.addSubview(contentLabel)
        
        noUpdateView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        imaBg.snp.makeConstraints{
            $0.top.equalToSuperview().offset(152*CGFloat.widthSize())
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80*CGFloat.widthSize())
        }
        
        ima.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.width.equalTo(48*CGFloat.widthSize())
        }
        
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(imaBg.snp.bottom).offset(8*CGFloat.widthSize())
            $0.centerX.equalToSuperview()
        }
    }
    
    func initTable(){
        view.addSubview(tableView)
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(forClass: CheckUpdateCell.self)
        tableView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }

}

extension CheckUpdateViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CheckUpdateCell.self)
        if let item = self.viewModel.checkDataRelay.value{
            cell.bind(data: item)
        }
        return cell
    }
}



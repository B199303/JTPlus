//
//  RefreshHeader.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/12.
//

import MJRefresh

class RefreshHeader: MJRefreshNormalHeader {
    override func prepare() {
        super.prepare()
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.isHidden = true
        loadingView?.style = .medium
    }
    
    override func beginRefreshing() {
        loadingView?.style = .medium
        super.beginRefreshing()
    }
}

class RefreshFooter: MJRefreshAutoStateFooter {
    override func prepare() {
        super.prepare()
        isRefreshingTitleHidden = true
        stateLabel?.isHidden = true
    }
}

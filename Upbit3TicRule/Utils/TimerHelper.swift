//
//  TimerHelper.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/13.
//


import Foundation

class TimerHelper {
    typealias Update = (Int)->Void
    var timer:Timer?
    var timeInterval:Double = 1.0
    var count: Int = 0
    var update: Update?
    
    init(update:@escaping Update){
        self.update = update
    }
    func start(){
        
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        
    }
    func stop(){
        timer?.invalidate()
        timer = nil
    }
    /**
     * This method must be in the public or scope
     */
    @objc func timerUpdate() {
        count += 1;
        if let update = update {
            update(count)
        }
    }
}

//
//  MenuTransitionManager.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/5/23.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import UIKit

@objc protocol MenuTransitionManagerDelegate {
    func dismiss()
}

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    var delegate: MenuTransitionManagerDelegate?
    
    var isPresenting = false

    //  動畫持續時間
    var duration = 0.5
    var snapshot: UIView? {
        didSet {
            //  如果有設置委派
            if let delegate = delegate {
                let tapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: "dismiss")
                //  在 snapshot 加上手勢
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 取得我們的 fromView、toView 以及 container view的參照
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        // 設定滑動的變換（transform）
        let container = transitionContext.containerView
        let moveDown = CGAffineTransform(translationX: 0, y: container.frame.height - 150)
        let moveUp = CGAffineTransform(translationX: 0, y: -50)
        
        // 將兩個視圖加進容器視圖
        if isPresenting {
            toView?.transform = moveUp
            //  視圖快照
            snapshot = fromView?.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView!)
            container.addSubview(snapshot!)
            
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: [], animations: {
            
            //  打開選單
            if self.isPresenting {
                self.snapshot?.transform = moveDown
                toView?.transform = CGAffineTransform.identity
            //  關閉選單
            } else {
                self.snapshot?.transform = CGAffineTransform.identity
                fromView?.transform = moveUp
            }
        }, completion: { finished in
                transitionContext.completeTransition(true)
            //   如果是回到主頁面
            if !self.isPresenting {
                //  從父視圖移除
                self.snapshot?.removeFromSuperview()
            }
        })
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
}

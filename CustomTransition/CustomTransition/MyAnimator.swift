//
//  MyAnimator.swift
//  CustomTransition
//
//  Created by Hoen on 2022/12/06.
//

import UIKit

final class MyAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.4
    private let operation: UINavigationController.Operation
    private let VC: ViewController
    private let presentedVC: PresentedViewController
    
    
    init?(
        operation: UINavigationController.Operation,
        VC: ViewController,
        presentedVC: PresentedViewController) {
            
            self.operation = operation
            self.VC = VC
            self.presentedVC = presentedVC
        }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 애니메이션이 진행되는 뷰
        let container = transitionContext.containerView
        
        // 도착 뷰 push인지 pop인지에 따라 달라진다
        guard let toView = operation == .push ? presentedVC.view : VC.view else {
            // completeTransition을 꼭 불러줘야 한다. false면 실패 true면 성공.
            transitionContext.completeTransition(false)
            return
        }
        
        // 도착 뷰 더하고 일단 숨기기
        container.addSubview(toView)
        toView.alpha = 0

        // 애니메이션할 뷰 스냅샷
        let animateSnapshot: UIView
        
        // push인지 pop인지에 따라 달라진다
        // 스냅샷을 찍고 원래 뷰는 숨긴다. 움직이는 것처럼 보이게 하기 위해
        if operation == .push {
            VC.box.alpha = 0
            animateSnapshot = VC.box.snapshotView(afterScreenUpdates: false)!
        } else {
            presentedVC.box.alpha = 0
            animateSnapshot = presentedVC.box.snapshotView(afterScreenUpdates: false)!
        }

        // 애니메이션할 스냅샷을 container에 추가
        [animateSnapshot].forEach { container.addSubview($0) }

        // 스냅샷이 위치하게 될 frame window 좌표계로 바꿔준다 nil이면 window
        let boxViewRect = VC.box.convert(VC.box.bounds, to: nil)
        let presentedBoxRect = presentedVC.box.convert(presentedVC.boxFrame(), to: nil)
        
        // 스냅샷의 처음 프레임을 잡아준다.
        [animateSnapshot].forEach {
            $0.frame = operation == .push ? boxViewRect : presentedBoxRect
        }
        
        // 애니메이션
        UIView.animate(
            withDuration: duration,
            delay: 0) {
                // 스냅샷의 마지막 프레임을 잡아준다.
                animateSnapshot.frame = self.operation == .push ? presentedBoxRect : boxViewRect
            } completion: { _ in
                // 애니메이션이 끝나고, 스냅샷을 없애고, alpha값들을 제대로 돌려 놓는다.
                animateSnapshot.removeFromSuperview()
                toView.alpha = 1
                self.VC.box.alpha = 1
                self.presentedVC.box.alpha = 1
                transitionContext.completeTransition(true)
            }
    }
}


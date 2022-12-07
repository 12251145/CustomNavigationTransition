//
//  ViewController.swift
//  CustomTransition
//
//  Created by Hoen on 2022/12/06.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var box: UIView = {
        let box = UIView()
        self.view.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.backgroundColor = .systemPink
        
        return box
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .black
        config.title = "다음"
        
        button.configuration = config
        
        button.addAction(UIAction { _ in
            self.navigationController?.pushViewController(PresentedViewController(), animated: true)
            
        }, for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.delegate = self
        
        layout()
    }

    func layout() {
        NSLayoutConstraint.activate([
            box.widthAnchor.constraint(equalToConstant: 300),
            box.heightAnchor.constraint(equalToConstant: 200),
            box.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            box.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            switch operation {
            case .push:
                guard let fromVC = fromVC as? ViewController,
                      let toVC = toVC as? PresentedViewController else { return nil }
                
                let animator = MyAnimator(
                    operation: operation,
                    VC: fromVC,
                    presentedVC: toVC                    
                )
                
                return animator
            case .pop:
                guard let fromVC = fromVC as? PresentedViewController,
                      let toVC = toVC as? ViewController else { return nil }
                
                let animator = MyAnimator(
                    operation: operation,
                    VC: toVC,
                    presentedVC: fromVC
                )
                
                return animator
            default: return nil
                
            }
            
        }
}

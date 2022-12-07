//
//  PresentedViewController.swift
//  CustomTransition
//
//  Created by Hoen on 2022/12/06.
//

import UIKit

class PresentedViewController: UIViewController {
    
    var box: UIView = {
        let box = UIView()
        box.translatesAutoresizingMaskIntoConstraints = false
        box.backgroundColor = .systemPink
        
        return box
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .black
        config.title = "뒤로"
        
        button.configuration = config
        
        button.addAction(UIAction { _ in
            self.navigationController?.popViewController(animated: true)
            
        }, for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }

    func layout() {
        self.view.addSubview(box)
        
        NSLayoutConstraint.activate([
            box.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            box.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            box.topAnchor.constraint(equalTo: view.topAnchor),
            box.heightAnchor.constraint(equalToConstant: 300),
            
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - For Animation
extension PresentedViewController {
    func boxFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 300)
    }
}

//
//  SplashViewController.swift
//  Feature
//
//  Created by 이현욱 on 5/21/25.
//

import UIKit

public final class SplashViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(imageView)
        self.view.backgroundColor = .systemBackground
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let sideLength = min(view.bounds.width, view.bounds.height) * 0.3 // 예: 화면의 30%
        
        imageView.pin
            .size(CGSize(width: sideLength, height: sideLength))
            .center()
    }
    
}

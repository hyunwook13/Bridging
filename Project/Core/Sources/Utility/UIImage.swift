//
//  UIImage.swift
//  Bridging
//
//  Created by 이현욱 on 5/1/25.
//

import UIKit

extension UIImage {
  /// 주어진 크기로 이미지를 비율에 맞춰 리사이즈
  public func resized(to targetSize: CGSize) -> UIImage {
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let scale = min(widthRatio, heightRatio)
    let newSize = CGSize(width: size.width * scale,
                         height: size.height * scale)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    draw(in: CGRect(origin: .zero, size: newSize))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage ?? self
  }
}

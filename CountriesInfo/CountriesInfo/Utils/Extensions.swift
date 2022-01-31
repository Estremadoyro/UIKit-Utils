//
//  Extensions.swift
//  CountriesInfo
//
//  Created by Leonardo  on 26/01/22.
//

import UIKit

extension String {
  func capitalizingFirstLetter() -> String {
    return self.prefix(1).capitalized + self.dropFirst()
  }

  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}

var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
  func fetchImageFromURL(url: URL) {
    if let image = imageCache.object(forKey: url as NSURL) as? UIImage {
      print("image from cache")
      self.image = image
      return
    }
    // Its completion handler already runs in a background thread
    URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
      if let anError = error {
        debugPrint("Data task error: \(anError.localizedDescription)")
      }
      guard let aData = data, let image = UIImage(data: aData) else {
        return
      }
      DispatchQueue.main.async { [weak self] in
        imageCache.setObject(image, forKey: url as NSURL)
        self?.image = image
      }
    }).resume()
  }
}

extension UIView {
  func addShadowAndCorners(fillColor: UIColor, cornerRadius: CGFloat, shadowColor: CGColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) {
    let shadowLayer = CAShapeLayer()
    shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    shadowLayer.fillColor = fillColor.cgColor
    shadowLayer.shadowColor = shadowColor
    shadowLayer.shadowPath = shadowLayer.path
    shadowLayer.shadowOffset = shadowOffset
    shadowLayer.shadowOpacity = shadowOpacity
    shadowLayer.shadowRadius = shadowRadius
    shadowLayer.shouldRasterize = true
    shadowLayer.rasterizationScale = 0.8
    self.layer.insertSublayer(shadowLayer, at: 0)
  }
}

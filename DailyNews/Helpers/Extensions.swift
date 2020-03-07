//
//  Extensions.swift
//  AppStoreJSONApis
//
//  Created by Brian Voong on 2/14/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
    }
}

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    func downloadImage(from urlString : String) {
        let cache = FetchTopHeadline.shared.cache
           let cacheKey = NSString(string: urlString)
           if let image = cache.object(forKey: cacheKey) {
               self.image = image
               return
           }
           
           
           guard let url = URL(string: urlString) else { return }
           
           let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
               
               guard let self = self else { return }
               
               if error != nil { return }
               guard let response = response as? HTTPURLResponse , response.statusCode == 200 else { return }
               guard let data = data else { return }
               
               guard let image = UIImage(data: data) else { return }
               cache.setObject(image, forKey: cacheKey)
               DispatchQueue.main.async {
                   self.image = image
               }
               
               
           }
           
           task.resume()
       }

}

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
    }
}

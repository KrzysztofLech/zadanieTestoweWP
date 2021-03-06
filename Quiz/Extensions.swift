//
//  Extensions.swift
//  Quiz
//
//  Created by Black Thunder on 23.09.2016.
//  Copyright © 2016 Krzysztof Lech. All rights reserved.
//

import UIKit


extension UIImage {
    
    // skalowanie grafiki do podanej wielkości
    
    func resizedImageWithBounds(bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        let ratio = min(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImageView {
    
    // ładowanie ilustracji, skalowanie i zapis w tablicy
    
    func loadImage(url: URL, item: Item) -> URLSessionDownloadTask {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url, completionHandler: {
            [weak self] url, response, error in
            if error == nil, let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.image = image
                        
                        // pobrane zdjęcia skalujemy i zapamiętujemy
                        let smallImage = image.resizedImageWithBounds(bounds: CGSize(width: 365, height: 130))
                        let mediumImage = image.resizedImageWithBounds(bounds: CGSize(width: 375 * 2 , height: 230 * 2))
                        //print("small: \(smallImage.size), medium: \(mediumImage.size)")
                        
                        item.mainPhoto?.smallImage = smallImage
                        item.mainPhoto?.mediumImage = mediumImage
                    }
                }}
            })
        downloadTask.resume()
        return downloadTask
    }
}

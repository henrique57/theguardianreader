//
//  FetchService.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 19/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Alamofire
import SwiftyJSON
import ImageLoader

typealias JsonHandler = ((JSON) -> ())
typealias ImageHandler = (() -> ())


class FetchService {
    static func getRequest(url: String, handler: JsonHandler?){
        print(url)
        
        Alamofire.request(url).responseJSON {
            (response) in
            switch(response.result){
                case .success(let value) :
                    if let handlerUnwrapped = handler {
                        //print("Response: \(value)")
                        handlerUnwrapped(JSON(value))
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    static func getImage (url: String?, imagem: UIImageView!, handler: ImageHandler?){
        if var urlValue = url{
            if urlValue == "" { urlValue = "https://media.guim.co.uk/208c837d2ca2fdc5c5ffb5e7e3d6a6c4afed2d82/0_0_1300_780/500.jpg" }
            if let url = URL(string: urlValue){
                imagem.load.request(with: url, onCompletion: { image, error, operation in
                    //let transition = CATransition()
                    //transition.duration = 0.5
                    //transition.type = kCATransitionMoveIn
                    //imagem.layer.add(transition, forKey: nil)
                    
                    if let handlerUnwrapped = handler {
                        handlerUnwrapped()
                    }
                    
                    imagem.image = image
                })
            }
        }
    }
}

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

typealias JsonSessaoHandler = (([Section]?) -> ())
typealias JsonNoticiaSessaoHandler = (([NoticeSection]?) -> ())
typealias JsonNoticiaHandler = ((Notice?) -> ())
typealias JsonPesquisaHandler = (([Search]?) -> ())
typealias JsonHandler = ((JSON) -> ())


class FetchService {
    
    static func getRequest(url: String, handler: JsonHandler?){
        //print(url)
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
    
    static func getImage (url: String?, imagem: UIImageView!){
        if var urlValue = url{
            if urlValue == "" { urlValue = "https://media.guim.co.uk/208c837d2ca2fdc5c5ffb5e7e3d6a6c4afed2d82/0_0_1300_780/500.jpg" }
            if let url = URL(string: urlValue){
                imagem.load.request(with: url, onCompletion: { image, error, operation in
                    //print("\(operation)")

                    //print("entrei")
                    //let transition = CATransition()
                    //transition.duration = 0.5
                    //transition.type = kCATransitionMoveIn
                    //imagem.layer.add(transition, forKey: nil)
                    imagem.image = image
                })
            }
        }
    }
    
    static func requestSessoes(handler: JsonSessaoHandler?){
    }
    
    static func requestSessao(section: String, pagesQtt: Int, page: Int,handler: JsonNoticiaSessaoHandler?){
    }
    
    static func requestPesquisa(section: String, page: Int,query: String, handler: JsonPesquisaHandler?){
        let resource = "search";
    }
    
    static func requestNews(id: String, handler: JsonNoticiaHandler?){

    }
    
}

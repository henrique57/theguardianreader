//
//  FetchService.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 19/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

typealias JsonSessaoHandler = (([Sessao]?) -> ())
typealias JsonNoticiaSessaoHandler = (([NoticiaSessao]?) -> ())
typealias JsonNoticiaHandler = ((Noticia?) -> ())
typealias JsonPesquisaHandler = (([Pesquisa]?) -> ())


class FetchService {
    
    static func requestSessoes(handler: JsonSessaoHandler?){
        let resource = "sections";
        
        Alamofire.request(LinkManager.getUriSessoes(recurso: resource)).responseObject {
            (response: DataResponse<SessaoResponse>) in
            
            switch(response.result){
                
            case .success(let value) :
                if let sessoes = value.sessoes {
                    if let handlerUnwrapped = handler {
                        handlerUnwrapped(sessoes)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func requestSessao(section: String, pagesQtt: Int, page: Int,handler: JsonNoticiaSessaoHandler?){
        Alamofire.request(LinkManager.getUriSessao(recurso: section, pageQtt: pagesQtt, page: page)).responseObject {
            (response: DataResponse<NoticiaSessaoResponse>) in
            
            switch(response.result){
                
            case .success(let value) :
                if let noticias = value.noticias {
                    if let handlerUnwrapped = handler {
                        handlerUnwrapped(noticias)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func requestPesquisa(section: String, page: Int,query: String, handler: JsonPesquisaHandler?){
        let resource = "search";
        Alamofire.request(LinkManager.getUriPesquisa(section: section,page: page, recurso: resource, query: query)).responseObject {
            (response: DataResponse<PesquisaResponse>) in
            
            switch(response.result){
                
            case .success(let value) :
                if let noticias = value.pesquisa {
                    if let handlerUnwrapped = handler {
                        handlerUnwrapped(noticias)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func requestNews(id: String, handler: JsonNoticiaHandler?){
        Alamofire.request(LinkManager.getUriNoticia(recurso: id)).responseObject {
            (response: DataResponse<NoticiaResponse>) in
            
            switch(response.result){
                
            case .success(let value) :
                if let noticia = value.noticia {
                    if let handlerUnwrapped = handler {
                        handlerUnwrapped(noticia)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//
//  Response.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 01/10/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResponseService{
    
    static func mapSections (json: JSON?) -> [Section]{
        var sections = [Section]()
        if let json = json {
            if let items = json["response"]["results"].array {
                items.forEach { (item) in
                    //print(item)
                    sections.append(Section(id: item["id"].stringValue,
                                            webTitle: item["webTitle"].stringValue,
                                            apiUrl: item["apiUrl"].stringValue))
                }
            }
        }
        return sections
    }
    
    static func mapNoticeSection (json: JSON?) -> [NoticeSection]{
        var noticeSection = [NoticeSection]()
        if let json = json {
            if let items = json["response"]["results"].array {
                items.forEach { (item) in
                    //print(item)
                    noticeSection.append(NoticeSection(id: item["id"].stringValue,
                                                       webPublicationDate: item["webPublicationDate"].stringValue,
                                                       webTitle: item["webTitle"].stringValue,
                                                       apiUrl: item["apiUrl"].stringValue,
                                                       thumbnail: item["fields"]["thumbnail"].stringValue))
                }
            }
        }
        return noticeSection
    }
    
    static func mapNotice (json: JSON?) -> Notice {
        if let json = json {
            let item = json["response"]["content"]
            //print(item)
            return Notice(headline: item["fields"]["headline"].stringValue,
                          firstPublicationDate: item["fields"]["firstPublicationDate"].stringValue,
                          sectionName: item["sectionName"].stringValue,
                          thumbnail: item["fields"]["thumbnail"].stringValue,
                          body: item["fields"]["body"].stringValue,
                          bodyText: item["fields"]["bodyText"].stringValue)
        }
        return Notice()
    }
    
    static func mapSearch(json: JSON?) -> [Search] {
        var search = [Search]()
        if let json = json {
            if let items = json["response"]["results"].array {
                items.forEach { (item) in
                    //print(item)
                    search.append(Search(id: item["id"].stringValue,
                                        section: item["sectionName"].stringValue,
                                        webPublicationDate: item["webPublicationDate"].stringValue,
                                        webTitle: item["webTitle"].stringValue))
                }
            }
        }
        return search
    }
    
}



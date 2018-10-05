//
//  Utils.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 28/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class Utils {
    
    static func formatToBrazilianData(data: String?) -> String?{
        var formattedData = "";
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm:ss"
        if let dateToFormat = data, let date = dateFormatterGet.date(from: dateToFormat) {
            formattedData = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        return formattedData
    }
    
    /// Resize the picture and erase iframe tags
    ///
    /// - Parameters:
    ///   - html: Html to be formatted
    ///   - size: The container size
    /// - Returns: Html formatted
    static func resizeImageHtml(html: String, size: CGSize) -> String {
        var htmlWithouIframe = eraseTag(html: html, tag: "blockquote")
        htmlWithouIframe = eraseTag(html: htmlWithouIframe, tag: "figcaption")
        htmlWithouIframe = eraseTag(html: htmlWithouIframe, tag: "iframe")
        let contentWidth = size.width
        var strToChange = ""
        var nroWidth = self.getValueTag(html: htmlWithouIframe, element: "width=\"")
        var nroHeight = self.getValueTag(html: htmlWithouIframe, element: "height=\"")
        
        repeat{
            if (nroWidth != nil){
                var tamanho = [Int]()
                
                if let nroWidth = nroWidth {
                    if(nroWidth > contentWidth){
                        let proporcao =  nroWidth/contentWidth
                        tamanho.append(Int((nroWidth/proporcao).rounded()))
                        if let nroHeight = nroHeight{
                            strToChange = ("width=\"\(Int(nroWidth))\" height=\"\(Int(nroHeight))\"")
                            tamanho.append(Int((nroHeight/proporcao).rounded()))
                        }
                    }
                }
                let strForChange = "width= \"\(tamanho[0])\" height= \"\(tamanho[1])\""
                htmlWithouIframe = htmlWithouIframe.replacingOccurrences(of: strToChange, with: strForChange)
                nroWidth = self.getValueTag(html: htmlWithouIframe, element: "width=\"")
                nroHeight = self.getValueTag(html: htmlWithouIframe, element: "height=\"")
            }
        } while (nroWidth != nil)
        return htmlWithouIframe
    }
    
    static func getValueTag(html: String, element: String) -> CGFloat?{  
        var number: CGFloat?
        if let widthStart = html.range(of: element) {
            if let widthEnd = html[widthStart.upperBound...].range(of: "\""){
                let newStri = html[widthStart.upperBound...]
                let newStr = newStri[..<widthEnd.lowerBound]
                //print(newStr)
                number = CGFloat(Float(String(newStr)) ?? 0.0)
            }
        }
        return number
    }
    
    static func eraseTag (html: String, tag: String) -> String{
        //<iframe></iframe>
        var newHtml = html
        var widthStart = html.range(of: "<\(tag)")
        var teste: Bool = false
        repeat{
            if let width = widthStart, !width.isEmpty {
                if let widthEnd = html[width.upperBound...].range(of: "</\(tag)>"){
                    let newStri = html[width.upperBound...]
                    let newStr = newStri[..<widthEnd.lowerBound]
                    
                    newHtml = newHtml.replacingOccurrences(of: "<\(tag)\(newStr)</\(tag)>", with: "")
                    teste = (newHtml.replacingOccurrences(of: "<\(tag)\(newStr)</\(tag)>", with: "")) != newHtml
                }
                widthStart = html.range(of: "<\(tag)")
            }
        }while(teste)
        
        return newHtml
    }
}

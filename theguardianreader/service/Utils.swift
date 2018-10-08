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
    static func resizeImgElements(html: String, size: CGSize) -> String{
        let deviceWidth = size.width
        var hasSomething : Bool = false
        var htmlToResize = html
        var oldElement = ""
        var newElement = ""
        var width : Float
        var height : Float
        var proporcao : Float
        
        oldElement = getElement(html: htmlToResize, element: "img")
        if (oldElement != ""){
            repeat{
                width = getValueTag(html: oldElement, tag: "width")
                height = getValueTag(html: oldElement, tag: "height")
                newElement = oldElement.replacingOccurrences(of: "<img src=", with: "<img src =")
                newElement = newElement.replacingOccurrences(of: "class=\"gu-image\"", with: "")
                if(width > Float(deviceWidth)){
                    proporcao =  width/Float(deviceWidth)
                    newElement = newElement.replacingOccurrences(of: "width=\"\(Int(width))\"", with: "width=\"\(Int((width/proporcao).rounded()))\"")
                    newElement = newElement.replacingOccurrences(of: "height=\"\(Int(height))\"", with: "height=\"\(Int((height/proporcao).rounded()))\"")
                }else {
                    proporcao =  Float(deviceWidth)/width
                    newElement = newElement.replacingOccurrences(of: "width=\"\(Int(width))\"", with: "width=\"\(Int(width*proporcao.rounded()))\"")
                    newElement = newElement.replacingOccurrences(of: "height=\"\(Int(height))\"", with: "height=\"\(Int(height*proporcao.rounded()))\"")
                }
                htmlToResize = htmlToResize.replacingOccurrences(of: oldElement, with: newElement)
                oldElement = getElement(html: htmlToResize, element: "img")
                hasSomething = (oldElement != "") ? true : false
            }while(hasSomething)
        }
        
        return formatHtml(html: htmlToResize)
    }
    
    static func formatHtml(html: String) -> String{
        var newHtml = html
        newHtml = eraseTag(html: newHtml, tag: "blockquote")
        newHtml = eraseTag(html: newHtml, tag: "figcaption")
        return eraseTag(html: newHtml, tag: "iframe")
    }
    
    static func getValueTag(html: String, tag: String) -> Float{
        var number = Float(0.0)
        if let widthStart = html.range(of: "\(tag)=\"") {
            if let widthEnd = html[widthStart.upperBound...].range(of: "\""){
                let newStri = html[widthStart.upperBound...]
                let newStr = newStri[..<widthEnd.lowerBound]
                //print(newStr)
                number = (Float(String(newStr)) ?? 0.0)
            }
        }
        return number
    }
    
    static func getElement (html: String, element: String) -> String{
        //<iframe></iframe>
        let widthStart = html.range(of: "<\(element) src=")
        if let width = widthStart, !width.isEmpty {
            if let widthEnd = html[width.upperBound...].range(of: ">"){
                return "<\(element) src=\(html[width.upperBound...][..<widthEnd.lowerBound])>"
            }
        }
        
        return ""
    }
    
    static func getOpenElement (html: String, element: String) -> String{
        //<iframe></iframe>
        let widthStart = html.range(of: "<\(element)")
        if let width = widthStart, !width.isEmpty {
            if let widthEnd = html[width.upperBound...].range(of: "</\(element)>"){
                return String(html[width.upperBound...][..<widthEnd.lowerBound])
            }
        }
        
        return ""
    }
    
    static func eraseTag (html: String, tag: String) -> String{
        //<iframe></iframe>
        var newHtml = html
        var widthStart = html.range(of: "<\(tag)")
        var teste: Bool = false
        repeat{
            if let width = widthStart, !width.isEmpty {
                if let widthEnd = html[width.upperBound...].range(of: "</\(tag)>"){
                    let newStr = html[width.upperBound...][..<widthEnd.lowerBound]
                    
                    newHtml = newHtml.replacingOccurrences(of: "<\(tag)\(newStr)</\(tag)>", with: "")
                    teste = (newHtml.replacingOccurrences(of: "<\(tag)\(newStr)</\(tag)>", with: "")) != newHtml
                }
                widthStart = html.range(of: "<\(tag)")
            }
        }while(teste)
        
        return newHtml
    }
}

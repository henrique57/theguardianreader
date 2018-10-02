//
//  Utils.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 28/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class Utils {
    
    static func formatToBrazilianData(data: String?) -> String{
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
    
    static func resizeImageHtml(html: String) -> String {
        // ---------------------------------
        // GET SCREEN SIZE
        // ---------------------------------
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        var strToChange = ""
        
        // ---------------------------------
        // GET THE IMAGE WIDTH
        // ---------------------------------
        var nroWidth: Int?
        if let widthStart = html.range(of: "width=\"") {
            if let widthEnd = html[widthStart.upperBound...].range(of: "\""){
                let newStri = html[widthStart.upperBound...]
                let newStr = newStri[..<widthEnd.lowerBound]
                //print(newStr)
                nroWidth = Int(newStr)
            }
        }
        
        // ---------------------------------
        // GET THE IMAGE HEIGHT
        // ---------------------------------
        var nroHeight: Int?
        if let widthStart = html.range(of: "height=\"") {
            if let widthEnd = html[widthStart.upperBound...].range(of: "\""){
                let newStri = html[widthStart.upperBound...]
                let newStr = newStri[..<widthEnd.lowerBound]
                //print(newStr)
                nroHeight = Int(newStr)
            }
        }
        //print("\(nroWidth) - \(nroHeight)")
        
        // ---------------------------------
        // CALCULATE IMAGE SIZE PROPORCIONALLY
        // ---------------------------------
        var tamanho = [Int]()
        
        if let nroWidth = nroWidth {
            if(nroWidth > Int(screenWidth)){
                let proporcao =  nroWidth / Int(screenWidth)
                tamanho.append(Int(nroWidth/proporcao))
                if let nroHeight = nroHeight{
                    strToChange.append(contentsOf: "width=\"\(nroWidth)\" height=\"\(nroHeight)\"")
                    tamanho.append(Int(nroHeight/proporcao))
                }
            }
        }
        //print(tamanho)
        //width="1000" height="1000"
        //var strToChange = "width=\"\(tamanho[0])\" height=\"\(tamanho[1])\""
        let strForChange = "width=\"\(tamanho[0])\" height=\"\(tamanho[1])\""
        
        //html = html.replacingOccurrences(of: strToChange, with: strForChange)
        
        print("width=\"\(screenWidth)\"")
        print(strToChange)
        print(strForChange)
        
        return html.replacingOccurrences(of: strToChange, with: strForChange)
    }
    
}

//
//  Utils.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 28/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class Utils {
    
    static func resizeImageHtml(html: String) -> String {
        // ---------------------------------
        // CHANGE WIDTH AND HEIGHT
        // ---------------------------------
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        var nroWidth: Int?
        if let widthStart = html.range(of: "width=\"") {
            if let widthEnd = html[widthStart.upperBound...].range(of: "\""){
                let newStri = html[widthStart.upperBound...]
                let newStr = newStri[..<widthEnd.lowerBound]
                //print(newStr)
                nroWidth = Int(newStr)
            }
        }
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
        
        var tamanho = [Int]()
        
        
        if let nroWidth = nroWidth {
            if(nroWidth > (Int)screenWidth){
                let proporcao =  nroWidth / (Int)screenWidth
                tamanho.append(Int(nroWidth/proporcao))
                if let nroHeight = nroHeight{
                    tamanho.append(Int(nroHeight/proporcao))
                }
            }
        }
        
        
        print(tamanho)
        
        return ""
    }
    
}

//
//  Utils.swift
//  BeatBlender
//
//  Created by 김선웅 on 2020/05/09.
//  Copyright © 2020 novdov. All rights reserved.
//

import Foundation

func mapToRequestBodyString(_ body: [String:Any]) -> String {
    let keyValueJoinString: String = "="
    let queryJoinString: String = "&"
    
    var requestBodyString: [String] = []
    
    for (key, value) in body {
        requestBodyString.append("\(key)\(keyValueJoinString)\(value)")
    }
    
    return requestBodyString.joined(separator: queryJoinString)
}

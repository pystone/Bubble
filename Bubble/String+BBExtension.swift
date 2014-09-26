//
//  String+BBExtension.swift
//  Bubble
//
//  Created by ChuangXie on 9/26/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation

extension String {
    func initalCharacters() -> String {
        if self.isEmpty {
            return ""
        }
        var array: [String] = self.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " _-"))
        var visualText: String = ""
        for word: String in array {
            visualText.append(Array(word)[0])
        }
        return visualText
    }
    
    func initalCharacters(maxlen: Int) -> String {
        if self.isEmpty {
            return ""
        }
        var array: [String] = self.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " _-"))
        var visualText: String = ""
        for (index, element) in enumerate(array) {
            if index >= maxlen {
                break;
            }
            visualText.append(Array(element)[0])
        }
        return visualText
    }
}

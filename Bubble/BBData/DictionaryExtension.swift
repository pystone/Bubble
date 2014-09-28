//
//  DictionaryExtension.swift
//  bubble_data
//
//  Created by PY on 9/27/14.
//  Copyright (c) 2014 PY. All rights reserved.
//

import Foundation

func +=<K, V>(inout left: [K: V], right: [K: V]) -> [K: V] {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
    return left
}

extension Dictionary {
    
    func sortedKeys(isOrderedBefore:(Key, Key) -> Bool) -> [Key] {
        var array = Array(self.keys)
        sort(&array, isOrderedBefore)
        return array
    }
    
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
    
    mutating func merge(anotherDict: Dictionary) {
        for (key, val) in anotherDict {
            self[key] = val
        }
    }
    
}
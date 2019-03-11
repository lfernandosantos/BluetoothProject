//
//  Extensions.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 11/03/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation



extension String {
    
    func substring(fromIndex: Int, toIndex: Int) -> String {
        if fromIndex < toIndex && toIndex < self.count {
            let startIndex = self.index(self.startIndex, offsetBy: fromIndex)
            let endIndex = self.index(self.startIndex, offsetBy: toIndex)
            return String(self[startIndex..<endIndex])
        }else{
            return ""
        }
    }
    
    func getChar(at: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: at)
        let char = self[index]
        return String(char)
    }
}

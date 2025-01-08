//
//  FileUtils.swift
//  MyQiwi
//
//  Created by Ailton on 07/11/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import SwiftDate

class FileUtils {
    
//    public static String generateImageName(String terminalId, long seq) {
//    return terminalId + seq + DateFormatter.format("ddMMyyyyHHmmss", Calendar.getInstance()) + ".jpg";
//    }
//    "2010-05-20 15:30".toDate("yyyy-MM-dd HH:mm")

    static func generateImageName(terminalId: String, seq: Int) -> String {
        return generateImageName(terminalId: terminalId, seq: seq, extension: ".jpg")
    }
    
    static func generateImageName(terminalId: String, seq: Int, extension: String) -> String {
        let random1 = Int.random(in: 1000..<50000)
        let random2 = Int.random(in: 50000..<99999)
        let test = String(format: "%@%@%@%d%d%@", terminalId, String(seq), Date().toFormat("ddMMyyyyHHmmss"), random1, random2, ".jpg")
        return test
    }
    
    static func generateVideoName(path: String, terminalId: String, seq: Int) -> String {
        
        let formattedPath = Util.formatImagePath(path: path)
        let fullPath = formattedPath.components(separatedBy: ".")
        let fileExtension = "." + fullPath[fullPath.count-1]
        let random1 = Int.random(in: 1000..<50000)
        let random2 = Int.random(in: 50000..<99999)
        
        let test = String(format: "%@%@%@%d%d%@", terminalId, String(seq), Date().toFormat("ddMMyyyyHHmmss"), random1, random2, fileExtension)
        return test
    }
}

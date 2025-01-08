//
//  DeviceInformation.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 16/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

struct DeviceInformation {
    // UIDevice.current.model's value is "iPhone" or "iPad"，which does not include details; the following "model" is detailed, such as, iPhone7,1 is actually iPhone 6 plus
    static let model: String = {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }()
    
    static func deviceTypeModelName() -> String {
        return model
    }
    
    static func deviceTypeReadableName() -> String {
        
        switch model {
        case "iPhone1,1":   return "iPhone 1G"
        case "iPhone1,2":   return "iPhone 3G"
        case "iPhone2,1":   return "iPhone 3GS"
        case "iPhone3,1":   return "iPhone 4"
        case "iPhone3,3":   return "iPhone 4" //"iPhone 4 (Verizon)"
        case "iPhone4,1":   return "iPhone 4S"
        case "iPhone5,1":   return "iPhone 5" //"iPhone 5 (GSM)"
        case "iPhone5,2":   return "iPhone 5" //"iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":   return "iPhone 5c" //"iPhone 5c (GSM)"
        case "iPhone5,4":   return "iPhone 5c" //"iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":   return "iPhone 5s" //"iPhone 5s (GSM)"
        case "iPhone6,2":   return "iPhone 5s" //"iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":   return "iPhone 6"
        case "iPhone7,1":   return "iPhone 6 Plus"
        case "iPhone8,1":   return "iPhone 6s"
        case "iPhone8,2":   return "iPhone 6s Plus"
        case "iPhone8,4":   return "iPhone SE"
        case "iPhone9,1":   return "iPhone 7"
        case "iPhone9,3":   return "iPhone 7"
        case "iPhone9,2":   return "iPhone 7 Plus"
        case "iPhone9,4":   return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPod1,1":     return "iPod Touch 1G"
        case "iPod2,1":     return "iPod Touch 2G"
        case "iPod3,1":     return "iPod Touch 3G"
        case "iPod4,1":     return "iPod Touch 4G"
        case "iPod5,1":     return "iPod Touch 5G"
        case "iPod7,1":     return "iPod Touch 6G"
        case "iPad1,1":     return "iPad 1G"
        case "iPad2,1":     return "iPad 2"
        case "iPad2,2":     return "iPad 2"
        case "iPad2,3":     return "iPad 2"
        case "iPad2,4":     return "iPad 2"
        case "iPad2,5":     return "iPad Mini"
        case "iPad2,6":     return "iPad Mini"
        case "iPad2,7":     return "iPad Mini"
        case "iPad3,1":     return "iPad 3"
        case "iPad3,2":     return "iPad 3"
        case "iPad3,3":     return "iPad 3"
        case "iPad3,4":     return "iPad 4"
        case "iPad3,5":     return "iPad 4"
        case "iPad3,6":     return "iPad 4"
        case "iPad4,1":     return "iPad Air"
        case "iPad4,2":     return "iPad Air"
        case "iPad4,3":     return "iPad Air"
        case "iPad4,4":     return "iPad Mini 2"
        case "iPad4,5":     return "iPad Mini 2"
        case "iPad4,6":     return "iPad Mini 2"
        case "iPad4,7":     return "iPad Mini 3"
        case "iPad4,8":     return "iPad Mini 3"
        case "iPad4,9":     return "iPad Mini 3"
        case "iPad5,1":     return "iPad Mini 4"
        case "iPad5,2":     return "iPad Mini 4"
        case "iPad5,3":     return "iPad Air 2"
        case "iPad5,4":     return "iPad Air 2"
        case "iPad6,3":     return "iPad Pro 9.7 Inch"
        case "iPad6,4":     return "iPad Pro 9.7 Inch"
        case "iPad6,7":     return "iPad Pro 12.9 Inch"
        case "iPad6,8":     return "iPad Pro 12.9 Inch"
        case "iPad7,1":     return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,2":     return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3":     return "iPad Pro 10.5 Inch"
        case "iPad7,4":     return "iPad Pro 10.5 Inch"
        case "AppleTV2,1":  return "Apple TV"
        case "AppleTV3,1":  return "Apple TV"
        case "AppleTV3,2":  return "Apple TV"
        case "AppleTV5,3":  return "Apple TV"
        case "AppleTV6,2":  return "Apple TV 4K"
        case "AudioAccessory1,1":  return "HomePod"
        case "Watch1,1":    return "Apple Watch Series 1 (38mm, S1)"
        case "Watch1,2":    return "Apple Watch Series 1 (42mm, S1)"
        case "Watch2,6":    return "Apple Watch Series 1 (38mm, S1P)"
        case "Watch2,7":    return "Apple Watch Series 1 (42mm, S1P)"
        case "Watch2,3":    return "Apple Watch Series 2 (38mm, S2)"
        case "Watch2,4":    return "Apple Watch Series 2 (42mm, S2)"
        case "i386":        return "Simulator"
        case "x86_64":      return "Simulator"
            
        default:
            return "No Device"
        }
    }
}

//------ ORIGINAL -----
//case "iPod1,1":     return "iPod Touch 1G"
//case "iPod2,1":     return "iPod Touch 2G"
//case "iPod3,1":     return "iPod Touch 3G"
//case "iPod4,1":     return "iPod Touch 4G"
//case "iPod5,1":     return "iPod Touch 5G"
//case "iPod7,1":     return "iPod Touch 6G"
//case "iPad1,1":     return "iPad 1G"
//case "iPad2,1":     return "iPad 2 (Wi-Fi)"
//case "iPad2,2":     return "iPad 2 (GSM)"
//case "iPad2,3":     return "iPad 2 (CDMA)"
//case "iPad2,4":     return "iPad 2 (Wi-Fi)"
//case "iPad2,5":     return "iPad Mini (Wi-Fi)"
//case "iPad2,6":     return "iPad Mini (GSM)"
//case "iPad2,7":     return "iPad Mini (GSM+CDMA)"
//case "iPad3,1":     return "iPad 3 (Wi-Fi)"
//case "iPad3,2":     return "iPad 3 (GSM+CDMA)"
//case "iPad3,3":     return "iPad 3 (GSM)"
//case "iPad3,4":     return "iPad 4 (Wi-Fi)"
//case "iPad3,5":     return "iPad 4 (GSM)"
//case "iPad3,6":     return "iPad 4 (GSM+CDMA)"
//case "iPad4,1":     return "iPad Air (Wi-Fi)"
//case "iPad4,2":     return "iPad Air (Cellular)"
//case "iPad4,3":     return "iPad Air (China)"
//case "iPad4,4":     return "iPad Mini 2G (Wi-Fi)"
//case "iPad4,5":     return "iPad Mini 2G (Cellular)"
//case "iPad4,6":     return "iPad Mini 2G (China)"
//case "iPad4,7":     return "iPad Mini 3 (Wi-Fi)"
//case "iPad4,8":     return "iPad Mini 3 (Cellular)"
//case "iPad4,9":     return "iPad Mini 3 (China)"
//case "iPad5,1":     return "iPad Mini 4 (Wi-Fi)"
//case "iPad5,2":     return "iPad Mini 4 (Cellular)"
//case "iPad5,3":     return "iPad Air 2 (Wi-Fi)"
//case "iPad5,4":     return "iPad Air 2 (Cellular)"
//case "iPad6,3":     return "iPad Pro 9.7' (Wi-Fi)"
//case "iPad6,4":     return "iPad Pro 9.7' (Cellular)"
//case "iPad6,7":     return "iPad Pro 12.9' (Wi-Fi)"
//case "iPad6,8":     return "iPad Pro 12.9' (Cellular)"
//case "AppleTV2,1":  return "Apple TV 2G"
//case "AppleTV3,1":  return "Apple TV 3"
//case "AppleTV3,2":  return "Apple TV 3 (2013)"
//case "AppleTV5,3":  return "Apple TV 4"
//case "Watch1,1":    return "Apple Watch Series 1 (38mm, S1)"
//case "Watch1,2":    return "Apple Watch Series 1 (42mm, S1)"
//case "Watch2,6":    return "Apple Watch Series 1 (38mm, S1P)"
//case "Watch2,7":    return "Apple Watch Series 1 (42mm, S1P)"
//case "Watch2,3":    return "Apple Watch Series 2 (38mm, S2)"
//case "Watch2,4":    return "Apple Watch Series 2 (42mm, S2)"
//case "i386":        return "Simulator"
//case "x86_64":      return "Simulator"

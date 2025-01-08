//
//  Theme.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class Theme {
    
    struct `default` {
        
        // MARK: Colors
        
        static let first = UIColor(hexString: Constants.Colors.Hex.first)
        static let second = UIColor(hexString: Constants.Colors.Hex.second)
        static let white = UIColor.white
        static let primary = UIColor(hexString: Constants.Colors.Hex.colorPrimary)
        static let primaryDark = UIColor(hexString: Constants.Colors.Hex.colorPrimaryDark)
        static let background = UIColor(hexString: Constants.Colors.Hex.colorBackground)
        static let green = UIColor(hexString: Constants.Colors.Hex.colorButtonGreen)
        static let blue = UIColor(hexString: Constants.Colors.Hex.colorButtonBlue)
        static let orange = UIColor(hexString: Constants.Colors.Hex.colorAccent)
        static let red = UIColor(hexString: Constants.Colors.Hex.colorButtonRed)
        static let greyCard = UIColor(hexString: Constants.Colors.Hex.colorGrey1)
        static let yellow = UIColor(hexString: Constants.Colors.Hex.colorButtonYellow)
        static let statementLine = UIColor(hexString: Constants.Colors.Hex.colorStatementItem)
        static let blueBackground = UIColor(hexString: Constants.Colors.Hex.colorBueBackground)
        
        static let disabledButton = UIColor(hexString: Constants.Colors.Hex.colorGrey3)
        
        // MARK: Color ViewController
        
        static func backgroundCard(_ viewController: UIViewController) {
            viewController.view.backgroundColor = Theme.default.greyCard
        }
        
        static func backgroundBlue(_ viewController: UIViewController) {
            viewController.view.backgroundColor = Theme.default.blueBackground
        }
        
        // MARK: Colors Text Cards
        
        static func textAsDefault(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
            label.font = FontCustom.helveticaBold.font(14)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsListTitle(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            label.font = FontCustom.helveticaBold.font(19)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsDescForPopup(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
            label.font = FontCustom.helveticaBold.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsDesc(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
            label.font = FontCustom.helveticaMedium.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsMessage( _ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaRegular.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        // MARK: Colors Buttons
        
        static func firstButton(_ button: UIButton, radius: CGFloat = 3) {
            button.setupViewCard(radius: radius)
            button.tintColor = UIColor.white
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = Theme.default.first
            button.titleLabel?.font = FontCustom.helveticaBold.font(17)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        static func secondButton(_ button: UIButton, radius: CGFloat = 3) {
            button.setupViewCard(radius: radius)
            button.tintColor = UIColor.white
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = Theme.default.second
            button.titleLabel?.font = FontCustom.helveticaBold.font(17)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        static func greenButton(_ button: UIButton, radius: CGFloat = 3) {
            button.setupViewCard(radius: radius)
            button.tintColor = UIColor.white
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = Theme.default.green
            button.titleLabel?.font = FontCustom.helveticaBold.font(17)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        static func blueButton(_ button: UIButton, radius: CGFloat = 3) {
            button.setupViewCard(radius: radius)
            button.tintColor = UIColor.white
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = Theme.default.blue
            button.titleLabel?.font = FontCustom.helveticaBold.font(17)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        static func orageButton(_ button: UIButton, radius: CGFloat = 3) {
            button.setupViewCard(radius: radius)
            button.tintColor = UIColor.white
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = Theme.default.orange
            button.titleLabel?.font = FontCustom.helveticaBold.font(17)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        static func redButton(_ button: UIButton, radius: CGFloat = 3) {
            button.setupViewCard(radius: radius)
            button.tintColor = UIColor.white
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = Theme.default.red
            button.titleLabel?.font = FontCustom.helveticaBold.font(17)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        static func yellowButton(_ button: UIButton, radius: CGFloat = 3) {
            button.setupViewCard(radius: radius)
            button.tintColor = UIColor.white
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = Theme.default.yellow
            button.titleLabel?.font = FontCustom.helveticaBold.font(17)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        // MARK: Receipt
        
        static func textAsReceipt(_ textView: UITextView) {
            textView.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            textView.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorReceipt)
            textView.font = FontCustom.monaco.font(13)
        }
        
        // MARK: Error
        
        static func textAsError(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.holo_red_light)
            label.font = FontCustom.helveticaMedium.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func roundedBlueButton(_ button: UIButton, radius: CGFloat = 40) {
            button.setupViewCard(radius: radius)
            button.tintColor = UIColor.white
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = Theme.default.blue
            button.titleLabel?.font = FontCustom.helveticaBold.font(24)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct ZoneBlue {
       
    }
    
    struct Home {
        
        static func textAsModeDev(_ label: UILabel) {
            label.superview?.backgroundColor = Theme.default.red
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
            label.font = FontCustom.helveticaRegular.font(12)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsWhatWantToDo(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaBold.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct More {
        
        static func textAsExpand(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
            label.font = FontCustom.helveticaRegular.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsUserName(_ label: UILabel) {
            label.textColor = Theme.default.blue
            label.font = FontCustom.helveticaMedium.font(17)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsMenu(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
            label.font = FontCustom.helveticaRegular.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct Attendance {
        
        static func textAsMessage( _ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            label.font = FontCustom.helveticaMedium.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsCardTitle(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaMedium.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct InfoApp {
        
        static func textAsNameApp(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaMedium.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsVersionApp(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaMedium.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsTerminalApp(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaMedium.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsNotificarionApp(_ label: UILabel) {
            label.textColor = Theme.default.orange
            label.font = FontCustom.helveticaBold.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct OthersSerives {
        
        static func textAsHeaderTableView(_ label: UILabel?) {
            label?.textColor = Theme.default.primary
            label?.font = FontCustom.helveticaBold.font(20)
            label?.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsMessage(_ textView: UITextView) {
            textView.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
            textView.font = FontCustom.helveticaBold.font(14)
            textView.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct Orders {
        
        static func textAsActiveFilters(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
            label.font = FontCustom.helveticaRegular.font(18)
        }
        
        static func textAsChangeFilter(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            label.font = FontCustom.helveticaMedium.font(18)
        }
        
        static func textAsFilterTitle(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
            label.font = FontCustom.helveticaRegular.font(20)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsFilterStatusOrders(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
            label.font = FontCustom.helveticaBold.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsCheckBox(_ button: UIButton) {
            button.setImage(#imageLiteral(resourceName: "ic_check_box").withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiOrange)
            button.titleLabel?.textColor = UIColor(hexString: Constants.Colors.Hex.colorPrimaryDark)
            button.titleLabel?.font = FontCustom.helveticaRegular.font(17)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
        }
        
        static func setClose(_ button: UIButton) {
            button.setImage(#imageLiteral(resourceName: "ic_close").withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey4)
        }
        
        static func setArrow(_ imageView: UIImageView) {
            imageView.image = #imageLiteral(resourceName: "ic_enter_arrow").withRenderingMode(.alwaysTemplate)
            imageView.tintColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)
        }
    }
    
    struct OrderDetail {
        
        static func textAsProductName(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaBold.font(20)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsLabel(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
            label.font = FontCustom.helveticaRegular.font(15)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsLabelValue(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey8)
            label.font = FontCustom.helveticaBold.font(15)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct Offline {
        
        static func textAsTitle(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.holo_red_light)
            label.font = FontCustom.helveticaBold.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsDesc(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
            label.font = FontCustom.helveticaRegular.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct Comission {
        
        static func textAsSubtitle(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
            label.font = FontCustom.helveticaRegular.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct BalanceQiwi {
        
        static func textAsAccount(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            label.font = FontCustom.helveticaMedium.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsValue(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            label.font = FontCustom.helveticaMedium.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsRefresh(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey3)
            label.font = FontCustom.helveticaBold.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func setColorRefresh(_ imagem: UIImageView) {
            imagem.image = UIImage(named: "ic_refresh")?.withRenderingMode(.alwaysTemplate)
            imagem.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey3)
        }
    }
    
    struct Checkout {
        
        struct SaveCard {
            
            static func textAsSaveCard(_ label: UILabel) {
                label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey8)
                label.font = FontCustom.helveticaRegular.font(16)
                label.adjustsFontForContentSizeCategory = true
            }
        }
        
        struct OrderDetail {
            
            static func textAsLabelOrder(_ label: UILabel) {
                label.textColor = UIColor.black
                label.font = FontCustom.helveticaMedium.font(18)
                label.adjustsFontForContentSizeCategory = true
            }
            
            static func textAsValueOrder(_ label: UILabel) {
                label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
                label.font = FontCustom.helveticaRegular.font(18)
                label.adjustsFontForContentSizeCategory = true
            }
            
            static func textAsDetailMessage(_ label: UILabel) {
                label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
                label.font = FontCustom.helveticaRegular.font(18)
                label.adjustsFontForContentSizeCategory = true
            }
        }
        
        struct QiwiPass {
            
            static func textAsLabelPass(_ label: UILabel) {
                label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
                label.font = FontCustom.helveticaBold.font(16)
                label.adjustsFontForContentSizeCategory = true
            }
            
            static func textAsWrongPass(_ button: UIButton) {
                button.tintColor = Theme.default.primary
                button.titleLabel?.numberOfLines = 0
                button.titleLabel?.font = FontCustom.helveticaBold.font(18)
                button.titleLabel?.adjustsFontForContentSizeCategory = true
            }
        }
    }
    
    struct TransportInstructions {
        
        static func textAsTitle(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            label.font = FontCustom.helveticaBold.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsDesc(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaRegular.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
    }
    
    struct BankInfo {
        
        static func textAsName(_ label: UILabel) {
            label.textColor = UIColor.black
            label.font = FontCustom.helveticaBold.font(16)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsFavored(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaRegular.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsTranferWarningInfo(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            label.font = FontCustom.helveticaBold.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsBankInfo(_ label: UILabel) {
            label.textColor = UIColor.black
            label.font = FontCustom.helveticaBold.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsBankWarning(_ label: UILabel) {
            label.textColor = Theme.default.red
            label.font = FontCustom.helveticaBold.font(18)
            label.adjustsFontForContentSizeCategory = true
        }
        
        static func textAsBankTransferInfo(_ label: UILabel) {
            label.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
            label.font = FontCustom.helveticaRegular.font(17)
            label.adjustsFontForContentSizeCategory = true
        }
    }
}

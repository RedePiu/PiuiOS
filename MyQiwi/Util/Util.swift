//
//  Util.swift
//  MyQiwi
//
//  Created by ailton on 28/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation
import SystemConfiguration
import MapKit
import Contacts
import UIKit
import CryptoSwift
import YPImagePicker

public class Util {
    
    static func setupTabBar() {
        
//        [performanceItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaLTStd-Roman" size:10.0f], NSFontAttributeName,  [UIColor yellowColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
        
//        [performanceItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaLTStd-Roman" size:10.0f], NSFontAttributeName,  [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
        
        UITabBar.appearance().backgroundColor = Theme.default.orange
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white, .font: FontCustom.helveticaRegular.font(12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : UIColor.red, .font: FontCustom.helveticaBold.font(12)], for: .selected)
        
//        let attrsStateDefault = [
//            NSAttributedStringKey.font: FontCustom.helveticaRegular.font(12) ]
//
//        let attrsStateSelected = [
//            NSAttributedStringKey.font: FontCustom.helveticaBold.font(12) ]
//
//        UITabBarItem.appearance().setTitleTextAttributes(attrsStateDefault, for: UIControlState())
//        UITabBarItem.appearance().setTitleTextAttributes(attrsStateSelected, for: .selected)
    }
    
    public static func formatCoin(value: Double, currency: String = "") -> String {
        if value == 0 {
            return "R$ 0,00"
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "pt_BR")
        formatter.numberStyle = .currency
        if let formattedAmout = formatter.string(from: value as NSNumber) {
            return currency.isEmpty ? formattedAmout.currencyInputFormatting() : formattedAmout.currencyInputFormatting(currency: currency)
        }
        
        return ""
    }
    
    public static func doubleToInt(_ value: Double) -> Int {
        return Int(CGFloat(value + 0.0000001) * 100)
    }
    
    public static func doubleToIntAsStringMethod(_ value: Double) -> Int {
        
        var s = String(value)
        return Int(s.removeAllCaractersExceptNumbers()) ?? 0
    }
    
    public static func formatCoin(value: Int) -> String {
        return value == 0 ? "R$ 0,00" : Util.formatCoin(value: Double(Double(value) / 100))
    }
    
    /**
     * Formats a String into a pre defined format. E.G. Text: 12345678921 Format: ###.###.###-## = return 123.456.789-21
     *
     * @param text   The text to formats
     * @param format A specific format to convert the text. Use '#' to represent the characters,
     *               any other character won't be changed. E.G: ###.###.###-## for a CPF or ##/##/## for a date.
     * @return The formatted String or null if text is null/empty.
     */
    public static func formatText(text: String, format: String) -> String {
        let cleanText = text.removeAllOtherCaracters()
        var currentIndex = 0
        var formattedText = ""
        
        for i in 0..<format.count {
            
            //Texto ja foi concluido
            if currentIndex >= cleanText.count {
                return formattedText
            }
            
            //Se nao for #, adiciona o caracter original
            if format[i] != "#" {
                //Adiciona na nova string
                formattedText = formattedText + format[i]
                continue
            }
            
            formattedText = formattedText + cleanText[currentIndex]
            currentIndex = currentIndex + 1
        }
        
        return formattedText
    }
    
    public static func formatImagePath(path: String) -> String {
        if (!path.contains("/")) {
            return path;
        }
        
        let fullPath = path.components(separatedBy: "/")
        return fullPath[fullPath.count-1]
    }
    
    static func getAvailableValues(limitMax: Double) -> [Double] {
        
        let listValues = [Double]()
        
        return listValues
    }
    
    public static func setAsCardView(view: UIView, radius: CGFloat = 5) {
        
        view.layer.cornerRadius = radius
        
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        view.layer.shadowColor =  UIColor.black.withAlphaComponent(0.34).cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }
    
    public static func setShadowIn(view: UIView, radius: CGFloat = 5) {
        
        view.layer.cornerRadius = radius
        
//        view.layer.shadowColor =  UIColor.black.withAlphaComponent(0.34).cgColor
//        view.layer.shadowOffset = CGSize(width:1, height: 3)
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowRadius = 2
//        view.layer.masksToBounds = false
    }
    
    static func tintColorLogoToolbar(imageView: UIImageView) {
        
        imageView.image = Constants.Image.Qiwi.LOGO_TOOLBAR
        imageView.tintColor = UIColor.white
    }
    
    static func setStatusBarView(color: UIColor) {
        
        // Caso já esteja criada no UIApplication remvove
        Util.removeStatusBarView()
        
        // Criar nova view e adicionar na UIApplication
        Util.createStatusBarView(backgroundColor: color)
    }
    
    fileprivate static func createStatusBarView(backgroundColor: UIColor) {
        
        let width = UIApplication.shared.statusBarFrame.width
        let height = UIApplication.shared.statusBarFrame.height
        
        let frameStatusBar = CGRect(x: 0, y: 0, width: width, height: height)
        let statusBarView = UIView(frame: frameStatusBar)
        statusBarView.tag = 9999
        statusBarView.backgroundColor = backgroundColor
        
        // Adicionando na window atual
        UIApplication.shared.keyWindow?.addSubview(statusBarView)
    }
    
    fileprivate static func removeStatusBarView() {
        
        if let subViews = UIApplication.shared.keyWindow?.subviews {
            for subView in subViews {
                if subView.tag == 9999 {
                    subView.removeFromSuperview()
                }
                continue
            }
        }
    }
    
    
    /// Share a text to all apps that accepts
    /// - Parameters:
    ///   - sender: Controller
    ///   - text: Text to send
    ///   - completion: ex. { activity, completed, items, error in } -
    static func shareText(sender: UIViewController, text: String, completion: ((Optional<UIActivity.ActivityType>, Bool, Optional<Array<Any>>, Optional<Error>) -> Swift.Void)? = nil) {
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender.view // so that iPads won't crash=

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]

        // present the view controller
        sender.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = completion
    }
    
    static func openAppleStore() {
        
        let url  = URL(string: "itms-apps://itunes.apple.com/app/bars/id1157092557")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func stringToSh256(string: String) -> String {
        return string.sha256()
    }
    
    static func stringHoursSeconds() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:SS"
        let time = dateFormatter.string(from: Date())
        return time
    }
    
    static func stringDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let time = dateFormatter.string(from: Date())
        return time
    }
    
    static func formatDate(_ currentDate: String) -> String {
        let index = currentDate.prefix(19)
        
        //2018-09-26T22:00:16
        let dateFormatterIn = DateFormatter()
        dateFormatterIn.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "dd/MM/yy 'as' HH:mm"
        
        if let dateServer = dateFormatterIn.date(from: String(index)) {
            return dateFormatterOut.string(from: dateServer)
        } else {
            return ""
        }
    }
    
    static func openWhatsApp(number: String, msg: String) {
        let urlWhats = "whatsapp://send?phone=\(number)&text=\(msg)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.openURL(whatsappURL)
                } else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    static func selectTakePhoto(_ sender: UIViewController, onDidSelectImage: ((UIImage) -> Void)?) {
        
        // Configuration
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.hidesStatusBar = false
        config.screens = [.library, .photo]
//        config.wordings.libraryTitle = "Gallery"
        config.albumName = "Qiwi"
        config.library.onlySquare = true
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 1
        config.onlySquareImagesFromCamera = true
        config.showsCrop = .rectangle(ratio: (3/3))

        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .overFullScreen

        picker.didFinishPicking { [unowned picker] items, cancelled in

            for item in items {

                switch item {

                case .photo(let photo):

                    // image picked
                    Log.print(photo.image.size, typePrint: .alert)

                    picker.dismiss(animated: true, completion: {
                        onDidSelectImage?(photo.image)
                    })
                    break

                case .video(_):
                    break
                }
            }

            picker.dismiss(animated: true, completion: nil)
        }

        sender.present(picker, animated: true, completion: nil)
    }
    
    static func formatAttributedText(texts: [String], hex: [String]) -> NSMutableAttributedString {
        
        let mutableAttributed = NSMutableAttributedString(string: "")
        
        for position in 0..<texts.count {
            
            let attributes: [NSAttributedStringKey : Any] = [.foregroundColor: UIColor(hexString: hex[position]),
                                                             .font: FontCustom.helveticaRegular.font(18)]
            let attributedText = NSAttributedString(string: texts[position], attributes: attributes)
            mutableAttributed.append(attributedText)
        }
        
        return mutableAttributed
        
//
//        let attributedText_1 = NSAttributedString(string: "register_accept_terms_1".localized, attributes: [.foregroundColor : UIColor(hexString: Constants.Colors.Hex.colorQiwiGrey)])
//        let attributedText_2 = NSAttributedString(string: "register_accept_terms_2".localized, attributes: [.foregroundColor : UIColor(hexString: Constants.Colors.Hex.colorPrimary)])
//        let mutable = NSMutableAttributedString(attributedString: attributedText_1)
//        mutable.append(attributedText_2)
    }
    
    static func getMixedImg(image1: UIImage, image2: UIImage) -> UIImage {

        let width = image1.size.width > image2.size.width ? image1.size.width : image2.size.width
        let size = CGSize(width:  width, height: image1.size.height + image2.size.height)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        image2.draw(in: areaSize)
        image1.draw(in: areaSize, blendMode: .normal, alpha: 0.8)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func setTextBarIn(_ sender: UIViewController, title: String) {
        
        // Color
        sender.navigationController?.navigationBar.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
        sender.navigationController?.navigationBar.barTintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiBlue)
        sender.navigationController?.navigationBar.isTranslucent = false
        
        sender.navigationItem.title = title
        
        //
        sender.navigationController?.navigationBar.barStyle = .black
    }
    
    static func setLogoBarIn(_ sender: UIViewController) {
        
        // Color
        sender.navigationController?.navigationBar.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
        sender.navigationController?.navigationBar.barTintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiBlue)
        sender.navigationController?.navigationBar.isTranslucent = false
        
        let imgLogo = UIImageView(image: Constants.Image.Qiwi.LOGO_TOOLBAR)
        imgLogo.contentMode = .scaleAspectFit
        imgLogo.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
        let newimg = imgLogo.setWidth(65)
        
        // Logo
        sender.navigationItem.titleView = newimg
        
        sender.navigationController?.navigationBar.barStyle = .black
    }
    
    static func showAlertDefaultOK(_ sender: UIViewController, message: String, titleOK: String = "ok".localized, completionOK: (() -> Swift.Void)? = nil) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: titleOK, style: .default, handler: { _ in
            completionOK?()
        })
        alertController.addAction(actionOK)
        
        sender.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertYesNo(_ sender: UIViewController, message: String, completionOK: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "alert".localized, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "yes".localized, style: .default) { _ in
            completionOK()
        }
        let actionCancel = UIAlertAction(title: "no".localized, style: .default)
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionOK)
        
        sender.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertYesNo(_ sender: UIViewController, message: String, yes: String = "yes".localized, no: String = "no".localized, completionOK: @escaping () -> Void, completionCancel: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "alert".localized, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: yes, style: .default) { _ in
            completionOK()
        }
        let actionCancel = UIAlertAction(title: no, style: .default) { _ in
            completionCancel()
        }
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionOK)
        
        sender.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertSheetRecharge(_ sender: UIViewController, message: String, actionEdit: @escaping () -> Void, actionDelete: @escaping () -> Void) {
        
        let alertSheet = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        let alertEdit = UIAlertAction(title: "phone_action_edit_contact".localized, style: .default, handler: { action in
            
            actionEdit()
        })
        let alertRemove = UIAlertAction(title: "phone_action_remove_contact".localized, style: .default, handler: { action in
            
            actionDelete()
        })
        
        let alertCancel = UIAlertAction(title: "cancel".localized, style: .cancel)
        
        alertSheet.addAction(alertEdit)
        alertSheet.addAction(alertRemove)
        alertSheet.addAction(alertCancel)
        
        sender.present(alertSheet, animated: true)
    }
    
    static func showNeedLogin(_ sender: UIViewController) {
        
        let storyBoard = UIStoryboard(name: "LoginNeed", bundle: Bundle.main)
        if let vc = storyBoard.instantiateInitialViewController() {
            
            vc.view.tag = 99999
            sender.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: sender.view.frame.width, height: sender.view.frame.height)
            sender.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: sender)
        }
    }
    
    static func removeNeedLogin(_ sender: UIViewController) {
        
        sender.view.subviews.forEach { (subView) in
            
            if subView.tag == 99999 {
                
                sender.willMove(toParentViewController: nil)
                
                sender.childViewControllers.forEach({ (viewController) in
                    if viewController is LoginNeedViewController {
                        viewController.removeFromParentViewController()
                        viewController.view.removeFromSuperview()
                    }
                })
            }
        }
    }
    
    static func phoneContactFormat(_ contact: CNContact) -> PhoneContact {
        
        let userName: String = contact.givenName + " " + contact.familyName
        
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let userPhone:CNPhoneNumber = userPhoneNumbers[0].value
        let primaryPhoneNumber:String = userPhone.stringValue
        
        let phoneContact = PhoneContact(name: userName, ddd: "", number: primaryPhoneNumber)
        let formattedContact = PhoneFormatter.splitDDDFromNumber(phoneContact: phoneContact)
        
        return formattedContact
    }
    
    static func phoneContactInternationalFormat(_ contact: CNContact) -> PhoneContact {
        
        let userName: String = contact.givenName + " " + contact.familyName
        
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let userPhone:CNPhoneNumber = userPhoneNumbers[0].value
        let primaryPhoneNumber:String = userPhone.stringValue
        
        let phoneContact = PhoneContact(name: userName, ddd: "", number: primaryPhoneNumber)
        
        return phoneContact
    }
    
    static func validateBirthday(_ date: String) -> Bool {
        
        if date.isEmpty || date.count < 10 {
            return false
        }
        
        let values = date.split(separator: "/")
        let day = Int(values[0]) ?? 0
        let month = Int(values[1]) ?? 0
        let year = Int(values[2]) ?? 0
        
        // Data
        if (day < 1) || (day > 31) {
            return false
        }
        
        // Mes
        if (month < 1) || (month > 12) {
            return false
        }
        
        // Ano
        if year.description.count < 4 {
            return false
        }
        
        // Data maior que a atual
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "pt-BR")
        let date = dateFormatter.date(from: date)
        
        let dateNow = Date()
        
        // Data de validade incorreta
        if date! > dateNow {
            Log.print(date!.debugDescription, typePrint: .alert)
            Log.print(dateNow.debugDescription, typePrint: .alert)
            
            return false
        }
        
        return true
    }
    
    static func validadeDueDate(_ dueDate: String) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "pt-BR")
        let date = dateFormatter.date(from: dueDate)
        
        let dateNow = Date()
        
        // Data de validade incorreta
        if date! < dateNow {
            Log.print(date!.debugDescription, typePrint: .alert)
            Log.print(dateNow.debugDescription, typePrint: .alert)
            
            return false
        }
        
        return true
    }
    
    static func validadePhone(_ phone: String) -> Bool {
        
        if phone.isEmpty || phone.removeAllOtherCaracters().count < 11 {
            return false
        }
        
        return true
    }
    
    static func validadePassword(_ password: String) -> Bool {
        
        if password.isEmpty || password.count < 6 {
            return false
        }
        
        return true
    }
    
    static func validadeEmail(_ email: String) -> Bool {
        
        if email.isEmpty || !email.isEmail() {
            return false
        }
        
        return true
    }
    
    static func validadeCPF(_ cpf: String) -> Bool {
        
        if cpf.isEmpty || !cpf.isValidCPF {
            return false
        }
        
        return true
    }
    
    static func validadeCNPJ(_ cnpj: String) -> Bool {
        
        if cnpj.isEmpty || !cnpj.isValidCNPJ {
            return false
        }
        
        return true
    }
    
    static func validadeName(_ name: String) -> Bool {
        
        if name.isEmpty || !name.containsSpace() {
            return false
        }
        
        return true
    }
    
    static func validadeDD(_ dd: String) -> Bool {
        
        if dd.isEmpty || dd.count < 2 {
            return false
        }
        
        return true
    }
    
    static func validadeNumberPhone(_ number: String) -> Bool {
        
        if number.isEmpty || number.count < 11 {
            return false
        }
        
        return true
    }
    
    
    
    static func masCodeBar(text: String?) -> String? {
        
        let maskString = text
        
        guard let textBarcode = maskString else {
            return maskString
        }
        
        guard let firtCharacter = textBarcode.first else {
            return maskString
        }
        
        if firtCharacter == "8" {
            return Util.formatText(text: text ?? "", format:
                FactoryFebraban.staticmaskConsumoEditText)
        } else {
            return Util.formatText(text: text ?? "", format: FactoryFebraban.maskBoletoCobrancaEditText)
        }
    }
    
    static func maskBarCodeTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> String? {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return nil }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)

        return self.masCodeBar(text: changedText)
    }
    
    static func limitTextView(text: String) -> Bool {
        
        let currentText = text
        
        guard let firtCharacter = currentText.first else {
            return true
        }
        
        if firtCharacter == "8" {
            return currentText.count <= Constants.FormatPattern.Bill.boletoConsumo.rawValue.count
            
        }else {
            return currentText.count <= Constants.FormatPattern.Bill.boleto.rawValue.count
        }
    }
    
    static func showController<ControllerType: UIViewController>(_ type: ControllerType.Type, sender: UIViewController, completion: ((ControllerType) -> Swift.Void)? = nil) {
        let controller = ControllerType()
        controller.modalPresentationStyle = .overFullScreen
        sender.present(controller, animated: false) {
            completion?(controller)
        }
    }
    
    static func showStoryboard(_ sender: UIViewController, name: String, withIdentifier: String? = nil) {
        
        let storyBoard = UIStoryboard(name: name, bundle: Bundle.main)
        
        if let idetifierController = withIdentifier {
            
            let vc = storyBoard.instantiateViewController(withIdentifier: idetifierController)
            sender.present(vc, animated: true)
            
        }else {
            
            if let vc = storyBoard.instantiateInitialViewController() {
                sender.present(vc, animated: true)
            }
        }
    }
    
    static func showPopupWebView(_ sender: UIViewController) {
        let popup = PopupWebViewController()
        popup.modalPresentationStyle = .overFullScreen
        sender.present(popup, animated: false)
    }
    
    static func showWarningController(_ sender: UIViewController) {
        let warnigController = WarningViewController()
        warnigController.modalPresentationStyle = .overFullScreen
        sender.present(warnigController, animated: false)
    }
    
    static func showSeqOrSignErrorController(_ sender: UIViewController) {
        let warnigController = WarningViewController()
        warnigController.modalPresentationStyle = .overFullScreen
        sender.present(warnigController, animated: false, completion: {
            
        })
    }
    
    static func showLoading(_ sender: UIViewController, message: String = "processing".localized, completion: (() -> Swift.Void)? = nil) {
        let loadingController = LoadingViewController()
        loadingController.message = message
        loadingController.modalPresentationStyle = .overFullScreen
        sender.present(loadingController, animated: false, completion: completion)
    }
    
    static func showComingSoon(_ sender: UIViewController, delegate: DismisModalDelegate, title: String, message: String) {
        let comingSoonViewController = BankComingSoonViewController()
        comingSoonViewController.delegateModal = delegate
        
        let navigationController = UINavigationController(rootViewController: comingSoonViewController)
        
        sender.present(navigationController, animated: true) {
            comingSoonViewController.lbTitle.text = title
            comingSoonViewController.lbMessage.text = message
        }
    }
    
    static func captureImageIn(view: UIView) -> UIImage? {
        
        if let snapShotView = view.snapshotView(afterScreenUpdates: true) {
            
            UIGraphicsBeginImageContext(snapShotView.frame.size)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
        }
        
        return nil
    }
    
    static func snapShotView(_ sender: UIViewController, view: UIView) {
        
        if let snapShotView = view.snapshotView(afterScreenUpdates: true) {
            
            UIGraphicsBeginImageContext(snapShotView.frame.size)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let newImage = img {
                let activityViewController = UIActivityViewController(activityItems: [newImage], applicationActivities: nil)
                sender.present(activityViewController, animated: true)
            }
        }
    }
    
    static func showConnection(sender: UIViewController) {
    
        if checkReachable() {
            
            // Remove popup offline
            if OfflineViewController.isPresent {
                sender.dismiss(animated: false)
            }
            
        }else {
            
            if !OfflineViewController.isPresent {
                // Mostra popup offline
                let offlineViewController = OfflineViewController()
                offlineViewController.modalPresentationStyle = .overFullScreen
                sender.present(offlineViewController, animated: false)
            }
        }
    }
    
    static func checkReachable() -> Bool {
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com.br")!
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if (isNetworkReachable(with: flags)) {
//            Log.print(flags)
            if flags.contains(.isWWAN) {
//                Log.print("via mobile")
                return true
            }
            
//            Log.print("via wifi")
            return true
            
        }else if (!isNetworkReachable(with: flags)) {
//            Log.print("unreachable - Sorry no connection")
//            Log.print(flags)
            return false
        }
        
        return true
    }
    
    static private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    static func estimateSizeWith(width: CGFloat = 50, text: String) -> CGSize {
        
        var size = CGSize(width: width, height: 60)
        
        let sizeText = NSString(string: text).boundingRect(with: size, options: .truncatesLastVisibleLine, attributes: [NSAttributedStringKey.font : FontCustom.helveticaRegular.font(16)], context: nil)
        
        size.height = max(size.height, (sizeText.size.height + 20))
        
        return size
    }
    
    static func estimateSizeWith(width: CGFloat = 50, text: String, image: UIImage) -> CGSize {
        
        var size = CGSize(width: width, height: 40)
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)]
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let heightText = NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        
        Log.print(heightText.standardized, typePrint: .alert)
        
        let newHeight = (heightText.height + 40 + 35)
        
        size.height = newHeight
        
        // top + height image + espaco + height texto + bottom
        // 0 + 40 + 0 + 40 + 0
        
        return size
    }
    
    static func getCity(location: CLLocation) -> String {
        
        var city = ""
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            
            if let placeMark = placeMarks?.first {
                city = placeMark.locality ?? ""
            }
        }
        
        return city
    }
    
    /*
     * Verify if a textview contains text or not
     */
    static func textViewHasText(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        return true
    }
    
    /*
     * Verify if a textview contains text or not
     */
    static func textViewHasText(textView: MaterialField) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        return true
    }
}




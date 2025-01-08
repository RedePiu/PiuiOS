//
//  AmazonRN.swift
//  MyQiwi
//
//  Created by Ailton on 05/11/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import AWSCore
import AWSS3
import ObjectMapper

class AmazonRN: BaseRN {
    
    let bucket = "aplicativomeuqiwi"
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func writeFile(imageType: Int, image: UIImage, fileName: String) {
        let reducedImage = image.resizeImage(targetSize: CGSize(width: 250, height: 250))
        let data = reducedImage.jpeg
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                
                var objs = [AnyObject]()
                objs.append(task.key as AnyObject)
                objs.append(task.transferID as AnyObject)
                objs.append(imageType as AnyObject)
                
                self.delegate?.onReceiveData(fromClass: AmazonRN.self, param: Param.Contact.DOC_SENT, result: error == nil, object: objs as AnyObject)
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data!,
                                   bucket: self.bucket,
                                   key: fileName,
                                   contentType: "image/png",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error amazon: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                        print("sucesso amazon")
                                    }
                                    return nil;
        }
    }

    lazy var mDocumentsRN = DocumentsRN(delegate: self as? BaseDelegate)
    
    func sendVideo(url: URL, fileName: String) {
        
        var data: Data?
        do {
            data = try Data(contentsOf: url)
            //data = try Data(contentsOf: url, options: Data.ReadingOptions.alwaysMapped)
        } catch _ {
            data = nil
            self.delegate?.onReceiveData(fromClass: AmazonRN.self, param: Param.Contact.DOCS_SEND_VIDEO_RESPONSE, result: false, object: nil)
            return
        }
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async ( execute: {
                // Do Something
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do Something
                var objs = [AnyObject]()
                objs.append(task.key as AnyObject)
                objs.append(task.transferID as AnyObject)
                objs.append(ActionFinder.Documents.Types.VIDEO as AnyObject)
                
                self.delegate?.onReceiveData(fromClass: AmazonRN.self, param: Param.Contact.DOCS_SEND_VIDEO_RESPONSE, result: error == nil, object: objs as AnyObject)
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data!, bucket: self.bucket, key: fileName, contentType: AVVideoCodecKey, expression: expression, completionHandler: completionHandler).continueWith {
            (task) -> AnyObject? in
            if let error = task.error {
                print("Error amazon Video: \(error.localizedDescription)")
            }
            if let _ = task.result {
                print("Sucesso Amazon Video")
            }
            return nil;
        }
    }
    
    func readFile(key: String) {
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            print("Downloading...")
        })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(fromBucket: self.bucket, key: key, expression: expression) { (task, URL, data, error) in
                if error != nil {
                    print(error!)
                }
            
            DispatchQueue.main.async(execute: {
                print("Got here")
                let utf8Data = String(decoding: data!, as: UTF8.self).data(using: .utf8)

                
                self.delegate?.onReceiveData(fromClass: AmazonRN.self, param: Param.Contact.AMAZON_DOWNLOAD_FILE_RESPONSE, result: error == nil, object: utf8Data as AnyObject)
            })
        }
    }
    
    func sendDocForServer(documents: [DocumentImageRequest], param: Int) {
        // Create request
        var stringJson = "["
        
        // prints 0-9
        for i in 0..<documents.count {
            stringJson += documents[i].generateJsonBodyAsString()
            
            if i < documents.count - 1 {
                stringJson += ","
            }
        }
        
        stringJson += "]"
        
        let serviceBody = updateJsonWithHeader(jsonBody: stringJson)
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedRegisterDocument, json: serviceBody)
        
        callApi(request: request) { (response) in
            
            if response.sucess {
                UserRN.setNeedToSendDocs(sent: false)
            }
            
            self.sendContact(fromClass: DocumentsRN.self, param: param,
                             result: response.sucess, object: nil)
        }
    }
    
    //Resultados vao chegar na extensao no fim da pagina
    func sendDocument(anexos: [Anexo]) {
        let amazonHelper = AmazonHelper(amazonRN: self)
        amazonHelper.sendDocs(anexos: anexos)
    }
    
    //Internal class for amazon
    class AmazonHelper : BaseDelegate {
        
        var amazonRN : AmazonRN
        var documentsToSend = [DocumentImage]()
        var numberOfFiles = 0
        //var videosSent = self.documentRN.sendDocumentVideo()
        
        init(amazonRN: AmazonRN) {
            self.amazonRN = amazonRN
        }
        
        func sendDocs(anexos: [Anexo]) {
            self.documentsToSend = [DocumentImage]()
            self.numberOfFiles = anexos.count
            
            var img: UIImage?
            for anexo in anexos {
                
                if !anexo.tag.isEmpty {
                    self.documentsToSend.append(DocumentImage(anexo: anexo))
                    
                    if self.documentsToSend.count >= self.numberOfFiles {
                        self.amazonRN.delegate?.onReceiveData(fromClass: AmazonRN.self, param: Param.Contact.DOC_SENT, result: true, object: self.documentsToSend as AnyObject)
                        break
                    }
                    continue
                }
                
                img = UIImage.init(contentsOfFile: anexo.path) ?? nil
                
                if img != nil {
                    self.generateDocumentImage(imageType: anexo.type, image: img!)
                }
            }
        }
        
        //AuthenticatedRegisterDocument
        func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
            if fromClass == AmazonRN.self {
                if param == Param.Contact.DOC_SENT || param == Param.Contact.DOCS_SEND_VIDEO_RESPONSE{
                    if !result {
                        self.amazonRN.delegate?.onReceiveData(fromClass: DocumentsRN.self, param: param, result: result, object: object)
                        return
                    }
                    
                    let objs = object as! [AnyObject]
                    let imageId = objs[0] as! String
                    let bucketTag = objs[1] as! String
                    let imageType = objs[2] as! Int
                    self.documentsToSend.append(DocumentImage(imageType: imageType, imageId: imageId, bucketTag: bucketTag))
                    
                    if self.documentsToSend.count >= self.numberOfFiles {
                        self.amazonRN.delegate?.onReceiveData(fromClass: AmazonRN.self, param: Param.Contact.DOC_SENT, result: result, object: self.documentsToSend as AnyObject)
                    }
                }
            }
        }
        
        func generateDocumentImage(imageType: Int, image: UIImage) {
            let amazonRN = AmazonRN(delegate: self)
            let fileName = FileUtils.generateImageName(terminalId: BaseRN.getTerminalId(), seq: self.amazonRN.getCurrentSequencial())
            amazonRN.writeFile(imageType: imageType, image: image, fileName: fileName)
        }
    }
}

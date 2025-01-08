//
//  DocumentsRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class DocumentsRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func setSeen(processId: Int) {
        // Create request
        let objectData = DocumentSeenBody(processId: processId)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedSetSeen, json: serviceBody)
        
        callApi(request: request) { (response) in
            self.sendContact(fromClass: DocumentsRN.self, param: Param.Contact.DOCS_DOCUMENT_SEEN_RESPONSE,
                             result: response.sucess, object: (response.body?.data as AnyObject) )
        }
    }
    
    //Internal class for amazon
    class AmazonHelper : BaseDelegate {
        
        var documentRN : DocumentsRN
        var documentsToSend = [DocumentImageRequest]()
        var numberOfFiles = 0
        var callSendDocumentService = true
        //var videosSent = self.documentRN.sendDocumentVideo()
        
        init(documentRN: DocumentsRN, callSendDocumentService: Bool = true) {
            self.documentRN = documentRN
            self.callSendDocumentService = callSendDocumentService
        }
        
        func sendDocs(imageType: Int, images : [UIImage]) {
            self.documentsToSend = [DocumentImageRequest]()
            self.numberOfFiles = images.count
            
            for image in images {
                self.generateDocumentImage(imageType: imageType, image: image)
            }
        }
        
        func sendDocs(imageType: [Int], images: [UIImage]) {
            self.documentsToSend = [DocumentImageRequest]()
            self.numberOfFiles = images.count
            
            for i in 0..<images.count {
                self.generateDocumentImage(imageType: imageType[i], image: images[i])
            }
        }
        
        func sendVideo(path: String) {
            let amazonRN = AmazonRN(delegate: self)
            let fileName = FileUtils.generateVideoName(path: path, terminalId: BaseRN.getTerminalId(), seq: self.documentRN.getCurrentSequencial())
            
            //amazonRN.sendVideo(url: path, fileName: fileName)
        }
        
        //AuthenticatedRegisterDocument
        func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
            if fromClass == AmazonRN.self {
                if param == Param.Contact.DOC_SENT || param == Param.Contact.DOCS_SEND_VIDEO_RESPONSE{
                    if !result {
                        self.documentRN.delegate?.onReceiveData(fromClass: DocumentsRN.self, param: param, result: result, object: object)
                        return
                    }
                    
                    let objs = object as! [AnyObject]
                    let imageId = objs[0] as! String
                    let bucketTag = objs[1] as! String
                    let imageType = objs[2] as! Int
                    self.documentsToSend.append(DocumentImageRequest(imageType: imageType, imageId: imageId, bucketTag: bucketTag))
                    
                    if self.documentsToSend.count >= self.numberOfFiles {
                        if callSendDocumentService {
                            self.documentRN.sendDocForServer(documents: self.documentsToSend, param: param)
                        } else {
                            self.documentRN.delegate?.onReceiveData(fromClass: DocumentsRN.self, param: Param.Contact.DOC_SENT, result: result, object: self.documentsToSend as AnyObject)
                        }
                    }
                }
            }
        }
        
        func generateDocumentImage(imageType: Int, image: UIImage) {
            let amazonRN = AmazonRN(delegate: self)
            let fileName = FileUtils.generateImageName(terminalId: BaseRN.getTerminalId(), seq: self.documentRN.getCurrentSequencial())
            amazonRN.writeFile(imageType: imageType, image: image, fileName: fileName)
        }
        
//        func generateDocumentVideo(vide: AVCaptureVideoDataOutput) {
//            let amazonRN = AmazonRN(delegate: self)
//            let filename = FileUtils.generateImageName(terminalId: BaseRN.getTerminalId(), seq: self.documentRN.sendDocumentVideo())
//            amazonRN.writeFile(image: image, fileName: filename)
//        }
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
    func sendDocument(imageType: Int, images: UIImage..., callSendDocumentService: Bool = true) {
        let amazonHelper = AmazonHelper(documentRN: self, callSendDocumentService: callSendDocumentService)
        amazonHelper.sendDocs(imageType: imageType, images: images)
    }
    
    func sendRGAndCPF(imageType: [Int], images: [UIImage], callSendDocumentService: Bool = true) {
        
        let amazonHelper = AmazonHelper(documentRN: self, callSendDocumentService: callSendDocumentService)
        amazonHelper.sendDocs(imageType: imageType, images: images)
    }
    
    //Resultados vao chegar na extensao no fim da pagina
    func sendDocumentVideo(path: String, callSendDocumentService: Bool = true) {
        
        let amazonHelper = AmazonHelper(documentRN: self, callSendDocumentService: callSendDocumentService)
        amazonHelper.sendVideo(path: path)
    }
    
    func getNotApprovedDocuments() {
    }
    
    func hasFailedImages() -> Bool {
        return true
    }
    
    func getUserDocumentMessageStatus() {
    }
    
    func setDocumentProcesses(documents: [DocumentProcess]) {

        let documentProcessDAO = DocumentProcessDAO()
        let documentImageDAO = DocumentImageDAO()
        
        documentProcessDAO.deleteAll()
        documentImageDAO.deleteAll()
        
        //PARA FINS DE TESTE - ISSO ABRIRÁ O POPUP
//        var docImage = DocumentImage(imageType: ActionFinder.Documents.Types.FACE_CARTAO, imageId: "", bucketTag: "")
//        docImage.obs = "Pq não kkkkk"
//        var doc = DocumentProcess()
//        doc.cardNumber = "4490"
//        doc.processId = 1
//        doc.status = ActionFinder.Documents.Status.
//        doc.documents.append(docImage)
//
//        DocStatusViewController.mDocumentProcess = doc
//        DispatchQueue.main.async {
//            Util.showController(DocStatusViewController.self, sender: self.getTopView(), completion: { controller in
//            })
//        }
//        return
        
        //Infert all on bank
        UserRN.setNeedToSendDocs(sent: true)
        if documents.isEmpty {
            return
        }

        for documentProcess in documents {
            //check all docs for search if has approved or in analysis
            if(!documentProcess.documents.isEmpty) {
                for documentImage in documentProcess.documents {
                    if documentImage.imageType != ActionFinder.Documents.Types.FACE_CARTAO {
                        UserRN.setNeedToSendDocs(sent: false)
                    }
                }
            }

            //If is pending, save at local database
            if documentProcess.status == ActionFinder.Documents.Status.ANALISE {
                
                documentProcessDAO.insert(with: documentProcess)
                if !documentProcess.documents.isEmpty {
                
                    documentImageDAO.insert(with: documentProcess.documents)
                }

                //check all docs for search if has approved or in analysis
                for documentImage in documentProcess.documents {
                    if documentImage.imageType != ActionFinder.Documents.Types.FACE_CARTAO {
                        UserRN.setNeedToSendDocs(sent: false)
                    }
                }
            }
                //Otherwise, start the doc status activity
            else {
                //if it's approved, set tha was seen before start the popup
                if documentProcess.status == ActionFinder.Documents.Status.APROVADO {
                    self.setSeen(processId: documentProcess.processId)
                }

                DocStatusViewController.mDocumentProcess = documentProcess
                DispatchQueue.main.async {
                    Util.showController(DocStatusViewController.self, sender: self.getTopView(), completion: { controller in
                    })
                }
            }
        }
    }
    
    func getDocumentImageStatus() {
    }
    
    func getCreditCards() {
    }
    
    func getDeniedCreditCardsStatus() {
    }
    
    func verifyPendingCards() {
    }
    
    static func setRemberLaterTime() {
    }
    
    static func clearRemberLaterTime() {
    }
    
    static func setShowDocPopup(canShow: Bool) {
    }
    
    static func canShowDocPopup() -> Bool {
        return false
    }
    
    static func getDocumentStatus() -> Bool {
        return false
    }
    
    static func canShowDocWarning() -> Bool {
        return false
    }
    
    static func setCanShowDocWarning(canShow: Bool) {
    }
    
    func setSeenWithoutThread(processId: Int, completion: @escaping (_ result: Bool) -> Void) {
        
        let objectData = DocumentSeenBody(processId: processId)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedSetSeen, json: serviceBody)
        
        callApi(request: request) { (response) in
            
            if response.sucess {
                UserRN.setNeedToSendDocs(sent: false)
            }
            
            completion(response.sucess)
        }
    }
    
    static func changeDocumentStatus(document: DocumentImage, tvDocNumber: UITextView, tvDocStatus: UITextView, tvDocReason: UITextView) {
        
    }
    
    func startDocStatusActivityAfeterAWhile(documentProcess: DocumentProcess) {
    }
}

extension DocumentsRN: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
    }
}

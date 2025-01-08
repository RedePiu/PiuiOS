//
//  DocumentImage.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class DocumentImage: BasePojo {

    @objc dynamic var docId: Int = 0
    @objc dynamic var imageType: Int = 0
    @objc dynamic var imageId: String?
    @objc dynamic var bucketTag: String?
    @objc dynamic var status: Int = 0
    @objc dynamic var obs: String = ""
    
    override public static func primaryKey() -> String? {
        return "docId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {

        docId <- map["id_documento"]
        imageType <- map["tipo"]
        imageId <- map["id_imagem"]
        bucketTag <- map["tag_bucket"]
        status <- map["status"]
        obs <- map["observacao"]
    }
    
    convenience init(anexo: Anexo) {
        self.init()
        
        self.imageType = anexo.type
        self.bucketTag = anexo.tag
    }
    
    convenience init(imageType: Int, imageId: String, bucketTag: String) {
        self.init()
        
        self.imageId = imageId
        self.imageType = imageType
        self.bucketTag = bucketTag
    }
    
    convenience init(documentImageRequest: DocumentImageRequest) {
        self.init()
        
        self.imageId = documentImageRequest.imageId
        self.imageType = documentImageRequest.imageType
        self.bucketTag = documentImageRequest.bucketTag
    }
}

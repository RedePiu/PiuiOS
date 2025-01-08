//
//  DocumentImageRequest.swift
//  MyQiwi
//
//  Created by Ailton on 13/11/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class DocumentImageRequest: BasePojo {
    
    @objc dynamic var imageType: Int = 0
    var imageId: String?
    var bucketTag: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
//    "tag_bucket":"d3d75c378282080e0b26c20e320f77eb",
//    "id":0,
//    "id_imagem":"221528713112018131725.jpg",
//    "tipo":1
    
    override func mapping(map: Map) {
        
        imageType <- map["tipo"]
        imageId <- map["id_imagem"]
        bucketTag <- map["tag_bucket"]
    }
    
    convenience init(imageType: Int, imageId: String, bucketTag: String) {
        self.init()
        
        self.imageId = imageId
        self.imageType = imageType
        self.bucketTag = bucketTag
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>

        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {

        // Extract optional
        let bodyString = "{\"tag_bucket\":\"\(self.bucketTag ?? "")\",\"id\":\(0),\"id_imagem\":\"\(self.imageId ?? "")\",\"tipo\":\(self.imageType)}"
        return bodyString
    }
}

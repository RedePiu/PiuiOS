//
//  MenuItem.swift
//  MyQiwi
//
//  Created by ailton on 14/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

//import RealmSwift
import ObjectMapper

public class MenuItem: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var order: Int = 0
    @objc dynamic var action: Int = 0
    @objc dynamic var imageMenu: String? = ""
    @objc dynamic var imageLogo: String? = ""
    @objc dynamic var dadId: Int = 0
    @objc dynamic var prvID: Int = 0
    var data: AnyObject? = nil
    var notAvailable: Bool = false
    var descAux: String = ""
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        id          <-  map["id_terminal_menu"]
        desc        <-  map["descricao_menu"]
        order       <-  map["ordenacao"]
        action      <-  map["id_acao"]
        imageMenu   <-  map["path_imagem_icone"]
        imageLogo   <-  map["path_imagem_logo"]
        dadId       <-  map["id_pai"]
        prvID       <-  map["osmpproviderid"]
    }
    
    convenience init(description: String, data: AnyObject?) {
        self.init()
        
        self.desc = description
        self.data = data
    }
    
    convenience init(description: String, descAux: String, data: AnyObject?) {
        self.init()
        
        self.desc = description
        self.descAux = descAux
        self.data = data
    }
 
    convenience init(description: String, order: Int, imageMenu: String) {
        self.init()
        
        self.desc = description
        self.imageMenu = imageMenu
    }
    
    convenience init(description: String, action: Int, imageMenu: String) {
        self.init()
        
        self.desc = description
        self.action = action
        self.imageMenu = imageMenu
    }
    
    convenience init(description: String, action: Int, imageMenu: String, prvid: Int) {
        self.init()
        
        self.desc = description
        self.action = action
        self.imageMenu = imageMenu
        self.prvID = prvid
    }
    
    convenience init(description: String, image: String, action: Int, id: Int) {
        self.init()
        
        self.desc = description
        self.action = action
        self.imageMenu = image
        self.id = id
    }
    
    convenience init(description: String, image: String, action: Int, id: Int, data: AnyObject?) {
        self.init()
        
        self.desc = description
        self.action = action
        self.imageMenu = image
        self.id = id
        self.data = data as AnyObject
    }
    
    convenience init(description: String, image: String, id: Int, prvid: Int) {
        self.init()
        
        self.desc = description
        self.imageMenu = image
        self.id = id
        self.prvID = prvid
    }
    
    convenience init(description: String, image: String, id: Int, prvid: Int, data: AnyObject?) {
        self.init()
        
        self.desc = description
        self.imageMenu = image
        self.id = id
        self.prvID = prvid
        self.data = data as AnyObject
    }

    convenience init(description: String, image: String, id: Int, data: AnyObject?) {
        self.init()
        
        self.desc = description
        self.imageMenu = image
        self.data = data as AnyObject
        self.id = id
    }
    
    convenience init(id: Int, description: String, action: Int, imageMenu: String, data: AnyObject? = nil) {
        self.init()
        
        self.id = id
        self.desc = description
        self.action = action
        self.imageMenu = imageMenu
        self.data = data
    }
}

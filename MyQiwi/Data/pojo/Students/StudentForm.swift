//
//  StudentForm.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 26/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class StudentForm : BasePojo {
    
    static var ID_CLASSTIME_NORMAL: Int = 1
    static var ID_CLASSTIME_SATURDAY: Int = 2
    static var ID_CLASSTIME_DESPORTIVA: Int = 3
   
    @objc dynamic var id: Int = 0
    @objc dynamic var idTipoParticipante: Int = 0
    @objc dynamic var idEmissor: Int = 0
    
    @objc dynamic var name: String = ""
    @objc dynamic var rg: String = ""
    @objc dynamic var cpf: String = ""
    @objc dynamic var birthDate: String = ""
    @objc dynamic var father: String = ""
    @objc dynamic var mother: String = ""
    
    @objc dynamic var cep: String = ""
    @objc dynamic var street: String = ""
    @objc dynamic var number: String = ""
    @objc dynamic var complement: String = ""
    @objc dynamic var district: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var state: String = ""
    
    @objc dynamic var dependent: DependentStudent?
    var schoolList: [SchoolForm]?
    var lineList: [Int]?
    var classTimeList: [ClassTime]?
    var dayList: [Int]?
    var documentList: [DocumentImage]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        idTipoParticipante <- map["IdTipoParticipanteProdata"]
        idEmissor <- map["IdEmissor"]
        
        name <- map["Nome"]
        rg <- map["Rg"]
        cpf <- map["Cpf"]
        birthDate <- map["DataNascimento"]
        father <- map["NomePai"]
        mother <- map["NomeMae"]
        
        cep <- map["Cep"]
        street <- map["Logradouro"]
        number <- map["Numero"]
        complement <- map["Complemento"]
        district <- map["Bairro"]
        city <- map["Cidade"]
        state <- map["Estado"]
        
        dependent <- map["Dependente"]
        schoolList <- map["Escolas"]
        lineList <- map["Linhas"]
        classTimeList <- map["Horarios"]
        dayList <- map["Dias"]
        documentList <- map["Documentos"]
    }
    
    func findClassTime(id: Int) -> ClassTime? {
        if self.classTimeList == nil || self.classTimeList!.isEmpty {
            return nil
        }
        
        for t in self.classTimeList! {
            if t.idTimeType == id {
                return t
            }
        }
        
        return nil
    }
    
    func hasDocument(imageType: Int) -> Bool {
        if self.documentList == nil || self.documentList!.isEmpty {
            return false
        }
        
        for doc in self.documentList! {
            if doc.imageType == imageType {
                return true
            }
        }
        
       return false
    }
    
//    public ClassTime findClassTime(int id) {
//        if (classTimeList == null || classTimeList.isEmpty()) {
//            return null;
//        }
//
//        for (ClassTime t : classTimeList) {
//            if (t.getIdTimeType() == id) {
//                return t;
//            }
//        }
//
//        return null;
//    }
}


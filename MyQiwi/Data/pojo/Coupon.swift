//
//  Coupon.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper
//import RealmSwift

public class Coupon: BasePojo {
    
//    string cod_cupom,
//    DateTime validade
//    decimal valor
//    produtos:
//    [
//       int id_prv,
//       string nome
//    ]
    
    @objc dynamic var code: String = ""
    @objc dynamic var expiration: String = ""
    @objc dynamic var value: Double = 0
    @objc dynamic var isAcumulative: Bool = false
    @objc dynamic var canPassValue: Bool = true
    var products = [CouponProduct]()
    
    override public static func primaryKey() -> String? {
        return "code"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        code <- map["cod_cupom"]
        expiration <- map["validade"]
        value <- map["valor"]
        isAcumulative <- map["fl_acumulativo"]
        canPassValue <- map["fl_compra_menor"]
        products <- map["produtos"]
    }
    
    convenience init(code: String, expiration: String, value: Double, isAcumulative: Bool = false, canPassValue: Bool = false, products: [CouponProduct] = [CouponProduct]()) {
        self.init()
        
        self.code = code
        self.expiration = expiration
        self.value = value
        self.isAcumulative = isAcumulative
        self.canPassValue = canPassValue
        self.products = products
    }
    
    func isCouponAvailableForPrvAndValue(prvid: Int, value: Int) -> Bool {
        let transationValue = Double(value/100)
        
        //Não pode usar
        if !self.canPassValue && self.value > transationValue {
            return false
        }
        
        //Se não tem limitação de produtos, pode exibir
        if self.products.isEmpty {
            return true
        }
        
        //Se existir limitacão, chega para ver se pode exibir
        for product in self.products {
            if product.prvid == prvid {
               return true
            }
        }
        
        return false
    }
    
    func isCouponAvailableForCouponPaymentMethod(prvid: Int, value: Int) -> Bool {
        let transationValue = Double(value/100)
        
        //Não pode usar
        if  !self.canPassValue && self.value > transationValue {
            return false
        }
        
        //Se for não for acumulativo, só pode ter valor igual
        if !self.isAcumulative && !self.canPassValue && self.value != transationValue {
            return false
        }
        
        //Se não tem limitação de produtos, pode exibir
        if self.products.isEmpty {
            return true
        }
        
        //Se existir limitacão, chega para ver se pode exibir
        for product in self.products {
            if product.prvid == prvid {
               return true
            }
        }
        
        return false
    }
}


//
//  CouponRN.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation

class CouponRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    /**
     * Get the user's current balance.<bR><br>
     * It will response thor Param: PARKING_CARDS_BALANCE_RESPONSE
     */
    func addCoupon(code: String) {
        let serviceBody = getServiceBody(AddCouponBody.self, objectData: AddCouponBody(code: code))
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedAddCoupon, object: serviceBody)
        var msg = ""
        
        callApiForList(Coupon.self, request: request) { (response) in
            
            if response.sucess {
                let coupons = response.body?.data ?? [Coupon]()
                self.addAvailableTickets(coupons: coupons)
            } else {
                if response.body?.cod == ResponseCodes.INSERT_COUPON_ERROR {
                    msg = "coupon_invalid".localized
                } else {
                    msg = "coupon_error".localized
                }
            }
            
            self.sendContact(fromClass: CouponRN.self, param: Param.Contact.ADD_COUPON_RESPONSE, result: response.sucess, object: msg as AnyObject)
        }
    }
    
    func addAvailableTickets(coupons: [Coupon]) {
        let dao = CouponDAO()
        dao.deleteAll()
        dao.insert(with: coupons)
    }
    
    func getAvailableCoupons() -> [Coupon] {
        
//        var cupons = CouponDAO().getAll()
//        var products = [CouponProduct(prvid: 3333, name: "Zona Azul"), CouponProduct(prvid: 2233, name: "Google Play")]

        //yyyy-MM-dd'T'HH:mm:ssyyyy-MM-dd'T'HH:mm:ss
//        cupons.append(Coupon(code: "1234567891234567", expiration: "2020-04-20'T'00:00:00",  value: 10))
//        cupons.append(Coupon(code: "abcdefghijklmnop", expiration: "2020-04-22'T'00:00:00", value: 10, isAcumulative: true))
//        cupons.append(Coupon(code: "abcdefghijklmno1", expiration: "2020-04-20'T'00:00:00", value: 30))
//        cupons.append(Coupon(code: "abcdefghijklmnop", expiration: "2020-04-22'T'00:00:00", value: 10, isAcumulative: true))
//        cupons.append(Coupon(code: "abcdefghijklmnop", expiration: "2020-04-22'T'00:00:00", value: 10, isAcumulative: true))
//        cupons.append(Coupon(code: "abcdefghijklmno2", expiration: "2020-04-20'T'00:00:00", value: 10, isAcumulative: true))
//        cupons.append(Coupon(code: "1234567891234568", expiration: "2020-04-20'T'00:00:00", value: 20, products: products))
//        cupons.append(Coupon(code: "abcdefghijklmno3", expiration: "2020-04-20'T'00:00:00", value: 12, products: products))
//        cupons.append(Coupon(code: "abcdefghijklmno4", expiration: "2020-04-20'T'00:00:00", value: 10, isAcumulative: true))
//        cupons.append(Coupon(code: "1234567891234569", expiration: "2020-04-20'T'00:00:00", value: 10, isAcumulative: true))
//        cupons.append(Coupon(code: "1234567891234563", expiration: "2020-04-20'T'00:00:00", value: 12))
//        cupons.append(Coupon(code: "1234567891234560", expiration: "2020-04-20'T'00:00:00", value: 10, isAcumulative: true))
//        cupons.append(Coupon(code: "1234567891234562", expiration: "2020-04-20'T'00:00:00", value: 10, isAcumulative: true))
//        return cupons
        
        return CouponDAO().getAll()
    }
    
    func getAvailableCouponsForPrvAndValue(prvid: Int, value: Int) -> [Coupon] {
        let coupons = CouponDAO().getAll()
        var available = [Coupon]()
        
        if !coupons.isEmpty {
            for c in coupons {
                if c.isCouponAvailableForCouponPaymentMethod(prvid: prvid, value: value) {
                    available.append(c)
                }
            }
        }
        
        return available
    }
}

//
//  OrdersPro.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 16/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class OrdersProRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getDividasAsOrderPro(transacoes: [DividaDetailsResponse]) -> [OrderPro]{
        var orders = [OrderPro]()
        
        for tr in transacoes {
            orders.append(OrderPro(dividaDetails: tr))
        }
        
        return orders
    }
    
    func getOrders(daysBack: Int, type: Int) {
        
        //let yearsToAdd = -1
        let currentDate = Date()
        
        var dateComponent = DateComponents()
        //dateComponent.year = yearsToAdd
        dateComponent.day = -daysBack
        
        let fromDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        getOrders(fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: currentDate), type: type)
    }
    
    func getOrders(date: Date, type: Int) {
        
        var dateComponent = DateComponents()
        dateComponent.setValue(date.day, for: .day)
        dateComponent.setValue(date.month, for: .month)
        dateComponent.setValue(date.year, for: .year)
        dateComponent.setValue(0, for: .hour)
        dateComponent.setValue(0, for: .minute)
        dateComponent.setValue(0, for: .second)
        
        var toDateComponent = dateComponent
        toDateComponent.setValue(date.day, for: .day)
        toDateComponent.setValue(date.month, for: .month)
        toDateComponent.setValue(date.year, for: .year)
        toDateComponent.setValue(23, for: .hour)
        toDateComponent.setValue(59, for: .minute)
        toDateComponent.setValue(59, for: .second)
        
        let fromDate = Calendar.current.date(from: dateComponent)
        let toDate = Calendar.current.date(from: toDateComponent)
        
        getOrders(fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: toDate!), type: type)
    }
    
    func getOrders(month: Int, year: Int, type: Int) {
        
        var dateComponent = DateComponents()
        dateComponent.setValue(month, for: .month)
        dateComponent.setValue(year, for: .year)
        dateComponent.setValue(1, for: .day)
        
        var toDateComponent = dateComponent
        toDateComponent.setValue(23, for: .hour)
        toDateComponent.setValue(59, for: .minute)
        toDateComponent.setValue(59, for: .second)
        toDateComponent.year = 0
        toDateComponent.month = 1 //pula um mes
        toDateComponent.day = -1 //volta 1 dia
        
        let fromDate = Calendar.current.date(from: dateComponent)
        let toDate = Calendar.current.date(byAdding: toDateComponent, to: fromDate!)
        
        getOrders(fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: toDate!), type: type)
    }
    
    func getOrders(fromDate: String, toDate: String, type: Int) {
        
//        orders.append(OrderPro(prvid: 1000, product: "Bilhete Único", value: 50, commission: 1, isPrePago: true, transitionId: 1))
//        orders.append(OrderPro(prvid: 1000, product: "Bilhete Único", value: 70, commission: 1.20, isPrePago: false, transitionId: 1))
//        orders.append(OrderPro(prvid: 1000, product: "Bilhete Único", value: 30, commission: 3, isPrePago: true, transitionId: 1))
//        orders.append(OrderPro(prvid: 1001, product: "Vivo", value: 50, commission: 1, isPrePago: false, transitionId: 1))
//        orders.append(OrderPro(prvid: 1001, product: "Vivo", value: 10, commission: 0.20, isPrePago: false, transitionId: 1))
//        orders.append(OrderPro(prvid: 1001, product: "Vivo", value: 5, commission: 1, isPrePago: true, transitionId: 0))
//        orders.append(OrderPro(prvid: 1002, product: "Claro", value: 30, commission: 1, isPrePago: true, transitionId: 1))
//        orders.append(OrderPro(prvid: 1002, product: "Claro", value: 40, commission: 1, isPrePago: false, transitionId: 1))
//        orders.append(OrderPro(prvid: 1000, product: "Bilhete Único", value: 50, commission: 1, isPrePago: true, transitionId: 1))
//
//        ordersContainer.append(OrderProContainer(date: "2019-10-17T16:40:40", items: orders))
//        ordersContainer.append(OrderProContainer(date: "2019-10-14T16:40:40", items: orders))
//        ordersContainer.append(OrderProContainer(date: "2019-10-09T16:40:40", items: orders))
//        ordersContainer.append(OrderProContainer(date: "2019-09-25T16:40:40", items: orders))
//
//        self.sendContact(fromClass: OrdersProRN.self, param: Param.Contact.ORDER_PRO_LIST_RESPONSE,
//                                     result: true, object: ordersContainer as AnyObject)
        
        // Create request
        let consultBody = OrderProBody(fromDate: fromDate, toDate: toDate, type: type)

        //At this case JSON must be ordened with a specific order.
        //updateJsonWithHeader must be called with generateJsonBody
        //A data object will be returned to send to the server
        let serviceBody = updateJsonWithHeader(jsonBody: consultBody.generateJsonBody())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedComplementOrderPro, json: serviceBody)

        var ordersContainer = [OrderProContainer]()
        callApiForList(OrderProContainer.self, request: request) { (orderResponse) in

            //If failed to get the baptism response
            if orderResponse.sucess {
                ordersContainer = (orderResponse.body?.data)!
            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: OrdersProRN.self, param: Param.Contact.ORDER_PRO_LIST_RESPONSE,
                             result: orderResponse.sucess, object: ordersContainer as AnyObject)
        }
    }
    
    func splitOrders(orderContainers: [OrderProContainer], type: Int) -> [OrderProContainer] {
        var containers = [OrderProContainer]()
        var orders: [OrderPro]
        
        //Passa por todos os containers de data
        for oc in orderContainers {
            
            //Zera a lista para verificar se existem do mesmo tipo
            orders = [OrderPro]()
            for order in oc.items {
                if type == ActionFinder.OrderPro.TYPE_PRE_PAGO && order.isPrePago {
                    orders.append(order)
                }
                
                else if type == ActionFinder.OrderPro.TYPE_POS_PAGO && !order.isPrePago {
                    orders.append(order)
                }
                //Todos
                else if type == ActionFinder.OrderPro.TYPE_ALL {
                    orders.append(order)
                }
            }
            
            //Se houver algum do tipo, inclui o container
            if !orders.isEmpty {
                containers.append(OrderProContainer(date: oc.date, items: orders))
            }
        }
        
        return containers
    }
    
    func somarValores(dividas: [DividaDetailsResponse]) -> [ProValue] {
        return somarValores(orders: self.getDividasAsOrderPro(transacoes: dividas))
    }
    
    func somarValores(orders: [OrderPro]) -> [ProValue] {
        var proValues = [ProValue]()
        var index = -1
        
        for order in orders {
            
            index = self.containsValue(proValues: proValues, prvid: order.prvid)
            
            //Não existe na lista ainda
            if index == -1 {
                proValues.append(ProValue(order: order))
                continue
            }
            
            //Já existe
            proValues[index].addPrice(price: order.value)
            proValues[index].addCommission(commission: order.commission)
        }
        
        return proValues
    }
    
    func somarValores(containers: [OrderProContainer]) -> [ProValue] {
        var proValues = [ProValue]()
        var index = -1
        
        for container in containers {
            //Passa por todos os itens
            for order in container.items {
                
                index = self.containsValue(proValues: proValues, prvid: order.prvid)
                
                //Não existe na lista ainda
                if index == -1 {
                    proValues.append(ProValue(order: order))
                    continue
                }
                
                //Já existe
                proValues[index].addPrice(price: order.value)
                proValues[index].addCommission(commission: order.commission)
            }
        }
        
        return proValues
    }
    
    /**
        Verifica se contem um prvid na lista de valores.
        Se tiver, retorna o index. Caso contrário retorna -1.
     */
    private func containsValue(proValues: [ProValue], prvid: Int) -> Int {
        
        for i in 0..<proValues.count {
            if proValues[i].prvid == prvid {
                return i
            }
        }
        
        return -1
    }
    
    func calculateTotalPrice(proValues: [ProValue]) -> Double {
        var total: Double = 0
        
        for value in proValues {
            total += value.price
        }
        
        return total
    }
    
    func calculateTotalCommission(proValues: [ProValue]) -> Double {
        var total: Double = 0
        
        for value in proValues {
            total += value.commission
        }
        
        return total
    }
}

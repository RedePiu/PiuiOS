//
//  ValidaTipoBoleto.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class ValidaTipoBoleto {
    
    var linhaDigitavel: String = ""
    
    init(codigoBarras: String, linhaDigitavel: Bool) {
        if(linhaDigitavel) {
            self.linhaDigitavel = codigoBarras
        } else {
            self.linhaDigitavel = parseCodigoBarrasLinhaDigitavel(codigoBarras: codigoBarras)
        }
    }
    
    public func getLinhaDigitavel() -> String {
        return linhaDigitavel;
    }
    
    public func setLinhaDigitavel(linhaDigitavel: String) {
        self.linhaDigitavel = linhaDigitavel;
    }
    
    public func parseCodigoBarrasLinhaDigitavel(codigoBarras: String) -> String {
        return ""
    }
    
    public func validarLinhaDigitavel(/*String linhaDigitavel*/) -> Bool {
        return false
    }
    
    public func validarBlocoLinhaDigitavel(/*String linhaDigitavel*/) -> Bool {
        return false
    }
    
    public func getValorBoleto(/*String linhaDigitavel*/) -> Int {
        return 0
    }
    
    public func getDataVencimento(/*String linhaDigitavel*/) -> String {
        return ""
    }
    
    public func getLinhaDigitavelSemFormatacao() -> String {
        return self.linhaDigitavel.removeAllCaractersExceptNumbers()
    }
    
    public func modulo10(_ numero: String) -> Int {
        let number = numero.removeAllOtherCaracters()
        var soma = 0
        var peso: Int = 2
        var contador = number.count - 1
    
        while contador >= 0 {
            let sub = Int(number.substring(contador, contador + 1)) ?? 0
            var multiplicacao = sub * peso;
        
            if multiplicacao >= 10 {
                multiplicacao = 1 + (multiplicacao - 10);
            }
            
            soma = soma + multiplicacao;
            
            if peso == 2 {
                peso = 1;
            } else {
                peso = 2
            }
            
            contador = contador - 1
        }
        
        var digito = 10 - (soma % 10)
        
        if digito == 10 {
            digito = 0;
        }
        
        return digito
    }
    
    public func modulo11(_ numero: String) -> Int {
        let number = numero.removeAllOtherCaracters()
        
        var valorDAC: Int = 0
        var fatorMultiplicador: Int = 2
        
        let base: Int = 9
        let size: Int = number.count - 1
        
        for i in (0...size).reversed() {
            let sub = Int(number.substring(i, i + 1)) ?? 0
            valorDAC = valorDAC + (sub * fatorMultiplicador)
            
            if fatorMultiplicador < base {
                fatorMultiplicador = fatorMultiplicador + 1
            } else {
                fatorMultiplicador = 2
            }
        }
        
        valorDAC = (valorDAC % 11)
        
        if valorDAC <= 1 {
            valorDAC = 0
        }
        else if valorDAC == 10 {
            valorDAC = 1
        }
        else {
            valorDAC = 11 - valorDAC
        }
        return valorDAC
    }
    
    public func getDataVencimentoComFator(fatorVencimento:String) -> String {
        let venc:String!
        if fatorVencimento == "0000" {
            venc = "Boleto pode ser pago em qualquer data."
        } else{ 
            
            //PEGANDO VENCIMENTO QUE É A DATA BASE DO FEBRABAN 07/10/1997 + Numero de dias da posicao 34-37
            let database = "07/10/1997"
            let formartter = DateFormatter()
            formartter.dateFormat = "dd/MM/yyyy"
            let data_aux = formartter.date(from: database)
            let dias:Int = ((fatorVencimento as NSString).integerValue)
            let venc_date = NSCalendar.current.date(byAdding: .day, value: dias, to: data_aux!)
            //        let venc_date = NSCalendar.currentCalendar.dateByAddingUnit(NSCalendar.Unit.Day, value: dias, toDate: data_aux!, options: NSCalendar.Options.init(rawValue: 0))
            
            venc = formartter.string(from: venc_date!)
            
        }
        
        return venc
    }
}

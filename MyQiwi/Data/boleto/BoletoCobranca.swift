//
//  BoletoCobranca.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class BoletoCobranca: ValidaTipoBoleto {
    
    override init(codigoBarras: String, linhaDigitavel: Bool) {
        super.init(codigoBarras: codigoBarras, linhaDigitavel: linhaDigitavel)
    }
    
    override func getValorBoleto() -> Int {
        linhaDigitavel = getLinhaDigitavelSemFormatacao()
    
        if (linhaDigitavel.count > 44) {
            let sub = (linhaDigitavel.substring(37, linhaDigitavel.count))
            return Int(sub) ?? 0
        }
    
        return 0
    }
    
    override func getDataVencimento() -> String {
        linhaDigitavel = getLinhaDigitavelSemFormatacao()
        
        if linhaDigitavel.count > 44 {

            let sub = (linhaDigitavel.substring(33, 37))
            return getDataVencimentoComFator(fatorVencimento:sub)
        }
        
        return "";
    }
    
    override func parseCodigoBarrasLinhaDigitavel(codigoBarras: String) -> String {
        var linha = codigoBarras.removeAllCaractersExceptNumbers()
        
        if linha.count != 44 {
            return codigoBarras
        }
        
        let campo1 = linha.substring(0, 4) + linha[19] + "." + linha.substring(20, 24)
        let campo2 = linha.substring(24, 29) + "." + linha.substring(29, 34)
        let campo3 = linha.substring(34, 39) + "." + linha.substring(39, 44)
        let campo4 = linha.substring(4,  5)
        let campo5 = linha.substring(5, 19)
        
//        codigoBarras = campo1 + modulo10(campo1) + ' ' + campo2 + modulo10(campo2) + ' ' + campo3 + modulo10(campo3)
//            + ' ' + campo4 + ' ' + campo5;
        var novoCodigoBarras = "\(campo1)\(modulo10(campo1)) \(campo2)\(modulo10(campo2)) \(campo3)\(modulo10(campo3)) \(campo4) \(campo5)"
        
        self.linhaDigitavel = novoCodigoBarras
        return linhaDigitavel
    }
    
    override func validarLinhaDigitavel() -> Bool {
        linhaDigitavel = getLinhaDigitavelSemFormatacao()
        
        if (linhaDigitavel.count == 47) {
        
            if "00000000000000000000000000000000000000000000000" == linhaDigitavel {
                return false
        }
        
        let campo1 = linhaDigitavel.substring(from: 0, to: 9)
        let dv1 = Int(linhaDigitavel.substring(from: 9, to: 10))
        let campo2 = linhaDigitavel.substring(from: 10, to: 20)
        let dv2 = Int(linhaDigitavel.substring(from: 20, to: 21))
        let campo3 = linhaDigitavel.substring(from: 21, to: 31)
        let dv3 = Int(linhaDigitavel.substring(from: 31, to: 32))
    
        let campos = [
            campo1 : dv1,
            campo2 : dv2,
            campo3 : dv3
        ]
        
        for (cmp, vlr) in campos {
            var total = 0
            let campo = cmp
            let dv = vlr
            
            for i in 0..<campo.count {
                let valor = Int(campo[i]) ?? 0
                var result: Int = 0
                
                if campo.count == 10 {
                    if i % 2 == 0 {
                        result = valor * 1
                    } else {
                        result = valor * 2
                    }
                } else {
                    if i % 2 == 0 {
                        result = valor * 2
                    } else {
                        result = valor * 1
                    }
                }
                
                let retorno = String(result)
                if (retorno.count > 1) {
                    var resultLocal = 0
                    
                    for j in 0..<retorno.count {
                        resultLocal += Int(retorno[j]) ?? 0
                    }
                    
                    result = resultLocal;
                }
                
                total += result
                }
            
                var proximo = 0
                if total % 10 != 0 {
                    proximo = ((total + 10) / 10) * 10;
                } else {
                    proximo = total;
                }
            
                if (proximo - total) != dv {
                    return false
                } else {
                    return true
                }
            
            }
        
        }
        
        return false
    }
    
    override func validarBlocoLinhaDigitavel() -> Bool {
        linhaDigitavel = getLinhaDigitavelSemFormatacao()
        let tamanho = linhaDigitavel.count
        
        if tamanho == 32 {
            if !validarBloco1(linhaDigitavel) {
                return false
            }
            
            if !validarBloco2(linhaDigitavel) {
                return false
            }
            
            if !validarBloco3(linhaDigitavel) {
                return false
            }
        }
        
        if tamanho >= 21 {
            if !validarBloco1(linhaDigitavel) {
                return false
            }
            
            if !validarBloco2(linhaDigitavel) {
                return false
            }
            
            return true
        }
        
        if tamanho >= 10 {
            if !validarBloco1(linhaDigitavel) {
                return false
            }
        }
        
        return true
    }
    
    private func validarBloco1(_ linhaDigitavel: String) -> Bool {
        let dv = Int(linhaDigitavel.substring(9, 10)) ?? 0
        return realizaCalculo(linhaDigitavel.substring(0, 9), dv)
    }
    
    private func validarBloco2(_ linhaDigitavel: String) -> Bool {
        let dv = Int(linhaDigitavel.substring(20, 21)) ?? 0
        return realizaCalculo(linhaDigitavel.substring(10, 20), dv)
    }
    
    private func validarBloco3(_ linhaDigitavel: String) -> Bool {
        let dv = Int(linhaDigitavel.substring(31, 32)) ?? 0
        return realizaCalculo(linhaDigitavel.substring(21, 31), dv)
    }
    
    private func realizaCalculo(_ campo: String,_ dv: Int) -> Bool {
    
        var total = 0
        
        if campo == "000000000" || campo == "0000000000" {
            return false
        }
        
        for i in 0..<campo.count {
            let valor = Int(campo[i]) ?? 0
            var result = 0
            
            if campo.count == 10 {
                if i % 2 == 0 {
                    result = valor * 1
                } else {
                    result = valor * 2
                }
            } else {
                if i % 2 == 0 {
                    result = valor * 2
                } else {
                    result = valor * 1
                }
            }
            
            let retorno = String(result)
            if (retorno.count > 1) {
                var resultLocal = 0
                for j in 0..<retorno.count {
                    resultLocal += Int(retorno[j]) ?? 0
                }
                
                result = resultLocal
            }
            
            total += result
        }
        
        var proximo = 0
        if total % 10 != 0 {
            proximo = ((total + 10) / 10) * 10
        } else {
            proximo = total
        }
        
        if (proximo - total) != dv {
            return false
        } else {
            return true
        }
    }
}

//
//  ContaConsumo.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class ContaConsumo: ValidaTipoBoleto {
    
    override init(codigoBarras: String, linhaDigitavel: Bool) {
        super.init(codigoBarras: codigoBarras, linhaDigitavel: linhaDigitavel)
    }
    
    override func parseCodigoBarrasLinhaDigitavel(codigoBarras: String) -> String {
        var linha = codigoBarras.removeAllOtherCaracters()
    
        if linha.count != 44 {
            return codigoBarras
        }
    
        let campo1 = linha.substring(0, 11)
        let campo2 = linha.substring(11, 22)
        let campo3 = linha.substring(22, 33)
        let campo4 = linha.substring(33, 44)
    
        var novoCodigoBarras = ""
        if (campo1[2] == "6" || campo1[2] == "7") {
//            novoCodigoBarras = campo1 + "-" + modulo10(campo1) + " " + campo2 + "-" + modulo10(campo2) + " " + campo3 + "-"
//            + modulo10(campo3) + " " + campo4 + "-" + modulo10(campo4)
            
            novoCodigoBarras = "\(campo1)-\(modulo10(campo1)) \(campo2)-\(modulo10(campo2)) \(campo3)-\(modulo10(campo3)) \(campo4)-\(modulo10(campo4))"
        } else {
//            novoCodigoBarras = campo1 + "-" + modulo11(campo1) + " " + campo2 + "-" + modulo11(campo2) + " " + campo3 + "-"
//            + modulo11(campo3) + " " + campo4 + "-" + modulo11(campo4)
            
            novoCodigoBarras = "\(campo1)-\(modulo11(campo1)) \(campo2)-\(modulo11(campo2)) \(campo3)-\(modulo11(campo3)) \(campo4)-\(modulo11(campo4))"
        }
    
        return novoCodigoBarras
    }
    
    override func validarLinhaDigitavel() -> Bool {
        if linhaDigitavel.count == 48 {
            return validarBlocoLinhaDigitavel()
        } else {
            return false
        }
    }
    
    override func validarBlocoLinhaDigitavel() -> Bool {
        linhaDigitavel = getLinhaDigitavelSemFormatacao()
        let tamanho = linhaDigitavel.count
        
        if (linhaDigitavel.count > 3) {
            let mod10 = linhaDigitavel[2] == "6" || linhaDigitavel[2] == "7"
            
            if tamanho == 48 {
        
                if "000000000000000000000000000000000000000000000000" == linhaDigitavel {
                    return false
                }
            
                if !validarBloco1(mod10) {
                    return false
                }
                
                if !validarBloco2(mod10) {
                    return false
                }
                
                if !validarBloco3(mod10) {
                    return false
                }
                
                if !validarBloco4(mod10) {
                    return false
                }
                
                return true
            }
            
            if tamanho >= 36 {
                if !validarBloco1(mod10) {
                    return false
                }
                
                if !validarBloco2(mod10) {
                    return false
                }
                
                if !validarBloco3(mod10) {
                    return false
                }
                
                return true
            }
            
            if (tamanho >= 24) {
                if !validarBloco1(mod10) {
                    return false
                }
                
                if !validarBloco2(mod10) {
                    return false
                }
                
                return true
            }
            
            if tamanho >= 12 {
                if !validarBloco1(mod10) {
                    return false
                }
                
                return true
            }
            
        }
        
        return true
    }
    
    private func validarBloco1(_ mod10: Bool) -> Bool {
        var mod: Int
        var verificador: Int
        let campo = linhaDigitavel.substring(0, 11)
        
        let inicio = linhaDigitavel.substring(0, 10)
        if (inicio == "0000000000") {
            return false
        }
        
        if (mod10) {
            mod = modulo10(campo)
        } else {
            mod = modulo11(campo)
        }
        
        verificador = Int(linhaDigitavel[11])!
        
        if mod != verificador {
            return false
        }
        
        return true
    }
    
    private func validarBloco2(_ mod10: Bool) -> Bool {
        var mod: Int
        var verificador: Int
        let campo = linhaDigitavel.substring(12, 23)
        
        let inicio = linhaDigitavel.substring(12, 22)
        if (inicio == "0000000000") {
            return false
        }
        
        if (mod10) {
            mod = modulo10(campo);
        } else {
            mod = modulo11(campo);
        }
        
        verificador = Int(linhaDigitavel[23])!
        
        if (mod != verificador) {
            return false
        }
        
        return true
    }
    
    private func validarBloco3(_ mod10: Bool) -> Bool {
        var mod: Int
        var verificador: Int
        let campo = linhaDigitavel.substring(24, 35)
        
        let inicio = linhaDigitavel.substring(24, 34)
        if (inicio == "0000000000") {
            return false
        }
        
        if (mod10) {
            mod = modulo10(campo);
        } else {
            mod = modulo11(campo);
        }
        
        verificador = Int(linhaDigitavel[35])!
        
        if (mod != verificador) {
            return false
        }
        
        return true
    }
    
    private func validarBloco4(_ mod10: Bool) -> Bool {
        var mod: Int
        var verificador: Int
        let campo = linhaDigitavel.substring(36, 47)
        
        let inicio = linhaDigitavel.substring(36, 46)
        if (inicio == "0000000000") {
            return false
        }
        
        if (mod10) {
            mod = modulo10(campo);
        } else {
            mod = modulo11(campo);
        }
        
        verificador = Int(linhaDigitavel[47])!
        
        if (mod != verificador) {
            return false
        }
        
        return true
    }
    
    override func getValorBoleto() -> Int {
        let linha = getLinhaDigitavelSemFormatacao()
        var valor = ""
        
        if linha.count > 44 {
            valor = linhaDigitavel.substring(5, 11)
            valor += linhaDigitavel.substring(12, 16)
        }
        
        if valor == "" {
            return 0
        }
        
        return Int(valor) ?? 0
    }
}

//
//  FactoryFebraban.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class FactoryFebraban {
    
    public static let maskBoleto = "#####.#####  #####.######  #####.######  #  ##############"
    public static let maskConsumo = "###########-#  ###########-#  ###########-#  ###########-#"
    public static let maskBoletoCobrancaEditText = "#####.#####\n#####.######\n#####.######\n#\n##############"
    public static let staticmaskConsumoEditText = "###########-#\n###########-#\n###########-#\n###########-#"
    
    private var boleto: ValidaTipoBoleto?
    private var bankSlip: RequestBankSlip
    private var linhaDigitavel: String
    
    init() {
        self.bankSlip = RequestBankSlip()
        self.linhaDigitavel = ""
    }
    
    public func validarCodigoBarras(codigoBarras: String) -> Bool {
        if (textLeitorCodigoBarras(textCodigoBarras: codigoBarras) || linhaDigitavel.count > 1) {
            linhaDigitavel = linhaDigitavel.removeAllOtherCaracters()
            
            if (linhaDigitavel.count > 1) {
                if (linhaDigitavel[0] != "8") {
                    if (boleto == nil) {
                        boleto = BoletoCobranca(codigoBarras: linhaDigitavel, linhaDigitavel: false)
                    } else {
                        boleto!.setLinhaDigitavel(linhaDigitavel: linhaDigitavel)
                    }
                    
                } else {
                    if (boleto == nil) {
                        boleto = ContaConsumo(codigoBarras: linhaDigitavel, linhaDigitavel: false)
                    } else {
                        boleto!.setLinhaDigitavel(linhaDigitavel: linhaDigitavel)
                    }
                }
                
                return boleto!.validarLinhaDigitavel()
            }
        }
        
        return false
    }
    
    private func textLeitorCodigoBarras(textCodigoBarras: String) -> Bool {
        if (textCodigoBarras.count <= 44 && textCodigoBarras.count > 0) {
            if (textCodigoBarras[0] != "8") {
                
                // Boleto bancario.
                if (boleto == nil) {
                    boleto = BoletoCobranca(codigoBarras: textCodigoBarras, linhaDigitavel: false)
                }
                
                self.linhaDigitavel = boleto!.getLinhaDigitavel()
                return true
            } else {
                // Conta de consumo.
                if (boleto == nil) {
                    boleto = ContaConsumo(codigoBarras: textCodigoBarras, linhaDigitavel: false)
                }
                
                self.linhaDigitavel = boleto!.getLinhaDigitavel()
                return true
            }
        } else {
            self.linhaDigitavel = textCodigoBarras
            return false
        }
    }
    
    public func getTipoBoleto() -> Constants.TipoBoleto {
        if (linhaDigitavel == "") {
            return Constants.TipoBoleto.NENHUM
        }
    
        if (linhaDigitavel.count > 1) {
            if (linhaDigitavel[0] == "8") {
                return Constants.TipoBoleto.CONSUMO
            } else {
                return Constants.TipoBoleto.COBRANCA
            }
        }
        
        return Constants.TipoBoleto.NENHUM
    }
    
    public func getBoleto() -> ValidaTipoBoleto {
        return self.boleto!
    }
}

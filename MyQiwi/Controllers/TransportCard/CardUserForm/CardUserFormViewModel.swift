import UIKit

final class CardUserFormViewModel {
    // MARK: - Properties
    weak var viewController: CardUserFormViewController?
    private let service: TransportCardService
    
    var uploadFileItem = UploadFileCell()
    var layoutForm = [LayoutFormResponse]()
    var camposCreateForm = [CampoCreateForm]()
    var previewImage = UIImageView()
    
    private var campos = [CampoCreateForm]()
    private var uploadedImageID = Int()
    private let idForm: Int
    let fields: [CampoFormResponse]
    var editedStrings = [String]()
    
    // MARK: Retorno dos Campos
    private var isValid: Bool = false
    
    init(service: TransportCardService, idForm: Int, campos: [CampoFormResponse]) {
        self.service = service
        self.idForm = idForm
        self.fields = campos
    }
    
    // MARK: - Functions
    func setupViewImage(baseURL: String, imageView: UIImageView) {
        guard let url = URL(string: baseURL) else {
            print("URL inválida")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro ao fazer download da imagem: \(error)")
            }
            
            guard let imageData = data else {
                print("Não foram recebidos dados da imagem")
                return
            }
            
            if let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                print("Não foi possível criar a imagem a partir dos dados recebidos")
            }
        }
        
        task.resume()
    }
    
    func executeOrder(response: GetTaxasResponse, formSaved: Int, completion: @escaping (() -> Void)) {
        QiwiOrder.checkoutBody.requestProdata = nil
        QiwiOrder.checkoutBody.requestTaxaCampo = RequestTaxaAdm()
        QiwiOrder.checkoutBody.requestTaxaCampo?.id_taxa = response.Id_Taxa
        QiwiOrder.checkoutBody.requestTaxaCampo?.cpf = Constants.cpfTaxa
        QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos = []
        
        for campo in response.Campos ?? [] {
            switch campo.Tag {
            case "id_formulario":
                appendFields(from: campo, value: formSaved)
            case "tipo_formulario":
                appendFields(from: campo, value: Constants.idTipoCarga)
            default:
                break
            }
        }
        
        QiwiOrder.setTransitionAndValue(value: response.Valor_Taxa)
        QiwiOrder.productName = response.Nome
        QiwiOrder.setPrvId(prvId: response.Id_Prv)
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        completion()
    }
    
    func populaCampos(pagina: Int) -> Bool {
        var sendAmazon = false
        
        for linha in layoutForm.filter({ $0.Pagina == pagina }) {
            for field in fields where field.Id_Campo == linha.Id {
                if linha.Controle == "Text" || linha.Controle == "TextArea" {
                    if let txtView = viewController?.view?.viewWithTag(linha.Id) as? MaterialField {
                        if !field.Fl_Validado && linha.Fl_Obrigatorio && txtView.text == "" {
                            self.viewController?.displayAlert(
                                title: "Dados Obrigatórios",
                                description: "O campo \(linha.Descricao) deve ser preenchido"
                            )
                        }
                        
                        if field.Fl_Validado {
                            let campo: CampoCreateForm = CampoCreateForm()
                            campo.idCampo = linha.Id
                            campo.Valor = txtView.text!
                            self.camposCreateForm.append(campo)
                        }
                        
                        let campo: CampoCreateForm = CampoCreateForm()
                        campo.idCampo = linha.Id
                        campo.Valor = txtView.text!
                        self.camposCreateForm.append(campo)
                    }
                }
                
                if linha.Controle == "InputFile" {
                    if let imageView = viewController?.view.viewWithTag(linha.Id) as? UIImageView {
                        if imageView.image == nil || linha.Fl_Obrigatorio {
                            self.viewController?.displayAlert(
                                title: "Dados Obrigatórios",
                                description: "A imagem \(linha.Descricao) deve ser enviada"
                            )
                        }
                    }
                }
            }
        }
        return true
    }
    
    func sendForm(completion: @escaping (() -> Void)) {
        if let viewController {
            Util.showLoading(viewController)
        }
        
        completion()
    }
    
    func createViewHeader(
        from layout: LayoutFormResponse,
        label: UILabel,
        image: UIImageView,
        stackView: UIStackView
    ) {
        switch layout.Controle {
        case "Titulo":
            viewController?.navigationTitle = layout.Descricao
        case "Label":
            label.text = layout.Descricao
        case "Imagem":
            image.tag = layout.Id
            setupViewImage(
                baseURL: layout.Observacao,
                imageView: image
            )
        default:
            break
        }
    }
    
    func createFormFields(from layout: LayoutFormResponse, stackView: UIStackView) {
        switch layout.Controle {
        case "Text", "TextArea":
            do {
                let data = NSMutableData()
                let archiver = NSKeyedArchiver(forWritingWith: data)
                let stTextView = UITextView()
                stTextView.encode(with: archiver)
                archiver.finishEncoding()
                let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data as Data)
                let textView = MaterialField(coder: unarchiver)
                textView?.tag = layout.Id
                textView?.isEnabled = !layout.Fl_Somente_Leitura
                
                for field in fields where field.Id_Campo == layout.Id {
                    textView?.isEnabled = !field.Fl_Validado
                    
                    if !field.Fl_Validado {
                        textView?.borderColor = Theme.default.red
                        textView?.placeholder = layout.Observacao
                    } else {
                        textView?.placeholder = field.Valor
                        textView?.backgroundColor = Theme.default.greyCard
                    }
                    
                    if #available(iOS 14.0, *) {
                        if !field.Fl_Validado {
                            textView?.setOnEndChangeListener(onEndEdition: {
                                let campo = CampoCreateForm(
                                    idCampo: field.Id_Campo,
                                    valor: textView?.text ?? ""
                                )
                                self.viewController?.campos.append(campo)
                            })
                        } else {
                            let campo = CampoCreateForm(
                                idCampo: field.Id_Campo,
                                valor: field.Valor
                            )
                            self.viewController?.campos.append(campo)
                        }
                    }
                }
                
                switch layout.Descricao {
                case "CPF":
                    textView?.keyboardType = .numberPad
                    textView?.isEnabled = false
                    textView?.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
                    if Constants.cpfTaxa == "" {
                        textView?.placeholder = UserRN.getLoggedUser().cpf
                    } else {
                        textView?.text = Constants.cpfTaxa
                    }
                case "RG":
                    textView?.keyboardType = .numberPad
                case "Data de Nascimento":
                    textView?.keyboardType = .numberPad
                    textView?.formatPattern = Constants.FormatPattern.Default.BIRTHDAY.rawValue
                    textView?.isUserInteractionEnabled = !layout.Descricao.isEmpty
                case "Celular":
                    textView?.keyboardType = .numberPad
                    textView?.formatPattern = Constants.FormatPattern.Cell.ddPhone.rawValue
                case "CEP":
                    textView?.keyboardType = .numberPad
                    textView?.formatPattern = Constants.FormatPattern.Default.CEP.rawValue
                default:
                    break
                }
                
                guard let viewController else { return }
                
                if let endereco = layout.Tag.range(of: "endereco") {
                    if layout.Tag != "endereco_cep" {
                        if layout.Tag != "endereco_numero" && layout.Tag != "endereco_complemento" {
                            textView?.isEnabled = false
                        }
                    } else {
                        textView?.addTarget(
                            self,
                            action: #selector(textViewDidEndEditing(_:)),
                            for: .editingDidEnd
                        )
                    }
                }
                
                guard let textView,
                      let view = viewController.view else { return }
                
                stackView.addArrangedSubviews(views: [ textView ])
                textView.leadingAndTrailing(to: view, padding: 16)
            } catch {
                print ("erro")
            }
        default:
            break
        }
    }
    
    func createPhotoUploadItem(
        with form: LayoutFormResponse = LayoutFormResponse(),
        imagePath: String? = nil
    ) -> UploadFileCell {
        let uploadFileItem = UploadFileCell()
        uploadFileItem.titleLabel.text = form.Descricao
        uploadFileItem.observationLabel.text = form.Observacao
        uploadFileItem.uploadButton.tag = form.Id
        uploadFileItem.previewImage.tag = form.Id
        uploadFileItem.previewImage.image = UIImage(named: imagePath ?? "")
        
        self.uploadFileItem = uploadFileItem
        
        if let campo = self.campos.filter({ $0.idCampo == uploadFileItem.previewImage.tag}).first {
            if let image = UIImage(named: campo.Valor) {
                uploadFileItem.previewImage.image = image
                uploadFileItem.previewImage.isHidden = false
            }
        }
        
        for field in fields where field.Id_Campo == form.Id {
            if !field.Fl_Validado {
                uploadFileItem.titleLabel.textColor = Theme.default.red
                uploadFileItem.observationLabel.textColor = Theme.default.red
            } else {
                uploadFileItem.isHidden = true
            }
        }
        
        uploadFileItem.didTapUpload = { [weak self] in
            guard let self else { return }
            print("\n\n\n", "@! >>> tag_id ", form.Id, "\n\n\n")
            self.viewController?.didTapSelectFile(uploadFileItem.uploadButton)
        }
        
        return uploadFileItem
    }
    
    func editedTextView(with string: String) -> String {
        return string
    }
}

private extension CardUserFormViewModel {
    func appendFields(from field: CamposGetTaxasResponse, value: Int) {
        let objeto = CamposRequestTaxaAdm()
        objeto.id_campo = field.Id_Campo
        objeto.valor_campo = "\(value)"
        QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos?.append(objeto)
    }
    
    @objc
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let viewController,
              let cep = textView.text?.removeAllOtherCaracters() else { return }
        if cep.count == 8 {
            AddressRN(delegate: viewController).consultCEP(cep: cep)
         }
    }
}

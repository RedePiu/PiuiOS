import UIKit

final class CardUserFormViewController: BaseViewController<CardUserFormView> {
    
    // MARK: - Properties
    private let viewModel: CardUserFormViewModel
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    private lazy var taxaCardRN = TaxaCardRN(delegate: self)
    
    private(set) var imageView = UIImageView()
    private(set) var picker = UIImagePickerController()
    private(set) var pickerInfo = [String : Any]()
    private(set) var imagePath: URL?
    private let uploadFileItem = UploadFileCell()
    
    private var layoutForm = [LayoutFormResponse]()
    var campos = [CampoCreateForm]()
    private var getTaxas = [GetTaxasResponse]()
    private var getFields = [CampoFormResponse]()
    private var getForms = [GetFormsResponse]()
    private var anexos = [Anexo]()
    private var documentList: [DocumentImage]?
    
    private(set) var dropdownItems = [String]()
    private(set) var pickerView = UIPickerView()
    private(set) var pickerTextView = MaterialField()
    
    private let form: GetFormsResponse
    
    private var campo: CampoCreateForm?
    private var idTipoCard = Int()
    private var itemDownload = Int()
    
    var navigationTitle = String()
    var idFormulario = Int()
    
    // MARK: - View Lifecycle
    init(viewModel: CardUserFormViewModel, form: GetFormsResponse) {
        self.viewModel = viewModel
        self.form = form
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taxaCardRN.getFormsResponses(
            idEmissor: produtoProdata.id_emissor,
            cpf: Constants.cpfTaxa
        )
        
        taxaCardRN.getLayoutFormResponses(
            idEmissor: produtoProdata.id_emissor,
            id_tipo_formulario_carga: form.Id_Tipo_Carga,
            via: 1,
            fl_dependente: false
        )
        
        viewModel.layoutForm = self.taxaCardRN.getAllLayoutForm()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupNavigationBar(with: navigationTitle)
    }
}

// MARK: - Base Delegate
extension CardUserFormViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if result {
                switch param {
                case Param.Contact.TAXA_LAYOUT_FORM_RESPONSE:
                    self.layoutForm = self.taxaCardRN.getAllLayoutForm()
                    self.initialLayoutView(page: 1, layoutForm: self.taxaCardRN.getAllLayoutForm())
                    
                    for item in self.taxaCardRN.getAllLayoutForm() {
                        self.idTipoCard = item.Id_Formulario_Tipo_Cartao
                    }
                    
                    self.endEditionAndDismiss()
                    
                case  Param.Contact.ADDRESS_CONSULT_CEP_RESPONSE:
                    self.showLoading(self) {
                        self.fillAddress(
                            response: object as! CEPConsultResponse,
                            view: self.view
                        )
                        self.endEditionAndDismiss()
                    }
                    
                case Param.Contact.TAXA_GET_FORM_RESPONSE:
                    self.getForms = self.taxaCardRN.getAllGetForms()
                    self.getFields = self.taxaCardRN.getAllCamposForm()
                    
                    for item in self.getForms {
                        self.idFormulario = item.Id_Formulario
                    }
                    
                case Param.Contact.TAXA_GET_TAXA_RESPONSE:
                    self.getTaxas = self.taxaCardRN.getAllGetTaxas()
                    
                case Param.Contact.TAXA_GET_FORM_UPDATE:
                    self.displayNoticeView(
                        title: "É isso ai! Agora é só aguardar!",
                        description: "Agora é só aguardar a aprovação da empresa! A gente te avisa quando tudo estiver certo :)",
                        image: "img_student_1",
                        btnTitle: "Continuar"
                    )
                default:
                    break
                }
            }
        }
    }
}

// MARK: - Setup Items & Private Functions
private extension CardUserFormViewController {
    func initialLayoutView(page: Int, layoutForm: [LayoutFormResponse]) {
//        layoutForm.sort{ $0.Pagina < $1.Pagina }
        montaBotaoControle(page: 1)
        self.viewModel.populaCampos(pagina: page)
        
        for subview in baseView.materialStack.subviews{
            subview.removeFromSuperview()
        }
        
        var layoutPagina = self.layoutForm.filter({ $0.Pagina == page })
        layoutPagina.sort{ $0.Ordem < $1.Ordem }
        
        for linha in layoutPagina {
            self.viewModel.createViewHeader(
                from: linha,
                label: baseView.viewLabel,
                image: baseView.viewImage,
                stackView: baseView.materialStack
            )
            
            self.viewModel.createFormFields(
                from: linha,
                stackView: baseView.materialStack
            )
            
            switch linha.Controle {
            case "InputFile":
                baseView.materialStack.addArrangedSubviews(views: [
                    viewModel.createPhotoUploadItem(with: linha)
                ])
            case "Dropdown":
                let data = NSMutableData()
                let archiver = NSKeyedArchiver(forWritingWith: data)
                let _textView = UITextView()
                
                _textView.encode(with: archiver)
                archiver.finishEncoding()
                
                do {
                    let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data as Data)
                    pickerTextView.coder = unarchiver
                    pickerTextView.borderStyle = .roundedRect
                    pickerTextView.adjustsFontForContentSizeCategory = true
                    pickerTextView.backgroundColor = Theme.default.white
                    pickerTextView.tintColor = .gray
                    pickerTextView.layer.borderColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5).cgColor
                    pickerTextView.layer.borderWidth = 0.6
                    pickerTextView.layer.cornerRadius = 6
                    pickerTextView.attributedPlaceholder = NSAttributedString(
                        string: pickerTextView.placeholder ?? "",
                        attributes: [
                            .foregroundColor: UIColor(hexString: Constants.Colors.Hex.colorGrey5),
                            .font: FontCustom.helveticaRegular.font(16)
                        ]
                    )
                    
                    for item in layoutPagina where item.Id == linha.Id && item.Observacao != "Motivo" {
                        dropdownItems.append(linha.Observacao)
                    }
                    
                    pickerTextView.placeholder = "Motivo"
                    pickerTextView.inputView = pickerView
                    
                    self.pickerView.delegate = self
                    self.pickerView.dataSource = self
                    
                    if linha.Observacao == "Motivo" {
                        baseView.materialStack.addArrangedSubview(pickerTextView)
                    }
                    
                    let campo: CampoCreateForm = CampoCreateForm()
                    campo.idCampo = linha.Id
                    campo.Valor = linha.Observacao
                    self.campos.append(campo)
                } catch {
                    print("@! >>> CATCH_ERROR...")
                }
            default:
                print("Ordem: \(linha.Ordem)")
            }
        }
    }
    
    func montaBotaoControle(page: Int) {
        guard let ultimaPagina = layoutForm.last?.Pagina else { return }
        
        if page < ultimaPagina {
            self.baseView.continueButton.tag = page + 1
        }
        
        if page > 1 {
            self.baseView.backButton.tag = page - 1
        }
        
        baseView.continueButton.setTitle(page < ultimaPagina ? "continue_label".localized : "finish".localized)
        
        baseView.continueButton.addTarget(
            self,
            action: page < ultimaPagina ? #selector(continueNav) : #selector(finishNav),
            for: .touchUpInside
        )
        
        baseView.backButton.addTarget(
            self,
            action: page > 1 ? #selector(tapBack) : #selector(tapPopView),
            for: .touchUpInside
        )
    }
    
    func clearStacks() {
        for subview in baseView.materialStack.subviews{
            subview.removeFromSuperview()
        }
        
        for subview in baseView.uploadFilesStack.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func saveToDocuments(image: UIImage) -> URL {
        let imageFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = imageFolder.appendingPathComponent("\(UUID()).jpg")
        
        do {
            let jpegData = UIImageJPEGRepresentation(image, 1)
            try jpegData?.write(to: imageURL, options: .atomic)
            return imageURL
        } catch { }
        
        return imageURL
    }
    
    func saveToImagePicker(_ picker: UIImagePickerController, info: [String:Any]) {
        if picker.sourceType == .camera {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imagePath = self.saveToDocuments(image: image)
            }
        } 
        
        if picker.sourceType == .photoLibrary {
            if let imageUrl = info[UIImagePickerControllerMediaURL] as? URL {
                imagePath = imageUrl
            }
        }
    }
}

// MARK: - Picker View Data Source and Delegate
extension CardUserFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //TODO: - Implementação Dropdown
    /// Envia o id do Dropdown
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dropdownItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dropdownItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextView.placeholder = dropdownItems[row]
        pickerTextView.resignFirstResponder()
    }
}


// MARK: - Setup AVCapture Delegate
extension CardUserFormViewController: AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {}
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            self.displayAlert(
                title: "Falha ao capturar imagem",
                description: "Tivemos um problema ao capturar a imagem. Por favor, tente novamente."
            )
        }
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        
        var imagePath: URL?
        let viewSize = CGSize(width: 120.0, height: 160.0)
        
        if #available(iOS 11.0, *) {
            if picker.sourceType == .camera {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    let resizedImage = image.convert(toSize: viewSize, scale: UIScreen.main.scale)
                    imagePath = self.saveToDocuments(image: resizedImage)
                }
            }
            else {
                if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
                    imagePath = imageURL
                }
            }
        }
        //VERSAO ANTERIOR AO IOS
        else {
            
            if picker.sourceType == .camera {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    //salva a imagem na galeria
                    imagePath = self.saveToDocuments(image: image)
                }
            }
            else {
                if let imageUrl = info[UIImagePickerControllerMediaURL] as? URL {
                    imagePath = imageUrl
                }
            }
        }
        
        //self.videoPath = info[UIImagePickerControllerMediaURL] as? URL
        
        guard let path = imagePath else {
            print("Image not found!")
            Util.showAlertDefaultOK(self, message: "Falha ao selecionar imagem!")
            return
        }
        
        print(self.itemDownload)
        //descobrindo qual a imagem que devo incluir
        if let imageView = viewModel.uploadFileItem.previewImage.viewWithTag(self.itemDownload) as? UIImageView {
            if let image = UIImage(named: path.path) {
                imageView.image = image
                imageView.isHidden = false
            }
        }
        
        //gravando form
        //adiciona campo para a página
        if var campo = self.campos.filter({ $0.idCampo == self.itemDownload }).first {
            campo.Valor = path.path
        } else {
            var campo: CampoCreateForm = CampoCreateForm()
            campo.idCampo = self.itemDownload
            campo.Valor = path.path
            self.campos.append(campo)
        }

        if let anexo = self.anexos.filter({ $0.type == self.itemDownload }).first {
            anexo.path = path.path
        } else {
            let anexo = Anexo(type: self.itemDownload, path: path.path, tag: "")
            self.anexos.append(anexo)
        }
    }
}

// MARK: - Fields Functions
extension CardUserFormViewController {
    func fillAddress(response: CEPConsultResponse, view: UIView) {
        var layoutPagina = self.layoutForm.filter({ $0.Tag == "endereco_rua"}).first
        if let txtStreet = view.viewWithTag(layoutPagina!.Id) as? MaterialField {
            txtStreet.text = response.street
        }
        layoutPagina = self.layoutForm.filter({ $0.Tag == "endereco_bairro"}).first
        if let txtDistrict = view.viewWithTag(layoutPagina!.Id) as? MaterialField {
            txtDistrict.text = response.neighborhood
        }
        layoutPagina = self.layoutForm.filter({ $0.Tag == "endereco_cidade"}).first
        if let txtCity = view.viewWithTag(layoutPagina!.Id) as? MaterialField {
            txtCity.text = response.city
        }
        layoutPagina = self.layoutForm.filter({ $0.Tag == "endereco_estado"}).first
        if let txtState = view.viewWithTag(layoutPagina!.Id) as? MaterialField {
            txtState.text = response.uf
        }
    }
}

// MARK: - Buttons and Navigation
extension CardUserFormViewController {
    @objc
    func didTapSelectFile(_ sender: UIButton) {
        print("\n\n\n", "@! >>> Sender_TAG ", sender.tag, "\n\n\n")
        self.itemDownload = sender.tag
        self.displayChooseDevice(delegate: self)
    }
    
    @objc
    func continueNav(_ sender: UIButton) {
        let pagina = sender.tag
        
        if viewModel.populaCampos(pagina: pagina - 1) {
            montaBotaoControle(page: pagina)
            initialLayoutView(page: pagina, layoutForm: self.taxaCardRN.getAllLayoutForm())
        }
    }
    
    @objc
    func finishNav(_ sender: UIButton) {
        guard let ultimaPagina = self.layoutForm.last?.Pagina else { return }
        
        if viewModel.populaCampos(pagina: ultimaPagina) {
            viewModel.sendForm { [weak self] in
                guard let self else { return }
                self.taxaCardRN.sendFormUpdate(
                    idFormulario: self.idFormulario,
                    campos: self.campos,
                    failCompletion: { [weak self] (error) in
                        guard let self else { return }
                        
                        DispatchQueue.main.async {
                            self.displayNoticeView(title: error, description: "", image: "ic_warning", btnTitle: "Voltar")
                        }
                    }
                )
                
                self.endEditionAndDismiss()
            }
        }
    }
    
    @objc
    func tapPopView() {
        self.popViewController()
    }
    
    @objc
    func tapBack() {
        let pagina = baseView.backButton.tag
        
        if viewModel.populaCampos(pagina: pagina - 1) {
            montaBotaoControle(page: pagina)
            self.initialLayoutView(page: pagina, layoutForm: self.taxaCardRN.getAllLayoutForm())
        }
    }
}

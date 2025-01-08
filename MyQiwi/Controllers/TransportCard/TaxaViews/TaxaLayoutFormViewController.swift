//
//  TaxaLayoutFormViewController.swift
//  MyQiwi
//
//  Created by Daniel Catini on 11/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import UIKit

class TaxaLayoutFormViewController: UIBaseViewController {
    
    // MARK: - Outlets and UI
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var btContinue: UIButton!
    
    private let scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UIScrollView())
    
    private let stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 20
        $0.isLayoutMarginsRelativeArrangement = true
        return $0
    }(UIStackView())
    
    // MARK: - Properties
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    private lazy var taxaCardRN = TaxaCardRN(delegate: self)
    
    private var menuCardTypes = [MenuCardTypeResponse]()
    private var taxaCards = [TaxaCardResponse]()
    private var layoutForm = [LayoutFormResponse]()
    private var form: CreateForm? = nil
    private var campos = [CampoCreateForm]()
    private var idFormSaved = 0
    private var dropdownItems = [String]()
    private var getForms = [GetFormsResponse]()
    private var getTaxas = [GetTaxasResponse]()
    private var rechargGeneric = false
    private var itemDownload = 0
    private var anexos = [Anexo]()
    private var documentList: [DocumentImage]?
    
    private var picker = UIPickerView()
    private var pickerTextView = MaterialField()
    private var imagePath: URL?
    
    private var errorMessage = String()
    private var isPrimeiraVia = Bool()
    private var isStudent = Bool()
    
    @IBAction func closeClick(_ sender: UIBarButtonItem) {
        self.dismissPage(sender)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.popPage(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupTexts()
        self.SetPlaceHolder()
        self.btContinue.setTitle("continue_label".localized)
        self.btBack.setTitle("back".localized)
        
        self.layoutForm = self.taxaCardRN.getAllLayoutForm()
        self.clearStackView()
        
        //self.dismissPage(self)
        self.getLayout()
    }
    
    @objc func didTapSelectFile(_ sender: UIButton) {
        print(sender.tag)
        
        self.itemDownload = sender.tag
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Biblioteca de Fotos", style: .default, handler: { _ in
            imagePicker.sourceType = .photoLibrary
            imagePicker.videoQuality = .typeIFrame1280x720
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Câmera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                imagePicker.videoQuality = .typeIFrame1280x720
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Câmera não disponível")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension TaxaLayoutFormViewController : AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { }
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            self.displayAlert(
                title: "Falha ao capturar imagem",
                message: "Tivemos um problema ao capturar a imagem. Por favor, tente novamente."
            )
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        var imagePath: URL?
        
        guard (info[UIImagePickerControllerOriginalImage] != nil) else {
            print("No image found to load...")
            return
        }
        
        let viewSize = CGSize(width: 120.0, height: 160.0)
        
        if #available(iOS 11.0, *) {
            if picker.sourceType == .camera {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    let resizedImage = image.convert(toSize: viewSize, scale: UIScreen.main.scale)
                    imagePath = self.saveToDocuments(image: resizedImage)
                }
            } else {
                if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
                    imagePath = imageURL
                }
            }
        } else {
            if picker.sourceType == .camera {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    let resizedImage = image.convert(toSize: viewSize, scale: UIScreen.main.scale)
                    imagePath = self.saveToDocuments(image: image)
                }
            } else {
                if let imageUrl = info[UIImagePickerControllerMediaURL] as? URL {
                    let newURLImage = UIImage(named: imageUrl.absoluteString)
                    let resizedImage = newURLImage?.convert(toSize: viewSize, scale: UIScreen.main.scale)
                    imagePath = URL(string: resizedImage?.jpeg?.base64EncodedString() ?? "")
                }
            }
        }
        
        //self.videoPath = info[UIImagePickerControllerMediaURL] as? URL
        
        guard let path = imagePath else {
            return Util.showAlertDefaultOK(self, message: "Falha ao selecionar imagem!")
        }
        
        print("@! >>> ITEM_DOWNLOAD: ", self.itemDownload)

        if let imageView = view.viewWithTag(self.itemDownload) as? UIImageView {
            
            if let image = UIImage(named: path.path) {
                image.withRenderingMode(.alwaysOriginal)
                imageView.image = image
                imageView.isHidden = false
            }
        }
        
        if let campo = self.campos.filter({ $0.idCampo == self.itemDownload }).first {
            campo.Valor = path.path
        } else {
            let campo: CampoCreateForm = CampoCreateForm()
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
        //self.updateList()
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
    
    func sendForm() {
        Util.showLoading(self)
        let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
        
        TaxaCardRN(delegate: self).createFormResponses(idEmissor: produtoProdata.id_emissor, id_formulario_tipo_cartao: self.layoutForm.first!.Id_Formulario_Tipo_Cartao, cpf: Constants.cpfTaxa, campos: self.campos) { [weak self] (error) in
            guard let self else { return }
            
            let viewController = NoticeViewController(
                navigationTitle: "",
                contentTitle: error,
                contentDescription: "",
                contentImage: "",
                completion: nil
            )
            viewController.baseView.contentImageView.image = UIImage(named: "ic_warning")
            viewController.baseView.actionButton.setTitle("Voltar")
            viewController.baseView.actionButton.addTarget(
                self,
                action: #selector(self.dismissView),
                for: .touchUpInside
            )
            
            DispatchQueue.main.async {
                self.dismissPage(Util.showLoading(self))
                self.pushViewController(viewController)
            }
        }
    }
}

private extension TaxaLayoutFormViewController {
    func getLayout() {
        print("@! >>> LAYOUT_FORM: ", layoutForm)
        print("@! >>> VIA_CARGA: ", Constants.viaCarga)
        
        if self.layoutForm.count > 0 && Constants.viaCarga == 2 {
            self.iniMontaFormulario()
        } else {
            self.dismissPage(Util.showLoading(self))
            self.criaLayoutInicial()
        }
    }
    
    func criaLayoutInicial() {
        self.viewButtons.isHidden(true)
        self.menuCardTypes = self.taxaCardRN.getAllCardTypes()
        self.taxaCards = self.taxaCardRN.getAllCards()
        
        let viewTitle = ContentViewTitle(title: "Qual será o seu Cartão?")
        
        let cardImageView: UIImageView = {
            $0.contentMode = .scaleAspectFit
            return $0
        }(UIImageView())
        
        let buttonStackView: UIStackView = {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 16
            return $0
        }(UIStackView())
        
        switch QiwiOrder.selectedMenu.prvID {
        case ActionFinder.Transport.Prodata.Caieiras.COMUM, 
             ActionFinder.Transport.Prodata.Caieiras.ESCOLAR:
            cardImageView.image = UIImage(named: "cartao_form_bem_caieras")
        case ActionFinder.Transport.Prodata.Cajamar.COMUM, 
             ActionFinder.Transport.Prodata.Cajamar.ESCOLAR:
            cardImageView.image = UIImage(named: "cartao_form_bem_cajamar")
        case ActionFinder.Transport.Prodata.FrancodaRocha.COMUM, 
             ActionFinder.Transport.Prodata.FrancodaRocha.ESCOLAR:
            cardImageView.image = UIImage(named: "cartao_form_bem_franco")
        case ActionFinder.Transport.Prodata.Osasco.COMUM, 
             ActionFinder.Transport.Prodata.Osasco.ESCOLAR:
            cardImageView.image = UIImage(named: "cartao_form_bem_osasco")
        case ActionFinder.Transport.Prodata.SantanadeParnaiba.COMUM,
             ActionFinder.Transport.Prodata.SantanadeParnaiba.ESCOLAR:
            cardImageView.image = UIImage(named: "cartao_form_bem_santana")
        default: break
        }
        
        for card in self.menuCardTypes {
            let cartao = self.taxaCards.filter({
                return Int($0.codCarga) == Int(card.codCarga)
            }).first
            
            let button = MainButton(type: .primary, title: card.Nome)
            button.tag = card.Id_Tipo_Formulario_Carga
            button.addTarget(self,
                             action: #selector(buttonTapped(_:)),
                             for: .touchUpInside)
            button.height(size: 40)
            
            if card.primeiraVia && card.Nome == "Vale Transporte" {
                buttonStackView.removeFromSuperview()
            }
            
            if cartao == nil && card.primeiraVia {
                buttonStackView.addArrangedSubview(button)
                button.leadingAndTrailing(to: buttonStackView, padding: 20)
            }
            
            isPrimeiraVia = card.primeiraVia
        }
        
        stackView.addArrangedSubviews(views: [
            viewTitle, cardImageView, buttonStackView
        ])
        
        viewTitle.top(to: stackView.topAnchor, padding: 16)
        viewTitle.height(size: 30)
        cardImageView.height(size: 200)
        
        stackView.sizeToFit()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView, constraints: true)
        scrollView.anchors(equalTo: view)
        scrollView.width(size: UIScreen.main.bounds.width)
        scrollView.top(to: view.topAnchor)
        scrollView.bottom(to: viewButtons.topAnchor)
    }
    
    func clearStackView() {
        for subview in self.stackView.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func populaCampos(pagina: Int) -> Bool {
        var sendAmazon = false
        let layoutPagina = self.layoutForm.filter({ return $0.Pagina == pagina })
        
        for linha in layoutPagina {
            if linha.Controle == "Text" || linha.Controle == "TextArea" {
                print("@! >>> FIELD_TITLE: ", linha.Observacao)
                
                if let txtView = view.viewWithTag(linha.Id) as? MaterialField {
                    if linha.Descricao == "CPF" {
                        let userMeCPF = UserRN.getLoggedUser().cpf.removeAllOtherCaracters()
                        let userOtherCPF = Constants.cpfTaxa.removeAllOtherCaracters()
                        txtView.text = Constants.cpfTaxa == "" ? userMeCPF : userOtherCPF
                        print("@! >>> CPF_ENVIADO ", txtView.text = Constants.cpfTaxa == "" ? userMeCPF : userOtherCPF)
                    }
                    
                    //validar se campo é obrigatório
                    if(linha.Fl_Obrigatorio && txtView.text == "") {
                        //apresentar alerta e cancelar envio
                        let alert = UIAlertController(
                            title: "Dados Obrigatórios",
                            message: "O campo \(linha.Descricao) deve ser preenchido", 
                            preferredStyle: .alert
                        )
                        let cancelAction = UIAlertAction(
                            title: "OK",
                            style: .cancel,
                            handler: nil
                        )
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        return false
                    }
                    
                    //adiciona campo para a página
                    if let campo = self.campos.filter({ $0.idCampo == linha.Id }).first {
                        campo.Valor = txtView.text!
                    } else {
                        let campo: CampoCreateForm = CampoCreateForm()
                        campo.idCampo = linha.Id
                        campo.Valor = txtView.text!
                        self.campos.append(campo)
                    }
                }
            }
            
            if linha.Controle == "Dropdown" {
                if let campo = self.campos.filter({ $0.idCampo == linha.Id }).first {
                    campo.Valor = pickerTextView.placeholder ?? ""
                } else {
                    let campo: CampoCreateForm = CampoCreateForm()
                    campo.idCampo = linha.Id
                    campo.Valor = pickerTextView.placeholder ?? ""
                    self.campos.append(campo)
                }
            }
            
            //InputFile enviar arquivos para S3 e gravar o nome do arquivo no form
            if(linha.Controle == "InputFile") {
                //recuperando imagem
                if let imageView = view.viewWithTag(linha.Id) as? UIImageView {
                    if imageView.image == nil {
                        //apresentar alerta e cancelar envio
                        let alert = UIAlertController(
                            title: "Dados Obrigatórios",
                            message: "A imagem \(linha.Descricao) deve ser enviada",
                            preferredStyle: .alert
                        )
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                        return false
                    }
                } else if linha.Fl_Obrigatorio {
                    //apresentar alerta e cancelar envio
                    let alert = UIAlertController(
                        title: "Dados Obrigatórios",
                        message: "A imagem \(linha.Descricao) deve ser enviada",
                        preferredStyle: .alert
                    )
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    return false
                    
                }
            }
        }
        
        return true
    }
    
    func montaBotaoControle(pagina: Int) {
        self.viewButtons.isHidden(false)
        //descobrir numero de páginas
        let ultimaPagina = self.layoutForm.last?.Pagina
        
        self.btBack.backgroundColor = Theme.default.orange
        self.btContinue.backgroundColor = Theme.default.primary
        
        //definir nomes dos botões
        if(pagina < ultimaPagina ?? 0) {
            self.btContinue.setTitle("continue_label".localized)
            self.btContinue.tag = pagina+1
            self.btContinue.removeTarget(self, action: nil, for: .allEvents)
            self.btContinue.addTarget(self, action: #selector(buttonContinue(_:)), for: .touchUpInside)
        } else {
            self.btContinue.setTitle(isStudent ? "agree".localized : "finish".localized)
            self.btContinue.removeTarget(self, action: nil, for: .allEvents)
            self.btContinue.addTarget(self, action: #selector(buttonFinish(_:)), for: .touchUpInside)
        }
        
        if pagina > 1 {
            self.btBack.tag = pagina-1
            self.btBack.removeTarget(self, action: nil, for: .allEvents)
            self.btBack.backgroundColor = Theme.default.yellow
            self.btBack.addTarget(self, action: #selector(buttonContinue(_:)), for: .touchUpInside)
        } else {
            self.btBack.removeTarget(self, action: nil, for: .allEvents)
            self.btBack.addTarget(self, action: #selector(clickBack(_:)), for: .touchUpInside)
        }
    }
    
    func montaAvisoPendente() {
        //apagar a stackview
        self.clearStackView()
        
        //removendo botões do footer
        self.viewButtons.isHidden(true)
        
        // Crie uma imagem
        let imageView = UIImageView(image: UIImage(named: "img_student3"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(imageView)
        
        // Crie um título
        let titleLabel = UILabel()
        titleLabel.text = "É isso ai! Agora é só aguardar!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        stackView.addArrangedSubview(titleLabel)
        
        // Crie um parágrafo
        let paragraphLabel = UILabel()
        paragraphLabel.text = "Agora é só aguardar a aprovação da empresa! A gente te avisa quando tudo estiver certo :)"
        paragraphLabel.textAlignment = .center
        paragraphLabel.numberOfLines = 0
        stackView.addArrangedSubview(paragraphLabel)
    }
    
    func montaFormulario(pagina: Int) {
        //apagar a stackview
        self.clearStackView()
        //filtrando layout por pagina
        var layoutPagina = self.layoutForm.filter({return $0.Pagina == pagina})
        //ordenar
        layoutPagina.sort{ $0.Ordem < $1.Ordem }
        
        //montar linha
        for linha in layoutPagina {
            switch linha.Controle {
            case "Titulo":
                self.title = linha.Descricao
            case "Label":
                stackView.addArrangedSubview(ContentViewTitle(title: linha.Descricao))
            case "termo_aceite":
                let scrollText = UILabel(frame: .zero)
                scrollText.text = linha.Observacao
                scrollText.numberOfLines = .zero
                viewButtons.isHidden(false)
                viewButtons.backgroundColor = .red
                viewButtons.leading(to: view.leadingAnchor)
                viewButtons.trailing(to: view.trailingAnchor)
                viewButtons.height(size: 60)
                Theme.default.orageButton(self.btBack)
                Theme.default.blueButton(self.btContinue)
                stackView.addArrangedSubview(scrollText)
            case "Imagem":
                let imageView = UIImageView()
                imageView.tag = linha.Id
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                stackView.addArrangedSubview(imageView)
                
                guard let url = URL(string: linha.Observacao) else {
                    print("URL inválida")
                    continue
                }
                
                let session = URLSession.shared
                let task = session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        return print("Erro ao fazer download da imagem: \(error)")
                    }
                    
                    guard let imageData = data else {
                        return print("Não foram recebidos dados da imagem")
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
            case "Text", "TextArea":
                let data = NSMutableData()
                let archiver = NSKeyedArchiver(forWritingWith: data)
                let _textView = UITextView()
                
                _textView.encode(with: archiver)
                archiver.finishEncoding()
                
                do {
                    let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data as Data)
                    let textView = MaterialField(coder: unarchiver)
                    textView?.placeholder = linha.Observacao
                    textView?.tag = linha.Id
                    
                    if linha.Tipo_Parametro == "int" {
                        textView?.keyboardType = .numberPad
                    }
                    
                    if linha.Fl_Somente_Leitura {
                        textView?.isEnabled = false
                    }
                    
                    switch linha.Descricao {
                    case "CPF":
                        textView!.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
                        if Constants.cpfTaxa == "" {
                            textView!.placeholder = UserRN.getLoggedUser().cpf
                            print("@! >>> USER_CPF", UserRN.getLoggedUser().cpf.removeAllOtherCaracters())
                        } else {
                            textView!.text = Constants.cpfTaxa
                            print("@! >>> USER_CPF", Constants.cpfTaxa.removeAllOtherCaracters())
                        }
                        
                        textView?.keyboardType = .numberPad
                        textView?.isEnabled = false
                    case "RG":
                        textView!.formatPattern = "##.###.###-#"
                    case "Data de Nascimento":
                        textView!.formatPattern = Constants.FormatPattern.Default.BIRTHDAY.rawValue
                        textView?.keyboardType = .numberPad
                    case "Celular":
                        textView!.formatPattern = Constants.FormatPattern.Cell.ddPhone.rawValue
                        textView?.keyboardType = .numberPad
                    case "CEP":
                        textView!.formatPattern = "#####-###"
                        textView?.keyboardType = .numberPad
                    default:
                        print("sem uma mascara especifica")
                    }
                    
                    if let _ = linha.Tag.range(of: "endereco") {
                        if linha.Tag == "endereco_estado" {
                            textView?.text = "SP"
                        }
                        
                        if linha.Tag != "endereco_cep" {
                            if(linha.Tag != "endereco_numero" && linha.Tag != "endereco_complemento") {
                                textView!.isEnabled = false
                            }
                        } else {
                            textView!.addTarget(self, action: #selector(textViewDidEndEditing(_:)), for: .editingDidEnd)
                        }
                    }
                    
                    if let campo = self.campos.filter({ $0.idCampo == textView!.tag}).first {
                        textView!.text = campo.Valor
                    }
                    
                    stackView.addArrangedSubview(textView!)
                } catch {
                    print ("erro")
                }
                
            case "Dropdown":
                let data = NSMutableData()
                let archiver = NSKeyedArchiver(forWritingWith: data)
                let _textView = UITextView()
                
                _textView.encode(with: archiver)
                archiver.finishEncoding()
                
                do {
                    let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data as Data)
                    self.pickerTextView.coder = unarchiver
                    self.pickerTextView.borderStyle = .roundedRect
                    self.pickerTextView.adjustsFontForContentSizeCategory = true
                    self.pickerTextView.backgroundColor = Theme.default.white
                    self.pickerTextView.tintColor = .gray
                    self.pickerTextView.layer.borderColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5).cgColor
                    self.pickerTextView.layer.borderWidth = 0.6
                    self.pickerTextView.layer.cornerRadius = 6
                    self.pickerTextView.attributedPlaceholder = NSAttributedString(
                        string: self.pickerTextView.placeholder ?? "",
                        attributes: [
                            .foregroundColor: UIColor(hexString: Constants.Colors.Hex.colorGrey5),
                            .font: FontCustom.helveticaRegular.font(16)
                        ]
                    )
                    
                    for item in layoutPagina where item.Id == linha.Id && item.Observacao != "Motivo" {
                        self.dropdownItems.append(linha.Observacao)
                    }
                    
                    pickerTextView.placeholder = "Motivo"
                    pickerTextView.inputView = picker
                    
                    self.picker.delegate = self
                    self.picker.dataSource = self
                    
                    if linha.Observacao == "Motivo" {
                        stackView.addArrangedSubview(pickerTextView)
                    }
                } catch {
                    print("@! >>> CATCH_ERROR...")
                }
            case "InputFile":
                //criando a StackView
                let inputsStack: UIStackView = {
                    $0.axis = .vertical
                    $0.spacing = 10
                    $0.alignment = .leading
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    return $0
                }(UIStackView())
                
                //criar Label
                let label = UILabel()
                label.text = linha.Descricao
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.textAlignment = .left
                inputsStack.addArrangedSubview(label)
                
                let obs = UILabel()
                obs.text = linha.Observacao
                obs.font = UIFont.systemFont(ofSize: 14)
                obs.textAlignment = .left
                inputsStack.addArrangedSubview(obs)
                
                let imageView: UIImageView = {
                    $0.tag = linha.Id
                    $0.contentMode = .scaleAspectFit
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.isHidden = true
                    return $0
                }(UIImageView())
                imageView.width(size: 50)
                imageView.height(size: 50)
                inputsStack.addArrangedSubview(imageView)
                
                //incluir dados já gravados
                
                //ic_file
                //criando a StackView
                let HstackView = UIStackView()
                HstackView.axis = .horizontal
                HstackView.spacing = 10
                HstackView.translatesAutoresizingMaskIntoConstraints = false
                inputsStack.addArrangedSubview(HstackView)
                
                let imageViewH = UIImageView(image: UIImage(named: "ic_file"))
                imageViewH.contentMode = .scaleAspectFit
                imageViewH.translatesAutoresizingMaskIntoConstraints = false
                // Definir a largura desejada para a imagem
                imageViewH.widthAnchor.constraint(equalToConstant: 30).isActive = true
                imageViewH.heightAnchor.constraint(equalToConstant: 30).isActive = true
                HstackView.addArrangedSubview(imageViewH)
                
                // Criar um botão
                let button = UIButton(type: .system)
                button.tag = linha.Id
                button.setTitle("+ Adicionar Arquivo", for: .normal)
                button.addTarget(self, action: #selector(didTapSelectFile), for: .touchUpInside)
                button.contentHorizontalAlignment = .left
                HstackView.addArrangedSubview(button)
                
                stackView.addArrangedSubview(inputsStack)
            default:
                print("Ordem: \(linha.Ordem)")
            }
            
            //self.dismissPage(nil)
        }
        
        setupScrollView()
        scrollView.addSubview(stackView, constraints: true)
        
        stackView.leadingAndTrailing(to: scrollView, padding: 16)
        stackView.top(to: scrollView.topAnchor, padding: 16)
        stackView.bottom(to: scrollView.bottomAnchor, padding: 16)
        
        stackView.sizeToFit()
    }
    
    @objc func textViewDidEndEditing(_ textView: UITextView) {
        let cep = textView.text?.removeAllOtherCaracters() ?? ""
        if (cep.count == 8) {
            Util.showLoading(self)
            AddressRN(delegate: self).consultCEP(cep: cep)
            return
        }
    }
    
    @objc func buttonFinish(_ sender: UIButton) {
        guard let ultimaPagina = self.layoutForm.last?.Pagina else { return }
        
        DispatchQueue.main.async {
            //validar campos da página
            if self.populaCampos(pagina: ultimaPagina) {
                //validar se existe anexo
                if self.anexos.count <= 0 {
                    self.sendForm()
                } else {
                    //necessário primeiro enviar docs para amazon
                    Util.showLoading(self)
                    AmazonRN(delegate: self).sendDocument(anexos: self.anexos)
                }
            }
        }
    }
    
    
    @objc func buttonContinue(_ sender: UIButton) {
        let pagina = sender.tag
        
        if self.populaCampos(pagina: pagina-1) {
            self.montaBotaoControle(pagina: pagina)
            self.montaFormulario(pagina: pagina)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        Util.showLoading(self)
        
        Constants.idTipoCarga = sender.tag
        Constants.viaCarga = 1
        print("@! >>> Botão com tag \(Constants.idTipoCarga) foi clicado!")
        print("@! >>> VIA_CARGA: ", Constants.viaCarga)
        
        self.taxaCardRN.getLayoutFormResponses(
            idEmissor: self.produtoProdata.id_emissor,
            id_tipo_formulario_carga: Constants.idTipoCarga,
            via: Constants.viaCarga,
            fl_dependente: false
        )
    }
}

extension TaxaLayoutFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension TaxaLayoutFormViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if param == Param.Contact.TAXA_LAYOUT_FORM_RESPONSE {
                print("@! >>> TAXA_LAYOUT_FORM_RESPONSE")
                self.layoutForm = self.taxaCardRN.getAllLayoutForm()
                self.clearStackView()
                self.iniMontaFormulario()
                self.dismissPage(Util.showLoading(self))
            }
        }
        
        DispatchQueue.main.async {
            if param == Param.Contact.ADDRESS_CONSULT_CEP_RESPONSE {
                print("@! >>> ADDRESS_CONSULT_CEP_RESPONSE")
                self.dismissPage(nil)
                if result {
                    self.fillAddress(response: object as! CEPConsultResponse)
                }
            }
            
            if param == Param.Contact.TAXA_CREATE_FORM_RESPONSE {
                print("@! >>> TAXA_CREATE_FORM_RESPONSE")
                //self.dismissPage(nil)
                if result {
                    self.getResponseForm(response: object as! CreateFormResponse)
                }
            }
            
            if param == Param.Contact.TAXA_GET_FORM_RESPONSE {
                print("@! >>> TAXA_GET_FORM_RESPONSE")
                //self.dismissPage(nil)
                if result {
                    self.getForms = self.taxaCardRN.getAllGetForms()
                    print(self.getForms.count)
                    self.MontaStatusForm()
                }
            }
            
            if param == Param.Contact.TAXA_GET_TAXA_RESPONSE {
                print("@! >>> TAXA_GET_TAXA_RESPONSE")
                //self.dismissPage(nil)
                if result {
                    self.getTaxas = self.taxaCardRN.getAllGetTaxas()
                    Util.showLoading(self)
                    self.pushViewController(
                        TaxListFactory().start(with: self.taxaCardRN, cpf: Constants.cpfTaxa)
                    )
                }
            }
            
            if param == Param.Contact.TAXA_GET_CAMPO_TAXA_RESPONSE {
                print("@! >>> TAXA_GET_CAMPO_TAXA_RESPONSE")
                //self.dismissPage(nil)
                if result {
                    self.executeOrder(response: object as! GetTaxasResponse)
                }
            }
            
            if param == Param.Contact.DOC_SENT {
                print("@! >>> DOC_SENT")
                self.dismissPage(nil)
                if result {
                    self.documentList = object as? [DocumentImage]
                    
                    for doc in self.documentList ?? [] {
                        if let campo = self.campos.filter({ $0.idCampo == doc.imageType }).first {
                            campo.Valor = doc.imageId!
                        } else {
                            let campo: CampoCreateForm = CampoCreateForm()
                            campo.idCampo = doc.imageType
                            campo.Valor = doc.imageId!
                            self.campos.append(campo)
                        }
                    }
                    
                    self.sendForm()
                }
                
                self.dismiss(animated: true, completion: nil)
                Util.showAlertDefaultOK(self, message: "transport_students_form_sent_amazon_failed".localized)
                return
            }
        }
    }
}

extension TaxaLayoutFormViewController {
    func executeOrder(response: GetTaxasResponse) {
        QiwiOrder.checkoutBody.requestProdata = nil
        
        QiwiOrder.checkoutBody.requestTaxaCampo = RequestTaxaAdm()
        QiwiOrder.checkoutBody.requestTaxaCampo?.id_taxa = response.Id_Taxa
        QiwiOrder.checkoutBody.requestTaxaCampo?.cpf = Constants.cpfTaxa
        QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos = []
        
        for campo in response.Campos ?? [] {
            if campo.Tag == "id_formulario" {
                let objeto = CamposRequestTaxaAdm()
                objeto.id_campo = campo.Id_Campo
                objeto.valor_campo = "\(self.idFormSaved)"
                QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos?.append(objeto)
            } else if campo.Tag == "tipo_formulario"{
                let objeto = CamposRequestTaxaAdm()
                objeto.id_campo = campo.Id_Campo
                objeto.valor_campo = "\(Constants.idTipoCarga)"
                QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos?.append(objeto)
            }
        }
        
        QiwiOrder.setTransitionAndValue(value: response.Valor_Taxa)
        QiwiOrder.productName = response.Nome
        QiwiOrder.setPrvId(prvId: response.Id_Prv)
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        
        self.rechargGeneric = true
        //self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    func MontaStatusForm(){
        if let status = self.getForms.filter({ $0.Id_Formulario == self.idFormSaved }).first {
            if status.Id_Status == 4 {
                Util.showLoading(self)
                let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
                TaxaCardRN(delegate: self).getTaxaResponses(idEmissor: produtoProdata.id_emissor)
            } else {
                self.dismissPage(nil)
                let viewController = NoticeViewController(
                    navigationTitle: "Aguarde",
                    contentTitle: "transport_students_form_sent_success_title".localized,
                    contentDescription: "Agora é só aguardar a aprovação da empresa! A gente te avisa quando tudo estiver certo :)",
                    contentImage: "img_student3",
                    completion: nil
                )
                viewController.baseView.actionButton.setTitle("Continuar")
                viewController.baseView.actionButton.addTarget(
                    self,
                    action: #selector(self.dismissView),
                    for: .touchUpInside
                )
                
                self.pushViewController(viewController)
            }
        }
    }
    
    func iniMontaFormulario() {
        self.layoutForm.sort{ $0.Pagina < $1.Pagina }
        self.montaBotaoControle(pagina: 1)
        self.montaFormulario(pagina: 1)
    }
    
    // ~> Action:
    /// Buscar status dos formularios
    func getResponseForm(response: CreateFormResponse) {
        self.idFormSaved = response.id_Cadastro_Formulario
        //Util.showLoading(self)
        let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
        
        TaxaCardRN(delegate: self).getFormsResponses(
            idEmissor: produtoProdata.id_emissor,
            cpf: Constants.cpfTaxa
        )
    }
    
    func fillAddress(response: CEPConsultResponse) {
        var layoutPagina = self.layoutForm.filter({return $0.Tag == "endereco_rua"}).first
        print(layoutPagina!.Observacao)
        if let txtStreet = view.viewWithTag(layoutPagina!.Id) as? MaterialField {
            txtStreet.text = response.street
        }
        layoutPagina = self.layoutForm.filter({return $0.Tag == "endereco_bairro"}).first
        if let txtDistrict = view.viewWithTag(layoutPagina!.Id) as? MaterialField {
            txtDistrict.text = response.neighborhood
        }
        layoutPagina = self.layoutForm.filter({return $0.Tag == "endereco_cidade"}).first
        if let txtCity = view.viewWithTag(layoutPagina!.Id) as? MaterialField {
            txtCity.text = response.city
        }
        layoutPagina = self.layoutForm.filter({return $0.Tag == "endereco_estado"}).first
        if let txtState = view.viewWithTag(layoutPagina!.Id) as? MaterialField {
            txtState.text = response.uf
        }
    }
}

extension TaxaLayoutFormViewController: SetupUI {
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btBack)
        Theme.default.blueButton(self.btContinue)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        view.addSubview(stackView, constraints: true)
        
        stackView.leadingAndTrailing(to: view, padding: 16)
        
        self.viewButtons.height(size: 40)
        self.viewButtons.bottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func SetPlaceHolder() { }
    func setupTexts() { }
    func setupNib() { }
    
    func setupHeightTable() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

private extension TaxaLayoutFormViewController {
    func convertCPFToString(isOtherUser: Bool) -> String {
        return isOtherUser ? Constants.cpfTaxa.removeAllOtherCaracters() : ""
    }
}

extension UIImage {
    func convert(toSize size:CGSize, scale:CGFloat) ->UIImage {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copied!
    }
}

//
//  ViewAnexo.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class ViewAnexo: LoadBaseView {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbError: UILabel!
    @IBOutlet weak var lbNoFiles: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    // MARK: Init
    var controller: UIViewController?
    var anexos = [Anexo]()
    var imagePicker: UIImagePickerController!
    var imageTake: UIImage?
    var tipoAnexo: Int = 0
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func initCoder() {
        self.loadNib(name: "ViewAnexo")
        self.setupCollectionView()
        self.setupView()
        
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
    }
    
    @IBAction func onClickAddFile(_ sender: Any) {
        self.displayFileOptions(sender)
    }
    
    @objc func onClickRemoveAnexo(sender: UIButton) {
        
        // Item
        self.anexos.remove(at: sender.tag)
        self.updateList()
    }
}

extension ViewAnexo {
    
    func setName(name: String) {
        self.lbTitle.text = name
    }
    
    func setDesc(desc: String) {
        self.lbDesc.text = desc
        self.lbDesc.isHidden = false
    }
    
    func hideDesc() {
        self.lbDesc.isHidden = true
    }
    
    func setError(_ text: String) {
        self.lbError.text = text
        self.lbError.isHidden = false
    }
    
    func hideError() {
        self.lbError.text = ""
        self.lbError.isHidden = true
    }
}

extension ViewAnexo {
    
    func setupView() {
        self.lbDesc.isHidden = true
        self.lbError.isHidden = true
        self.collectionView.isHidden = true
        self.lbNoFiles.isHidden = false
    }
    
    func setupCollectionView() {
        
        //  Cell custom
        self.collectionView.register(ViewAnexoCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = false
    }
}

extension ViewAnexo {
    
    func hasFiles() -> Bool {
        return !self.anexos.isEmpty
    }
    
    func removeAll() {
        self.anexos.removeAll()
        self.updateList()
    }
}

extension ViewAnexo {
    
    @IBAction func displayFileOptions (_ sender: Any) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "anexo_view_select_options".localized, preferredStyle: .actionSheet)
        
        // 2
        let camera = UIAlertAction(title: "anexo_view_open_camera".localized, style: .default, handler: { action in
            self.openCamera(sender)
        })
        let gallery = UIAlertAction(title: "anexo_view_select_from_files".localized, style: .default, handler: { action in
            self.openGallery()
        })
        
        // 3
        let cancelAction = UIAlertAction(title: "anexo_view_cancel".localized, style: .cancel)
        
        // 4
        optionMenu.addAction(camera)
        optionMenu.addAction(gallery)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.controller?.present(optionMenu, animated: true, completion: nil)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        self.controller?.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    @IBAction func openGallery() {

         selectImageFrom(.photoLibrary)
     }
}

// MARK: Observer Height Collection
extension ViewAnexo {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.width.constant = size.width
                    return
                }
            }
        }
    }
}


extension ViewAnexo {

    func updateList() {
        self.lbError.isHidden = true
        self.lbNoFiles.isHidden = !self.anexos.isEmpty
        self.collectionView.isHidden = self.anexos.isEmpty
        
        self.collectionView.reloadData()
    }
}

// Data Collection
extension ViewAnexo: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.anexos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ViewAnexoCell

        let currentItem = self.anexos[indexPath.row]
        cell.displayContent(anexo: currentItem)
        
        // Index no button, para abrir detalhes
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.removeTarget(nil, action: nil, for: .allEvents)
        cell.btnRemove.addTarget(self, action: #selector(onClickRemoveAnexo(sender:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: Layout Collection
extension ViewAnexo: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Layout custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
        }
        
        //let size = CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: 130)
        let size = CGSize(width: 100, height: 140)
        return size
    }
}

extension ViewAnexo : AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Falha ao capturar imagem", message: "Tivemos um problema ao capturar a imagem. Por favor, tente novamente.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.controller?.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        var imagePath: URL?
        if #available(iOS 11.0, *) {
            
            if picker.sourceType == .camera {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    //salva a imagem na galeria
                    imagePath = self.saveToDocuments(image: image)
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
            Util.showAlertDefaultOK(self.controller!, message: "Falha ao selecionar imagem!")
            return
        }

        let anexo = Anexo(type: self.tipoAnexo, path: path.path, tag: "")
        self.anexos.append(anexo)
        self.updateList()
    }
    
    func saveToDocuments(image: UIImage) -> URL
    {
        let imageFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = imageFolder.appendingPathComponent("\(UUID()).jpg")
        
        do {
            let jpegData = UIImageJPEGRepresentation(image, 0.5)
            try jpegData?.write(to: imageURL, options: .atomic)
            return imageURL
        } catch {
            
        }
        
        return imageURL
    }
}

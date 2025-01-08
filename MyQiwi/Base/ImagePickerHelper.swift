import UIKit

protocol ImagePickerDelegate: AnyObject {
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage)
    func didClickCancel(at imagePicker: ImagePicker)
}

class ImagePicker: NSObject {
    
    // MARK: - Properties
    weak var controller: UIImagePickerController?
    weak var viewController: UIViewController?
    weak var delegate: ImagePickerDelegate?
    var info: [String : Any]?
    private var imagePath: URL?
    
    func dismiss() {
        controller?.dismiss(animated: true)
    }
    
    func present(from viewController: UIViewController, sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = false) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        pickerController.allowsEditing = allowsEditing
        self.controller = pickerController
        
        DispatchQueue.main.async {
            viewController.present(pickerController, animated: true)
        }
    }
    
    func displayChooseDevice(from viewController: UIViewController, allowsEditing: Bool) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePicture = UIAlertAction(title: "Câmera", style: .default) { [unowned self] _ in
                self.present(from: viewController, sourceType: .camera, allowsEditing: allowsEditing)
            }
            alertController.addAction(takePicture)
        }
        
        let selectFromLibrary = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { [unowned self] _ in
            self.present(from: viewController, sourceType: .photoLibrary, allowsEditing: allowsEditing)
        }
        alertController.addAction(selectFromLibrary)
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let viewController else { return }
        self.controller = picker
        self.info = info
        
        guard let path = imagePath else {
            Util.showAlertDefaultOK(viewController, message: "Falha ao selecionar imagem!")
            return
        }
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: editedImage)
        } else
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: originalImage)
        } else {
            print("Nenhuma fonte de imagem reconhecida...")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.didClickCancel(at: self)
    }
}

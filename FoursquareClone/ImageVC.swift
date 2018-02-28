
import UIKit

//A16-> Global değişkenler her yerde kullanabilmek için,tüm sayfalarda vc'lerde ulaşabileceğim bunlara
 var GlobalName = ""
 var GlobalType = ""
 var GlobalAtmosphere = ""
 var GlobalImage = UIImage()

class ImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var PlaceName: UITextField!
    @IBOutlet weak var PlaceType: UITextField!
    @IBOutlet weak var PlaceAtmosphere: UITextField!
    @IBOutlet weak var SelectedImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //A9 ImageView dokunulabilir olmalı,
        SelectedImage.isUserInteractionEnabled = true
        //A10 Dokunduğunda çalışması için bir fonksiyona ihtiyacı var
        let GestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageVC.SelectImage))
        //A11 Yaratılan fonksiyonun Image'a atanması
        SelectedImage.addGestureRecognizer(GestureRecognizer)
    }
    
    //A17 -> bu fonksiyon ile sıfırlıyoruz böylelikle, boş olduğundan emin olalım -> viewWillAppear -> dataları mapVC'ye taşıyoruz
    //A18, daha önce segue ile yapıyoduk çünkü tek değişken taşıyoduk ve daha güvenli yöntem ama şuan 4 değişken taşıyoruz.
    //Her açıldığında sayfa sıfır yapar
    override func viewWillAppear(_ animated: Bool) {
        GlobalName = ""
        GlobalType = ""
        GlobalAtmosphere = ""
        GlobalImage = UIImage()
    }
    
    
    @objc func SelectImage() {
        //A12 seçme fonksiyonu
        let Picker = UIImagePickerController()
        //A13 Delegate -> yukarda tanımla
        Picker.delegate = self
        Picker.sourceType = .photoLibrary
        Picker.allowsEditing = true
        self.present(Picker, animated: true, completion: nil)
    }
    //A14 -> Image seçilince ne olacak
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //A15 -> info diyoruz o bizden string istiyor, zaten bu fonksiyona bi string değeri geliyor ondan info diyoruz.
        SelectedImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func NextClicked(_ sender: Any) {
        //A19 -> en son segue yapıldı burda sonra -> MapVC
        if PlaceName.text != "" && PlaceType.text != "" && PlaceAtmosphere.text != "" {
            if let ChoosenImage = SelectedImage.image {
                GlobalName = PlaceName.text!
                GlobalType = PlaceType.text!
                GlobalAtmosphere = PlaceAtmosphere.text!
                GlobalImage = ChoosenImage
            }
        }
        self.performSegue(withIdentifier: "FromImageVCToMapVC", sender: nil)
        PlaceName.text = ""
        PlaceType.text = ""
        PlaceAtmosphere.text = ""
        SelectedImage.image = UIImage(named: "SelectPicture.png")
    }
    
    

}

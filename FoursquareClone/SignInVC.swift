// A0 -> kullanıcı hatırlansın -> userdefaults komutu kullanımı için

import UIKit
import Firebase
import FirebaseAuth


class SignInVC: UIViewController {

    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func SignInClicked(_ sender: Any) {
        if EmailText.text != "" && PasswordText.text != "" {
            Auth.auth().signIn(withEmail: EmailText.text!, password: PasswordText.text!, completion: { (User, Error) in
                if Error != nil {
                    let Alert = UIAlertController(title: "Error", message: Error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let OkButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    Alert.addAction(OkButton)
                    self.present(Alert, animated: true, completion: nil)
                } else {
                    // A0 için self.performSegue(withIdentifier: "FromSignInVCToPlacesVC", sender: nil)
                    //A1 -> AppDelegate.swift func RememberLogin her yerde kullanabilmek için
                    UserDefaults.standard.set(User!.email, forKey: "UserLogin")
                    UserDefaults.standard.synchronize()
                    
                    //A3 kullanıcı girdikten sonra dataları tutulsun diye Appdelegate' de tanımladığımız fonksiyonu çağırıyoruz.Delegate'de tanımladığımız için önce buraya entegre ediyoruz.
                    let Delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    Delegate.RememberLogin()
                    
                }
            })
        } else {
            let Alert = UIAlertController(title: "Error", message: "Kullanıcı adı ve Şifre gerekli", preferredStyle: UIAlertControllerStyle.alert)
            let OkButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            Alert.addAction(OkButton)
            self.present(Alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func SignUpClicked(_ sender: Any) {
        if EmailText.text != "" && PasswordText.text != "" {
            
            Auth.auth().createUser(withEmail: EmailText.text!, password: PasswordText.text!, completion: { (User, Error) in
                if Error != nil {
                    let Alert = UIAlertController(title: "Error", message: Error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let OkButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    Alert.addAction(OkButton)
                    self.present(Alert, animated: true, completion: nil)
                } else {
                    //Önce deneme için mail yazdırıyoruz.
                   // print(User?.email)
                    //print("Succesfull")
                    //self.performSegue(withIdentifier: "FromSignInVCToPlacesVC", sender: nil)
                    
                    //A4 A3 de üstte yapılanın aynısını buraya da yazıyoruz A5 yapmamız lazım Appdelegate
                       // A0 için self.performSegue(withIdentifier: "FromSignInVCToPlacesVC", sender: nil)
                       //A1 -> AppDelegate.swift func RememberLogin her yerde kullanabilmek için
                       UserDefaults.standard.set(User!.email, forKey: "UserLogin")
                       UserDefaults.standard.synchronize()
                    
                        //A3 kullanıcı girdikten sonra dataları tutulsun diye Appdelegate' de tanımladığımız fonksiyonu çağırıyoruz.Delegate'de tanımladığımız için önce buraya entegre ediyoruz.
                        let Delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        Delegate.RememberLogin()
                    
                    
                }
            })
            
        } else {
            let Alert = UIAlertController(title: "Error", message: "Kullanıcı adı ve Şifre gerekli", preferredStyle: UIAlertControllerStyle.alert)
            let OkButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            Alert.addAction(OkButton)
            self.present(Alert, animated: true, completion: nil)
        }
        
    }
}


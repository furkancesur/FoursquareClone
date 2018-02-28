

import UIKit
import Firebase
import FirebaseAuth

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //A48 Fonksiyonlarını tanımladık
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = UITableViewCell()
        //A49 cell ' e data nerden gelecek
        Cell.textLabel?.text = PlaceNameArray[indexPath.row]
        
        return Cell
    }
    
    
    @IBOutlet var TableView: UITableView!
    //A50 değişkenlerimiz
    var PlaceNameArray = [String]()
    var ChoosenPlace = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //A47,Tableview ayarları
        TableView.delegate = self
        TableView.dataSource = self
        //A52 fonksiyonu çağıyoruz.
        GetData()
    }
    //A51 data çekme fonksiyonumuz
    func GetData() {
        //A52. Databaseden bana göster yeni bi data geldiğinde,
        Database.database().reference().child("Users").observe(DataEventType.childAdded) { (SnapShot) in
            //A53 value ve key geliyor bunlardan hangisi benim işime yarar, key direk en başı veriyor.
            //print("SnapShot value: \(SnapShot.value)")
            //print("SnapShot key: \(SnapShot.key)")
            //A54 gelen Value' da bize lazım olanı al, ! optional yazısından kurtulduk
            let Values = SnapShot.value! as! NSDictionary
            //A55 ne verecek görelim print, Posttan kurtulmuş olduk
            //print(Values)
            let Posts = Values["Post"] as! NSDictionary
            //print(Posts)
            //A56 şimdi AllKeys yapıyoruz ve ID  ler geliyor bunların içinde loop'a girebiliriz.
            let PostID = Posts.allKeys
            //A60 öncekileri silsin birikmesin
            self.PlaceNameArray.removeAll(keepingCapacity: false)
            for ID in PostID {
                //A57 Postların içinde, tek tek idleri aratıyoruz, ve NSDic. şeklinde getir.
                let SinglePost = Posts[ID] as! NSDictionary
                //print(SinglePost["Name"]!)
                //A58 optional vs. diye gitmesin diye as! String diyoruz.
                self.PlaceNameArray.append(SinglePost["Name"] as! String)
            }
            //A59 tabloyu yeniden yükleyecek
            self.TableView.reloadData()
        }
    }
    //A60 listeden seçildiğinde ne olacak.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //A61 seçtiğimiz yeri alıp bi değişkene kaydettik.
        self.ChoosenPlace = PlaceNameArray[indexPath.row]
        //A62 detaya geçen segue neydi
        self.performSegue(withIdentifier: "FromPlacesVCToDetailsVC", sender: nil)
        //A63 -> DetailsVC
    }
    //A64 prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromPlacesVCToDetailsVC" {
            //A65 seçilen veriyi eski yöntemle, global olmadan diğer tarafa aktarmış olduk.66 Details
            let DestinationVC = segue.destination as! DetailsVC
            DestinationVC.SelectedPlace = self.ChoosenPlace
        }
    }
    @IBAction func LogoutClicked(_ sender: Any) {
        //A6 Siliyoruz önceki bilgiyi.
        UserDefaults.standard.removeObject(forKey: "UserLogin")
        UserDefaults.standard.synchronize()
        //A7 Oku diğer tarafa götürüyoruz yani ilk sayfaya, SignInVC -> bunu kopyala mainstoryboard'a SignInVC olana sarısına tıkla ve Storyboard id kısmına yaz 
        let SignInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let Delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        Delegate.window?.rootViewController = SignInVC
        Delegate.RememberLogin()
    }
    @IBAction func AddClicked(_ sender: Any) {
        //A8 -> Add butonun olduğu yerdeki segue ile normal seguesi aynı isim olmalı, böylelikle imageVC'a gidebilecek. -> ImageVC
        performSegue(withIdentifier: "FromPlacesVCToImageVC", sender: nil)
    }
}

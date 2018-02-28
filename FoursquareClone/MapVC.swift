import UIKit
import MapKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
//A20 -> MapKit için burda tanımlamalar yapıyoruz.
class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var MapView: MKMapView!
    //A21 -> Lokasyonlarla yapacağımız tüm işlemleri yapmamızı sağlıyor.
    var Manager = CLLocationManager()
    //A34 -> Kayıt işlemi başlangıç
    var ChoosenLatitude = ""
    var ChoosenLongitude = ""
    
    //A42 ->
    var UUID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        Manager.delegate = self
        //A22 -> gösterebildiğin en iyi şekilde göster, zoom
        Manager.desiredAccuracy = kCLLocationAccuracyBest
        //A23 -> sadece kullanırken konum alışverişi olacak
        Manager.requestWhenInUseAuthorization()
        Manager.startUpdatingLocation()
        //A24 -> info.plist izin almamız lazım, StartUpdate location dediğimiz için bir de DidUpdateLocation yazmalıyız.
        
        //A29 -> Pin koyma işlemi için
        let Recognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.ChooseLocation(GestureRecognizer:)))
        //A31 -> 3 saniye basılı tutunca işlemi yapacak.
        Recognizer.minimumPressDuration = 3
        MapView.addGestureRecognizer(Recognizer)
        
        
    }
    //A36 -> Her UIview yüklendiğinde çalışır, bir önceki koordinati save etmeye çalışmasın.
    override func viewWillAppear(_ animated: Bool) {
        self.ChoosenLatitude = ""
        self.ChoosenLongitude = ""
    }
    
    
    //A30 -> ChooseLocation fonksiyonunu yazıyoruz, Oluşturduğumuz noktayı kullanacağımız için Parantez içine bir parametre yazıyoruz.
    @objc func ChooseLocation(GestureRecognizer: UILongPressGestureRecognizer) {
        if GestureRecognizer.state == UIGestureRecognizerState.began {
            //A31 Dokunduğumuz yerin koordinatlarını almamız lazım, nerden alıyoruz mapView'dan alıyoruz.
            let Touches = GestureRecognizer.location(in: self.MapView)
            //A32 Dokunulan noktayı convert edicem, Touches'ı al ve haritaları kullanarak koordinata çevir
            let Coordinates = self.MapView.convert(Touches, toCoordinateFrom: self.MapView)
            //A33 iğne eklemek için
            let Annotation = MKPointAnnotation()
            Annotation.coordinate = Coordinates
            Annotation.title = GlobalName
            Annotation.subtitle = GlobalType
            self.MapView.addAnnotation(Annotation)
            
            //A35 ->Kullanıcı bi yer seçtiğinde konumunu enlem ve boylam olarak alıp tutuyorum, bunları firebase'e kaydediyoruz.
            self.ChoosenLatitude = String(Coordinates.latitude)
            self.ChoosenLongitude = String(Coordinates.longitude)
        }
    }
    
    
    //A25 -> Lokasyonlar güncellenince ne olacak.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //A26 -> Kullanıcı lokasyonunu aldık
        let Location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        //A27 -> Bu bilgileri alıp harita odağına koymamız gerekiyor, Delta sorar bize zoom seviyesi 0.05 yapıyoruz
        let Span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        //A28 -> Lokasyon ve Spanı kullanarak bir region oluşturuyoruz.
        let Region = MKCoordinateRegion(center: Location, span: Span)
        MapView.setRegion(Region, animated: true)
    }
    //A38 firebase kayıt için, firebase import, Firebase'e gidip Storage kısmında Media klasörü oluşturdum ve onu burda tanımlamalıyım.
    @IBAction func SaveClicked(_ sender: Any) {
        //A39 Folder tanımlandı.
        let MediaFolder = Storage.storage().reference().child("Media")
        //A40 Upload sürecini başlatmak için resmi dataya çevirmek gerekiyor.
        if let Data = UIImageJPEGRepresentation(GlobalImage, 0.5){
            //A41 her seferinde uniq bir isimle kaydetmek istiyoruz, completion vereni seçiyoruz., enter yapıyoruz o blokta
            MediaFolder.child("\(UUID).jpg").putData(Data, metadata: nil, completion: { (MetaData, Error) in
                if Error != nil {
                    let Alert = UIAlertController(title: "Alert", message: Error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let OkButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                    Alert.addAction(OkButton)
                    self.present(Alert, animated: true, completion: nil)
                } else {
                    //A43 Metadata bana bir download url veriyor. Download URL'i string'e çevirebiliyoruz
                    let ImageURL = MetaData?.downloadURL()?.absoluteString
                    //A44 -> image url yazdırması lazım kontrol ediyoruz, kaydederse firebase'e bana link vericek.
                    //print(ImageURL)
                    //A46 Location tanımlıyorum sonra Database'e nasıl kaydedeceğini gösteriyorum, A47 ->PlacesVC
                    let Location = ["Image" : ImageURL!, "Name" : GlobalName, "Type" : GlobalType, "Atmosphere" : GlobalAtmosphere, "Latitude" : self.ChoosenLatitude, "Longitude" : self.ChoosenLongitude, "UUID" : self.UUID, "PostedBy" : Auth.auth().currentUser!.email! ] as [String : Any]
                    Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Post").childByAutoId().setValue(Location)
                    //A45 burdan places viewcontroller'a gitmek istiyoruz.
                    self.performSegue(withIdentifier: "FromMapVCToPlacesVC", sender: nil)
                }
            })
            
            
        }
    }
    //A37 -> Cancel tıkladığımda önceki sayfa boş çıkmalı, test et
    @IBAction func CancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

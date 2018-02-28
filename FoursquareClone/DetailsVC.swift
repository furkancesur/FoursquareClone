import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
//67 ögeleri buraya aktardık, Mapkit import, ve 2 delegate
import MapKit
import SDWebImage

class DetailsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var PlaceImage: UIImageView!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var PlaceType: UILabel!
    @IBOutlet weak var PlaceAtmosphere: UILabel!
    @IBOutlet weak var MapView: MKMapView!
    //A63 -> 64 Prepareforsegue PlacesVC
    var SelectedPlace = ""
    //A66 üstüne başka ne getireceğiz.
    var NameArray = [String]()
    var TypeArray = [String]()
    var AtmosphereArray = [String]()
    var LongitudeArray = [String]()
    var LatitudeArray = [String]()
    var ImageURLArray = [String]()
    
    var Manager = CLLocationManager()
    var RequestCLLocation = CLLocation()
    
    var ChosenLatitude = ""
    var ChosenLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapView.delegate = self
        Manager.delegate = self
        Manager.desiredAccuracy = kCLLocationAccuracyBest
        Manager.requestWhenInUseAuthorization()
        Manager.startUpdatingLocation()
        
        FindPlaceFromServer()
    }
    //A67 -> update olacak location, update olan locationı değiştirmeliyiz bize yollananı göstermeliyiz.Firebase verileri çekilmeli
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //selectedLocation
        if self.ChosenLongitude != "" && self.ChosenLatitude != "" {
            let Location = CLLocationCoordinate2D(latitude: Double(self.ChosenLatitude)!, longitude: Double(self.ChosenLongitude)!)
            let Span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let Region = MKCoordinateRegion(center: Location, span: Span)
            self.MapView.setRegion(Region, animated: true)
            let Annotation = MKPointAnnotation()
            Annotation.coordinate = Location
            Annotation.title = self.NameArray.last!
            Annotation.subtitle = self.TypeArray.last!
            self.MapView.addAnnotation(Annotation)
        }
    }
    //A68 yukarda çağırmayı unutma
    func FindPlaceFromServer() {
        
        Database.database().reference().child("Users").observe(DataEventType.childAdded) { (SnapShot) in
        
        let Values = SnapShot.value! as! NSDictionary
        let Posts = Values["Post"] as! NSDictionary
        let PostID = Posts.allKeys
            //print(PostID)
            //print(self.SelectedPlace)
            self.NameArray.removeAll(keepingCapacity: false)
            self.TypeArray.removeAll(keepingCapacity: false)
            self.AtmosphereArray.removeAll(keepingCapacity: false)
            self.LongitudeArray.removeAll(keepingCapacity: false)
            self.LatitudeArray.removeAll(keepingCapacity: false)
            self.ImageURLArray.removeAll(keepingCapacity: false)
        
            //let query = Posts.queryOrderedByChild("published").queryEqualToValue(true)
            
            for ID in PostID {
                let SinglePost = Posts[ID] as! NSDictionary
                self.NameArray.append(SinglePost["Name"] as! String)
                self.TypeArray.append(SinglePost["Type"] as! String)
                self.AtmosphereArray.append(SinglePost["Atmosphere"] as! String)
                self.LongitudeArray.append(SinglePost["Longitude"] as! String)
                self.LatitudeArray.append(SinglePost["Latitude"] as! String)
                self.ImageURLArray.append(SinglePost["Image"] as! String)
                
            }
                self.PlaceName.text = "Name: \(self.NameArray.last!)"
                self.PlaceType.text = "Type: \(self.TypeArray.last!)"
                self.PlaceAtmosphere.text = "Atmosphere: \(self.AtmosphereArray.last!)"
                self.PlaceImage.sd_setImage(with: URL(string : "\(self.ImageURLArray.last!).jpg"))
                self.ChosenLatitude = self.LatitudeArray.last!
                self.ChosenLongitude = self.LongitudeArray.last!
        }
    }
}

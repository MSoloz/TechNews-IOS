
import UIKit
import  MapKit
import CoreLocation

class MapSelectedAnnotation
{
    var coordinate:CLLocationCoordinate2D?
    var adress:String?
}

class SelectEventPositionMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectedAdressLabel: UILabel!
    var lastMapSelectedAnnotation:MapSelectedAnnotation?
    var locationManager = CLLocationManager()

    @IBOutlet weak var saveAdress: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveAdress.isEnabled = false

        self.initLocation()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined  || status == .restricted
        {
            locationManager.requestWhenInUseAuthorization()
            
        }else{
                
            self.centerViewOnUserLocation()
        }
            
    }
    
    func initLocation()
    {
        self.locationManager = CLLocationManager()
      
        self.mapView.delegate = self
    }
    
    func centerViewOnUserLocation(){
    
        if let location = locationManager.location?.coordinate{
            
            self.MarkSelectedPosition(coordinate: location)
            
        }
        
    }
    
    func MarkSelectedPosition(coordinate:CLLocationCoordinate2D)
    {
        self.mapView.removeAnnotations(self.mapView.annotations)
           let myPosition = MKPointAnnotation()
           myPosition.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.addAnnotation(myPosition)
        
           let coordinateRegion = MKCoordinateRegion(center: myPosition.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        
    }
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        mapView.removeOverlays(mapView.overlays)
                    if let touch = touches.first {
                        let coordinate = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)

                        self.MarkSelectedPosition(coordinate: coordinate)
                        self.getReversedAdress(coordinate: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        
                    }
        	
    }
    
   
    func getReversedAdress(coordinate:CLLocation)
    {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(coordinate) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            var adress = ""
            var adressDidFound = true
            
            if let thoroughfare = placemark.thoroughfare
            {
                adress.append(thoroughfare+", ")
            
            }else{
                adressDidFound = false
            }
            
            if let locality = placemark.locality
            {
                adress.append(locality+", ")

            }else{
                adressDidFound = false

            }
            
            if let country = placemark.country
            {
                adress.append(country)

            }else{
                adressDidFound = false

            }
            
            if adressDidFound{
                self.saveAdress.isEnabled = true
                self.lastMapSelectedAnnotation = MapSelectedAnnotation()
                self.lastMapSelectedAnnotation?.adress = adress
                self.lastMapSelectedAnnotation?.coordinate = coordinate.coordinate
                
                self.selectedAdressLabel.text = adress
                
            }else{
                self.saveAdress.isEnabled = false
                self.selectedAdressLabel.text = ""
                
            }
            
        }
    }
    

    @IBAction func saveDidTapped(_ sender: Any) {
        
        
        //let addEvent = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEventPageVC") as! AddEventPageVC
        
        //self.navigationController?.pushViewController(addEvent, animated: true)
        
        for vc in self.self.navigationController!.viewControllers
        {
            if vc is AddEventPageVC
            {
                let addEvent = vc as! AddEventPageVC
                addEvent.selectedMapLocation = self.lastMapSelectedAnnotation

                self.navigationController?.popToViewController(addEvent, animated: true)
            }
        }
    }
    
    @IBAction func cancelDidTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


import UIKit
import MapKit

class ShowMapEventViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var coordinate:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let coordinate = coordinate {
            
            self.MarkSelectedPosition(coordinate: coordinate)
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
    

    @IBAction func returnToPrevious(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

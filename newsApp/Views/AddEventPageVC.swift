

import UIKit

class AddEventPageVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, AddEventResponseNotifier,UITextFieldDelegate{
    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    var selectedMapLocation:MapSelectedAnnotation?
    
    
    @IBOutlet weak var adressLocationLabel: UILabel!
    
    @IBOutlet weak var eventDateTimePicker: UIDatePicker!
    var selectedImage:UIImage?
    
    func showLoading() {
        LoadingView.shared.showLoadingView(view: self.view)
    }
    
    func eventDidCreated() {
        LoadingView.shared.dismissLoadingView()
        
        AlertResponseView.shared.showAlert(message: "Event successfully created", viewController: self,handler: nil)
        self.NameEventTextField.text = ""
        self.DescEventTextField.text = ""
        self.EventImageView.image = UIImage(named: "hghg")
    }
    
    func serverNotResponding() {
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    }
    
    
    @IBOutlet weak var NameEventTextField: UITextField!
    
    @IBOutlet weak var TimeEventTextFiled: UITextField!
    
    
    @IBOutlet weak var DescEventTextField: UITextField!
    

    @IBOutlet weak var EventImageView: UIImageView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedMapLocation = selectedMapLocation {
            
            self.adressLocationLabel.text = selectedMapLocation.adress
            
        }else{
            
            self.adressLocationLabel.text = "Please choose a location"

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NameEventTextField.delegate = self
        self.DescEventTextField.delegate = self
        
        EventController.shared.addEventNotifier = self
        self.eventDateTimePicker.minimumDate = Date()
        
    }
    
    @IBAction func returnBackToPrevious(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func selectPositionFromMap(_ sender: Any) {
        
        let mapVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "SelectEventPositionMapViewController") as SelectEventPositionMapViewController
        self.navigationController?.pushViewController(mapVC, animated: true)
                
    }
    
    @IBAction func AddPhoto1(_ sender: Any) {
        
        showActionSheet()
    }
    
    @IBAction func SaveEvent(_ sender: Any) {
        
        
        if let name = self.NameEventTextField.text,let desc = self.DescEventTextField.text,!desc.isEmpty,!name.isEmpty
        {
            
            if let img = selectedImage
            {
                
                if let selectedLocation = self.selectedMapLocation,let coordinate = selectedLocation.coordinate,let adress = selectedLocation.adress
                {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
                    let datetimeEvent = dateFormatter.string(from: self.eventDateTimePicker.date)
                    
                      let event = Event()
                      event.event_time = datetimeEvent
                      event.name = name
                      event.description = desc
                    event.lng = coordinate.longitude.description
                    event.lat = coordinate.latitude.description
                    event.adress = adress
                    
                    if let user = user
                    {
                        
                        EventController.shared.addEvent(event: event, image: img,user:user)
                       
                    }
                    
                    
                }else{
                    
                    AlertResponseView.shared.showAlert(message: "Select a location to continue", viewController: self,handler: nil)
                    
                }
               
            }else{
                
                AlertResponseView.shared.showAlert(message: "Select a photo to continue", viewController: self,handler: nil)
                
            }
            
            
        }else{
            
            AlertResponseView.shared.showAlert(message: "All fields are required", viewController: self,handler: nil)
        }
        
    
    }
    
      func camera()
      {
          let myPickerControllerCamera = UIImagePickerController()
          myPickerControllerCamera.delegate = self
          myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
          myPickerControllerCamera.allowsEditing = true
          self.present(myPickerControllerCamera, animated: true, completion: nil)

      }
    
    
    func gallery()
    {

        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
           
            return
       }
        
        self.selectedImage=selectedImage
        self.EventImageView.image = self.selectedImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func showActionSheet(){

        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)

        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
            self.camera()
        }
        actionSheetController.addAction(saveActionButton)

        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true

    }

}

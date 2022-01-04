
import UIKit

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UpdateProfileResponseNotifier {
    
    
   func showLoading() {
       LoadingView.shared.showLoadingView(view: self.view)

    }
    
    func userSuccessfullyUpdated() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Profile successfully update !", viewController: self, handler: nil)
        
    }
    
    func serverNotResponding() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    
        
    }
    

    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.updateProfileNotifier = self
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        
        if let user = user
        {
            
            firstnameTF.text = user.prenom
            lastnameTF.text = user.nom
            emailTF.text = user.email
            
            if let img = user.image
            {
                let imgPath = Utils.URL_IMAGE_PATH+"USERImg/"+img
                
                WebServiceProvider.shared.downloadImage(url: imgPath, responseImageHandler: {
                    image in
                
                    self.profileImageView.image = image
                    
                })
            }

            
        }

    }
    

    @IBAction func addPhoto(_ sender: Any) {
    
        showActionSheet()
    
    }
    
    
    @IBAction func updateProfileTapped(_ sender: Any) {
        
        
        if firstnameTF.text?.isEmpty == true  ||  lastnameTF.text?.isEmpty == true
        {
            
            AlertResponseView.shared.showAlert(message: "All fields are required !", viewController: self,handler: nil)
        
            
        }else{
            
            let updatedUser = User()
            
            updatedUser._id = self.user?._id
            updatedUser.nom = lastnameTF.text
            updatedUser.prenom = firstnameTF.text
            
            UserController.shared.updateUser(user: updatedUser, image: self.profileImageView.image!)
            
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
        
        self.selectedImage = selectedImage
        self.profileImageView.image = self.selectedImage
        
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
}

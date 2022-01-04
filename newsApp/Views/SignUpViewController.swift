
import UIKit

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SignUpResponseNotifier,UITextFieldDelegate {
    
    
    func showLoading() {
        
        LoadingView.shared.showLoadingView(view: self.view)
        
    }
    
    func userSuccessfullyCreated() {
        
        LoadingView.shared.dismissLoadingView()

        AlertResponseView.shared.showAlert(message: "User successfully created !", viewController: self){
            
            let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            self.navigationController?.viewControllers = [loginVC]
            
        }
        
    }
    
    func userAlreadyExist() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "User already exists !", viewController: self,handler: nil)
    }
    
    func serverNotResponding() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self, handler: nil)
        
    }
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    let emailPattern = #"^\S+@\S+\.\S+$"#
    
    var isValidForm = true

    var selectedImage:UIImage?
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        self.confirmPassTextField.delegate = self
        
        
        UserController.shared.signUpNotifier = self
    
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2

    }
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        
        self.showActionSheet()
        
    }
    
    
    @IBAction func returnToLogin(_ sender: Any) {
        
        let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        navigationController?.viewControllers = [loginVC]
    
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        isValidForm = true
        
        if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty  || emailTextField.text!.isEmpty  || passwordTextField.text!.isEmpty || confirmPassTextField.text!.isEmpty
        {
            
            AlertResponseView.shared.showAlert(message: "All fields are required !", viewController: self,handler: {})
            isValidForm = false

        }else{
            
            if  emailTextField.text!.range(of: emailPattern,options: .regularExpression) == nil
            {
                AlertResponseView.shared.showAlert(message: "Please enter a valid email address !", viewController: self,handler: {})
                isValidForm = false
            }
            
            if passwordTextField.text != confirmPassTextField.text
            {
                AlertResponseView.shared.showAlert(message: "Password and confirm password doesn't match !", viewController: self,handler: {})
                isValidForm = false

            }
            
            if selectedImage == nil
            {
                AlertResponseView.shared.showAlert(message: "Select a profile photo !", viewController: self,handler: {})
                isValidForm = false
            }
            
            
            if isValidForm
            {
                let newUser = User()
                newUser.email = emailTextField.text!
                newUser.nom = lastNameTextField.text!
                newUser.prenom = firstNameTextField.text!
                
                UserController.shared.signUpUser(user: newUser, password: passwordTextField.text!,image: self.selectedImage!)
                
            }
            
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
        self.profileImage.image = self.selectedImage
        
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

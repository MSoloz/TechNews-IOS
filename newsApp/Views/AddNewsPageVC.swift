

import UIKit

class AddNewsPageVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AddNewsResponseNotifier{
   
    
    func showLoading() {
        LoadingView.shared.showLoadingView(view: self.view)
        
    }
    
    func newsDidCreated() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "News successfully created", viewController: self,handler: nil)
        
        self.DescNewsTextField.text = ""
        self.NameNewsTextField.text = ""
        self.NewsImageView.image = UIImage(named: "hghg")
        
    }
    
    func serverNotResponding() {
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    }
    
    
    @IBOutlet weak var NameNewsTextField: UITextField!
    
    @IBOutlet weak var DescNewsTextField: UITextField!

    @IBOutlet weak var NewsImageView: UIImageView!
    
    var selectedImage:UIImage?
    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsController.shared.addNewsNotifier = self
        
    }
    


    @IBAction func AddPhoto(_ sender: Any) {
        
        showActionSheet()
            
    }

    @IBAction func SaveNews(_ sender: Any) {
        
        if NameNewsTextField.text!.isEmpty  || DescNewsTextField.text!.isEmpty
        {
            
            AlertResponseView.shared.showAlert(message: "All field are required !", viewController: self, handler: nil)
            
        }else{
            
            
            if let img = selectedImage
            {
                
                if let user = user{
                    
                    let news = News()
                    news.title = self.NameNewsTextField.text
                    news.desc = self.DescNewsTextField.text
                    NewsController.shared.addNews(news: news, image: img,user: user)
                    
                }
                
            }else{
                
                AlertResponseView.shared.showAlert(message: "Select a photo to continue", viewController: self,handler: nil)
            
            }
            
        }
        
        
    }
    
    @IBAction func geBackToPrevious(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
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
        self.NewsImageView.image = self.selectedImage
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

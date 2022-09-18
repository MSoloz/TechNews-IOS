import UIKit

class LoginViewController: UIViewController,LoginResponseNotifier,UITextFieldDelegate {
    
    
    func showLoading() {
        
        LoadingView.shared.showLoadingView(view: self.view)
        
    }
    
    func userSuccessfullyLoggedIn(user: User) {
        
        LoadingView.shared.dismissLoadingView()
        let parentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentTabViewController")
        self.navigationController?.pushViewController(parentViewController, animated: true)
        
    }
    
    func wrongCredential() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Please verify your credential !", viewController: self,handler: nil)
        
    }
    
    func serverNotResponding() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
        
    }
    
    
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var LoginEmailTextField: UITextField!
    @IBOutlet weak var LoginPasswordTextField: UITextField!
        
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LoginEmailTextField.delegate = self
        self.LoginPasswordTextField.delegate = self
        
        UserController.shared.loginNotifier = self
        
    }
    
    @IBAction func goToForgetPassword(_ sender: Any) {
        
        let forgetPassVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        
        navigationController?.viewControllers = [forgetPassVC]
        
    }
    
    @IBAction func goToHome(_ sender: Any) {
     
        UserController.shared.loginUser(email: LoginEmailTextField.text!, password: LoginPasswordTextField.text!)
        
    }
   
    @IBAction func goToSignUp(_ sender: Any) {
        
        let signUpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        navigationController?.viewControllers = [signUpVC]
        
    }
    
    
    

}

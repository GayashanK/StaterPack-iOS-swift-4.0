//
//  BaseViewController.swift
//  Feel Destination
//
//  Created by KE-MacMini2 on 10/20/17.
//  Copyright © 2017 KeenEye Solutions. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    var container: UIView = UIView()
    var loaderImageView:UIImageView? = nil
    
    var userId:Int {
        get{
            return UserDefaultsHelper.instance.get(key: .userId)
        }
    }
    var userFirstName:String {
        get{
            return UserDefaultsHelper.instance.get(key: .userFirstName) ?? ""
        }
    }
    var userLastName:String {
        get{
            return UserDefaultsHelper.instance.get(key: .userLastName)  ?? ""
        }
    }
    var userEmailAddress:String? {
        get{
            return UserDefaultsHelper.instance.get(key: .userEmail)
        }
    }
    var userCountry:String {
        get{
            return UserDefaultsHelper.instance.get(key: .userCountry)  ?? ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showActivityIndicator(uiView: UIView) {
        if loaderImageView == nil {
        container.frame = uiView.frame
        container.center = uiView.center
        var loaderImage:UIImage = UIImage()
//        if type == .dark {
//            container.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            loaderImage = #imageLiteral(resourceName: "loader_white")
//        } else {
//            container.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//            loaderImage = #imageLiteral(resourceName: "loader_blue")
//        }
        loaderImageView = UIImageView(image: loaderImage)
        loaderImageView?.contentMode = .scaleAspectFill
        loaderImageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loaderImageView?.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
        
        container.addSubview(loaderImageView!)
        uiView.addSubview(container)
        loaderImageView?.rotateAnimation()
        }
    }
    
    func hideActivityIndicator() {
        loaderImageView?.removeFromSuperview()
        loaderImageView = nil
        container.removeFromSuperview()
    }
    
    func showErrorView(errorCode: String, parentView: UIViewController) -> AOAlertView {
        let errorView = setupErrorView()
        
        errorView.setView(errorCode: errorCode, view: parentView)
        view.addSubview(errorView)
        fadeInAnimateView(errorView: errorView)
        return errorView
    }
    
    func showErrorView(errorMessage: String, parentView: UIViewController) -> AOAlertView {
        let errorView = setupErrorView()
        errorView.tag = 100
        errorView.setView(errorMessage: errorMessage, view: parentView)
        view.addSubview(errorView)
        fadeInAnimateView(errorView: errorView)
        return errorView
    }
    
    func removeErrorView(parentView : UIViewController) -> AOAlertView{
        let errorView = setupErrorView()
        view.viewWithTag(100)?.removeFromSuperview()
//        view.remov(errorView)
        fadeInAnimateView(errorView: errorView)
        return errorView
    }
    
    func showStatus(view: UIView, message:String? = nil)  {
        
        let generator = UINotificationFeedbackGenerator()
        
        let modalView = AOModalStatusView(frame: view.bounds)
        modalView.alpha = 0
        if message == nil {
            generator.notificationOccurred(.success)
            modalView.statusImage.alpha = 0
            modalView.headerLine.text = "Success"
        } else {
            generator.notificationOccurred(.error)
            modalView.checkBox.alpha = 0
            modalView.errorMessage = message!
        }
        view.addSubview(modalView)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            modalView.alpha = 1
        }, completion: { (finished: Bool) in
            modalView.checkBox.setOn(true, animated: true)
            modalView.statusImage.shake()
        })
    }
    
    private func setupErrorView() -> AOAlertView {
        let errorView = AOAlertView(frame: self.view.bounds)
        errorView.alpha = 0
        return errorView
    }
    
    private func fadeInAnimateView(errorView:AOAlertView) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            errorView.alpha = 1
        })
    }
    
    func alert(title:String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertViewController.addAction(okButton)
        present(alertViewController, animated: true, completion: nil)
    }
    
//    func alertNavigateUserToLogin(title:String,message:String){
//
//        let showLoginAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//
//        // navigate to login
//        showLoginAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in
//
//             let loginVc = UIStoryboard(name: StoryboardIdentifier.login.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.login.rawValue) as! LoginScreenViewController
//            self.navigationController!.pushViewController(loginVc, animated: true)
//            self.tabBarController?.tabBar.isHidden = true
//
//        }))
//
//        //"Cancel"
//        showLoginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Logic here")
//        }))
//
//        present(showLoginAlert, animated: true, completion: nil)
//
//
//    }
    
    
    func navigate(to:ViewControllerIdentifier) {
        var viewController:UIViewController? = nil
        var isNavigationHidden = false
        switch to {
        case .viewController:
            viewController = UIStoryboard(name: StoryboardIdentifier.main.rawValue, bundle: nil).instantiateViewController(withIdentifier: to.rawValue) as? ViewController
            isNavigationHidden = true
            break
        }
        if let navigator = navigationController, let viewController = viewController  {
            navigator.setNavigationBarHidden(isNavigationHidden, animated: false)
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    func navigate(to:UIViewController) {
        if let navigator = navigationController  {
            navigator.pushViewController(to, animated: true)
        }
    }
}
private extension UIView {
    func rotateAnimation(duration: CFTimeInterval = 0.9) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

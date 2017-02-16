//
//  MemeImageController.swift
//  PickImage
//
//  Created by Kevin Reese on 11/6/16.
//  Copyright © 2016 Kevin Reese. All rights reserved.
//

import UIKit

class MemeImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var pickAnImage: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memedImage: UIImage!
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -4.0]
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
        
    
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setTextField(textField: topTextField)
        setTextField(textField: bottomTextField)
        
        
    }
    
    func setTextField(textField: UITextField)
    {
        textField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        textField.textAlignment = .center
        textField.delegate = self
        shareButton.isEnabled = false
        
    }
    
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    
    func save()
    {
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: image.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        
        let appDelegate = object as! AppDelegate
        
        appDelegate.memes.append(meme)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage
    {
        
        
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
        
        return memedImage
    }
    
    
    func imagePickerController(_ PickAnImage: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.image.image = image
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ PickAnImage: UIImagePickerController)
    {
        if (cancelButton.action != nil) {
            
            shareButton.isEnabled = false
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if textField.text == "TOP" || textField.text == "BOTTOM"
            
        {
            textField.text = ""
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        
        if bottomTextField.isFirstResponder
        {
            return keyboardSize!.cgRectValue.height
            
        }
            
        else
        {
            return 0
            
        }
        
    }
    
    
    func keyboardWillShow(_ notification:Notification)
    {
        view.frame.origin.y = getKeyboardHeight(notification: notification as NSNotification) * (-1)
    }
    
    func keyboardWillHide(_ notification:Notification)
    {
        view.frame.origin.y = 0
    }
    
    
    func subscribeToKeyboardNotifications()
    {
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {

        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    @IBAction func PickAnImage(_ sender: Any)
    {
        presentPicker(sourceType: .photoLibrary)
        
    }
    
   
    @IBAction func PickFromCamera(_ sender: Any)
    {
        presentPicker(sourceType: .camera)
        
    }
    
    func presentPicker(sourceType: UIImagePickerControllerSourceType)
    {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        
        pickerController.sourceType = sourceType
        
        present(pickerController, animated: true, completion: nil)
        
        shareButton.isEnabled = true
        
    }
    
    @IBAction func Share(_ sender: Any)
    {
        let memeShare = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeShare], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {activity, success, items, error in
            
            if success
            {
                self.save()
            }
            
        }
        
        present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func CancelButton(_ sender: Any)
    {
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    

}


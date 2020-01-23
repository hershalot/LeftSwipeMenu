//
//  LeftMenu.swift
//
//  Created by Hershalot on 10/10/19.
//  Copyright © 2019 Hershalot. All rights reserved.
//


enum LeftMenuAction {
    
    case toggleAction
    case logoutAction
    
}

import UIKit


protocol LeftMenuDelegate {
    
    func didSelectLeftMenuItem (withAction: LeftMenuAction)
}



class LeftMenu: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    var dataManager: DataManager = DataManager()
    var backgroundView:UIView!
    var isOpen: Bool = false
    var parentViewController = UIViewController()
    var menuDelegate:LeftMenuDelegate?
    
    
    @IBOutlet weak var logoutButton: UIButton!
    //Storyboard Objects
    @IBOutlet weak var toggleViewButton: UIButton!
    
    
    let sizeScalor: CGFloat = 0.15
    
    

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    init(width:CGFloat, parentViewController:UIViewController) {
        
        super.init(frame: CGRect(x: -width + width * sizeScalor, y: 0, width: width, height: parentViewController.view.frame.height))
        
        //setup UI Views and load XIB
        commonInit()
        
        
        self.parentViewController = parentViewController
        
        //Do Any UI Setup Here
        self.toggleViewButton.layer.cornerRadius = 40
        self.toggleViewButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.toggleViewButton.clipsToBounds = true
        
        
        //Add self as subview to parent
        parentViewController.view.addSubview(self)
        
        
        //Set PAN Gesture Recognizer
        let pullMenuRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.respondToPanGesture))
        self.addGestureRecognizer(pullMenuRecognizer)
        
        //Configure the background view UI for parentView overlay (below menu)
        backgroundView = UIView(frame: CGRect(x: parentViewController.view.bounds.minX,y:parentViewController.view.bounds.minY, width: parentViewController.view.bounds.width , height: parentViewController.view.bounds.height))
        backgroundView = UIView(frame: parentViewController.view.bounds)
        backgroundView.backgroundColor = UIColor.white()
        
        self.layer.cornerRadius = 20;
        backgroundView.alpha = 0.0

        //Add the Background tap recognize for closing the drawer on background view touched
        let touchClose:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTouched))
        self.backgroundView.addGestureRecognizer(touchClose)
        self.clipsToBounds = true
        
    }
    
    
    
    private func commonInit(){
        
        //load the custom menu xib
        Bundle.main.loadNibNamed("LeftMenu", owner: self, options: nil)
        
        //initialize the content view and set it's UI
        contentView = UIView();
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 20
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        addSubview(contentView)
        
        
        //initialze the menu state and set it's image
        self.isOpen = false;
//        self.toggleViewButton.setImage(UIImage(), for: .normal)

        
    }
    
    

    //Toggle Actions. Perfrom the delegate action and set toggle button UI here
    @IBAction func toggleViewAction(_ sender: Any) {
        
        menuDelegate?.didSelectLeftMenuItem(withAction: .toggleAction)
        
        if(self.isOpen){
            self.isOpen = false;
            
            
//            self.toggleViewButton.setImage(rightImage, for: .normal)
            
            close(interval: 0.2)
            
        }else{
            self.isOpen = true;
            
//            self.toggleViewButton.setImage(leftImage, for: .normal);
            
            open(interval: 0.2)
        }
    }
    
    

    
    //Example menu action
    @IBAction func logoutAction(_ sender: Any) {
        menuDelegate?.didSelectLeftMenuItem(withAction: .logoutAction)
    }


    
    
 
    //PAN Gesture response
    @objc func respondToPanGesture(gesture: UIPanGestureRecognizer){
        
        //Panning variables
        let velocity = gesture.velocity(in: self)
        let translation = gesture.translation(in: self)
        
        
        //On gesture begin or change, and the menu is , transalate the menu along the X axis
        if (gesture.state == .began || gesture.state == .changed) {
            
            if(self.frame.minX <= 0 && self.frame.maxX <= self.parentViewController.view.frame.maxX){
                
                gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x , y: gesture.view!.center.y)
                gesture.setTranslation(CGPoint.zero, in: self)
            }
        }
            
        //on pan end, determine whether to change views or stay in current view. On change, do animation
        else if (gesture.state == .ended){
            
            //if velocity is enough, open or close based on current isOpen state. This simulates a swipe
            if(velocity.x > 1500 && !self.isOpen){
                self.open(interval: 0.3)
                
            }else if(velocity.x < -1500 && self.isOpen){
                self.close(interval: 0.3)
                
            }
                
            //if not enough velocity and the menu center is greater than the left size, finish opening the drawer
            else if (self.center.x > 0){
                
                self.open(interval: 0.3)
            }
            // If not enough velocity and the menu center is less the left size finish closing the drawer
            else if (self.center.x <= 0){
                
                self.close(interval: 0.3)
            }
        }
    }
    
    
    
    //Use this to close the drawer if the background view is touched.
    @objc func backgroundViewTouched(){
        self.close(interval: 0.3)
    }
    
    
    
    
    //Open the Menu and set the background view to cover the parent view controller yet still behine the menu
    func open(interval: TimeInterval){
        
        self.isOpen = true
        
//        self.toggleViewButton.setImage(leftImage, for: .normal)
        
        //insert background view
        self.parentViewController.view.insertSubview(self.backgroundView, belowSubview: self)
        
        
        //Animate the opening
        UIView.animate(withDuration: interval,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.2,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        
                        self.center = CGPoint(x: self.frame.width/2, y: self.parentViewController.view.frame.height/2)
                        self.backgroundView.alpha = 0.0
                        
        },
                       completion: { finished in
                        print("Completed")
                        
        })
    }
    
    
    
    
    
    //Close the menu and remove the background view
    func close(interval: TimeInterval){
        
        self.isOpen = false
        
        //remove background view
        self.backgroundView.removeFromSuperview()
    
//        self.toggleViewButton.setImage(rightImage, for: .normal)
        
        //Animate the menu closing
        UIView.animate(withDuration: interval,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.2,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        
                        self.center = CGPoint(x: -self.frame.width/2 + self.frame.width * self.sizeScalor, y: self.frame.height/2)
                        self.backgroundView.alpha = 0.0
                        
        },
                       completion: { finished in
                        print("Completed")
                        
        })
    }
    
}




# LeftSwipeMenu
XIB and View framework for a panning menu on the left handside of a ViewController

Initialize the Menu and set the MenuDelegate from you View Controller:


  `self.leftMenu = LeftMenu.init(width: self.view.frame.width, parentViewController: self)`

  `self.leftMenu.menuDelegate = self`



The Menu Action Delegate


`func didSelectLeftMenuItem(withAction: LeftMenuAction) {`

      switch withAction {

        case .toggleAction:

           	print("Toggle Action")
            
            
        case .logoutAction:
            
           print("Logout Action")
            
        }
   `}`

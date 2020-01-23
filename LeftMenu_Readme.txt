
Initialize the Menu:

self.leftMenu = LeftMenu.init(width: self.view.frame.width, parentViewController: self);



Set the Menu Delegate

self.leftMenu.menuDelegate = self;



//The Menu Action Delegate

func didSelectLeftMenuItem(withAction: LeftMenuAction) {
        switch withAction {

            
        case .toggleAction:

            print("Toggle Action")
            
            break;
            
            
        case .logoutAction:
            
            print("Logout Action")
            break;
            
    }

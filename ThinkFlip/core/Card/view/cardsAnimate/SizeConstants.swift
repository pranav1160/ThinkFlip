//
//  SizeConstants.swift
//  CardTut
//
//  Created by Pranav on 20/03/25.
//


//
//  SizeConstants.swift
//  tinder-clone
//
//  Created by Pranav on 17/03/25.
//

import SwiftUI

struct SizeConstants{
    static var screenCutOff:CGFloat{
        (UIScreen.main.bounds.width/1.5)*0.8
    }
    static var cardHeight:CGFloat{
        UIScreen.main.bounds.height/1.45
    }
    
    static var cardWidth:CGFloat{
        UIScreen.main.bounds.width-20
    }
}

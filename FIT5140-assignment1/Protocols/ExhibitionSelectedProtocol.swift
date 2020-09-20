//
//  ExhibitionSelectedProtocol.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 16/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

//Used to call the method when an exhibition is selected in the exhibition list view
protocol ExhibitionSelectedProtocol:AnyObject {
    func didSelectExhibition(exhibition:Exhibition)
}

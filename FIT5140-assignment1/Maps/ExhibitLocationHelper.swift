//
//  ExhibitLocationHelper.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 4/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import Foundation

func convertExhibitionsToAnnotations(exhibitons:[Exhibition])->[ExhibitsLocationAnnotation]{
    return exhibitons.map{(exhibition) in
        return ExhibitsLocationAnnotation(exhibition: exhibition)
    }
}

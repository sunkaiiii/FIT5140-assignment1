//
//  EditExhibitionViewController.swift
//  FIT5140-assignment1
//
//  Created by sunkai on 19/9/20.
//  Copyright © 2020 sunkai. All rights reserved.
//

import UIKit
import MapKit

class EditExhibitionViewController: UIViewController, ImagePickerDelegate,MKMapViewDelegate {


    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var exhibitionImage: UIImageView!
    @IBOutlet weak var exhibitionName: UITextField!
    @IBOutlet weak var exhibitionDescription: UITextField!
    @IBOutlet weak var searchBlurView: UIVisualEffectView!
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var geofenceSwitch: UISwitch!
    @IBOutlet weak var exhibitionSubtitle: UITextField!
    
    var exhibitionLocationAnnotation:ExhibitsLocationAnnotation?
    var selectedImageUrl:String?
    var imagePicker:ImagePicker?
    var searchLocationDelegateImpl:SearchLocationDelegateImpl?
    
    
    weak var editExhibitionDelegate:EditExhibitionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init widgets
        self.blurView.layer.cornerRadius = 12
        self.searchBlurView.layer.cornerRadius = 12
        self.selectedImageUrl = exhibitionLocationAnnotation?.exhibition?.imageUrl
        self.mapView.delegate = self
        self.exhibitionName.text = exhibitionLocationAnnotation?.exhibition?.name
        self.exhibitionDescription.text = exhibitionLocationAnnotation?.exhibition?.desc
        self.exhibitionSubtitle.text = exhibitionLocationAnnotation?.exhibition?.subtitle
        searchLocationDelegateImpl = SearchLocationDelegateImpl(searchResultView: searchBlurView, searchResultLabel: searchResultLabel)
        self.locationTextField.delegate = searchLocationDelegateImpl
        self.exhibitionName.delegate = self
        self.exhibitionDescription.delegate = self
        self.exhibitionSubtitle.delegate = self
        self.searchResultLabel.isUserInteractionEnabled = true
        self.geofenceSwitch.isOn = exhibitionLocationAnnotation?.exhibition?.isGeoFenced ?? false
        
        //References on https://stackoverflow.com/questions/33658521/how-to-make-a-uilabel-clickable
        self.searchResultLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditExhibitionViewController.onSearchResultClicked)))
        
        
        if let annotation = exhibitionLocationAnnotation{
            mapView.addAnnotation(annotation)
            selectAnnotationAndMoveToZoom(mapView: mapView, annotation: annotation)
            convertCoordinateToCurrentLocation(location: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), completionHandler: {(placemark) in
                if let placemark = placemark{
                    self.locationTextField.text = placemark.getCompatAddress()
                }
            })
        }
        ImageLoader.simpleLoad(selectedImageUrl, imageView: exhibitionImage)
        exhibitionImage.image = exhibitionImage.image?.circleMasked?.addShadow()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func editExhibitionImage(_ sender: Any) {
        if let view = sender as? UIView{
            imagePicker?.present(from: view)
        }
    }
    
    func didSelect(imageUrl: String, image: UIImage?) {
        //after selecta image, this should refresh the annotation and imageview
        if let image = image{
            self.selectedImageUrl = imageUrl
            self.exhibitionImage.image = image.circleMasked?.addShadow()
            if let exhibition = exhibitionLocationAnnotation?.exhibition{
                let newExhibition = generateNewUIExhibitionFromCurrent(desc: exhibition.desc, imageUrl: selectedImageUrl, latitude: exhibition.latitude, longitude: exhibition.longitude, name: exhibition.name, subtitle: exhibition.subtitle, isGeoFenced: exhibition.isGeoFenced, exhibitionPlants: exhibition.exhibitionPlants)
                exhibitionLocationAnnotation?.exhibition = newExhibition
            }
            reloadMapView()
        }
    }
    
    private func reloadMapView(){
        if let annotation = exhibitionLocationAnnotation{
            mapView.removeAnnotation(annotation)
            mapView.addAnnotation(annotation)
            selectAnnotationAndMoveToZoom(mapView: mapView, annotation: annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ExhibitsLocationAnnotation{
            return MapViewHelper.generateCustomAnnotationView(mapView: mapView, annotation: annotation)
        }
        return nil
    }
    
    @objc
    private func onSearchResultClicked(sender:UITapGestureRecognizer){
        self.locationTextField.text = searchResultLabel.text
        self.searchResultLabel.text = ""
        self.searchBlurView.isHidden = true
        if let coordinate = searchLocationDelegateImpl?.location?.location?.coordinate{
            exhibitionLocationAnnotation?.coordinate = coordinate
        }
        reloadMapView()
    }
    
    @IBAction func onSaveChanges(_ sender: Any) {
        if checkValidate() == false{
            return
        }
        guard let text = exhibitionDescription.text, let imageUrl = selectedImageUrl,
              let latitude = exhibitionLocationAnnotation?.coordinate.latitude,
              let longitude = exhibitionLocationAnnotation?.coordinate.longitude,
              let name = exhibitionName.text, let subtite = exhibitionSubtitle.text,
              let plants = exhibitionLocationAnnotation?.exhibition?.exhibitionPlants else {
            showAltert(title: "You need to fill all the fields", message: "Please try again")
            return
        }
        let exhibitionSource = UIExhibitionImpl(desc: text, imageUrl: imageUrl, latitude: latitude, longitude: longitude, name: name, subtitle: subtite, isGeoFenced: geofenceSwitch.isOn, exhibitionPlants: plants)
        if let result = editExhibitionDelegate?.editExhibition(source: exhibitionSource), result == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            showAltert(title: "Update exhibition error", message: "Please try again")
        }
    }
    
    private func generateNewUIExhibitionFromCurrent(desc:String?, imageUrl:String?, latitude:Double, longitude:Double, name:String?,subtitle:String?, isGeoFenced:Bool, exhibitionPlants:[UIPlant])->UIExhibition{
        let exhibitionSource = UIExhibitionImpl(desc: desc, imageUrl: imageUrl, latitude: latitude, longitude: longitude, name: name, subtitle: subtitle, isGeoFenced: isGeoFenced, exhibitionPlants: exhibitionPlants)
        return exhibitionSource
        
    }
    
    private func checkValidate()->Bool{
        if exhibitionName.text?.count == 0{
            showAltert(title: "Exhibition name cannot be empty", message: "please try again")
            return false
        }
        
        if exhibitionDescription.text?.count == 0{
            showAltert(title: "Exhibition Description cannot be empty", message: "please try again")
            return false
        }
        
        if selectedImageUrl == nil || selectedImageUrl?.count == 0{
            showAltert(title: "Exhibition image cannot be empty", message: "Please select a image")
            return false
        }
        
        if exhibitionLocationAnnotation == nil{
            showAltert(title: "Exhibition location is empty", message: "Please select a location")
            return false
        }
        
        if exhibitionSubtitle.text?.count == 0{
            showAltert(title: "Exhibition Subtitle cannot be empty", message: "please try again")
        }
        return true
    }
    
    class SearchLocationDelegateImpl:NSObject,UITextFieldDelegate{
        weak var searchResultView:UIView?
        weak var searchResultLabel:UILabel?
        var location:CLPlacemark?
        init(searchResultView:UIView, searchResultLabel:UILabel) {
            self.searchResultView = searchResultView
            self.searchResultLabel = searchResultLabel
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchResultView?.isHidden = false
            if let address = textField.text, address.count > 0{
                converAddressStringToCoordinate(addressString: address, completionHandler: {(placemark,error) in
                    if error == nil && placemark.count > 0{
                        self.location = placemark[0]
                        self.searchResultLabel?.text = placemark[0].getCompatAddressWithState()
                    }
                })
            }
            
            return textField.resignFirstResponder()
        }
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            searchResultView?.isHidden = true
            searchResultLabel?.text = ""
            return true
        }
    }
}

//
//  ViewController.swift
//  Geofenced-Test
//
//  Created by Nour on 2/21/19.
//  Copyright © 2019 Nour. All rights reserved.
//

import UIKit

import MapKit
import RxSwift
import RxSwiftExt
import RxCocoa
import RxGesture
import RxKeyboard

class HomeViewController: UIViewController, HasDisposeBag {

    let locationManager = CLLocationManager()
    var viewModel: HomeViewModelType!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var radiusTextfield: UITextField!
    @IBOutlet weak var networkTextfield: UITextField!
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = Dependency.resolve(HomeViewModelType.self)!
        self.mapview.showsUserLocation = true
        self.bind()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.setupMapview()
//    }

//    func setupMapview() {
//        if let userLocation = locationManager.location?.coordinate {
//
//            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
//            mapview.setRegion(viewRegion, animated: false)
//        }
//    }
//
    func bind() {
        // 1. avoid keyboard
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak scrollView] height in
                scrollView?.contentInset.bottom = height
            })
            .disposed(by: self.disposeBag)
        
        // 2. tap to hide keyboard
        self.view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak view] (_) in
                view?.endEditing(true)
            })
            .disposed(by: self.disposeBag)
        
        // 3. long tap to pin annotation
        self.mapview.rx.longPressGesture()
            .when(.recognized)
            .subscribe(onNext: { [unowned self] (gesture) in
                let touchpoint = gesture.location(in: self.mapview)
                let newcoords = self.mapview.convert(touchpoint, toCoordinateFrom: self.mapview)
                
                let pin = MKPointAnnotation()
                pin.coordinate = newcoords
                
                self.mapview.removeAnnotations(self.mapview.annotations)
                self.mapview.addAnnotation(pin)
                
                self.viewModel.inputs.update(coords: newcoords)
            })
            .disposed(by: self.disposeBag)
        // initialize map centered to user location
        Observable
            .merge(self.locationManager.rx.location.unwrap(),
                   self.locationManager.rx.didChangeAuthorization
                    .filter { $0.status ==  .authorizedAlways || $0.status == .authorizedWhenInUse }
                    .flatMap { $0.manager.rx.location.unwrap() })
            .take(1)
            .map { $0.coordinate }
            .subscribe(onNext: { [weak mapview] coords in
                let viewRegion = MKCoordinateRegion(center: coords, latitudinalMeters: 2000, longitudinalMeters: 2000) // initial radius value
                mapview?.setRegion(viewRegion, animated: false)
            })
            .disposed(by: self.disposeBag)
        
        // 4. wire vm inputs outputs
        // Inputs
        self.radiusTextfield.rx.text
            .unwrap()
            .asDriver(onErrorJustReturn: "0")
            .drive(onNext: { radius in
                self.viewModel.inputs.update(radius: radius)
            })
            .disposed(by: self.disposeBag)
        
        self.networkTextfield.rx.text.asDriver()
            .drive(onNext: { network in
                self.viewModel.inputs.update(network: network)
            })
            .disposed(by: self.disposeBag)
        // Outputs
        self.viewModel.outputs
            .status
            .drive(self.statusLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.outputs
            .statusColor
            .drive(self.statusLabel.rx.textColor)
            .disposed(by: self.disposeBag)
    }
}


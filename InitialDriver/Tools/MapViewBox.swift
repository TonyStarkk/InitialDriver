//
//  MapViewBox.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 13/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import UIKit
import Mapbox

class MapViewBox: MapView {
    var mapView: MGLMapView
    
    override var centerCoordinate: CLLocationCoordinate2D {
        get {
            return mapView.centerCoordinate
        }
        set {
            mapView.centerCoordinate = newValue
        }
    }
    override init(frame: CGRect) {
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        mapView = MGLMapView(frame: frame, styleURL: url)
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.init(frame: frame)
        mapView.delegate = self
        self.addSubview(mapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setCenter(coordinate: CLLocationCoordinate2D) {
        self.mapView.setCenter(coordinate, zoomLevel: 15.0, animated: true)
    }
}

extension MapViewBox: MGLMapViewDelegate {
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        self.delegate?.isChangingRegion(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        self.delegate?.didChangedRegion(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
    }
}

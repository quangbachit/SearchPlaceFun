//
//  MapViewExtention.swift
//  Search-Bach
//
//  Created by Quang Bach on 4/10/17.
//  Copyright © 2017 QuangBach. All rights reserved.
//

import GoogleMaps


extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
   private func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        let topCenterPoint = self.convert(CGPoint.init(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterPoint)
        return point
    }
    func getRadius() -> CLLocationDistance {
        let centerCordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCordinate.latitude, longitude: centerCordinate.longitude)
        let topCenter = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenter.latitude, longitude: topCenter.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return round(radius)
    }
}

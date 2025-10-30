//
//  MiniGoogleMapView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GoogleMaps
import AlamofireImage


struct CropedGoogleMapView: UIViewRepresentable {

    //MARK: -1.PROPERTY
    var busking: Busking
    var artist: Artist
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: busking.latitude, longitude: busking.longitude, zoom: 17.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        let markerImage = UIImageView()
        if let url = URL(string: artist.artistImage) { markerImage.af.setImage(withURL: url) }
        let customMarker = UIImageView(image: UIImage(named: "markerpin_blue"))
        mapView.setMinZoom(13, maxZoom: 19)
        customMarker.addSubview(markerImage)

        markerImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markerImage.centerXAnchor.constraint(equalTo: customMarker.centerXAnchor),
            markerImage.centerYAnchor.constraint(equalTo: customMarker.centerYAnchor, constant: -UIScreen.getWidth(4)),
            markerImage.widthAnchor.constraint(equalToConstant: UIScreen.getWidth(74)),
            markerImage.heightAnchor.constraint(equalToConstant: UIScreen.getWidth(74))
        ])

        markerImage.center = customMarker.center
        markerImage.contentMode = .scaleToFill
        markerImage.layer.borderColor = UIColor.white.cgColor
        markerImage.layer.borderWidth = UIScreen.getWidth(2)
        markerImage.layer.cornerRadius = 37
        markerImage.layer.masksToBounds = true

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: busking.latitude, longitude: busking.longitude)
        marker.map = mapView
        marker.iconView = customMarker

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}

}


//
//  MapView.swift
//  FilmsApp
//
//  Created by Владимир Царь on 19.11.2025.
//

import UIKit

import UIKit
import YandexMapsMobile

class MapView: UIViewController {
    
    private var viewModel: MapViewModel
    
    private var mapView: YMKMapView!
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    private func setupMap() {
        // Создаем MapView
        mapView = YMKMapView(frame: view.bounds)
        view.addSubview(mapView)
        
        // Настройка constraints если нужно
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Настройка начальной позиции
        let targetLocation = YMKPoint(latitude: 55.751574, longitude: 37.573856) // Москва
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: targetLocation, zoom: 15, azimuth: 0, tilt: 0),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil
        )
        
        // Включаем отображение текущего местоположения
        mapView.mapWindow.map.isFastTapEnabled = true
        mapView.mapWindow.map.isRotateGesturesEnabled = true
    }
}

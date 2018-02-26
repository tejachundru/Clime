//
//  ByLocationVC.swift
//  Clime
//
//  Created by Teja on 2/24/18.
//  Copyright © 2018 Teja. All rights reserved.
//

import UIKit
import CoreLocation


class ByLocationVC: UIViewController, CLLocationManagerDelegate {
    
    //Climate Details That are To Updated
    
//    struct climateDetails
//    {
//        var temp = 0
//        var description = ""
//        var speed = 0
//        var name = ""
//
//    }
    
    
    
    struct userDetails {
        
    }
    
    
    
    // Some Important variable Needed
    let appId = "46df8e428c6e96c3f0bca5da94e7af7d"
    let deviceLocation = CLLocationManager() //Location Manager
    
    //Coordinates
    var devicelatitude = 0.0
    var devicelongitude = 0.0
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationUpdation() //For Updating Current Location
        
    }
    

    func locationUpdation()
    {
        deviceLocation.delegate = self
        deviceLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters
        deviceLocation.requestWhenInUseAuthorization()
        deviceLocation.startUpdatingLocation()
    }

    //
    func updateClimateDetails()
    {
        /*
         Format For the Url OPEN WEATHER API
        http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=46df8e428c6e96c3f0bca5da94e7af7d
 
        */
        let climateURLString = "http://api.openweathermap.org/data/2.5/weather?lat=\(devicelatitude)&lon=\(devicelongitude)&appid=\(appId)"
        //latitude And longitude Are Added , Appid is Api Key of openWeather
        let climateURL = URL(string: climateURLString)
        
        
        URLSession.shared.dataTask(with: climateURL!)
        {
            //Completion Clousure
            (data, reponse, error) in
            
            print("The Data \n\(String(describing: data))")
            print("The Response is \(String(describing: reponse))")
            print(" The Error is \(String(describing: error))")
            
            
        }.resume()
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Location Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let inputLocationArray = locations[locations.count-1]
        if inputLocationArray.horizontalAccuracy > 0
        {
            print("latitude Is \(inputLocationArray.coordinate.latitude)")
            print("longitude Is \(inputLocationArray.coordinate.longitude)")
                
            devicelatitude = inputLocationArray.coordinate.latitude
            devicelongitude = inputLocationArray.coordinate.longitude
            deviceLocation.stopUpdatingLocation() //Location updation Stops
            
            //Calling The Climate To Update as Coordinates are determined
            updateClimateDetails()
        }
      
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location unavaliable error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

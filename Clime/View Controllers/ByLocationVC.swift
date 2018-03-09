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
    
    //UI Elements
    
    @IBOutlet weak var climateActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    
    
    
        var temperature:CGFloat = 0.0
        var weatherDescription = ""
        var windSpeed:Double = 0
        var placeName = ""

   
    
    // Some Important variable Needed
    let appId = "46df8e428c6e96c3f0bca5da94e7af7d"
    var deviceLocation = CLLocationManager() //Location Manager
    
    //Coordinates
    var devicelatitude = 0.0
    var devicelongitude = 0.0
    var buttonframe:CGRect?
    
   
    @IBOutlet weak var climateByLocationBtn: UIButton!
    
    @IBAction func climateByLocationClicked(_ sender: Any)
    {
        
        self.buttonframe = self.climateByLocationBtn.frame
        UIView.animate(withDuration: 0.7, animations:
            
        {
            self.climateByLocationBtn.frame = self.view.frame
        })
        { (compltedAnimaton) in
            
            let ByLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "BySearchVC") as! BySearchVC
            self.navigationController?.pushViewController(ByLocationVC, animated: false)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
        self.climateByLocationBtn.frame = self.buttonframe!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationUpdation() //For Updating Current Location
        //climateActivity.stopAnimating()
        climateActivity.startAnimating()
        deviceLocation.delegate = self
    }
    
    func updateUI(){
        DispatchQueue.main.async {
            
            self.climateActivity.stopAnimating()
            self.temperatureLabel.text = "\(Int(self.temperature))"
            self.descriptionLabel.text = self.weatherDescription.capitalized
            self.windLabel.text = "\(self.windSpeed)"
            self.locationLabel.text = self.placeName.capitalized
        }
        
    }

    func locationUpdation()
    {
        deviceLocation.delegate = self
        deviceLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters
        deviceLocation.requestWhenInUseAuthorization()
        deviceLocation.startUpdatingLocation()
    }

    func updateClimateDetails()
    {
        /*
         Format For the Url OPEN WEATHER API
        http://api.openweathermap.org/data/2.5/weather?lat=17.450404&lon=78.387166&appid=46df8e428c6e96c3f0bca5da94e7af7d
        */
        let climateURLString = "http://api.openweathermap.org/data/2.5/weather?lat=\(devicelatitude)&lon=\(devicelongitude)&appid=\(appId)"
        //latitude And longitude Are Added , Appid is Api Key of openWeather
        let climateURL = URL(string: climateURLString)
      
        URLSession.shared.dataTask(with: climateURL!)
        {
            //Completion Clousure
            (data, reponse, error) in
            
            do{
                let dataDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                //print(dataDict)
                //For Present Temperature
                let tempDetailsDict:[String:CGFloat] = dataDict["main"] as! [String : CGFloat]
                //print(tempDetailsDict)
                //Herw Temp Details Dict is ---->  ["humidity": 39.0, "temp_min": 301.15, "temp_max": 302.15, "temp": 301.63, "pressure": 1017.0]
                
                // MARK: - temperature
                var placeTemperature:CGFloat = tempDetailsDict["temp"]!
                //This is in Kelvin So Conversion Needed To Celsius
                // Celsius  = kelvinTemp - 273.15
                //so
                placeTemperature = placeTemperature - 273.15
                print(placeTemperature)
                
                // MARK: - Place
                //For Place
                let place:String = dataDict["name"] as! String
                print(place)
                
                // MARK: - weather Description
                //For weather Description
                //This is Array Of Dict
                let weatherArry = dataDict["weather"] as! [[String:Any]]
                //print(weatherArry)
                let weatherDict = weatherArry[0]
                let description = weatherDict["description"] as! String
                print(description)
                
                // MARK: - windspeed
                //For Wind Speed
                let windArry = dataDict["wind"] as! [String:Double]
                let speed:Double = windArry["speed"]!
                print(speed)
                //For U
                self.temperature = placeTemperature
                self.weatherDescription = description
                self.windSpeed = speed
                self.placeName = place
                self.updateUI()
                
            }catch{
                        print("Incoming data Error")
            }
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
            deviceLocation.delegate = nil
            //Calling The Climate To Update as Coordinates are determined
            updateClimateDetails()
        }
      
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location unavaliable error")
        locationLabel.text = "Location Unavaliable"
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

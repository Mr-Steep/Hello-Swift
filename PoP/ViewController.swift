//
//  ViewController.swift
//  PoP
//
//  Created by YurevichVasili on 3/30/20.
//  Copyright © 2020 YurevichVasili. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class ViewController: UIViewController {


    @IBOutlet weak var SpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var HumunutyLabel: UILabel!
    @IBOutlet weak var levSeaLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var DescreptionLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    
   
    
let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
    }
}

extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            let urlSTR = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&lang=ru&appid=ec83e822cfb2fec39b54fad239285f9d"
        let url = URL(string: urlSTR)
          
        var temperature: Double?
        var name: String?
        var lspeed:Double?
        var lhumidity: Int?
        var lpressure: Double?
        var lsea_level: Double?
        var lmintemp: Double?
        var lmaxtemp: Double?
        var lsunset: Double?
        var lsunrise: Double?
        var namenlsns : Date?
        var namesuan: Date?
            var ssRise: String?
            var ssSet: String?
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                    name = (json["name"] as? String)!

                if let sys = json["sys"] {
                    lsunset = sys["sunset"] as? Double
                    lsunrise = sys["sunrise"] as? Double
                    namesuan = Date (timeIntervalSince1970: lsunrise!)
                    namenlsns =  Date(timeIntervalSince1970: lsunset!)
                     
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let myString = formatter.string(from: namesuan!)
           let yourDate = formatter.date(from: myString)
           formatter.dateFormat = "HH:mm:ss"
           ssRise = formatter.string(from: yourDate!)
                    let mytring = formatter.string(from: namenlsns!)
                    let yurDate = formatter.date(from: mytring)
                    formatter.dateFormat = "HH:mm:ss"
                    ssSet = formatter.string(from: yurDate!)
                }
                
                if let list = json["main"] {
                    temperature = list["temp"] as? Double
                    lmintemp = list["temp_min"] as? Double
                    lmaxtemp = list["temp_max"] as? Double
                    lhumidity = list["humidity"] as? Int
                    lpressure = list["pressure"] as? Double
                    lsea_level = list["sea_level"] as? Double
                }
//
                if let wind = json["wind"] {
                 lspeed = wind["speed"] as? Double
                }
//
//
             

                DispatchQueue.main.async {
                    self?.CityLabel.text = name
                    self?.TemperatureLabel.text = "\(round(temperature! - 273.15)*1)" + " º"
                    self?.sunriseLabel.text = ssRise
                    self?.sunsetLabel.text = ssSet
                    self?.maxTempLabel.text = "\(round(lmaxtemp! - 273.15)*1)"
                    self?.minTempLabel.text = "\(round(lmintemp! - 273.15)*1)"
                    self?.HumunutyLabel.text = "\(lhumidity!)" + " %"
                    self?.pressureLabel.text = "\(lpressure!)"
                    self?.SpeedLabel.text = "\(lspeed!)"
                    self?.levSeaLabel.text = "\(lsea_level)"
                    
                }
            }
            catch let jsonError {
                print(jsonError )
            }

                }
        task.resume()
    }
}
}


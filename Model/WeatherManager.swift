
import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didTypeWithError(error: Error)
}


struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=791c78ca0759d65f4d7ac010ed7340ed&units=metric"
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String){
        
//       let urlString = "\(weatherURL)&q=\(cityName)"
//        perfomRequiest(with: urlString)
        let urlString = ("\(weatherURL)&q=\(cityName)")
        perfomRequiest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        perfomRequiest(with: urlString)
    }
    
    
    func perfomRequiest(with urlStrimg: String){
        
        if let url = URL(string: urlStrimg) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didTypeWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let parseData = parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather: parseData)
                    }
                }
            }
            task.resume()
        }
    }
    

    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do{
            let decodData = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionId = decodData.weather[0].id
            let cityName = decodData.name
            let temp = decodData.main.temp
            
            let weather = WeatherModel(conditionId: conditionId, cityName: cityName, temperature: temp)
            return weather
        }
        catch {
            delegate?.didTypeWithError(error: error)
            return nil
            }
        
    }
}

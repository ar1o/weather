//
//  XMLParser.swift - This file parses XML data retrived from Environment Canadas website.
//  Temperatures, location and current forecast data is parsed for the main weather application
//  and the details view here.
//
//  This file is a singleton.
//
//  Created by Ario K on 2016-02-17.
//  Copyright © 2016 Ario K. All rights reserved.
//

import Foundation


// 7 day forecast data structure
struct main_forecast {
    var city: String
    var forecast: String
    var day: String
    var temp: String
    var image: String
}

// Parsed XML title data structure
struct title {
    var title: String
}

// Parsed XML summary data structure
struct summary {
    var description: String
}

// Parsed XMl entry data structure
struct entry {
    var title: String
    var summary: String
}


class XMLParser: NSObject, NSXMLParserDelegate {
    //Singleton class
    static let xml = XMLParser()
    //XML parser class
    var xmlParser: NSXMLParser!
    //This is used to store the content of a tag until the end tag is called
    var elementValue: String?
    // Store unparsed title data here
    var weatherInfo: title!
    // Store unparsed summary data here
    var summaryInfo: summary!
    // Store title data for parsing
    var titles = [String]()
    // Store summaries for parsing
    var summaries = [String]()
    // Dictionary of entry tags for the detail view
    var entryInfo = [String:entry]()
    // Queried details info from the entryInfo data structure
    var detailsInfo = [String]()
    // Dictionary of forecasts
    var forecastInfo = [Int:main_forecast]()
    // Forecast summary data for main view display
    var forecastSummary = [String]()
    // Count the amount of title entries for discrepencies
    var count = 0
    // Parsed current weather info for main view display
    var currWeather = [String]()
    // Parsed current weather summary info for detail view display
    var currWeatherSummary = [String]()
    // Dictionary of locations added in location view
    var myLocations = [Int:cityInfo]()
    // Keep tabs on the locations added with this index
    var index = 0
    
    override init() {
        super.init()
        //no init atm
    }
    
    // This function is for getting data when in the location list view
    func configureParsing(given_url: String,city: String, province: String) {
        titles.removeAll()
        currWeather.removeAll()
        forecastInfo.removeAll()
        summaries.removeAll()
        
        let url = NSURL(string: given_url)
        self.xmlParser = NSXMLParser(contentsOfURL: url!)
        self.xmlParser.delegate = self
        self.xmlParser!.parse()
        
        configureForecast(city)
        
        let temp = configureDataStructure(titles[2],
            pattern:"^(Current Conditions:\\s)(\\w*\\s*\\w*)(,*)(\\s*)(\\-*[0-9]+(\\.[0-9][0-9]?)?°C)$",position:"$5")
        let cond = configureDataStructure(titles[3],
            pattern:"^(\\w+\\s*\\w*:\\s)((\\w+\\s*)+)(.)(\\s)(\\w+\\s*)+([0-9]+)(.)*$",position:"$2")
        let loc = city
        currWeather.append(loc)
        currWeather.append(cond)
        currWeather.append(temp)
        currWeather.append(defineForecastImage(cond))
        myLocations[index] = cityInfo(province: province, city: city, link: given_url)
        index++
    }
    // This function is for getting data when in the location view
    func getData(given_url: String,city: String, province: String) {
        titles.removeAll()
        currWeather.removeAll()
        forecastInfo.removeAll()
        summaries.removeAll()
        
        let url = NSURL(string: given_url)
        self.xmlParser = NSXMLParser(contentsOfURL: url!)
        self.xmlParser.delegate = self
        self.xmlParser!.parse()
        
        configureForecast(city)
        
        let temp = configureDataStructure(titles[2],
            pattern:"^(Current Conditions:\\s)(\\w*\\s*\\w*)(,*)(\\s*)(\\-*[0-9]+(\\.[0-9][0-9]?)?°C)$",position:"$5")
        let cond = configureDataStructure(titles[3],
            pattern:"^(\\w+\\s*\\w*:\\s)((\\w+\\s*)+)(.)(\\s)(\\w+\\s*)+(([0-9]+)*)(.)*$",position:"$2")
        let loc = city
        currWeather.append(loc)
        currWeather.append(cond)
        currWeather.append(temp)
        currWeather.append(defineForecastImage(cond))
//        print(currWeather)
    }
    // Get the current forecast summary
    func getCurrentSummary() -> [String] {
        var currSummary = [String]()
        for var i = 0; i < 3; i++ {
            currSummary.append(summaries[i])
        }
        return currSummary
    }
    
    // Set the forecast summary for a specific day
    func defineForecastSummary(day: String) {
        forecastSummary.removeAll()
        if entryInfo["\(day) night"] == nil {
            forecastSummary.append("Could not retrieve data for \(day) night")
        } else {
            forecastSummary.append(entryInfo["\(day) night"]!.summary)
        }
        forecastSummary.append(entryInfo[day]!.summary)
        //forecastSummary.append(entryInfo["\(day) night"]!.summary)
    }
    
    // Get the forecast summary for a specific day
    func getForecastSummary() -> [String] {
        return forecastSummary
    }
    // Get the main current forecast array
    func getArray(main_array: [String]) -> [String] {
        return main_array
    }
    // Set details information for the view
    func setDetails(details: [String]) {
        detailsInfo.removeAll()
        detailsInfo = details
    }
    // Get the details information for the view
    func getDetailsInfo() -> [String] {
        return detailsInfo
    }
    // Get the locations added
    func getMyLocations(myLocation: [Int:cityInfo]) ->  [Int:cityInfo] {
        return myLocation
    }
    
    // Generic regular expression parsing for all forecast data
    func configureDataStructure(forecast: String, pattern: String, position: String) -> String {
        var result = ""
        do {
            let string = forecast
            let regex = try NSRegularExpression(pattern:  pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
            result = regex.stringByReplacingMatchesInString(string, options: [], range: NSRange(location:0,
                length:string.characters.count), withTemplate: position)
        } catch {
            print(error)
        }
        return result
    }
    
    // XML parser function
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        //Reset the elementValue property to an empty string to store the content of the newly started tag
        self.elementValue = "";
        
        if elementName == "title" {
            self.weatherInfo = title(title: "N/A")
        }
        if elementName == "summary" {
            self.summaryInfo = summary(description: "N/A")
        }
        if elementName == "entry" {
        }
        
    }
    
    // XML parser function
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "title" {
            if self.weatherInfo != nil {
                self.weatherInfo.title = self.elementValue!
                titles.append(self.weatherInfo.title)
                count++
            }
        } else if elementName == "summary" {
            if self.summaryInfo != nil {
                self.summaryInfo.description = self.elementValue!
                summaries.append(self.summaryInfo.description)
            }
        }
        else if elementName == "entry" {
            let day = configureDataStructure(self.weatherInfo.title,
                pattern:"^(\\w+\\s*\\w*)(:\\s)((\\w+\\s*)+)(.)(\\s)(\\w+\\s*)+([0-9]+|zero)(.)*$",position:"$1")
            entryInfo[day] = entry(title: self.weatherInfo.title, summary: self.summaryInfo.description)
            
        }
    }
    
    // XML parser function
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        //append characters to self.elementValue
        self.elementValue? += string
        
        
    }
    
    // Parse the entire data into forecastInfo data structure based on days of the week.
    func configureForecast(city: String) {
//        print(titles.count)
//        print(titles)
        var weekday_count = 0
        for var i = 4; i < titles.count; i++ {
            
            let day = configureDataStructure(titles[i],
                pattern:"^(\\w+)(:\\s)((\\w+\\s*)+)(.)(\\s)(\\w+\\s*)+([0-9]+|zero)(.)*$",position:"$1")
            let temp = configureDataStructure(titles[i],
                pattern:"^(\\w+\\s*\\w*:\\s)(\\w+\\s*)+(.)(\\s)((\\w+\\s*)+([0-9]+|zero))(.)*$",position:"$5")
            let forecast = configureDataStructure(titles[i],
                pattern:"^(\\w+\\s*\\w*:\\s)((\\w+\\s*)+)(.)(\\s)((\\w+\\s*)+([0-9]+|zero))(.)*$",position:"$2")
            
            var final_temp = ""
            switch day {
            case "Monday":
                let affinity = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$3")
                let digit = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$5")
                
                if affinity == "plus" {
                    final_temp = digit
                } else if affinity == "minus" {
                    final_temp = "-\(digit)"
                } else {
                    if digit == "zero" {
                        final_temp = "0"
                    } else {
                        final_temp = digit
                    }
                }
                forecastInfo[weekday_count] = main_forecast(city: city, forecast: forecast, day: day, temp: final_temp, image: defineForecastImage(forecast))
                weekday_count++
            case "Tuesday":
                let affinity = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$3")
                let digit = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$5")
                
                if affinity == "plus" {
                    final_temp = digit
                } else if affinity == "minus" {
                    final_temp = "-\(digit)"
                } else {
                    if digit == "zero" {
                        final_temp = "0"
                    } else {
                        final_temp = digit
                    }
                }
                forecastInfo[weekday_count] = main_forecast(city: city, forecast: forecast, day: day, temp: final_temp, image: defineForecastImage(forecast))
                weekday_count++
            case "Wednesday":
                let affinity = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$3")
                let digit = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$5")
                
                if affinity == "plus" {
                    final_temp = digit
                } else if affinity == "minus" {
                    final_temp = "-\(digit)"
                } else {
                    if digit == "zero" {
                        final_temp = "0"
                    } else {
                        final_temp = digit
                    }
                }
                forecastInfo[weekday_count] = main_forecast(city: city, forecast: forecast, day: day, temp: final_temp, image: defineForecastImage(forecast))
                weekday_count++
            case "Thursday":
                let affinity = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$3")
                let digit = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$5")
                
                if affinity == "plus" {
                    final_temp = digit
                } else if affinity == "minus" {
                    final_temp = "-\(digit)"
                } else {
                    if digit == "zero" {
                        final_temp = "0"
                    } else {
                        final_temp = digit
                    }
                }
                forecastInfo[weekday_count] = main_forecast(city: city, forecast: forecast, day: day, temp: final_temp, image: defineForecastImage(forecast))
                weekday_count++
            case "Friday":
                let affinity = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$3")
                let digit = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$5")
                
                if affinity == "plus" {
                    final_temp = digit
                } else if affinity == "minus" {
                    final_temp = "-\(digit)"
                } else {
                    if digit == "zero" {
                        final_temp = "0"
                    } else {
                        final_temp = digit
                    }
                }
                forecastInfo[weekday_count] = main_forecast(city: city, forecast: forecast, day: day, temp: final_temp, image: defineForecastImage(forecast))
                weekday_count++
            case "Saturday":
                
                let affinity = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$3")
                let digit = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$5")
                
                if affinity == "plus" {
                    final_temp = digit
                } else if affinity == "minus" {
                    final_temp = "-\(digit)"
                } else {
                    if digit == "zero" {
                        final_temp = "0"
                    } else {
                        final_temp = digit
                    }
                }
                forecastInfo[weekday_count] = main_forecast(city: city, forecast: forecast, day: day, temp: final_temp, image: defineForecastImage(forecast))
                weekday_count++
            case "Sunday":
                let affinity = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$3")
                let digit = configureDataStructure(temp,
                    pattern:"^(High|Low)(\\s)(plus|minus)*(\\s)*([0-9]+|zero)$",position:"$5")
                
                if affinity == "plus" {
                    final_temp = digit
                } else if affinity == "minus" {
                    final_temp = "-\(digit)"
                } else {
                    final_temp = digit
                }
                
                forecastInfo[weekday_count] = main_forecast(city: city, forecast: forecast, day: day, temp: final_temp, image: defineForecastImage(forecast))
                weekday_count++
            default:
                print(" ")
            }
            
        }
    }
    
    // Forecast definition to image conversions
    func defineForecastImage(forecast:String) -> String {
        switch forecast {
        case "A mix of sun and cloud":
            return "partly_cloudy"
        case "Sunny":
            return "sun"
        case "Mainly Sunny":
            return "sun"
        case "Cloudy":
            return "cloud"
        case "Chance of showers":
            return "rain"
        case "Chance of flurries":
            return "snow"
        case "Chance of wet flurries":
            return "rain_snow_mix"
        case "A mix of sun and cloud":
            return "partly_cloudy"
        case "Periods of rain":
            return "rain"
        case "Chance of flurries or rain showers":
            return "rain_snow_partly_cloudy"
        case "Flurries":
            return "snow"
        case "Clearing":
            return "partly_cloudy"
        case "Periods of rain or snow":
            return "rain_snow_partly_cloudy_mix"
        case "Rain":
            return "rain"
        case "Periods of snow":
            return "snow"
        case "Rain or snow":
            return "rain_snow_mix"
        case "Snow or rain":
            return "rain_snow_mix"
        case "Snow":
            return "snow"
        case "Increasing cloudiness":
            return "cloud"
        case "A few clouds":
            return "partly_cloudy"
        case "Chance of rain showers or flurries":
            return "rain_snow_partly_cloudy_mix"
        case "Chance of wet flurries or rain showers":
            return "freezning_rain_snow_mix"
        default:
            return "sun"
        }
    }
    
    
}
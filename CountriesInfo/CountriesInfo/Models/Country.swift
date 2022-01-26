//
//  Country.swift
//  CountriesInfo
//
//  Created by Leonardo  on 25/01/22.
//

import UIKit

class Country: Codable {
  var name: String
  var capital: String
  var population: Int
  var currency: String
  var flag: URL
  var area_km: Int

  init(name: String, capital: String, population: Int, currency: String, flag: URL, area_km: Int) {
    self.name = name
    self.capital = capital
    self.population = population
    self.currency = currency
    self.flag = flag
    self.area_km = area_km
  }
}

class Countries: Codable {
  var countries: [Country]

  init(countries: [Country]) {
    self.countries = countries
  }

  init() {
    self.countries = Local.loadJSON(file: "countries.json").countries
  }
}

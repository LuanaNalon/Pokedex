//
//  Pokemon.swift
//  Pokedex
//
//  Created by Luana Nalon on 13/05/2021.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _defense: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var defense: String {
        if _defense == nil {
            _defense = ""
            }
        return _defense
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }

    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        AF.request(_pokemonURL).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let dict = value as? Dictionary<String, AnyObject> {
                    
                    if let weight = dict["weight"] as? Int {
                        self._weight = "\(weight)"
                    }
                    if let height = dict["height"] as? Int {
                        self._height = "\(height)"
                    }
                    
                    if let types = dict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
                        
                        if let type = types[0]["type"] {
                            
                            if let name = type["name"] {
                                
                                self._type = (name as? String)?.capitalized
                                
                            }
                            if types.count > 1 {
                                for x in 1..<types.count {
                                    
                                    if let type = types[x]["type"] {
                                        
                                        if let name = type["name"] as? String{
                                            
                                            self._type! += "/\(name.capitalized)"
                                        }
                                    }
                                }
                            }
                            
                        }
                    } else {
                        
                        self._type = ""
                        
                    }
                    if let dictStats = dict["stats"] as? [Dictionary<String, AnyObject>], dictStats.count > 0 {
                        if let attack = dictStats[1]["base_stat"] as? Int {
                            self._attack = "\(attack)"
                        }
                        if let defense = dictStats[2]["base_stat"] as? Int {
                            self._defense = "\(defense)"
                        }
                    }
                    if let descArr = dict["species"] as? Dictionary<String, String>, descArr.count > 0 {
                        if let url = descArr["url"] {
                            AF.request(url).responseJSON { (response) in
                                switch response.result {
                                case .success(let value):
                                    if let descDict = value as? Dictionary<String, AnyObject>, descDict.count > 0 {
                                        
                                      if let descDict_values = descDict["flavor_text_entries"] as? [Dictionary<String, AnyObject>], descDict_values.count > 0 {
                                        
                                            if let description = descDict_values[0]["flavor_text"] as? String {
                                                let newDrescription = description.replacingOccurrences(of: "POKéMON", with: "Pokemon")
                                                self._description = newDrescription
                                            }
                                       }
                                        if let evoChainDict = descDict["evolution_chain"] as? Dictionary<String, String> {
                                            if let evoChainURL = evoChainDict["url"] {
                                                AF.request(evoChainURL).responseJSON { (response) in
                                                    switch response.result {
                                                    case .success(let value):
                                                        if let dictChainRoot = value as? Dictionary<String, AnyObject>, dictChainRoot.count > 0 {
                                                            if let dictChain = dictChainRoot["chain"] as? Dictionary<String, AnyObject>, dictChain.count > 0 {
                                                                if let dictEnvolvesTo = dictChain["evolves_to"] as? [Dictionary<String, AnyObject>], dictEnvolvesTo.count > 0 {
                                                                    if let dictEnvolves_to = dictEnvolvesTo[0]["evolves_to"] as? [Dictionary<String, AnyObject>], dictEnvolves_to.count > 0 {
                                                                        if let dictEvolution_details = dictEnvolves_to[0]["evolution_details"] as? [Dictionary<String, AnyObject>] {
                                                                            if let lvlExist = dictEvolution_details[0]["min_level"] {
                                                                                if let lvl = lvlExist as? Int {
                                                                                    self._nextEvolutionLevel = "\(lvl)"
                                                                                } else {
                                                                                    self._nextEvolutionLevel = ""
                                                                                }
                                                                            }
                                                                        }
                                                                        if let dictSpecies = dictEnvolves_to[0]["species"] as? Dictionary<String, String> {
                                                                            if let nextEvolName = dictSpecies["name"] {
                                                                                self._nextEvolutionName = nextEvolName.capitalized
                                                                            }
                                                                            if let nextEvolLevelURL = dictSpecies["url"] {
                                                                                let newStr = nextEvolLevelURL.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                                                let nextEvolId = newStr.replacingOccurrences(of: "/", with: "")
                                                                                self._nextEvolutionId = nextEvolId
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            completed()
                                                        }
                                                    case .failure(let error):
                                                        print(error)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        completed()
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        } else {
                            self._description = ""
                        }
                    }
                    completed()
                    
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
}

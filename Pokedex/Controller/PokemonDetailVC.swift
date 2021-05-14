//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Luana Nalon on 14/05/2021.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
        
        }
    

}

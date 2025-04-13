//
//  ViewController.swift
//  PlantyApp
//
//  Created by Beyza Olgunsoy on 13.04.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Planty"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "navBarColor")
        appearance.titleTextAttributes = [.font: UIFont(name: "K2D-Bold", size: 20)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}


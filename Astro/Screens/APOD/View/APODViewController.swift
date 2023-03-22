//
//  ViewController.swift
//  Astro
//
//  Created by Ganesh TR on 20/03/23.
//

import UIKit

class APODViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var viewModel: APODViewModel!
    
    static func create(with viewModel: APODViewModel) -> APODViewController {
        let view = APODViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchAPOD { apod in
            self.title = apod.date
            self.titleLabel.text = apod.title
            self.descriptionLabel.text = apod.explanation
            let url = URL(string: apod.url)
            let data = try? Data(contentsOf: url!)
            self.imageView.image = UIImage(data: data!)
        }
        // Do any additional setup after loading the view.
    }


}


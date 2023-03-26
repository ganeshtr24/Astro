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
        viewModel.aPod.observe(on: self) { [weak self] _ in
            self?.updateViews()
        }
        viewModel.fetchAPOD()
        // Do any additional setup after loading the view.
    }

    func updateViews() {
        self.title = viewModel.date
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.explanation
        if let url = viewModel.url {
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            self.imageView.image = UIImage(data: data!)
        }
    }
}


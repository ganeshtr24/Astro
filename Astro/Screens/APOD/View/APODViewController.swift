//
//  ViewController.swift
//  Astro
//
//  Created by Ganesh TR on 20/03/23.
//

import UIKit

class APODViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var errorLabel: UILabel!
    
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
        viewModel.aPodImage.observe(on: self) { [weak self] image in
            self?.updateViews()
        }
        viewModel.error.observe(on: self) { [weak self] error in
            self?.errorLabel.text = error
        }
        viewModel.fetchAPOD()
        // Do any additional setup after loading the view.
    }

    func updateViews() {
        self.title = viewModel.date
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.explanation
        self.imageView.image = viewModel.image
    }
}


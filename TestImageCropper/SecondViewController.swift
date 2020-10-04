//
//  SecondViewController.swift
//  TestImageCropper
//
//  Created by Sakurako Shimbori on 2020/10/05.
//

import UIKit

class SecondViewController: UIViewController {
    
    var captureImage:UIImage!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = captureImage
    }
}

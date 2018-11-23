//
//  InfoViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/16/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "HackerNews"
        
        textView.text = "HackerNews is a simple and fast reader for hacker stories, articles and comments.\n\nDon't like it? Great! This app is completely Open Source. You can change and adjust it as you want. Code on GitHub: https://github.com/nazavrik/HackerNews \n\nIf you have any questions or recommendations, please feel free to contact me: nazavrik@gmail.com."
    }
}

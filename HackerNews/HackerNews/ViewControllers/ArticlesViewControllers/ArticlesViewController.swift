//
//  ArticlesViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var displayData: ArticlesDisplayData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Articles"
        
        displayData =  ArticlesDisplayData(viewController: self)
        
        tableView.registerNibs(from: displayData)
        
        let request = Article.Requests.articleIds
        Server.standard.request(request) { array, error in
            if let articleIds = array?.items {
                
                //var articles = [Article]()
                for articleId in articleIds {
                    let request = Article.Requests.article(for: articleId)
                    Server.standard.request(request, completion: { article, error in
                        if let article = article {
                            //articles.append(article)
                            self.displayData.add(article: article)
                        }
                    })
                }
            }
        }
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = displayData.model(for: indexPath)
        return tableView.dequeueReusableCell(for: indexPath, with: model)
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return displayData.height(for: indexPath)
    }
}

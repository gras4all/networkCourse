//
//  FeedViewController+UITableView.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 29.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = feedTable.dequeueReusableCell(withIdentifier: String(describing: FeedCell.self)) as! FeedCell
         cell.setPost(post: posts[indexPath.row])
         cell.delegate = self
         return cell
     }

}

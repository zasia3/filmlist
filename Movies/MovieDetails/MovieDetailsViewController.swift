//
//  MovieDetails.swift
//  Movies
//
//  Created by Joanna Zatorska on 19/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import UIKit
import Models

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var bottomScoreLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    var movieDetails: MovieDetails?
    @IBOutlet weak var synopsisView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var peopleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        titleLabel.text = movieDetails?.title
        yearLabel.text = movieDetails?.year
        categoriesLabel.text = movieDetails?.genre
        durationLabel.text = movieDetails?.duration
        scoreLabel.text = movieDetails?.rating
        plotLabel.text = movieDetails?.plot
        bottomScoreLabel.text = """
            Score
            \(movieDetails?.rating ?? "")
            """
        reviewsLabel.text = """
            Reviews
            \(movieDetails?.votes ?? "")
            """
        popularityLabel.text = """
            Popularity
            \(movieDetails?.popularity ?? "")
            """
        directorLabel.text = movieDetails?.director
        writerLabel.text = movieDetails?.writer
        actorsLabel.text = movieDetails?.actors
    }
}

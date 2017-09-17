//
//  Student.swift
//  RateMyStudentDB
//
//  Created by Amnuay M on 9/11/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit

class Student: NSObject {
    var StudentName : String
    var StudentRatingScore : Int
    var StudentImage : UIImage
    
    override init() {
        self.StudentName = ""
        self.StudentRatingScore = 0
        self.StudentImage = UIImage()
    }
    
    
    init(StudentName : String, StudentRatingScore : Int, StudentImage : UIImage){
        self.StudentName = StudentName
        self.StudentRatingScore = StudentRatingScore
        self.StudentImage = StudentImage
    }
    
    func resetRatingScore() -> Void {
        self.StudentRatingScore = 0
    }
    
    func addRatingScore(ratingScore : Int) -> Void {
        self.StudentRatingScore += ratingScore
    }
    
    func minusRatingScore(ratingScore : Int) -> Void{
        self.StudentRatingScore -= ratingScore
    }
}

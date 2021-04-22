//
//  ContentModel.swift
//  LearningApp
//
//  Created by Roxy Mardare on 06.04.2021.
//

import Foundation

class ContentModel: ObservableObject {
    
    //List of modules
    @Published var modules =  [Module]()
    
    //Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    //Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    //Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    //Current lesson explanation
    @Published var codeText = NSAttributedString()
    
    //Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    var styleData: Data?
    
    init (){
        
        getLocalData()
    }
    
    //MARK: Data methods
    func getLocalData (){
        
        //Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do{
            //Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            //Decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            //Assign parsed modules to modules property
            self.modules = modules
        }
        catch{
            //TODO log error
            print("Couldn't parse local data")
        }
       
        //Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        do{
            let styleData = try Data(contentsOf: styleUrl!)
            self.styleData = styleData
        }
        catch{
            print ("Couldn't parse style data")
        }
    }
    
    //MARK: Module navigation methods
    func beginModule(_ moduleId:Int){
       
        //Find the index for the module ID
        for index in 0..<modules.count{
            
            if modules[index].id == moduleId{
                
                //Found the matching module
                currentModuleIndex = index
                break
            }
        }
        //Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    //MARK: Lesson Navigation
    func beginLesson(_ lessonIndex:Int){
        
        //Check that the lesson index is in the range of module lessons
        if lessonIndex < currentModule!.content.lessons.count{
            currentLessonIndex = lessonIndex
        }
        else{
            currentLessonIndex = 0
        }
        //Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson (){
        
        //Advance the lesson index
        currentLessonIndex += 1
       
        //Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            //Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)        }
        else {
            
            //Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool{
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
   
    func beginTest (_ moduleId:Int){
        
        //Set the current module
        beginModule(moduleId)
        
        //Set the current question
        currentQuestionIndex = 0
        
        //If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            //Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion (){
        
        //Advance the question index
        currentQuestionIndex += 1
        
        //Check that it's between the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count{
            
            //Set the current questions
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else{
            //If not, reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
    
    //MARK: Code styling
    private func addStyling(_ htmlString:String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        //Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        //Add the html data
        data.append(Data(htmlString.utf8))
        
        //Convert to attributed string
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                
               resultString = attributedString
            }
        
        return resultString
    }
}

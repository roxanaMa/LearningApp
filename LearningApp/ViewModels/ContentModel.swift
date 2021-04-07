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
    
}

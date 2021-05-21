//
//  TestView.swift
//  LearningApp
//
//  Created by Roxy Mardare on 20.04.2021.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var selectedAnswerIndex: Int?
    @State var submitted = false
    
    @State var numCorrect = 0
    @State var showResults = false
    
    var body: some View {
        
        if model.currentQuestion != nil &&
            showResults == false {
            
            VStack(alignment: .leading){
                //Question no
                Text ("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                //Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                //Answers
                ScrollView{
                    VStack{
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self){index in
                         
                            Button(action: {
                                //Track the selected index
                                selectedAnswerIndex = index
                                
                            },
                                   label: {
                                    ZStack{
                                        if submitted == false{
                                            
                                            RectangleCard (color: index == selectedAnswerIndex ? .gray : .white)
                                                .frame(height: 48)
                                        }
                                        else{
                                            //Answer has been submitted
                                            //User has seected the right answer
                                            if index == selectedAnswerIndex &&
                                                index == model.currentQuestion!.correctIndex{
                                                    RectangleCard (color: .green)
                                                    .frame(height: 48)
                                            }
                                            else if index == selectedAnswerIndex &&
                                                        index != model.currentQuestion!.correctIndex{
                                               
                                                //User has selected the wrong answer
                                                RectangleCard(color: .red)
                                                    .frame(height: 48)
                                            }
                                            else if index == model.currentQuestion!.correctIndex {
                                                RectangleCard (color: .green)
                                                .frame(height: 48)
                                            }
                                            else {
                                                RectangleCard (color: .white)
                                                .frame(height: 48)
                                            }
                                        }
                                        Text (model.currentQuestion!.answers[index])
                                    }
                            })
                            .disabled(submitted)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                //Submit Button
                Button(action: {
                    
                    //Check if answer hat been submitted
                    if submitted == true {
                        
                        //Check if it's the last question
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count{
                            
                            //Show the results
                            showResults = true
                        }
                        else{
                            //Anwer has been submitted, move to the next question
                            model.nextQuestion()
                            
                            //Reset the properties
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                    }
                    else{
                        //Answer has not been submitted
                        //Change submitted state
                        submitted = true
                        
                        //Check the answer and increment the counter if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex{
                            numCorrect += 1
                        }
                    }
                    
                },
                       label: {
                        ZStack{
                            RectangleCard(color: .green)
                                .frame(height: 48)
                            Text(buttonText)
                                .bold()
                                .foregroundColor(Color.white)
                                
                        }
                        .padding()
                })
                .disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        
        else if showResults == true {
            //If current question is nil, show the TestResultView
            TestResultsView(numCorrect: numCorrect)
        }
        
        else{
            ProgressView()
        }
    }
    
    var buttonText:String {
        if submitted == true{
            
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                //This is the last question
                return "Finish"
            }
            else{
                //There is a next question
                return "Next"
            }
        }
        else {
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

//
//  SideView.swift
//  Pentominoes
//
//  Created by Michael Tufillaro on 2/26/26.
//

import SwiftUI


//this is a view representing the left and right side of the screen
struct SideView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    //parameter that determines which side the view is building
    let side: Side
    
    var body: some View
    {
        VStack
        {
            PuzzleImages(side: side)
                .padding()
            ButtonView(side: side)
            Spacer()
        }
        .padding()
    }
}


struct PuzzleImages: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    //parameter that determines which side the view is building
    let side: Side
    
    
    var body: some View
    {
        //loop through and add the puzzle images
        ForEach(side.loopIndex.0...side.loopIndex.1, id: \.self)
        {
            index in
            let currentPuzzleName = PuzzleNames.allCases[index]
            let imageName = currentPuzzleName.imageName
            let isSelected = manager.isSelectedPuzzle(puzzleName: currentPuzzleName.rawValue)
            //make a button that looks like the image
            Button
            {
                //pass the current puzzle name into the manager
                manager.puzzleButton(puzzleName: currentPuzzleName.rawValue)
            }
            label:
            {
                //TODO: remove constants eventually
                Image(imageName)
                    .resizable()
                    .frame(width: 120, height: 120)
                //if the current puzzle is selected, make it transparent
                .opacity(isSelected ? 0.3 : 1.0)
            }
            //disable button if its already selected
            .disabled(isSelected)
        }
    }
}


struct ButtonView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    //parameter that determines which side the view is building
    let side: Side
    
    //disable the solve button when the selected puzzle is blank
    var isBlank: Bool
    {
        return (side == .right) && (manager.selectedPuzzle == "blank")
    }
    
    //get the corresponding function from manager
    var buttonFunction: () -> Void
    {
        switch side
        {
            case .left: return manager.resetButton
            case .right: return manager.solveButton
        }
    }
    
    var body: some View
    {
        Button
        {
            //do animation when resetting/solving
            withAnimation(.easeInOut(duration: 1))
            {
                buttonFunction()
            }
        }
        label:
        {
            ZStack
            {
                //TODO: make buttons look pretty here
                RoundedRectangle(cornerRadius: CGFloat(16))
                    .frame(width: 120, height: 80)
                    .foregroundColor(side.buttonColor)
                Text(side.buttonText)
                    .foregroundColor(.black)
            }
            //if the button is disabled, make it transparent
            .opacity(isBlank ? 0.3 : 1.0)
            
        }
        .disabled(isBlank)
    }
}


//testing view to help with previewing
struct preView: View
{
    //declare this to access viewmodel from views
    @Environment(ViewModel.self) var manager: ViewModel
    
    
    var body: some View
    {
        HStack
        {
            SideView(side: .left)
            SideView(side: .right)
        }
        .padding()
    }
}

#Preview
{
    preView()
        .environment(ViewModel())
}

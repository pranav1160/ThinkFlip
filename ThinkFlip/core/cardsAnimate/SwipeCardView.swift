//
//  CardView.swift
//  CardTut
//
//  Created by Pranav on 20/03/25.
//



import SwiftUI

struct SwipeCardView: View {
    @State private var xOffset:CGFloat = 0
    @State private var rotationDeg:Double = 0
    
    @State private var flip = false
    
    let title:String
    let bodyText:String
    let frontColor:Color
    let imgUrl:String
    let accuracy:Float
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top){
                
                SingleCardRotView(
                    title: title,
                    bodyText: bodyText,
                    frontColor: frontColor,
                    imageUrl: imgUrl,
                    accuracy: accuracy
                )
                    .frame(width: SizeConstants.cardWidth,height: SizeConstants.cardHeight)
                
            }
            .frame(width: SizeConstants.cardWidth,height: SizeConstants.cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(x:xOffset)
            .rotationEffect(Angle(degrees: rotationDeg))
            .animation(.snappy,value: xOffset)
            .gesture(
                DragGesture()
                    .onChanged({ val in
                        onDraggyChanged(val)
                    })
                    .onEnded({ val in
                        onDraggyEnded(val)
                    })
            )
        }
    }
}

private extension SwipeCardView{
    func swipeLeft(){
        xOffset = -500
        rotationDeg = -12
    }
    
    func swipeRight(){
        xOffset = 500
        rotationDeg = 12
    }
    
    func moveToCentre(){
        xOffset = 0
        rotationDeg = 0
    }
}

private extension SwipeCardView{
    func onDraggyEnded(_ val :_ChangedGesture<DragGesture>.Value){
        let width = val.translation.width
        
        if abs(width) <= abs(SizeConstants.screenCutOff){
            moveToCentre()
            return
        }
        
        if width < SizeConstants.screenCutOff{
            swipeLeft()
        }
        
        if width > SizeConstants.screenCutOff{
            swipeRight()
        }
    }
    
    func onDraggyChanged(_ val :_ChangedGesture<DragGesture>.Value){
        xOffset = val.translation.width
        rotationDeg = Double(val.translation.width/25)
    }
}




#Preview {
    SwipeCardView(
        title: "hola",
        bodyText: "Prow scuttle parrel provost Sail ho shrouds spirits boom mizzenmast yardarm. Pinnace holystone mizzenmast quarter crow's nest nipperkin grog yardarm hempen halter furl. Swab barque interloper chantey doubloon starboard grog black jack gangway rutters.Deadlights jack lad schooner scallywag dance the hempen jig carouser broadside cable strike colors. Bring a spring upon her cable holystone",
        frontColor: .green,
        imgUrl: "https://imgs.search.brave.com/CJ46IPPJjBvaPp4kW6NNUEW_bvgKKdDVAguUIpZjaGw/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9za3li/bHVlLmNvbS93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMS8wMy9w/aWMtcG9wdXAtd2Vs/bC1kb25lLnBuZw",
        accuracy: 98.4
    )
}

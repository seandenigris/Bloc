"
I am an element with broken drawing and onLayout methods
"
Class {
	#name : #BlExampleElementWithBrokenDrawingAndOnLayout,
	#superclass : #BlElement,
	#category : #'Bloc-Examples-Errors'
}

{ #category : #drawing }
BlExampleElementWithBrokenDrawingAndOnLayout >> drawOnSpartaCanvas: aCanvas [
	1/0
]

{ #category : #layout }
BlExampleElementWithBrokenDrawingAndOnLayout >> onLayout: aBounds [
	#() at: 1
]

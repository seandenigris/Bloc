Class {
	#name : #BlCompositeAnimation,
	#superclass : #BlBaseAnimation,
	#instVars : [
		'animations'
	],
	#category : 'Bloc-Animation-Basic'
}

{ #category : #'instance creation' }
BlCompositeAnimation class >> with: aCollectionOfAnimations [
	<return: #BlCompositeAnimation>

	^ self new addAll: aCollectionOfAnimations
]

{ #category : #adding }
BlCompositeAnimation >> add: anAnimation [
	anAnimation parent: self.
	anAnimation time: self time.

	animations add: anAnimation
]

{ #category : #adding }
BlCompositeAnimation >> addAll: theAnimations [
	theAnimations do: [ :anAnimation | self add: anAnimation ]
]

{ #category : #'api - accessing' }
BlCompositeAnimation >> animations [
	<return: #Collection of: #BlBaseAnimation>

	^ animations
]

{ #category : #'api - running' }
BlCompositeAnimation >> doStep [
	self subclassResponsibility
]

{ #category : #initialization }
BlCompositeAnimation >> initialize [
	super initialize.

	animations := OrderedCollection new
]

{ #category : #'api - running' }
BlCompositeAnimation >> stop [
	super stop.

	self stopChildren
]

{ #category : #'api - running' }
BlCompositeAnimation >> stopChildren [
	animations
		select: [ :anAnimation | anAnimation isRunning ]
		thenDo: [ :anAnimation | anAnimation stop ]
]

{ #category : #accessing }
BlCompositeAnimation >> time: aBlTime [
	super time: aBlTime.
	
	self animations do: [ :anAnimation | anAnimation time: aBlTime ]
]

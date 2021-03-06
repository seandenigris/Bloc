"
I help developers to script UI scenes and simplify exemplification process.

I am designed for Model-based User Interface Testing
"
Class {
	#name : #BlDevScripter,
	#superclass : #Object,
	#traits : 'TBlDevScripterActionStep + TBlDevScripterCheckStepCreation',
	#classTraits : 'TBlDevScripterActionStep classTrait + TBlDevScripterCheckStepCreation classTrait',
	#instVars : [
		'element',
		'space',
		'events',
		'rootStep'
	],
	#category : #'Bloc-DevTool-Scripter'
}

{ #category : #adding }
BlDevScripter >> addStep: aScripterStep [
	<return: #BlDevScripterStep>
	^ rootStep addStep: aScripterStep
]

{ #category : #execution }
BlDevScripter >> continue [
	BlDevScripterStepContinueExecutor new
		scripter: self;
		async;
		"withScreenshots;"
		play
]

{ #category : #'accessing - element' }
BlDevScripter >> element [
	^ element
]

{ #category : #'accessing - element' }
BlDevScripter >> element: anElement [
	element := anElement.
	element removeFromParent.

	element addEventFilterOn: BlEvent do: [ :anEvent | events add: anEvent ].

	space addChild: element
]

{ #category : #'accessing - element' }
BlDevScripter >> elementWithoutParent [
	"Return element removed from a testing ${class:BlSpace}$.
	Useful when someone wants to display the resulting element.
	It cannot be used during the script execution."
	<return: #BlElement>
	^ self element removeFromParent
]

{ #category : #'accessing - data' }
BlDevScripter >> events [
	<return: #BlDevScripterEvents>

	^ events
]

{ #category : #'accessing - space' }
BlDevScripter >> extent [
	<return: #Point>
	^ space extent
]

{ #category : #'accessing - space' }
BlDevScripter >> extent: aPoint [
	space extent: aPoint
]

{ #category : #'gt-extension' }
BlDevScripter >> gtElementsFor: aView [
	<gtView>
	space ifNil: [ ^ aView empty ].
	^ aView tree
		title: 'Children';
		items: [ space root children ];
		children: #children;
		expandUpTo: 3
]

{ #category : #'gt-extension' }
BlDevScripter >> gtEventTracesIn: aContainer [
	| anEventColor |
	
	anEventColor := Color r: 0.270772238514174 g: 0.6705767350928641 b: 0.9960899315738025 alpha: 1.0.
	
	self events do: [ :eachEvent |
		eachEvent class = BlMouseDownEvent
			ifTrue: [
				aContainer addChild: (BlElement new
					geometry: (BlCircle new);
					size: 6@6;
					background: anEventColor;
					effect: (BlGaussianShadowEffect
						color: anEventColor
						width: 1
						offset: 0@0);
					border: (BlBorder paint: Color white width: 1);
					relocate: eachEvent position - (3@3)) ].
				
		eachEvent class = BlMouseUpEvent
			ifTrue: [
				aContainer addChild: (BlElement new
					geometry: (BlCircle new);
					size: 6@6;
					background: Color white;
					border: (BlBorder paint: anEventColor width: 1);
					effect: (BlGaussianShadowEffect
						color: anEventColor
						width: 1
						offset: 0@0);
					relocate: eachEvent position - (3@3)) ].
		
		eachEvent class = BlMouseMoveEvent
			ifTrue: [
				aContainer addChild: (BlLineElement new
					border: (BlBorder paint: anEventColor width: 1);
					fromAnchor: (BlAbsolutePositionAnchor position: eachEvent position - eachEvent delta);
					toAnchor: (BlAbsolutePositionAnchor position: eachEvent position)) ] ]
]

{ #category : #'gt-extension' }
BlDevScripter >> gtEventsFor: aView [
	<gtView>
	self events ifNil: [ ^ aView empty ].
	^ (self events gtEventsFor: aView)
		title: 'Events';
		priority: 3
]

{ #category : #'gt-extension' }
BlDevScripter >> gtReveresedEventsFor: aView [
	<gtView>
	self events ifNil: [ ^ aView empty ].
	^ (self events gtReveresedEventsFor: aView)
		title: 'Events (Reversed)';
		priority: 4
]

{ #category : #'gt-extension' }
BlDevScripter >> gtSpaceFor: aView [
	<gtView>
	space
		ifNil: [ ^ aView empty ].
		
	^ aView explicit
		title: 'Preview';
		priority: 0;
		stencil: [
			| aContainer |
			
			aContainer := BlElement new.
			aContainer constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical matchParent ].
			
			(space gtPreviewFor: GtPhlowEmptyView new)
				asElementDo: [ :anElement | aContainer addChild: anElement ].
			
			self gtEventTracesIn: aContainer.
			
			aContainer ];
		actionButtonLabel: 'Open' 
			action: [ self spaceWithElement show ];
		actionButtonLabel: 'Inspect' 
			action: [ :anElement | 
				anElement phlow spawnObject: self elementWithoutParent ]
]

{ #category : #'gt-extension' }
BlDevScripter >> gtSpaceTasksFor: aView [
	<gtView>
	space ifNil: [ ^ aView empty ].
	self spaceTasks ifEmpty: [ ^ aView empty ].
	^ (self spaceTasks gtItemsFor: aView)
		title: 'Space Tasks'
]

{ #category : #'gt-extension' }
BlDevScripter >> gtStepsMondrianTreeFor: aView [
	<gtView>
	
	^ rootStep gtStepsMondrianTreeFor: aView
]

{ #category : #'gt-extension' }
BlDevScripter >> gtStepsTreeFor: aView [
	<gtView>
	
	^ rootStep gtStepsTreeFor: aView
]

{ #category : #'gt-extension' }
BlDevScripter >> gtUserDataFor: aView [
	<gtView>
	space ifNil: [ ^ aView empty ].
	self userData isEmpty ifTrue: [ ^ aView empty ].
	^ (self userData gtUserDataFor: aView)
		priority: 7
]

{ #category : #initialization }
BlDevScripter >> initialize [
	super initialize.
	
	rootStep := BlDevScripterRootStep new.
	rootStep referenceHere.
	space := BlSpace new.
	space title: 'Scripter'.
	space extent: 800 @ 600.
	space host: BlMockedHost new.
	space addEventFilterOn: BlEvent do: [ :anEvent | events add: anEvent ].
	events := BlDevScripterEvents new
]

{ #category : #'accessing - data' }
BlDevScripter >> model [
	^ self userData model
]

{ #category : #'accessing - data' }
BlDevScripter >> model: anObject [
	self userData model: anObject
]

{ #category : #execution }
BlDevScripter >> play [
	BlDevScripterStepPlayOnceExecutor new
		scripter: self;
		async;
		"withScreenshots;"
		play
]

{ #category : #execution }
BlDevScripter >> pulse [
	space pulse
]

{ #category : #'accessing - space' }
BlDevScripter >> root [
	^ self space root
]

{ #category : #'accessing - space' }
BlDevScripter >> space [
	<return: #BlSpace>
	^ space
]

{ #category : #'accessing - space' }
BlDevScripter >> spaceTasks [
	^ space taskQueue tasks
]

{ #category : #'accessing - space' }
BlDevScripter >> spaceWithElement [
	"Return ${class:BlSpace}$ and ensure that the ==element== is its child
	Useful when someone wants to display the resulting space (window) with the element.
	It cannot be used during the script execution."
	<return: #BlSpace>
	self element space = space ifFalse: [ 
		space addChild: self elementWithoutParent ].
	^ space
]

{ #category : #execution }
BlDevScripter >> startWithExecutor: anExecutor [
	rootStep startWithExecutor: anExecutor
]

{ #category : #'steps - substeps' }
BlDevScripter >> substep: aLabel do: anOneArgBlock [
	^ (self substeps: aLabel do: anOneArgBlock) referenceSender
]

{ #category : #execution }
BlDevScripter >> syncContinue [
	BlDevScripterStepContinueExecutor new
		scripter: self;
		sync;
		"withScreenshots;"
		play
]

{ #category : #execution }
BlDevScripter >> syncPlay [
	BlDevScripterStepPlayOnceExecutor new
		scripter: self;
		sync;
		"withScreenshots;"
		play
]

{ #category : #'accessing - space' }
BlDevScripter >> time [
	<return: #BlTime>
	^ self space time
]

{ #category : #'accessing - data' }
BlDevScripter >> userData [
	<return: #BlDevScripterUserData>
	^ space root devScripterData
]

Class {
	#name : #BlDevScripterRequestFocusStep,
	#superclass : #BlDevScripterInteractionStep,
	#category : #'Bloc-DevTool-Scripter-Steps'
}

{ #category : #accessing }
BlDevScripterRequestFocusStep >> defaultLabel [
	^ 'Focus'
]

{ #category : #actions }
BlDevScripterRequestFocusStep >> playOn: aScripter [
	(self target findTargetStartingInScripter: aScripter) requestFocus.
	aScripter pulse
]

Class {
	#name : #LogGroup,
	#superclass : #Object,
	#instVars : [
		'source',
		'group'
	],
	#category : #LogFileManager
}

{ #category : #'as yet unclassified' }
LogGroup class >> withSource: aPath [
	"comment stating purpose of message"
	(self new) source: aPath group: OrderedCollection new.
]

{ #category : #'as yet unclassified' }
LogGroup >> group [
	^ group.
]

{ #category : #'as yet unclassified' }
LogGroup >> source [
	^ source.
]

{ #category : #'as yet unclassified' }
LogGroup >> source: aPath group: anArray [
	"comment stating purpose of message"
	source:= aPath.
	group:= anArray.
]

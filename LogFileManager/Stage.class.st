Class {
	#name : #Stage,
	#superclass : #Object,
	#instVars : [
		'stage',
		'groups'
	],
	#category : #LogFileManager
}

{ #category : #'instance creation' }
Stage class >> new: aNumber [
	"comment stating purpose of message"
	^ (self new) stage: aNumber groups: OrderedCollection new.
	
]

{ #category : #'as yet unclassified' }
Stage >> addGroup: aPath [
	"comment stating purpose of message"
	(groups anySatisfy: [ :group | group hasSource: aPath]) ifFalse:[groups add: (LogGroup withSource: aPath)].
]

{ #category : #'as yet unclassified' }
Stage >> addLog: aLogEntry withSource: aPath [
	"comment stating purpose of message"
	self addGroup: aPath.
	(self searchGroup: aPath) addLog: aLogEntry.
]

{ #category : #'as yet unclassified' }
Stage >> groups [
	"comment stating purpose of message"
	^ groups.
]

{ #category : #'as yet unclassified' }
Stage >> gtInspectorLogsEntries: composite [
	<gtInspectorPresentationOrder: 2>
	composite fastList
		title: 'Logs';
		display: [:each | each logEntries].
]

{ #category : #'as yet unclassified' }
Stage >> hasStage: aNumber [
	"comment stating purpose of message"
	^ stage = aNumber.
]

{ #category : #'as yet unclassified' }
Stage >> logEntries [
	"comment stating purpose of message"
	| newCollect |
	newCollect := OrderedCollection new.
	groups do: [ :group | newCollect addAll: group logEntries ].
	^ newCollect.
]

{ #category : #'as yet unclassified' }
Stage >> print [
	"comment stating purpose of message"
	^ 'Stage ', stage asString.
]

{ #category : #'as yet unclassified' }
Stage >> searchGroup: aPath [
	^ groups detect: [ :group | group hasSource: aPath].
]

{ #category : #'as yet unclassified' }
Stage >> stage [
	"comment stating purpose of message"
	^ stage.
]

{ #category : #'as yet unclassified' }
Stage >> stage: aNumber groups: anArray [
	"comment stating purpose of message"
	stage:= aNumber.
	groups:= anArray.
]

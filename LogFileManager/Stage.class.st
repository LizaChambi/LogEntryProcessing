Class {
	#name : #Stage,
	#superclass : #Object,
	#instVars : [
		'groups',
		'level'
	],
	#category : #LogFileManager
}

{ #category : #'instance creation' }
Stage class >> new: aNumber [
	"comment stating purpose of message"
	^ (self new) stage: aNumber groups: OrderedCollection new.
	
]

{ #category : #comparing }
Stage >> < aStage [
	( level = #Final) ifTrue: [ ^ false ]
		ifFalse: [ (aStage level = #Final) 
						ifTrue: [ ^ true ] 
						ifFalse: [ ^(level < aStage level )] 
					].
]

{ #category : #'as yet unclassified' }
Stage >> addGroup: aPath [
	"comment stating purpose of message"
	(groups anySatisfy: [ :group | group hasSource: aPath]) 
		ifTrue: [ ^ self searchGroup: aPath ]
		ifFalse:[ | newGroup | newGroup := LogGroup withSource: aPath stage: self. 
			groups add: newGroup.
			^ newGroup].
]

{ #category : #'as yet unclassified' }
Stage >> addLog: aLogEntry withSource: aPath [
	"comment stating purpose of message"
	| group |
	group := self addGroup: aPath.
	group addLog: (aLogEntry group: group).
]

{ #category : #'as yet unclassified' }
Stage >> childrens [
	"comment stating purpose of message"
	^ groups.
]

{ #category : #'as yet unclassified' }
Stage >> failuresReport [
	| failures |
	failures := OrderedCollection new.
	groups do:[:group | failures addAll: (group failuresReport)].
	^ failures
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
Stage >> hasStage: aNumberOrSymbol [
	"comment stating purpose of message"
	^ level = aNumberOrSymbol.
]

{ #category : #'as yet unclassified' }
Stage >> level [
	"comment stating purpose of message"
	^ level.
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
	^ 'Stage ', level asString.
]

{ #category : #removing }
Stage >> removeLogGroup: aLogGroup [
	groups removeAllSuchThat: [ :group | group = aLogGroup].
]

{ #category : #'as yet unclassified' }
Stage >> saveStage [
	"comment stating purpose of instance-side message"
	groups do: [ :group | group saveGroup ].
]

{ #category : #'as yet unclassified' }
Stage >> searchGroup: aPath [
	^ groups detect: [ :group | group hasSource: aPath].
]

{ #category : #'as yet unclassified' }
Stage >> stage: aNumberOrSymbol groups: anArray [
	"comment stating purpose of message"
	level:= aNumberOrSymbol.
	groups:= anArray.
]

{ #category : #'as yet unclassified' }
Stage >> stageNameSuffix [
	^ 'stage', level asString
]

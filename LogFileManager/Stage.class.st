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
						ifFalse: [ ^level < aStage level ] 
					].
]

{ #category : #'as yet unclassified' }
Stage >> addGroup: aName [
	"ESTE METODO HACE DOBLE BUSQUEDA"
	"aName := aBasename readStream upTo:$-; upTo:$.." "Read the name" "Se puede hacer con un parser"
	(groups anySatisfy: [ :group | group hasName: aName])
		ifTrue: [ ^ self searchGroup: aName ]
		ifFalse:[ | newGroup | newGroup := LogGroup withName: aName stage: self. 
			groups add: newGroup.
			^ newGroup].
]

{ #category : #'as yet unclassified' }
Stage >> addLog: aLogEntry withSource: aFileName [
	"comment stating purpose of message. validaciones"
	| group |
	group := self addGroup: (aFileName asFileReference base readStream upTo:$-; upToEnd). "Se puede hacer con un parser"
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
Stage >> hasGroupWithName: aGroupName [ 
	"comment stating purpose of message"
	^ groups anySatisfy: [:group | group hasName: aGroupName ].
]

{ #category : #'as yet unclassified' }
Stage >> hasLevel: aNumberOrSymbol [
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
Stage >> saveStageOnFolder: aPathFolder [
	"comment stating purpose of instance-side message"
	groups do: [ :group | group saveGroupOnFolder: aPathFolder ].
]

{ #category : #'as yet unclassified' }
Stage >> searchGroup: aName [
	^ groups detect: [ :group | group hasName: aName].
]

{ #category : #'as yet unclassified' }
Stage >> stage: aNumberOrSymbol groups: anArray [
	"comment stating purpose of message"
	level:= aNumberOrSymbol.
	groups:= anArray.
]

{ #category : #'as yet unclassified' }
Stage >> stageNamePrefix [
	^ 'stage', level asString
]

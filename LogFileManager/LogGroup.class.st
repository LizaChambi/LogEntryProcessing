Class {
	#name : #LogGroup,
	#superclass : #Object,
	#instVars : [
		'source',
		'logsEntries'
	],
	#category : #LogFileManager
}

{ #category : #'as yet unclassified' }
LogGroup class >> withSource: aPath [
	"comment stating purpose of message"
	^(self new) source: aPath logs: OrderedCollection new.
]

{ #category : #'as yet unclassified' }
LogGroup >> addLog: aLogEntry [
	"comment stating purpose of message"
	logsEntries add: aLogEntry.
]

{ #category : #adding }
LogGroup >> addNewLogEntry [
	self addLog: (LogEntry timestamp: 0 selector: #method: arguments: #(arguments ) stage: (self probableStage) group: self).
]

{ #category : #'as yet unclassified' }
LogGroup >> groups [
	^ OrderedCollection new.
]

{ #category : #'as yet unclassified' }
LogGroup >> gtInspectorLogsEntries: composite [
	<gtInspectorPresentationOrder: 1>
	composite fastList
		title: 'Logs';
		display: [:each | each logEntries].
]

{ #category : #'as yet unclassified' }
LogGroup >> hasSource: aPath [
	^ (source = aPath).
]

{ #category : #'as yet unclassified' }
LogGroup >> logEntries [
	^ logsEntries.
]

{ #category : #'as yet unclassified' }
LogGroup >> print [
	^ source asFileReference basename.
]

{ #category : #adding }
LogGroup >> probableStage [
	| probableStages |
	probableStages := (logsEntries collect: [ :log | log stage ]) removeDuplicates.
	(probableStages size = 1)
		ifTrue: [ ^ probableStages at:1 ]
		ifFalse: [ ^ (probableStages do: [ :stage | stage -> (logsEntries count: [:log | log stage = stage] ) ]) maxValue: [:assoc | assoc value] ].
]

{ #category : #'as yet unclassified' }
LogGroup >> saveGroup [
	self writeLogsEntries: self sortLogEntriesByTimestamp.
]

{ #category : #sorting }
LogGroup >> sortLogEntriesByTimestamp [
	"Sort the log entries by timestamp"
	|sortedEntries|
	sortedEntries := SortedCollection sortBlock: [:log1 :log2 | log1 timestamp <= log2 timestamp ].
	sortedEntries addAll: logsEntries.
	^ sortedEntries.
]

{ #category : #'as yet unclassified' }
LogGroup >> source [
	^ source.
]

{ #category : #'as yet unclassified' }
LogGroup >> source: aPath logs: anArray [
	"comment stating purpose of message"
	source:= aPath.
	logsEntries:= anArray.
]

{ #category : #writing }
LogGroup >> writeLogsEntries: aCollection [
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollection do: [:log | t nextPutAll: log prettyPrint]].
	source asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]

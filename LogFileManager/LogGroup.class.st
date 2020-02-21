Class {
	#name : #LogGroup,
	#superclass : #Object,
	#instVars : [
		'logsEntries',
		'stage',
		'name'
	],
	#category : #LogFileManager
}

{ #category : #'as yet unclassified' }
LogGroup class >> withName: aName stage:aStage [
	"comment stating purpose of message"
	^(self new) name: aName logs: OrderedCollection new stage:aStage.
]

{ #category : #'as yet unclassified' }
LogGroup >> addLog: aLogEntry [
	"comment stating purpose of message"
	logsEntries add: aLogEntry.
]

{ #category : #adding }
LogGroup >> addNewLogEntry [
	self addLog: (LogEntry timestamp: 0 selector: #method: arguments: #(arguments ) stage: self level group: self).
]

{ #category : #'as yet unclassified' }
LogGroup >> childrens [
	^ OrderedCollection new.
]

{ #category : #'as yet unclassified' }
LogGroup >> failuresReport [
	| failures |
	failures := OrderedCollection new.
	failures addAll: (self logsWithRepeatedTimestamp collect: [ :log | ReportLogError description: 'Timestamp repeated.' nameFile: self fileName logTimestamp: log timestamp ] ).
	logsEntries do: [ :logE | failures addAll: (logE failuresInGroup: self fileName)].
	^ failures.
]

{ #category : #accessing }
LogGroup >> fileName [
	^ (stage stageNamePrefix, '-', name, '.changes')
]

{ #category : #'as yet unclassified' }
LogGroup >> gtInspectorLogsEntries: composite [
	<gtInspectorPresentationOrder: 1>
	composite fastList
		title: 'Logs';
		display: [:each | each logEntries].
]

{ #category : #'as yet unclassified' }
LogGroup >> hasFileName: aBasename [
	^ (self fileName = aBasename).
]

{ #category : #'as yet unclassified' }
LogGroup >> hasName: aName [
	^ name = aName.
]

{ #category : #accessing }
LogGroup >> level [
	^ stage level
]

{ #category : #'as yet unclassified' }
LogGroup >> logEntries [
	^ logsEntries.
]

{ #category : #'as yet unclassified' }
LogGroup >> logsWithRepeatedTimestamp [
	^ logsEntries select: [ :log | (logsEntries count: [ :otherLog | otherLog timestamp = log timestamp]) > 1].

]

{ #category : #setter }
LogGroup >> name [
	^ name
]

{ #category : #setter }
LogGroup >> name: aString [ 
	name := aString
]

{ #category : #'as yet unclassified' }
LogGroup >> name: aName logs: anArray stage: aStage [
	"comment stating purpose of message"
	name:= aName.
	logsEntries:= anArray.
	stage := aStage.
]

{ #category : #'as yet unclassified' }
LogGroup >> print [
	^ name.
]

{ #category : #removing }
LogGroup >> removeLogEntry: aLogEntry [
	logsEntries removeAllSuchThat: [ :log | log = aLogEntry].
]

{ #category : #'as yet unclassified' }
LogGroup >> saveGroupOnFolder: aPathFolder [
	(logsEntries isEmpty) 
		ifTrue: [ self writeEmptyGroup: aPathFolder ]
		ifFalse: [self writeLogsEntries: self sortLogEntriesByTimestamp onFolder: aPathFolder ]
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
LogGroup >> sourceFile: pathFolder [
	"comment stating purpose of instance-side message"
	^ (pathFolder, '/', self fileName)
]

{ #category : #'as yet unclassified' }
LogGroup >> stage [
	^ stage.
]

{ #category : #'as yet unclassified' }
LogGroup >> stage: aStage [
	stage := aStage
]

{ #category : #'as yet unclassified' }
LogGroup >> writeEmptyGroup: aPathFolder [
	(self sourceFile: aPathFolder) asFileReference ensureDelete;writeStream.
]

{ #category : #writing }
LogGroup >> writeLogsEntries: aCollection onFolder: aPathFolder [
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollection do: [:log | t nextPutAll: log prettyPrint]].
	(self sourceFile: aPathFolder) asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]

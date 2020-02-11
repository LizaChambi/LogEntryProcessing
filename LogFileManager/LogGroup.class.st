Class {
	#name : #LogGroup,
	#superclass : #Object,
	#instVars : [
		'source',
		'logsEntries',
		'stage'
	],
	#category : #LogFileManager
}

{ #category : #'as yet unclassified' }
LogGroup class >> withSource: aPath stage:aStage [
	"comment stating purpose of message"
	^(self new) source: aPath logs: OrderedCollection new stage:aStage.
]

{ #category : #'as yet unclassified' }
LogGroup >> addLog: aLogEntry [
	"comment stating purpose of message"
	logsEntries add: aLogEntry.
]

{ #category : #adding }
LogGroup >> addNewLogEntry [
	"CAMBIAR IMPLEMENTACION DEL STAGE DEL LOG ENTRY"
	self addLog: (LogEntry timestamp: 0 selector: #method: arguments: #(arguments ) stage: (stage stage) group: self). "EL STAGE DEBE SER EL OBJETO ENTERO, NO SU VALOR"
]

{ #category : #'as yet unclassified' }
LogGroup >> childrens [
	^ OrderedCollection new.
]

{ #category : #'as yet unclassified' }
LogGroup >> failuresReport [
	| failures |
	failures := OrderedCollection new.
	failures addAll: (self logsWithRepeatedTimestamp collect: [ :log | ReportLogError description: 'Timestamp repeated.' nameFile: source asFileReference basename logTimestamp: log timestamp ] ).
	logsEntries do: [ :logE | failures addAll: (logE failuresInGroup: source)].
	^ failures.
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
LogGroup >> logsWithRepeatedTimestamp [
	^ logsEntries select: [ :log | (logsEntries count: [ :otherLog | otherLog timestamp = log timestamp]) > 1].

]

{ #category : #'as yet unclassified' }
LogGroup >> print [
	^ source asFileReference basename.
]

{ #category : #removing }
LogGroup >> removeLogEntry: aLogEntry [
	logsEntries removeAllSuchThat: [ :log | log = aLogEntry].
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
LogGroup >> source: aPath logs: anArray stage: aStage [
	"comment stating purpose of message"
	source:= aPath.
	logsEntries:= anArray.
	stage := aStage.
]

{ #category : #'as yet unclassified' }
LogGroup >> stage [
	^ stage.
]

{ #category : #'as yet unclassified' }
LogGroup >> stage: aStage [
	stage := aStage
]

{ #category : #writing }
LogGroup >> writeLogsEntries: aCollection [
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollection do: [:log | t nextPutAll: log prettyPrint]].
	source asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]

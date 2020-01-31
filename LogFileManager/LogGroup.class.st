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
	^ self source.
]

{ #category : #'as yet unclassified' }
LogGroup >> saveGroup [
	" Suponiendo que los archivos ya fueron removidos de la carpeta anteriormente en el LogFileManager>>#saveFile: "
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

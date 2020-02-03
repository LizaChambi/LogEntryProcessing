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
	"source asFileReference absolutePath parent asFileReference ensureDeleteAll." "Remove all older files from source folder"
	"	* Esta última linea no puede estar aquí, ya que CADA grupo va a limpiar el contenido de la carpeta, entonces solo quedará guardado el último grupo que se guardó en la carpeta.
		* Esta última linea se tiene que hacer en LogFile Manager (por una única vez) ya que él tiene la referencia de la carpeta que se leyó originalmente, LogGroup solo conoce el path de su archivo leido, la cual pudo editarse y ser diferente a la de origin."
	self writeLogsEntries: self sortLogEntriesByTimestamp.
	" Falta llamar a este método desde Stage>>#saveStage"
	" Falta crear Stage>>#saveStage"
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

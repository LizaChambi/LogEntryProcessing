Class {
	#name : #LogFileManagement,
	#superclass : #Object,
	#instVars : [
		'logEntries'
	],
	#classInstVars : [
		'filesToRead',
		'logEntries',
		'sortedEntries',
		'aLogEntry'
	],
	#category : #LogFileManagement
}

{ #category : #adding }
LogFileManagement >> addLog: aLogEntry [
	"comment stating purpose of message"
	(aLogEntry timestamp isNil) ifFalse: 
	[
		 logEntries add: aLogEntry.
	].
]

{ #category : #converting }
LogFileManagement >> entriesStringCollectionsToLogEntry: stringFile [
	"Create an array of LogEntry based on a string of a log entry"
	| fileRead chunk |
	chunk := ''.
	fileRead := stringFile readStream.
	[ fileRead atEnd ] whileFalse: [ 	chunk := chunk, (fileRead upTo: $.), '.' .
												( 
												(fileRead peek) = Character cr | fileRead atEnd ) ifTrue:
												[  
													self addLog: ((LogEntry new) byteStringLogToLogEntry: chunk).
													chunk:= ''.
												].
											].
	^ logEntries.
]

{ #category : #'as yet unclassified' }
LogFileManagement >> filesToReadLogFilesFromFolder: inputDirectory [
	"comment stating purpose of message"
	^ ((inputDirectory asFileReference) children) select: [ :each | each basename endsWith: '.changes' ].

]

{ #category : #initialization }
LogFileManagement >> initialize [
	"comment stating purpose of message"
	logEntries := OrderedCollection new.
]

{ #category : #accessing }
LogFileManagement >> logEntries [
	"comment stating purpose of message"

	^ logEntries.
]

{ #category : #'as yet unclassified' }
LogFileManagement >> logEntriesToPrint [
	"comment stating purpose of message"
	| stringsLogEntries textToPrint|
	stringsLogEntries := logEntries collect: [ :algo | algo atByteStringOutput ].
	textToPrint := ''.
	stringsLogEntries do: [:each | textToPrint := textToPrint , each ].
	^ textToPrint.
]

{ #category : #'as yet unclassified' }
LogFileManagement >> mergeLogFilesAsCollection: logFiles [
	"comment stating purpose of message"
	^ logFiles do: [:file | self readLogFile: file ].
]

{ #category : #'read/write usage' }
LogFileManagement >> mergeOrderedLogFileIn: inputDirectory withName: fileNameOutput [
	"comment stating purpose of message"
	|filesToRead|
	filesToRead := self filesToReadLogFilesFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogFile: file ].
	self writingOutputFiles: (self sortLogEntriesByTimestamp) withName: fileNameOutput.
]

{ #category : #'as yet unclassified' }
LogFileManagement >> mergeOrderedLogFilesIn: inputDirectory withName: fileNameOutput matchingACriteria: aBlock [
	"comment stating purpose of message"
	|filesToRead logEntriesFilter|
	filesToRead := self filesToReadLogFilesFromFolder: inputDirectory.
	logEntries := self mergeLogFilesAsCollection: filesToRead.
	logEntriesFilter := logEntries select: aBlock.
	self sortLogEntriesByTimestamp: logEntriesFilter.
	self writingOutputFilesWithName: fileNameOutput.
	
	
	
]

{ #category : #'as yet unclassified' }
LogFileManagement >> readFile: nameFile [
	"comment stating purpose of message"
	^ nameFile asFileReference readStream upToEnd replaceAll: Character lf with: Character cr.
]

{ #category : #reading }
LogFileManagement >> readLogFile: fileReference [
	"Read a log file and add them as LogEntry files to the log entries"
	| stringFile |
	stringFile := self readFile: fileReference. "read file ByteString"
	self entriesStringCollectionsToLogEntry: stringFile. "StringFiles to array LogEntry"
]

{ #category : #sorting }
LogFileManagement >> sortLogEntriesByTimestamp [
	"Sort the log entries by timestamp"
	|sortedEntries|
	sortedEntries := SortedCollection sortBlock: [:log1 :log2 | log1 timestamp <= log2 timestamp ].
	sortedEntries addAll: logEntries.
	^ sortedEntries.
]

{ #category : #'as yet unclassified' }
LogFileManagement >> writingOutputFiles: aCollectionLogEntries withName: fileNameOutput [ 
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollectionLogEntries  do: [:log | t nextPutAll: log atByteStringOutput]].
	fileNameOutput asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]

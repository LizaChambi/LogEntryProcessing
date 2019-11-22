Class {
	#name : #LogFileManagement,
	#superclass : #Object,
	#instVars : [
		'logEntries'
	],
	#category : #LogFileManagement
}

{ #category : #converting }
LogFileManagement >> asArrayLogEntry: stringFile [
	"Create an array of LogEntry based on a string of a log entry"
	| fileRead chunk |
	chunk := ''.
	fileRead := stringFile readStream.
	[ fileRead atEnd ] whileFalse: [ 	chunk := chunk, (fileRead upTo: $.), '.' .
												( (fileRead peek) = Character cr | fileRead atEnd ) ifTrue:
												[  
													logEntries add: ((LogEntry new) byteStringLogToLogEntry: chunk).
													chunk:= ''.
												].
											].
										
	^ logEntries
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
LogFileManagement >> mergeLogFilesAsArray: logFiles [
	"comment stating purpose of message"
	^ logFiles do: [:file | self readLogFile: file ].
]

{ #category : #'read/write usage' }
LogFileManagement >> mergeOrderedLogFileIn: inputDirectory withName: fileNameOutput [
	"comment stating purpose of message"
	|filesToRead |
	filesToRead := self filesToReadLogFilesFromFolder: inputDirectory.
	logEntries := self mergeLogFilesAsArray: filesToRead.
	self sortLogEntriesByTimestamp: logEntries.
	self writingOutputFilesWithName: fileNameOutput.
	
]

{ #category : #'as yet unclassified' }
LogFileManagement >> mergeOrderedLogFilesIn: inputDirectory withName: fileNameOutput matchingACriteria: aBlock [
	"comment stating purpose of message"
	|filesToRead logEntriesFilter|
	filesToRead := self filesToReadLogFilesFromFolder: inputDirectory.
	logEntries := self mergeLogFilesAsArray: filesToRead.
	logEntriesFilter := logEntries select: aBlock.
	self sortLogEntriesByTimestamp: logEntriesFilter.
	self writingOutputFilesWithName: fileNameOutput.
	
	
	
]

{ #category : #'as yet unclassified' }
LogFileManagement >> readFile: nameFile [
	"comment stating purpose of message"
	^ nameFile asFileReference readStream upToEnd.
]

{ #category : #reading }
LogFileManagement >> readLogFile: nameFile [
	"Read a log file and add them as LogEntry files to the log entries"
	| stringFile |
	stringFile := self readFile: nameFile. "read file ByteString"
	logEntries addAll: (self asArrayLogEntry: stringFile ). "Add parser stringFiles to array LogEntry"
]

{ #category : #sorting }
LogFileManagement >> sortLogEntriesByTimestamp: logFiles [
	"Sort the log entries by time stamp"
	^ logFiles "Falta implementar el método de ordenamiento. -Divide and conquer-"
]

{ #category : #'as yet unclassified' }
LogFileManagement >> writingOutputFilesWithName: fileNameOutput [
	"Write a file with the log entries with the given name"
	| text |	
	text := self logEntriesToPrint.
	fileNameOutput asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]

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
	(self isValidLog: aLogEntry)
		ifTrue: [ logEntries add: aLogEntry ] "ifFalse: [ - se puede guardar el log erroneo en un archivo con los logs erroneos - ]".
]

{ #category : #converting }
LogFileManagement >> convertFileReadedToLogsEntries: logStream [
	"Create an array of LogEntry based on a string of a log entry"
	[ logStream atEnd ] whileFalse: [ self addLog: ((LogEntry new) convertChunkToLogEntry: logStream next) ].
	^ logEntries.
]

{ #category : #'as yet unclassified' }
LogFileManagement >> filesToReadFromFolder: inputDirectory [
	"comment stating purpose of message"
	^ ((inputDirectory asFileReference) children) select: [ :each | each basename endsWith: '.changes' ].

]

{ #category : #initialization }
LogFileManagement >> initialize [
	"comment stating purpose of message"
	logEntries := OrderedCollection new.
]

{ #category : #adding }
LogFileManagement >> isValidLog: aLogEntry [
	^ (aLogEntry timestamp = nil) not and: [ (aLogEntry arguments = nil) not and: [ (aLogEntry selector = nil) not ] ].  
]

{ #category : #accessing }
LogFileManagement >> logEntries [
	"comment stating purpose of message"
	^ logEntries.
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
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: file ].
	self writeFiles: (self sortLogEntriesByTimestamp) withName: fileNameOutput.
]

{ #category : #'as yet unclassified' }
LogFileManagement >> mergeOrderedLogFilesIn: inputDirectory withName: fileNameOutput matchingACriteria: aBlock [
	"comment stating purpose of message"
	|filesToRead logEntriesFilter|
	filesToRead := self filesToReadFromFolder: inputDirectory.
	logEntries := self mergeLogFilesAsCollection: filesToRead.
	logEntriesFilter := logEntries select: aBlock.
	self sortLogEntriesByTimestamp: logEntriesFilter.
	self writingOutputFilesWithName: fileNameOutput.
	
	
	
]

{ #category : #reading }
LogFileManagement >> readLogsEntries: fileReference [
	"Read a log file and add them as LogEntry files to the log entries"
	| logStream |
	logStream := ReadLogStream onStream: fileReference asFileReference readStream.
	self convertFileReadedToLogsEntries: logStream.
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
LogFileManagement >> writeFiles: aCollectionLogEntries withName: fileNameOutput [ 
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollectionLogEntries  do: [:log | t nextPutAll: log asStringOutput]].
	fileNameOutput asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]

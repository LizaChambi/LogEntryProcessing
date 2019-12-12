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
	(aLogEntry isValidLog)
		ifTrue: [ logEntries add: aLogEntry ] "ifFalse: [ - se puede guardar el log erroneo en un archivo con los logs erroneos - ]".
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

{ #category : #reading }
LogFileManagement >> logStream: fileReference [
	"Read a log file and add them as LogEntry files to the log entries"
	^ ReadLogStream onStream: fileReference asFileReference readStream.
]

{ #category : #'read/write usage' }
LogFileManagement >> mergeOrderedLogFilesFrom: inputDirectory withName: fileNameOutput [
	"comment stating purpose of message"
	| filesToRead |
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file)].
	self writeFiles: (self sortLogEntriesByTimestamp) withName: fileNameOutput.
]

{ #category : #'as yet unclassified' }
LogFileManagement >> mergeOrderedLogFilesFrom: inputDirectory withName: fileNameOutput matchingACriteria: aBlock [
	"comment stating purpose of message"
	| filesToRead |
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file) withCriteria: aBlock].
	self writeFiles: (self sortLogEntriesByTimestamp) withName: fileNameOutput.
	
	
	
]

{ #category : #reading }
LogFileManagement >> readLogsEntries: logStream [
	"Read a log file and add them as LogEntry files to the log entries"
	[ logStream atEnd ] whileFalse: [	self addLog: ((LogEntry new) convertChunkToLogEntry: logStream next) ].
	^ logEntries.
]

{ #category : #reading }
LogFileManagement >> readLogsEntries: logStream  withCriteria: aBlock [
	"Read a log file and add them as LogEntry files to the log entries"
	| logCreated |
	[ logStream atEnd ] whileFalse: [
		logCreated := (LogEntry new) convertChunkToLogEntry: logStream next.
		(logCreated hasCriteria: aBlock) ifTrue: [ self addLog: logCreated ]. 
	].
	^ logEntries.
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

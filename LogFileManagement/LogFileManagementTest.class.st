Class {
	#name : #LogFileManagementTest,
	#superclass : #TestCase,
	#instVars : [
		'logFileManagement'
	],
	#classInstVars : [
		'text',
		'logFileManagement'
	],
	#category : #'LogFileManagement-Test'
}

{ #category : #'as yet unclassified' }
LogFileManagementTest >> logStreamSource2 [
^ ReadLogStream onStream: 'self
	timestamp: 0
	selector: #doAssignType:to:
	arguments: #(''Block[void,?]'' ''ByteArray>>do:$1'' ).
self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).' readStream.
]

{ #category : #'as yet unclassified' }
LogFileManagementTest >> logStreamSource3 [
^ ReadLogStream onStream: 'self
	timestamp: 0
	selector: #doAssignType:to:
	arguments: #(''Block[void,?]'' ''ByteArray>>do:$1'' ).
self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).
self
	timestamp: 0
	selector: #doAssignType:to:
	arguments: #(''void'' ''ByteArray>>do:'' ).' readStream.
]

{ #category : #tests }
LogFileManagementTest >> readFile: aPath [
	"comment stating purpose of message"
	^ aPath asFileReference readStream upToEnd replaceAll: Character lf with: Character cr.
]

{ #category : #running }
LogFileManagementTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	logFileManagement := LogFileManagement new.
]

{ #category : #running }
LogFileManagementTest >> tearDown [
	"comment stating purpose of message"
	'OututFile.txt' asFileReference ensureDelete.
	'sortedLogFiles' asFileReference ensureDelete.
]

{ #category : #tests }
LogFileManagementTest >> testAddLog [
	"comment stating purpose of message"
	logFileManagement addLog: (LogEntry timestamp: 123456 selector: #doAssignType:to: arguments: #(#Integer #'MoProgramStarter>>sleep:$1') ).
	self assert: (logFileManagement logEntries notEmpty).
]

{ #category : #tests }
LogFileManagementTest >> testExceptionAddLogNil [
	"comment stating purpose of message"
	logFileManagement addLog: (LogEntry timestamp: nil selector: nil arguments:nil ).
	self assert: (logFileManagement logEntries isEmpty).
]

{ #category : #tests }
LogFileManagementTest >> testMergeOrderedALogFileFromPath [
	"comment stating purpose of message"
	logFileManagement mergeOrderedLogFilesFrom: '/home/lizachambi/Pharo/images/Pharo 7.0 - 64bit (stable)/resources' withName: 'sortedLogFiles'.

	self assert: (self readFile: 'sortedLogFiles') equals: 'self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #()).
self
	timestamp: 8
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''SmtEntireFileReadStream'' #SmtSupportVASTTypingApp ''CfsReadFileStream'' #() #() #()).
self
	timestamp: 33
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #()).
'.
]

{ #category : #tests }
LogFileManagementTest >> testMergeOrderedALogFileFromPathWithCriteria [
	"comment stating purpose of message"
logFileManagement mergeOrderedLogFilesFrom: '/home/lizachambi/Pharo/images/Pharo 7.0 - 64bit (stable)/resources' 
withName: 'sortedLogFiles' 
matchingACriteria: [:log | log timestamp < 10 ].

	self assert: (self readFile: 'sortedLogFiles') equals: 'self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #()).
self
	timestamp: 8
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''SmtEntireFileReadStream'' #SmtSupportVASTTypingApp ''CfsReadFileStream'' #() #() #()).
'.
]

{ #category : #tests }
LogFileManagementTest >> testOneEntryWithCR [
	"comment stating purpose of message"

	| result |
	result := logFileManagement readLogsEntries: (ReadLogStream onStream: 'self
	timestamp: 0
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).
' readStream ).
	self assert: result notEmpty.
	self assert: ((result at: 1) timestamp) equals: (0).
	self assert: ((result at: 1) selector) equals: (#doAddCorrelationRule:to:).
	self assert: ((result at: 1) arguments) equals: (#('argument1.argument1 same-as #Integer' 'ByteArray>>do:') ).
]

{ #category : #tests }
LogFileManagementTest >> testOneEntryWithoutCR [
	"comment stating purpose of message"

	| result |
	result := logFileManagement readLogsEntries: (ReadLogStream onStream: 'self
	timestamp: 0
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).' readStream ).
	self assert: result notEmpty.
	self assert: ((result at: 1) timestamp) equals: (0).
	self assert: ((result at: 1) selector) equals: (#doAddCorrelationRule:to:).
	self assert: ((result at: 1) arguments) equals: (#('argument1.argument1 same-as #Integer' 'ByteArray>>do:') ).
]

{ #category : #tests }
LogFileManagementTest >> testReadLogEntries [
	"comment stating purpose of message"
	|entryManagement|
	entryManagement := LogFileManagement new.
	self assert: ((entryManagement readLogsEntries: self logStreamSource3) size) equals: 3.
]

{ #category : #tests }
LogFileManagementTest >> testReadLogsEntriesWithCriteriaTimestamp0 [
	"comment stating purpose of message"
	
	logFileManagement readLogsEntries: (self logStreamSource2) withCriteria: [:log | log timestamp = 0].
	self assert: (logFileManagement logEntries size) equals: (1).
]

{ #category : #tests }
LogFileManagementTest >> testReadLogsEntriesWithCriteriaTimestamp666 [
	"comment stating purpose of message"
	
	logFileManagement readLogsEntries: (self logStreamSource2) withCriteria: [:log | log timestamp = 666].
	self assert: (logFileManagement logEntries isEmpty).
]

{ #category : #tests }
LogFileManagementTest >> testSortLogEntriesByTimestamp [
	"comment stating purpose of message"
	logFileManagement addLog: ((LogEntry new) timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ));
	addLog: ((LogEntry new) timestamp: 0 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('DateTime' #SmtSupportVASTTypingApp 'Array' #() #() #() ));
	addLog: ((LogEntry new) timestamp: 8 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('SmtEntireFileReadStream' #SmtSupportVASTTypingApp 'CfsReadFileStream' #() #() #() )).
	
	self assert: (logFileManagement sortLogEntriesByTimestamp first timestamp) equals: (0).
	self assert: (logFileManagement sortLogEntriesByTimestamp second timestamp) equals: (8).
	self assert: (logFileManagement sortLogEntriesByTimestamp last timestamp) equals: (33).
]

{ #category : #tests }
LogFileManagementTest >> testWriteFilesWithName [
	"comment stating purpose of message"
	logFileManagement addLog: ((LogEntry new) timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ));
	addLog: ((LogEntry new) timestamp: 0 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('DateTime' #SmtSupportVASTTypingApp 'Array' #() #() #() )).
	
	logFileManagement writeFiles: (logFileManagement logEntries) withName: 'OututFile.txt'.
	
	self assert: (self readFile: 'OututFile.txt') equals: ('self
	timestamp: 33
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #()).
self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #()).
').
]

{ #category : #tests }
LogFileManagementTest >> testWritingOutputFilesWithName [
	"comment stating purpose of message"
	logFileManagement addLog: ((LogEntry new) timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ));
	addLog: ((LogEntry new) timestamp: 0 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('DateTime' #SmtSupportVASTTypingApp 'Array' #() #() #() )).
	
	logFileManagement writeFiles: (logFileManagement logEntries) withName: 'OututFile.txt'.
	
	self assert: (self readFile:'OututFile.txt') equals: ('self
	timestamp: 33
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #()).
self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #()).
').
]

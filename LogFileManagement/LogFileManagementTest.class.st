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
LogFileManagementTest >> logEntrySource [
^ 'self
	timestamp: 0
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #() ).
self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #() ).'
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
LogFileManagementTest >> testAsArrayLogEntry [
	"comment stating purpose of message"
	| collection |
	
	collection := OrderedCollection new.
	collection add: ((LogEntry new) timestamp: 0 selector: #doAssignType:to: arguments: #('Block[void,?]' 'ByteArray>>do:$1') );
	add: ((LogEntry new) timestamp: 0 selector: #doAddCorrelationRule:to: arguments: #('argument1.argument1 same-as #Integer' 'ByteArray>>do:') );
	add: ((LogEntry new) timestamp: 0 selector: #doAssignType:to: arguments: #('void' 'ByteArray>>do:') ).
	
	logFileManagement entriesStringCollectionsToLogEntry: 'self
	timestamp: 0
	selector: #doAssignType:to:
	arguments: #(''Block[void,?]'' ''ByteArray>>do:$1'' ).
self
	timestamp: 0
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).
self
	timestamp: 0
	selector: #doAssignType:to:
	arguments: #(''void'' ''ByteArray>>do:'' ).' .
	self assert: (logFileManagement logEntries first) equals: (collection first).
	
	"self assert: (logFileManagement logEntries) equals: (collection )."
]

{ #category : #tests }
LogFileManagementTest >> testAsArrayString [
	"comment stating purpose of message"
	|entryManagement|
	entryManagement := LogFileManagement new.
	self assert: (entryManagement entriesStringCollectionsToLogEntry: self logEntrySource ) notEmpty
]

{ #category : #tests }
LogFileManagementTest >> testMergeOrderedALogFileFromPathWithAName [
	"comment stating purpose of message"
	
	logFileManagement mergeOrderedLogFileIn: '/home/lizachambi/Pharo/images/Pharo 7.0 - 64bit (stable)/resources' withName: 'sortedLogFiles'.

	self assert: (logFileManagement readFile: 'sortedLogFiles') equals: 'self
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
LogFileManagementTest >> testOneEntryWithCR [
	"comment stating purpose of message"

	| result |
	result := logFileManagement
		entriesStringCollectionsToLogEntry:
			'self
	timestamp: 0
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).
	.'.
	self assert: result notEmpty.
	self assert: ((result at: 1) timestamp = 0).
]

{ #category : #tests }
LogFileManagementTest >> testOneEntryWithoutCR [
	"comment stating purpose of message"

	| result |
	result := logFileManagement
		entriesStringCollectionsToLogEntry:
			'self
	timestamp: 0
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).'.
	self assert: result notEmpty.
	self assert: ((result at: 1) timestamp = 0).
	self assert: ((result at: 1) arguments first = 'argument1.argument1 same-as #Integer' ).
]

{ #category : #tests }
LogFileManagementTest >> testReadFile [
	"comment stating purpose of message"
	self assert: (logFileManagement readFile:'Readme') equals: 'self
	timestamp: 33
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #() ).
'.
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
LogFileManagementTest >> testWritingOutputFilesWithName [
	"comment stating purpose of message"
	logFileManagement addLog: ((LogEntry new) timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ));
	addLog: ((LogEntry new) timestamp: 0 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('DateTime' #SmtSupportVASTTypingApp 'Array' #() #() #() )).
	
	logFileManagement writingOutputFiles: (logFileManagement logEntries) withName: 'OututFile.txt'.
	
	self assert: ((logFileManagement readFile:'OututFile.txt') sameAs: ('self
	timestamp: 33
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #()).
self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #()).
') ).
]

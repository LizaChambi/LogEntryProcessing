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

{ #category : #tests }
LogFileManagementTest >> testAsArrayLogEntry [
	"comment stating purpose of message"
	| collection |
	
	collection := OrderedCollection new.
	collection add: ((LogEntry new) timestamp: 0 selector: #doAssignType:to: arguments: #('Block[void,?]' 'ByteArray>>do:$1' ) );
	add: ((LogEntry new) timestamp: 0 selector: #doAddCorrelationRule:to: arguments: #('argument1.argument1 same-as #Integer' 'ByteArray>>do:' ) );
	add: ((LogEntry new) timestamp: 0 selector: #doAssignType:to: arguments: #('void' 'ByteArray>>do:' ) ).
	
	self assert: (logFileManagement asArrayLogEntry: 'self
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
	arguments: #(''void'' ''ByteArray>>do:'' ).' ) = (collection).
]

{ #category : #tests }
LogFileManagementTest >> testAsArrayString [
	"comment stating purpose of message"
	|entryManagement|
	entryManagement := LogFileManagement new.
	self assert: (entryManagement asArrayLogEntry: self logEntrySource ) notEmpty
]

{ #category : #tests }
LogFileManagementTest >> testOneEntryWithCR [
	"comment stating purpose of message"

	| result |
	result := logFileManagement
		asArrayLogEntry:
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
		asArrayLogEntry:
			'self
	timestamp: 0
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).'.
	self assert: result notEmpty.
	self assert: ((result at: 1) timestamp = 0).
]

{ #category : #tests }
LogFileManagementTest >> testReadFile [
	"comment stating purpose of message"
	self assert: (logFileManagement readFile:'Readme') = 'Texto.
'.
]

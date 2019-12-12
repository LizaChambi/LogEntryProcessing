Class {
	#name : #LogEntryTest,
	#superclass : #TestCase,
	#instVars : [
		'logEntry'
	],
	#classInstVars : [
		'logEntry'
	],
	#category : #'LogFileManagement-Test'
}

{ #category : #running }
LogEntryTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	logEntry := LogEntry timestamp: 0 selector: #doAssignType:to: arguments: #(#void 'AbtContainerDetailsColumn>>clearWidgets' ).
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntry [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).') equals: (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) ).
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntryWithDot [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).') equals: (logEntry timestamp: 3721902053120 selector: #doAddCorrelationRule:to: arguments: #('argument1.argument1 same-as #Integer' 'ByteArray>>do:') ).
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntryWrong [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' ).') equals: (logEntry timestamp: nil selector: nil arguments: nil).
]

{ #category : #tests }
LogEntryTest >> testHasCriteriaTimestamp0 [
	"comment stating purpose of message"
	self assert: ( logEntry hasCriteria: [:log | log timestamp = 0] ).
]

{ #category : #tests }
LogEntryTest >> testHasCriteriaWithArgumentsError [
	"comment stating purpose of message"
	| logWithError |
	logWithError := LogEntry timestamp: 10 selector: #doAssignType:to: arguments: #(#BwbMessage #'WSMessage class>>raiseError:$1').
	self assert: ( logWithError hasCriteria: [:log | log arguments anySatisfy: [:argument | argument includesSubstring: 'Error'] ] ).
]

{ #category : #tests }
LogEntryTest >> testHasCriteriaWithoutArgumentsError [
	"comment stating purpose of message"
	self assert: ( logEntry hasCriteria: [:log | log arguments anySatisfy: [:argument | argument includesSubstring: 'Error'] ]) not.
]

{ #category : #tests }
LogEntryTest >> testStringOutput [
	"comment stating purpose of message"
	self assert: ((logEntry timestamp: '123' selector: 'doAdd' arguments: '(return same-as)') asStringOutput) = 'self
	timestamp: 123
	selector: #doAdd
	arguments: (return same-as).
'.
]

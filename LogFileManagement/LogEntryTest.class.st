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

{ #category : #tests }
LogEntryTest >> convertChunkToLogEntry [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 0
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingAp'' nil #() ).') equals: (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) ).
]

{ #category : #running }
LogEntryTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	logEntry := LogEntry new.
]

{ #category : #tests }
LogEntryTest >> testByteStringLogToLogEntry [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 0
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingAp'' nil #() ).') equals: (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) ).
]

{ #category : #tests }
LogEntryTest >> testByteStringOutput [
	"comment stating purpose of message"
	self assert: ((logEntry timestamp: '123' selector: 'doAdd' arguments: '(return same-as)') asStringOutput) = 'self
	timestamp: 123
	selector: #doAdd
	arguments: (return same-as).
'.
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntry [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 0
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingAp'' nil #() ).') equals: (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) ).
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

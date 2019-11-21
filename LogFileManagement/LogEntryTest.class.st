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
	logEntry := LogEntry new.
]

{ #category : #tests }
LogEntryTest >> testByteStringLogToLogEntry [
	"comment stating purpose of message"
	self assert: (logEntry byteStringLogToLogEntry: 'self
	timestamp: 0
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingAp'' nil #() ).') = (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) ).
]

{ #category : #tests }
LogEntryTest >> testByteStringOutput [
	"comment stating purpose of message"
	self assert: ((logEntry timestamp: '123' selector: 'doAdd' arguments: '(return same-as)') atByteStringOutput) = 'self
	timestamp: 123
	selector: doAdd
	arguments: (return same-as).
'.
]

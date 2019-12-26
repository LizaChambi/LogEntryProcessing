Class {
	#name : #LogEntryTest,
	#superclass : #TestCase,
	#instVars : [
		'logEntry'
	],
	#classInstVars : [
		'logEntry'
	],
	#category : #'LogFileManager-Test'
}

{ #category : #running }
LogEntryTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	logEntry := LogEntry timestamp: 0 selector: #doAssignType:to: arguments: #(#void 'AbtContainerDetailsColumn>>clearWidgets' ) stage:0.
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntry [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' )
	stage: 0.') equals: (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) stage: 0).
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntryWithDot [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' )
	stage:0.') equals: (logEntry timestamp: 3721902053120 selector: #doAddCorrelationRule:to: arguments: #('argument1.argument1 same-as #Integer' 'ByteArray>>do:') stage:0 ).
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntryWithOriginPath [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' )
	stage: 0.' withOriginPath: '/home/lizachambi/Pharo/stage0-testfile.changes' ) equals: (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) stage: 0 source: '/home/lizachambi/Pharo/stage0-testfile.changes' asFileReference).
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntryWrong [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' )
	stage: 0.') equals: (LogEntry timestamp:nil selector:nil arguments: nil stage:nil source:nil). "Deberia reportar un error"
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
	logWithError := LogEntry timestamp: 10 selector: #doAssignType:to: arguments: #(#BwbMessage #'WSMessage class>>raiseError:$1') stage:0.
	self assert: ( logWithError hasCriteria: [:log | log arguments anySatisfy: [:argument | argument includesSubstring: 'Error'] ] ).
]

{ #category : #tests }
LogEntryTest >> testHasCriteriaWithoutArgumentsError [
	"comment stating purpose of message"
	self assert: ( logEntry hasCriteria: [:log | log arguments anySatisfy: [:argument | argument includesSubstring: 'Error'] ]) not.
]

{ #category : #tests }
LogEntryTest >> testHasNoStageErrorOnLogStream [
	"comment stating purpose of message"
	| logStream |
	logStream := ReadLogStream onStream: '/home/lizachambi/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfile.changes' asFileReference readStream.
	self assert: ( (logEntry hasStageErrorOn: logStream) not).
]

{ #category : #tests }
LogEntryTest >> testHasStageErrorOnLogStream [
	"comment stating purpose of message"
	| logStream logWithStage2 |
	logStream := ReadLogStream onStream: '/home/lizachambi/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfile.changes' asFileReference readStream.
	logWithStage2 := LogEntry timestamp: 0 selector: #doAssignType:to: arguments: #(#void 'AbtContainerDetailsColumn>>clearWidgets' ) stage:2 source: '/home/lizachambi/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfile.changes'.
	self assert: (logWithStage2 hasStageErrorOn: logStream).
]

{ #category : #tests }
LogEntryTest >> testStringOutput [
	"comment stating purpose of message"
	self assert: ((logEntry timestamp: '123' selector: 'doAdd' arguments: '(return same-as)' stage: '0' source: 'path' ) prettyPrint) = 'self
	timestamp: 123
	selector: #doAdd
	arguments: (return same-as)
	stage: 0.
'.
]

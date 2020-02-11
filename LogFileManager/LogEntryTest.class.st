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
	|group|
	group := LogGroup withSource: 'dir/stage0-algo.changes'.
	logEntry := LogEntry timestamp: 0 selector: #doAssignType:to: arguments: #(#void 'AbtContainerDetailsColumn>>clearWidgets' ) stage:0 group: group.
	group addLog: logEntry.
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
LogEntryTest >> testConvertChunkToLogEntryWithGroup [
	"comment stating purpose of message"
	| path group |
	path := './stage0-testfile.changes'.
	group := LogGroup withSource: path.
	
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' )
	stage: 0.' withGroup: group) equals: (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) stage: 0 group: group).
	
	path asFileReference ensureDelete.
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntryWithStageFinal [
	"comment stating purpose of message"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' )
	stage: #Final.') equals: (logEntry timestamp: 0 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #()) stage: #Final).
]

{ #category : #tests }
LogEntryTest >> testConvertChunkToLogEntryWrong [
	"POSIBLES ARREGLOS A ESTE MÉTODOS"
	self assert: (logEntry convertChunkToLogEntry: 'self
	timestamp: 3721902053120
	arguments: #(''argument1.argument1 same-as #Integer'' ''ByteArray>>do:'' )
	stage: 0.') equals: (LogEntry timestamp:nil selector:nil arguments: nil stage:nil group:nil). "Deberia reportar un error"
]

{ #category : #tests }
LogEntryTest >> testEditWithLog [
	"comment stating purpose of message"
	| aLogEntry newGroup |
	newGroup := LogGroup withSource: 'path/stageFinal-algo.changes'.
	aLogEntry := LogEntry timestamp: 0303 selector: #method: arguments: #(arg) stage: #Final group: newGroup.
	newGroup addLog: aLogEntry.
	self assert: (logEntry editWithLog: aLogEntry) equals: (logEntry timestamp: 0303 selector: #method: arguments: #(arg) stage: #Final group: newGroup ).
]

{ #category : #tests }
LogEntryTest >> testEditorSuccessfully [
	"comment stating purpose of message"
	self assert: (logEntry editor: 'self
	timestamp: 46
	selector: #doSetTypeNamed:asInMigrationSet:
	arguments: #(#RootPoolDictionary #false ).') equals: (logEntry timestamp: 46 selector: #doSetTypeNamed:asInMigrationSet: arguments: #(#RootPoolDictionary #false ) stage: logEntry stage group: logEntry group).
]

{ #category : #tests }
LogEntryTest >> testEditorUnsuccessfully [
	"comment stating purpose of message"
	self should: [ logEntry editor: 'self
	timestamp: 46
	selector: #doSetTypeNamed
	arguments: #(#RootPoolDictionary #false ).'] raise: (AssertionFailure).
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
	| fileRef |
	fileRef := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfile.changes' asFileReference.
	self assert: ( (logEntry hasStageErrorOn: fileRef) not).
]

{ #category : #tests }
LogEntryTest >> testHasStageErrorOnLogStream [
	"comment stating purpose of message"
	| fileRef logWithStage2 group |
	group := LogGroup withSource: '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfile.changes'.
	fileRef := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfile.changes' asFileReference.
	logWithStage2 := LogEntry timestamp: 0 selector: #doAssignType:to: arguments: #(#void 'AbtContainerDetailsColumn>>clearWidgets' ) stage:2 group: group.
	group addLog: logWithStage2.
	self assert: (logWithStage2 hasStageErrorOn: fileRef).
]

{ #category : #tests }
LogEntryTest >> testParserValidationAssertLMissingArguments [
	"comment stating purpose of message"
	| parserCollection argCollection|
	argCollection := OrderedCollection newFrom: #(#String).
	parserCollection := OrderedCollection newFrom: #('self' 'timestamp: ' 20 'selector: ' #doAssignType:to: 'arguments: ').
	parserCollection add: argCollection.
	
	self should: [ logEntry parserValidation: parserCollection ] raise: (AssertionFailure).
]

{ #category : #tests }
LogEntryTest >> testParserValidationAssertLeftoverArguments [
	"comment stating purpose of message"
	| parserCollection argCollection|
	argCollection := OrderedCollection newFrom: #(#String).
	parserCollection := OrderedCollection newFrom: #('self' 'timestamp: ' 20 'selector: ' #doAssignType 'arguments: ').
	parserCollection add: argCollection.
	
	self should: [ logEntry parserValidation: parserCollection ] raise: (AssertionFailure).
]

{ #category : #tests }
LogEntryTest >> testParserValidationAssertTimestampNegative [
	"comment stating purpose of message"
	| parserCollection argCollection|
	argCollection := OrderedCollection newFrom: #(#String).
	parserCollection := OrderedCollection newFrom: #('self' 'timestamp: ' -20 'selector: ' #doAssignType:to: 'arguments: ').
	parserCollection add: argCollection.
	
	self should: [ logEntry parserValidation: parserCollection ] raise: (AssertionFailure).
]

{ #category : #tests }
LogEntryTest >> testStringOutput [
	"comment stating purpose of message"
	self assert: ((logEntry timestamp: '123' selector: 'doAdd' arguments: '(return same-as)' stage: '0' group: 'aGroup' ) prettyPrint) = 'self
	timestamp: 123
	selector: #doAdd
	arguments: (return same-as)
	stage: 0.
'.
]

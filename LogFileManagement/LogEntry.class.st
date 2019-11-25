Class {
	#name : #LogEntry,
	#superclass : #Object,
	#instVars : [
		'arguments',
		'selector',
		'timestamp'
	],
	#classInstVars : [
		'arguments'
	],
	#category : #LogFileManagement
}

{ #category : #comparing }
LogEntry >> <= aLogEntry [
	"comment stating purpose of message"

	^ timestamp asInteger < aLogEntry timestamp asInteger 
]

{ #category : #comparing }
LogEntry >> = aLogEntry [
	"comment stating purpose of message"

	^ (timestamp = aLogEntry timestamp) and: ((arguments = aLogEntry arguments ) and: (selector = aLogEntry selector)).
]

{ #category : #accessing }
LogEntry >> arguments [
	"comment stating purpose of message"

	^ arguments
]

{ #category : #conversion }
LogEntry >> atByteStringOutput [
	"comment stating purpose of message"
	^ 'self
	timestamp: ', timestamp asString ,'
	selector: ', '#', selector asString,'
	arguments: ', arguments asString,'.
'.
]

{ #category : #tests }
LogEntry >> byteStringLogToLogEntry: aByteString [
	"comment stating purpose of message"

	(OpalCompiler new) source: aByteString; context: nil; receiver: (self); evaluate.
]

{ #category : #accessing }
LogEntry >> selector [
	"comment stating purpose of message"

	^ selector
]

{ #category : #accessing }
LogEntry >> timestamp [
	"comment stating purpose of message"
	^ timestamp. 
]

{ #category : #initialization }
LogEntry >> timestamp: aTimestamp selector: aString arguments: aCollection [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aString.
	arguments:= aCollection.
	
]

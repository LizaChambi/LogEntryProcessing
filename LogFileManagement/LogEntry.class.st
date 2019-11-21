Class {
	#name : #LogEntry,
	#superclass : #Object,
	#instVars : [
		'arguments',
		'selector',
		'timestamp'
	],
	#category : #LogFileManagement
}

{ #category : #conversion }
LogEntry >> atByteStringOutput [
	"comment stating purpose of message"
	^ 'self
	timestamp: ', timestamp asString ,'
	selector: ', selector asString,'
	arguments: ', arguments asString,'.
'.
]

{ #category : #tests }
LogEntry >> byteStringLogToLogEntry: aByteString [
	"comment stating purpose of message"

	(OpalCompiler new) source: aByteString; context: nil; receiver: (self); evaluate.
]

{ #category : #initialization }
LogEntry >> timestamp: aTimestamp selector: aSelector arguments: aCollection [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aSelector.
	arguments:= aCollection.
	
]

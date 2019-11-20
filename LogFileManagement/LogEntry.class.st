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

{ #category : #'as yet unclassified' }
LogEntry >> withTimestamp: aTimestamp withSelector: aSelector withArguments: argument [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aSelector.
	arguments:= argument.
	
]

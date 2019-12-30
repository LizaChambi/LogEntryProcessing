Class {
	#name : #Stage,
	#superclass : #Object,
	#instVars : [
		'stage',
		'logFiles'
	],
	#category : #LogFileManager
}

{ #category : #'instance creation' }
Stage class >> new: aNumber [
	"comment stating purpose of message"
	^ (self new) stage: aNumber logsFiles: Dictionary new.
	
]

{ #category : #'as yet unclassified' }
Stage >> addLog: aLogEntry withSource: aPath [
	"comment stating purpose of message"
	logFiles at:aPath put: aLogEntry.
]

{ #category : #'as yet unclassified' }
Stage >> groups [
	"comment stating purpose of message"
	^ self sources.
]

{ #category : #'as yet unclassified' }
Stage >> logFiles [
	"comment stating purpose of message"
	^ logFiles .
]

{ #category : #'as yet unclassified' }
Stage >> sources [
	"comment stating purpose of message"
	^ logFiles keys sort.
]

{ #category : #'as yet unclassified' }
Stage >> stage [
	"comment stating purpose of message"
	^ stage.
]

{ #category : #'as yet unclassified' }
Stage >> stage: aNumber logsFiles: aDictionary [
	"comment stating purpose of message"
	stage:= aNumber.
	logFiles:= aDictionary.
]

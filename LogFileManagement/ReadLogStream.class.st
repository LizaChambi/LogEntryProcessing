Class {
	#name : #ReadLogStream,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #LogFileManagement
}

{ #category : #'as yet unclassified' }
ReadLogStream class >> onStream: aReadStream [
	^ self new onStream: aReadStream.
]

{ #category : #initalize }
ReadLogStream >> atEnd [
	"comment stating purpose of message"
	^ stream atEnd.
]

{ #category : #initalize }
ReadLogStream >> next [
	"comment stating purpose of message"
	| chunk finalized |
	chunk := ''. 
	finalized := false.
	[ finalized ] whileFalse: 
	[ 
		chunk := chunk, (stream upTo: $.), '.'.
		( (stream peek = Character lf) or: [ (stream peek = Character cr) or: [ (stream atEnd) ] ]) ifTrue: [ stream next. finalized := true. ^ chunk. ]
	].
]

{ #category : #initalize }
ReadLogStream >> onStream: aReadStream [
	"comment stating purpose of message"
	stream := aReadStream.
]

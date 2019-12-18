Class {
	#name : #ReadLogStream,
	#superclass : #Object,
	#instVars : [
		'stream',
		'positionLog'
	],
	#category : #LogFileManager
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
ReadLogStream >> fileReference [
	"comment stating purpose of message"
	^ stream wrappedStream wrappedStream file name asFileReference.
]

{ #category : #initalize }
ReadLogStream >> next [
	"comment stating purpose of message"
	| chunk finalized |
	chunk := ''.
	finalized := false.
	positionLog := stream position.
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
	positionLog := 0.
]

{ #category : #initalize }
ReadLogStream >> position [
	"comment stating purpose of message"
	^ positionLog.
]

{ #category : #initalize }
ReadLogStream >> stream [
	"comment stating purpose of message"
	^ stream.
]

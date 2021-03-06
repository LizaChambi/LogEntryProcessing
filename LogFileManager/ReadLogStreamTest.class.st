Class {
	#name : #ReadLogStreamTest,
	#superclass : #TestCase,
	#instVars : [
		'stream',
		'streamEmpty'
	],
	#category : #'LogFileManager-Test'
}

{ #category : #running }
ReadLogStreamTest >> setUp [
	stream := ReadLogStream onStream: 'self
timestamp: 3721562907151
selector: #doAssignType:to:
arguments: #(#Integer #''MoProgramStarter>>sleep:$1'' )
stage: 0.
self
timestamp: 3721563207251
selector: #doAddCorrelationRule:to:
arguments: #(''argument1.argument1 same-as receiver'' #''Object>>ifNotNil:'' )
stage: 0.
self
timestamp: 3721562979643
selector: #doAssignType:to:
arguments: #(#Integer #''MoPsMasterAbstractAdminPage>>imageDateStringFor:#BE55D2C84A296007B7A03C9BC686594E@12'' )
stage: 0.' readStream.
	streamEmpty := ReadLogStream onStream: '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/resources/stage0-010-VastStubsCreation.changes' asFileReference readStream.
]

{ #category : #tests }
ReadLogStreamTest >> testIsEmptyFile [
	"comment stating purpose of message"
	self assert: (streamEmpty isEmptyFile)
]

{ #category : #tests }
ReadLogStreamTest >> testIsEmptyFileFalse [
	"comment stating purpose of message"
	self assert: (stream isEmptyFile not)
]

{ #category : #tests }
ReadLogStreamTest >> testNext [
	"comment stating purpose of message"
	self assert: (stream next) equals: ('self
timestamp: 3721562907151
selector: #doAssignType:to:
arguments: #(#Integer #''MoProgramStarter>>sleep:$1'' )
stage: 0.')
]

{ #category : #tests }
ReadLogStreamTest >> testNextNext [
	"comment stating purpose of message"
	stream next.
	self assert: (stream next) equals: ('self
timestamp: 3721563207251
selector: #doAddCorrelationRule:to:
arguments: #(''argument1.argument1 same-as receiver'' #''Object>>ifNotNil:'' )
stage: 0.')
]

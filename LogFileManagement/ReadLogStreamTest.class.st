Class {
	#name : #ReadLogStreamTest,
	#superclass : #TestCase,
	#instVars : [
		'stream'
	],
	#category : #LogFileManagement
}

{ #category : #running }
ReadLogStreamTest >> setUp [
	stream := ReadLogStream onStream: 'self
timestamp: 3721562907151
selector: #doAssignType:to:
arguments: #(#Integer #''MoProgramStarter>>sleep:$1'' ).
self
timestamp: 3721562979643
selector: #doAssignType:to:
arguments: #(#Integer #''MoPsMasterAbstractAdminPage>>imageDateStringFor:#BE55D2C84A296007B7A03C9BC686594E@12'' ).
self
timestamp: 3721563207251
selector: #doAddCorrelationRule:to:
arguments: #(''argument1.argument1 same-as receiver'' #''Object>>ifNotNil:'' ).' readStream.
]

{ #category : #tests }
ReadLogStreamTest >> testNext [
	"comment stating purpose of message"
	self assert: (stream next) equals: ('self
timestamp: 3721562907151
selector: #doAssignType:to:
arguments: #(#Integer #''MoProgramStarter>>sleep:$1'' ).')
]

{ #category : #tests }
ReadLogStreamTest >> testNextNext [
	"comment stating purpose of message"
	stream next.
	self assert: (stream next) equals: ('self
timestamp: 3721562979643
selector: #doAssignType:to:
arguments: #(#Integer #''MoPsMasterAbstractAdminPage>>imageDateStringFor:#BE55D2C84A296007B7A03C9BC686594E@12'' ).')
]

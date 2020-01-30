Class {
	#name : #LogEntryCompositionTest,
	#superclass : #PP2CompositeNodeTest,
	#category : #LogFileManager
}

{ #category : #accessing }
LogEntryCompositionTest >> parserClass [
	^ LogEntryComposition
]

{ #category : #tests }
LogEntryCompositionTest >> testPPArguments [
	"comment stating purpose of message"
	self parse: '#(4 false #NIL #Boolean_N #AbtRow #() #(''rcv'') #''Scaled class>>abt_X-ml:$1'' #''Lo[String,Obj]'' #''BD>>test|BA|4|row'' ''VaS_Ext class'' ''onClass: aClass 
	baseClass := aClass.
	^self'')' rule: #ppArguments.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPArgumentsWithSpace [
	"comment stating purpose of message"
	self parse: '	 #( 4 false #NIL #Boolean_N #AbtRow #() #(''rcv'') #''Scaled class>>abt_X-ml:$1'' #''Lo[String,Obj]'' #''BD>>test|BA|4|row'' ''VaS_Ext class'' ''onClass: aClass 
	baseClass := aClass.
	^self'' ) 	' rule: #ppArguments.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPLogEntry [
	"comment stating purpose of message"
	self parse: 'self 
	timestamp:0 
	selector:#method:and:other: 
	arguments:#(4 false #NIL #Boolean_N #AbtRow #() #(''rcv'') #''Scaled class>>abt_X-ml:$1'' #''Lo[String,Obj]'' #''BD>>test|BA|4|row'' ''VaS_Ext class'' ''onClass: aClass 
	baseClass := aClass.
	^self''). ' rule: #ppLogEntry.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPLogEntry2 [
	"comment stating purpose of message"
	self parse: 'self 
	timestamp:0 
	selector:#method:and:other: 
	arguments:#(#() #(''rcv'') ''VaS_Ext class'' ). ' rule: #ppLogEntry.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPSelectorWithAArguments [
	"comment stating purpose of message"
	self parse: '#method:' rule: #ppSelector.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPSelectorWithSpace [
	"comment stating purpose of message"
	self parse: ' 	#method:and: 	' rule: #ppSelector.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPSelectorWithTwoArguments [
	"comment stating purpose of message"
	self parse: '#method:and:' rule: #ppSelector.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPSelectorWithoutArguments [
	"comment stating purpose of message"
	self parse: '#method' rule: #ppSelector.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPTimestamp [
	"comment stating purpose of message"
	self parse: '0' rule: #ppTimestamp.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPTimestampNegative [
	"comment stating purpose of message"
	self parse: '-1' rule: #ppTimestamp.
]

{ #category : #tests }
LogEntryCompositionTest >> testPPTimestampWithBlank [
	"comment stating purpose of message"
	self parse: ' 		  0 	  	  ' rule: #ppTimestamp.
]

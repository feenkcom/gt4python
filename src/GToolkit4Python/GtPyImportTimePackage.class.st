"
This is a class that's useful for handling outputs of instructions like

```shell
python -X importtime -m xyz
``` 
"
Class {
	#name : #GtPyImportTimePackage,
	#superclass : #Object,
	#instVars : [
		'localTime',
		'cumulativeTime',
		'nesting',
		'name',
		'children'
	],
	#category : #GToolkit4Python
}

{ #category : #'as yet unclassified' }
GtPyImportTimePackage class >> fromString: aString [
	"aString looks like
import time: self [us] | cumulative | imported package
import time:        77 |         77 |   _io
import time:        19 |         19 |   marshal
import time:       131 |        131 |   posix
import time:       363 |        590 | _frozen_importlib_external
import time:       450 |        450 |   time
..."	
	| lineParser root stack lines |
	lines := aString lines allButFirst reversed select: [:each | each beginsWith: 'import time'].
	lineParser := ('import time:' asPParser trim
			, #digit asPParser plus flatten trim , '|' asPParser trim
			, #digit asPParser plus flatten trim , '|' asPParser , #space asPParser
			, #space asPParser star , #endOfInput asPParser negate plus flatten)
			==> [ :t | 
				GtPyImportTimePackage new
					localTime: (t at: 2) asNumber;
					cumulativeTime: (t at: 4) asNumber;
					nesting: (t at: 7) size / 2;
					name: (t at: 8) ].
	root := GtPyImportTimePackage new
			localTime: 0;
			cumulativeTime: -1;
			nesting: -1;
			name: 'Root'.
	stack := Stack new.
	stack push: root.
	lines
		do: [ :each | 
			| newPackage |
			newPackage := lineParser parse: each.
			[ newPackage nesting <= stack top nesting ] whileTrue: [ stack pop ].
			stack top addChild: newPackage.
			stack push: newPackage ].
	^ root
]

{ #category : #'as yet unclassified' }
GtPyImportTimePackage >> addChild: aPyImportTimePackage [ 
	children add: aPyImportTimePackage
]

{ #category : #'as yet unclassified' }
GtPyImportTimePackage >> children [
	^ children
]

{ #category : #'as yet unclassified' }
GtPyImportTimePackage >> cumulativeTime [
	cumulativeTime < 0 ifTrue: [ cumulativeTime := self children sumNumbers: #cumulativeTime ].
	^ cumulativeTime
]

{ #category : #accessing }
GtPyImportTimePackage >> cumulativeTime: aTime [
	cumulativeTime := aTime
]

{ #category : #'as yet unclassified' }
GtPyImportTimePackage >> gtChildrenFor: aView [
	<gtView>
	| normalizer |
	children ifNil: [ ^ aView empty ].
	normalizer := BrColorLinearNormalizer
			inContext: (self withDeepCollect: #children)
			withCommand: #cumulativeTime
			lowColor: Color veryVeryLightGray
			highColor: (Color
					r: 216
					g: 55
					b: 62
					range: 255).
	^ aView columnedTree
		title: 'Children';
		items: [ {self} ];
		expandOneLevel;
		children: [ :each | each children ];
		column: 'Value' text: [ :each | each name ];
		column: 'Local time' text: [ :each | each localTime ];
		column: 'Cumulative time'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | each cumulativeTime ];
					background: [ :each | normalizer value: each ] ]
]

{ #category : #'as yet unclassified' }
GtPyImportTimePackage >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
GtPyImportTimePackage >> localTime [
	^ localTime
]

{ #category : #accessing }
GtPyImportTimePackage >> localTime: aTime [
	localTime := aTime 
]

{ #category : #'as yet unclassified' }
GtPyImportTimePackage >> name [
	^ name
]

{ #category : #accessing }
GtPyImportTimePackage >> name: aString [
	name := aString 
]

{ #category : #'as yet unclassified' }
GtPyImportTimePackage >> nesting [
	^ nesting
]

{ #category : #accessing }
GtPyImportTimePackage >> nesting: anInteger [
	nesting := anInteger 
]

Class {
	#name : #GtTallyPythonMethod,
	#superclass : #Object,
	#instVars : [
		'file',
		'line',
		'name'
	],
	#category : #GToolkit4Python
}

{ #category : #accessing }
GtTallyPythonMethod >> file [
	^ file
]

{ #category : #accessing }
GtTallyPythonMethod >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtTallyPythonMethod >> gtDisplayOn: aStream [
	aStream << name << ' '.
	file gtDisplayOn: aStream.
	aStream << ':' << line asString
]

{ #category : #accessing }
GtTallyPythonMethod >> gtSourceFor: aView [
	<gtView>
	file file ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Source';
		object: [ (name = '<module>' and: [ line = 1 ])
				ifTrue: [ file file ]
				ifFalse: [ GtLSPFileLocation new
						lspFile: file file;
						startPosition: (GtLSPPositionStructure new
								line: line - 1;
								character: 0;
								yourself);
						endPosition: (GtLSPPositionStructure new
								line: line - 1;
								character: (file file source lineNumber: line) size;
								yourself) ] ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtTallyPythonMethod >> isFromTrait [
	^ false
]

{ #category : #accessing }
GtTallyPythonMethod >> line [
	^ line
]

{ #category : #accessing }
GtTallyPythonMethod >> line: anObject [
	line := anObject
]

{ #category : #accessing }
GtTallyPythonMethod >> method [
	^ self
]

{ #category : #accessing }
GtTallyPythonMethod >> methodClass [
	^ file
]

{ #category : #accessing }
GtTallyPythonMethod >> name [
	^ name
]

{ #category : #accessing }
GtTallyPythonMethod >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtTallyPythonMethod >> selector [
	^ (name ifNil: [ '' ]) asSymbol
]

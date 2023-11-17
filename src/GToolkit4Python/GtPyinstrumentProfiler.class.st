Class {
	#name : #GtPyinstrumentProfiler,
	#superclass : #Object,
	#instVars : [
		'projectDirectory',
		'model',
		'fileCache'
	],
	#category : #GToolkit4Python
}

{ #category : #accessing }
GtPyinstrumentProfiler class >> profile: program withArgs: anArray in: aDirectory [
	^ self
		profile: program
		withArgs: anArray
		workingDirectory: aDirectory
		sourceDirectory: aDirectory
]

{ #category : #accessing }
GtPyinstrumentProfiler class >> profile: program withArgs: anArray workingDirectory: aDirectory sourceDirectory: sourceDirectory [
	| filename |
	filename := (UUID new asString36 , '.prof') asFileReference.
	GtSubprocessWithInMemoryOutput new
		workingDirectory: aDirectory;
		command: 'pyinstrument';
		arguments: {'--show-all'.
				'--outfile=' , filename pathString.
				'--renderer=json'.
				program} , anArray;
		errorBlock: [ :theProcess | self error: 'Execution failed' ];
		runAndWait.
	^ [ self new importProfile: filename forProject: sourceDirectory ]
		ensure: [ filename delete ]
]

{ #category : #accessing }
GtPyinstrumentProfiler >> createTally: aDictionary [
	| class method tally |
	class := self fileFor: aDictionary.
	method := class
			methodNamed: (aDictionary at: 'function')
			line: (aDictionary at: 'line_no').
	tally := GtTally new
			class: class method: method;
			bumpBy: ((aDictionary at: 'time') * 1000000) rounded;
			yourself.
	(aDictionary at: 'children')
		do: [ :each | 
			(each at: 'function') = '[self]'
				ifFalse: [ tally addReceiver: (self createTally: each) ] ].
	^ tally
]

{ #category : #accessing }
GtPyinstrumentProfiler >> fileFor: aDictionary [
	| fullname |
	fullname := aDictionary at: 'file_path'.
	^ fileCache
		at: fullname
		ifAbsentPut: [ GtTallyPythonFile new
				fullName: fullname;
				name: (aDictionary at: 'file_path_short');
				file: (self lookupFileInModel: fullname);
				yourself ]
]

{ #category : #accessing }
GtPyinstrumentProfiler >> importProfile: aFileRef forProject: projFileRef [
	| json |
	model := GtLSPPythonModel onDirectory: projFileRef asFileReference.
	fileCache := Dictionary new.
	json := STONJSON fromString: aFileRef asFileReference contents.
	^ self createTally: (json at: 'root_frame')
]

{ #category : #accessing }
GtPyinstrumentProfiler >> lookupFileInModel: aString [
	| ref |
	ref := (aString beginsWith: '.')
			ifTrue: [ model filename / aString ]
			ifFalse: [ aString asFileReference ].
	^ (model fileFor: ref) ifNil: [ model fileFor: model filename / aString ]
]

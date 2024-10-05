Class {
	#name : #BaselineOfGToolkit4Python,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4Python
}

{ #category : #baseline }
BaselineOfGToolkit4Python >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkitWorld' with: [
				spec repository: 'github://feenkcom/gtoolkit-world:v0.6.1176/src' ].
		spec
			baseline: 'GToolkit4LSP' with: [
				spec repository: 'github://feenkcom/gt4lsp:v0.6.448/src' ].

		spec package: 'GToolkit4Python' with: [
			spec requires: #('GToolkit4LSP' 'GToolkitWorld') ].
	]
]

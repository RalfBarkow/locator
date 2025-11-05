Class {
	#name : #BaselineOfLocator,
	#superclass : #BaselineOf,
	#category : #BaselineOfLocator
}

{ #category : #loading }
BaselineOfLocator class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'locator' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfLocator >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Locator'
		]
]

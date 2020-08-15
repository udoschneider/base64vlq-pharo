Extension { #name : #SequenceableCollection }

{ #category : #'*Base64VLQEncoder-Core' }
SequenceableCollection >> base64VLQEncoded [
	^ Base64VLQEncoder new encode: self
]

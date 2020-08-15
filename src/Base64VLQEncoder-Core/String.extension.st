Extension { #name : #String }

{ #category : #'*Base64VLQEncoder-Core' }
String >> base64VLQDecoded [
	
	
	^ Base64VLQEncoder new decode: self
]

default: ns sa role

ns:
	kubectl create ns erickube
	
sa:
	kubectl create serviceaccount erickube-admin --namespace erickube

role:
	kubectl create rolebinding erickube-admin-binding --clusterrole=edit --serviceaccount=erickube:erickube-admin --namespace erickube
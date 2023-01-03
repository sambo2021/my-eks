# Storage class that allow expansion : true
## at first check the storage class used inside your PVC 
```sh
kubectl get pvc/{{pvc-name}} -n {{required namespace}} -o yaml | grep -i storageClassName
kubectl get storageclass/{{storage class name}} -o yaml | grep -i allowVolumeExpansion 
# previous command shall see that allowVolumeExpansion: true , which means it allows dynamic expansion 
kubectl edit pvc/{{pvc-name}} -n {{required namespace}}
# resize spec.resources.requests.storage : to upper size, save and quit 
# now storage class will resize the ebs on aws to the new size and no action needed more
# it would take a time on aws console for optimizing the new size 
# to make sure that new size is mounted to our pod file system xec inside the pod and use command 
df -h  
```





# Storage class that allow expansion : false

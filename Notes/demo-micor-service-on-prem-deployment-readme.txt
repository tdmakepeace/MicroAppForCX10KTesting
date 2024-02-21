


1.Deploy 13 VM's with the following name and IP address from the ovf, the ovf can be doanloaded from the following location.

https://pensando.my.salesforce-sites.com/DownloadFile?id=a0L4T000006VssXUAS

	 
*********************************************************************
HostID    VM Name                 ens192 address            Pod Network 
*********************************************************************
1         K8-master	        172.16.30.10/24	
2         adservice	        172.16.30.11/24	
3         cartservice	        172.16.30.12/24	
4         checkoutservice	        172.16.30.13/24	
currencyservice	        172.16.30.14/24	
emailservice	        172.16.30.15/24	
frontend	        172.16.30.16/24	
loadgenerator	        172.16.30.17/24	
paymentservice	        172.16.30.18/24	
productcatalogservice	172.16.30.19/24	
recommendationservice	172.16.30.20/24	
redis-cart	        172.16.30.21/24	
shippingservice	        172.16.30.22/24	


2. The ens160 network is connected to OOB management to get IP via DHCP  and ens192 is configured with Static IP. 


3. Change the machine ID of each VM, modify the last two digits to make it unique 
     sudo vim /etc/machine-id
cat /etc/machine-id
19e2010d4ff249cf937373df45bd1e10

4. Reboot the nodes.

5. Initialize the K8-cluster from the Master Node.

     sudo kubeadm init --apiserver-advertise-address=172.16.30.10 --apiserver-cert-extra-sans=172.16.30.10 --pod-network-cidr=192.168.0.0/16
	   
6. Once the cluster is Initialized 
     mkdir -p $HOME/.kube
     sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
     sudo chown $(id -u):$(id -g) $HOME/.kube/config

7. Deploy the Calico CNI Plugin

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

8. Create the Custom Resource for Calico , 
       wget https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml

For this Demo the Encapsulation is None and blockSize is 24 

vim  custom-resources.yaml


****************************************************************************************************************************   
# This section includes base Calico installation configuration.
# For more information, see: https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io/v1.Installation
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    # Note: The ipPools section cannot be modified post-install.
    ipPools:
    - blockSize: 24
      cidr: 192.168.0.0/16
      encapsulation: None
      natOutgoing: Enabled
      nodeSelector: all()

---

# This section configures the Calico API server.
# For more information, see: https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io/v1.APIServer
apiVersion: operator.tigera.io/v1
kind: APIServer
metadata:
  name: default
spec: {}
*************************************************************************************************************************************
 
9. Apply the custom resource file.
    
	   kubectl apply -f custom-resources.yaml
	   
10. Check the Node Status , it should be in ready state.
    
	  kubectl get nodes

11. Join the other worker Nodes to K8 cluster using the token, printed from output of Step 3. or print new one.
	  
      kubeadm token create --print-join-command
		   
12. Check the status of all the Nodes from Master, all the nodes should be in ready state.

 kubectl get nodes
NAME                    STATUS   ROLES           AGE     VERSION
adservice               Ready    <none>          7m24s   v1.28.2
cartservice             Ready    <none>          7m24s   v1.28.2
checkoutservice         Ready    <none>          7m24s   v1.28.2
currencyservice         Ready    <none>          7m24s   v1.28.2
emailservice            Ready    <none>          7m24s   v1.28.2
frontend                Ready    <none>          7m25s   v1.28.2
k8-master               Ready    control-plane   17m     v1.28.2
loadgenerator           Ready    <none>          7m24s   v1.28.2
paymentservice          Ready    <none>          3m40s   v1.28.2
productcatalogservice   Ready    <none>          7m24s   v1.28.2
recommendationservice   Ready    <none>          3m45s   v1.28.2
redis-cart              Ready    <none>          3m44s   v1.28.2
shippingservice         Ready    <none>          3m57s   v1.28.2


13. Install the Calicotool

     
	wget -O calicoctl https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-amd64
	chmod +x calicoctl
	sudo mv calicoctl /usr/local/bin/
	export KUBECONFIG=$HOME/.kube/config
	export DATASTORE_TYPE=kubernetes


14. Check the Status of Nodes 

calicoctl get nodes -o wide

NAME                    ASN       IPV4              IPV6
adservice               (64512)   172.16.30.11/24
cartservice             (64512)   172.16.30.12/24
checkoutservice         (64512)   172.16.30.13/24
currencyservice         (64512)   172.16.30.14/24
emailservice            (64512)   172.16.30.15/24
frontend                (64512)   172.16.30.16/24
k8-master               (64512)   172.16.30.10/24
loadgenerator           (64512)   172.16.30.17/24
paymentservice          (64512)   172.16.30.18/24
productcatalogservice   (64512)   172.16.30.19/24
recommendationservice   (64512)   172.16.30.20/24
redis-cart              (64512)   172.16.30.21/24
shippingservice         (64512)   172.16.30.22/24

15. Get the pods network subnet from every VM and update the following table.



kubectl get pods -o wide -n calico-system  | grep driver         "This is the Network Allocated to VM" 

csi-node-driver-4zrp5                      2/2     Running   2          3d    192.168.4.1     redis-cart              
csi-node-driver-6g9l2                      2/2     Running   2          3d    192.168.84.1    recommendationservice  
csi-node-driver-6ztbm                      2/2     Running   0          3d    192.168.45.0    adservice               
csi-node-driver-cxbpp                      2/2     Running   0          3d    192.168.41.0    frontend                
csi-node-driver-hxj4d                      2/2     Running   0          3d    192.168.155.0   currencyservice         
csi-node-driver-mbrbt                      2/2     Running   2          3d    192.168.158.1   paymentservice          
csi-node-driver-pcmb7                      2/2     Running   0          3d    192.168.83.0    checkoutservice        
csi-node-driver-q4589                      2/2     Running   0          3d    192.168.61.0    shippingservice         
csi-node-driver-rmlk8                      2/2     Running   0          3d    192.168.234.0   cartservice             
csi-node-driver-shgld                      2/2     Running   0          3d    192.168.33.0    k8-master               
csi-node-driver-t7fnw                      2/2     Running   0          3d    192.168.118.0   productcatalogservice   
csi-node-driver-wl92w                      2/2     Running   0          3d    192.168.65.0    emailservice            
csi-node-driver-x54sd                      2/2     Running   0          3d    192.168.42.0    loadgenerator           
elk@k8-master:~$




16. Create the following Static routes in the CX10K's.

ip route < network from step15> <next-hop IP is IPv4 IP from Step14> from each node.

ip route  192.168.4.0/24   172.16.30.21 vrf pod1 
ip route  192.168.33.0/24  172.16.30.10 vrf pod1
ip route  192.168.41.0/24  172.16.30.16 vrf pod1 
ip route  192.168.42.0/24  172.16.30.17 vrf pod1 
ip route  192.168.45.0/24  172.16.30.11 vrf pod1 
ip route  192.168.61.0/24  172.16.30.22 vrf pod1 
ip route  192.168.65.0/24  172.16.30.15 vrf pod1 
ip route  192.168.83.0/24  172.16.30.13 vrf pod1 
ip route  192.168.84.0/24  172.16.30.20 vrf pod1 
ip route  192.168.118.0/24  172.16.30.19 vrf pod1 
ip route  192.168.155.0/24  172.16.30.14 vrf pod1 
ip route  192.168.158.0/24  172.16.30.18 vrf pod1 
ip route  192.168.234.0/24  172.16.30.12 vrf pod1

17. Create LoadBalancer this is optional , we can use the NodeIP too.

kubectl create  -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

vim lb-pool.yaml
*******************************************************************
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: nat
  namespace: metallb-system
spec:
  addresses:
    - 172.16.30.245-172.16.30.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
********************************************************************* 
 kubectl apply -f lb-pool.yaml
 
18. Apply the label to each node.

kubectl label node adservice type=adservice
kubectl label node cartservice type=cartservice
kubectl label node checkoutservice type=checkoutservice
kubectl label node currencyservice type=currencyservice
kubectl label node emailservice type=emailservice
kubectl label node loadgenerator type=loadgenerator
kubectl label node paymentservice type=paymentservice
kubectl label node productcatalogservice type=productcatalogservice
kubectl label node recommendationservice type=recommendationservice
kubectl label node redis-cart type=redis-cart
kubectl label node frontend type=frontend
kubectl label node shippingservice type=shippingservic

19. Deploy the Boutique APP 

kubectl create -f boutique.yaml

20.Check the status of the PODS.

kubectl get pods -o wide
    NAME                                     READY   STATUS    RESTARTS   AGE     IP              NODE                    NOMINATED NODE   READINESS GATES
	adservice-55b7f5c45b-h7r5z               1/1     Running   0          7m29s   192.168.45.1    adservice               <none>           <none>
	cartservice-7d45657c79-wn67f             1/1     Running   0          7m30s   192.168.234.1   cartservice             <none>           <none>
	checkoutservice-c5c6b7c78-b7knv          1/1     Running   0          7m31s   192.168.83.1    checkoutservice         <none>           <none>
	currencyservice-6b47794c8-w42ql          1/1     Running   0          7m30s   192.168.155.1   currencyservice         <none>           <none>
	emailservice-ffc6c99cc-slf6k             1/1     Running   0          7m31s   192.168.65.1    emailservice            <none>           <none>
	frontend-68b9b7b9dc-7tnt9                1/1     Running   0          7m30s   192.168.41.1    frontend                <none>           <none>
	loadgenerator-9d4888654-2dwd2            1/1     Running   0          7m30s   192.168.42.1    loadgenerator           <none>           <none>
	loadgenerator-9d4888654-gzvqx            1/1     Running   0          7m30s   192.168.42.2    loadgenerator           <none>           <none>
	loadgenerator-9d4888654-wr2gq            1/1     Running   0          7m30s   192.168.42.3    loadgenerator           <none>           <none>
	paymentservice-68bddd4c7f-28t6k          1/1     Running   0          7m30s   192.168.158.2   paymentservice          <none>           <none>
	productcatalogservice-76f98fcfcf-vzvzq   1/1     Running   0          7m30s   192.168.118.1   productcatalogservice   <none>           <none>
	recommendationservice-cb455454-gngjt     1/1     Running   0          7m30s   192.168.84.2    recommendationservice   <none>           <none>
	redis-cart-55c5697d86-rmvmd              1/1     Running   0          7m30s   192.168.4.2     redis-cart              <none>           <none>
	shippingservice-5977dbc67c-xz7lh         1/1     Running   0          7m30s   192.168.61.1    shippingservice         <none>           <none>

21.Access the APP from Browser by pointing to Endpoints:

kubectl describe svc frontend
	Name:              frontend
	Namespace:         default
	Labels:            <none>
	Annotations:       <none>
	Selector:          app=frontend
	Type:              ClusterIP
	IP Family Policy:  SingleStack
	IP Families:       IPv4
	IP:                10.111.131.23
	IPs:               10.111.131.23
	Port:              http  80/TCP
	TargetPort:        8080/TCP
	Endpoints:         192.168.41.1:8080


22. If the Client is from remote network, make sure the static routes are advertised across the fabric.

23. Post the IP collection and APP collection to PSM.

24. Edit the IP collection to make sure the Network is same as POD network from Step 13.

25. Post the secutiy policy.

25. To clean up the deployment.
     From Master:
		kubectl delete  -f boutique.yaml   
		kubectl delete  -f custom-resources.yaml
		kubectl delete  -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml
	
	 Run on every Node:
	 
		sudo kubeadm reset cleanup-node 
		sudo rm -rf /etc/cni/net.d
		reboot 
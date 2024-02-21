#!/bin/bash
# The script has been create to set up the machines for testing the CX10K.


connection()
{
  if [ "$1" == "1" ]; then
   export VM_Name="k8-master"
   export ens192="172.16.30.10"
   elif  [ "$1" == "2" ]; then
   export VM_Name="adservice"
   export ens192="172.16.30.11"
   elif  [ "$1" == "3" ]; then
   export VM_Name="cartservice"
   export ens192="172.16.30.12"
   elif  [ "$1" == "4" ]; then
   export VM_Name="checkoutservice"
   export ens192="172.16.30.13"
   elif  [ "$1" == "5" ]; then
   export VM_Name="currencyservice"
   export ens192="172.16.30.14"
   elif  [ "$1" == "6" ]; then
   export VM_Name="emailservice"
   export ens192="172.16.30.15"
   elif  [ "$1" == "7" ]; then
   export VM_Name="frontend"
   export ens192="172.16.30.16"
   elif  [ "$1" == "8" ]; then
   export VM_Name="loadgenerator"
   export ens192="172.16.30.17"
   elif  [ "$1" == "9" ]; then
   export VM_Name="paymentservice"
   export ens192="172.16.30.18"
   elif  [ "$1" == "10" ]; then
   export VM_Name="productcatalogservice"
   export ens192="172.16.30.19"
   elif  [ "$1" == "11" ]; then
   export VM_Name="recommendationservice"
   export ens192="172.16.30.20"
   elif  [ "$1" == "12" ]; then
   export VM_Name="redis-cart	"
   export ens192="172.16.30.21"
   elif  [ "$1" == "13" ]; then
   export VM_Name="shippingservice"
   export ens192="172.16.30.22"
   
   

   elif [ "$1" == "x" ]; then
	  exit 0
  else
    echo "try again"
  fi
}



setmachineid()
{			chars=abcdef1234567890
			prefix=19e2010d4ff249cf

			for i in {1..16} ;
			 do
			    prefix="${prefix}${chars:RANDOM%${#chars}:1}"
			done

			rm /etc/machine-id
			echo ${prefix} > /etc/machine-id
			more /etc/machine-id
			

	}
	
sethostname()
{			rm /etc/hostname
			echo ${VM_Name} > /etc/hostname
	}	
	
	
setnetplan()
{ 		variable="          addresses: [${ens192}/24]"
			escaped_variable=$(printf "%s\n" "$variable" | sed 's/[\&/]/\\&/g')
	  	sed -i.bak "11s/^.*$/$escaped_variable/" /etc/netplan/01-netcfg.yaml
	    more /etc/netplan/01-netcfg.yaml
	}
	
	
command()
{
  if  [ "$1" == "a" ]; then
		setmachineid
		sethostname
		setnetplan
		reboot
		
  elif  [ "$1" == "b" ]; then
  	host=`more /etc/hostname`
  	if  [ "$host" == "k8-master" ]; then
		#		Initialize the K8-cluster from the Master Node
				sudo kubeadm init --apiserver-advertise-address=172.16.30.10 --apiserver-cert-extra-sans=172.16.30.10 --pod-network-cidr=192.168.0.0/16
				i=1
				while [ $i -le 12 ]
					do	
						echo "installing Kubenetes please wait"
						sleep 10
						((i++))
						
				done
				sleep 5s
				mkdir -p $HOME/.kube
		    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
		    sudo chown $(id -u):$(id -g) $HOME/.kube/config
				sleep 5s
		#		Deploy the Calico CNI Plugin
		    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml
		    sleep 5s
		#    Create the Custom Resource for Calico
		    wget https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml
				sed -i.bak "s/- blockSize: 26/- blockSize: 24/" custom-resources.yaml
			  sed -i.bak "s/encapsulation: VXLANCrossSubnet/encapsulation: None/" custom-resources.yaml
		#	  Apply the custom resource file, and check nodes
				kubectl apply -f custom-resources.yaml
		  	kubectl get nodes
		  	sleep 5s
		  	
				#  		Install the Calicotool
				wget -O calicoctl https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-amd64
				chmod +x calicoctl
				sudo mv calicoctl /usr/local/bin/
				export KUBECONFIG=$HOME/.kube/config
				export DATASTORE_TYPE=kubernetes
				sleep 10s

				#			Check the Status of Nodes 
				calicoctl get nodes -o wide
				#			Get the pods network subnet from every VM and update the following table.
				kubectl get pods -o wide -n calico-system  | grep driver
		  	
		  	
		  	
#		  	Get Token.
				echo "The following token is needed to join the kubenetess cluster"
		  	kubeadm token create --print-join-command
		  	
		  	
  	else 
  		echo "copy the value of the token to the to add host to the cluster"
  		read token
  		$token
  	fi

		 elif  [ "$1" == "c" ]; then
  	host=`more /etc/hostname`
  	if  [ "$host" == "k8-master" ]; then
		  	kubeadm token create --print-join-command
		  	
  	else 
  		echo "Run the command on the master"
   	fi
   	
	elif  [ "$1" == "d" ]; then
  	host=`more /etc/hostname`
  	if  [ "$host" == "k8-master" ]; then
		  	kubectl get nodes
		  	
  	else 
  		echo "Run the command on the master"
   	fi	

  elif [ "$1" == "x" ]; then
	  echo "" 
	  x=0
	  exit 0
  else
    echo "try again"
  fi
}
	


deploy()
{
	if  [ "$1" == "m" ]; then
  	host=`more /etc/hostname`
  	if  [ "$host" == "k8-master" ]; then

			echo "Enter the name of the vrf for the routes to be added"
			echo ""
			read z
			vrf=$z


	  	i=1
			 VM_Name_1="k8-master"
			 ens192_1="172.16.30.10"

			 VM_Name_2="adservice"
			 ens192_2="172.16.30.11"

			 VM_Name_3="cartservice"
			 ens192_3="172.16.30.12"

			 VM_Name_4="checkoutservice"
			 ens192_4="172.16.30.13"

			 VM_Name_5="currencyservice"
			 ens192_5="172.16.30.14"

			 VM_Name_6="emailservice"
			 ens192_6="172.16.30.15"

			 VM_Name_7="frontend"
			 ens192_7="172.16.30.16"

			 VM_Name_8="loadgenerator"
			 ens192_8="172.16.30.17"

			 VM_Name_9="paymentservice"
			 ens192_9="172.16.30.18"

			 VM_Name_10="productcatalogservice"
			 ens192_10="172.16.30.19"

			 VM_Name_11="recommendationservice"
			 ens192_11="172.16.30.20"

			 VM_Name_12="redis-cart	"
			 ens192_12="172.16.30.21"

			 VM_Name_13="shippingservice"
			 ens192_13="172.16.30.22"


			echo " now install the following routes in the CX10K."

			while [ $i -le 13 ]
				do	
					
					
					prefixvm="VM_Name_"
					prefixens="ens192_"
					vm_name="${prefixvm}${i}"
					ens_ip="${prefixens}${i}"
					
					sub=`kubectl get pods -o wide -n calico-system  | grep driver | grep ${!vm_name} | cut -d'.' -f 3`
					echo ip route  192.168.${sub}.0/24   ${!ens_ip} vrf ${vrf}
					((i++))
		done


#			echo "Enter IP of CX for the routes to be uploaded "
#			echo ""
#			read a
#			cx=$a
#			echo "Enter CX username "
#			echo ""
#			read u
#			cx=$u
#			echo "Enter CX password "
#			echo ""
#			read p
#			cxpass=$p
#			

  	fi 

  elif  [ "$1" == "n" ]; then
  	host=`more /etc/hostname`
  	if  [ "$host" == "k8-master" ]; then
#  		Install the Calicotool
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
			kubectl label node shippingservice type=shippingservice
	  	sleep 5s
			kubectl create -f ./Micro-Service/demo-micro-service.yaml
	  	sleep 5s
			echo""
			echo""
			kubectl get pods -o wide
	  	sleep 5s
			kubectl describe svc frontend

			
  	else 
  		echo "not on this machine"
  	fi

  elif [ "$1" == "x" ]; then
	  echo "" 
	  x=0
	  exit 0
  else
    echo "try again"
  fi
}


resetd()
{
  if  [ "$1" == "R" ]; then
  	host=`more /etc/hostname`
  	if  [ "$host" == "k8-master" ]; then
			echo "k8-master clean up ."
			echo "Do not run at the same time as clean-up on other nodes.."

			kubectl delete  -f ./Micro-Service/demo-micro-service.yaml   
			sleep 5s
			kubectl delete  -f custom-resources.yaml
			sleep 5s
			kubectl delete  -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml	 
			sleep 5s
			sudo kubeadm reset cleanup-node 
			sudo rm -rf /etc/cni/net.d
			
			
			rm .kube/config
			rm -r $HOME/.kube
     
			reboot 
			
  	else 
			echo "k8-master must be running to clean up the nodes."
			sudo kubeadm reset cleanup-node 
			sudo rm -rf /etc/cni/net.d
			reboot 
  	fi

  elif [ "$1" == "x" ]; then
	  echo "" 
	  x=0
	  exit 0
  else
    echo "try again"
  fi
}
	
	
	
while true ;
do
  echo "cntl-c  or x to exit"
  echo ""    
  echo "Set up Hosts and Deploy Kubernetes (H) or Deploy app (D) or Reset (R)"
	echo "H or D or R"
	read x
  
  clear

  	if  [ "$x" == "H" ]; then
				echo "
		*********************************************************************
		HostID    VM Name                 ens192 address            Pod Network 
		*********************************************************************
		1         k8-master               172.16.30.10/24	
		2         adservice               172.16.30.11/24	
		3         cartservice             172.16.30.12/24	
		4         checkoutservice         172.16.30.13/24	
		5         currencyservice         172.16.30.14/24	
		6         emailservice            172.16.30.15/24	
		7         frontend                172.16.30.16/24	
		8         loadgenerator           172.16.30.17/24	
		9         paymentservice          172.16.30.18/24	
		10        productcatalogservice   172.16.30.19/24	
		11        recommendationservice   172.16.30.20/24	
		12        redis-cart              172.16.30.21/24	
		13        shippingservice         172.16.30.22/24	
		        
		        
		        
		        "
				  echo "cntl-c  or x to exit"
				  echo ""    
				  echo "Enter the host ID you want to setup:"
				  read x
					  connection $x
					  clear
				   while [ $x -ge 1 ] ;
				    do
						  echo ""
							echo " ALL Machines"
						  echo "a - Set Hostname and IP"
						  echo "b - K8 setup"
						  echo ""
							echo "c - Get join key (master only)"
							echo "d - Check nodes (master only)"
						  echo ""
						  echo "x - previous menu"
						  echo ""
						  
						  echo "Command you want to run:"
						  read y
					  	command $y
				  done
  		
	  elif [ "$x" == "D" ]; then
					echo " MASTER ONLY"

				  echo "m - export routes for CX (master only)"
				  echo "n - Deploy app and labels (master only)"
				  echo ""
				  echo ""
				  echo "x - previous menu"
				  echo ""
				  
				  echo "Command you want to run:"
				  read y
					  deploy $y
				    


	  elif [ "$x" == "R" ]; then
				  echo "R - Confirm the host node reset"
 
				  echo ""
				  echo "x - previous menu"
				  echo ""
				  
				  echo "Command you want to run:"
				  read y
					  resetd $y
				    

	  elif [ "$x" == "x" ]; then
				break


  	else
    	echo "try again"
  	fi

done   


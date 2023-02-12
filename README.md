# Kubernetes_Cluster

kubeadm을 이용하여 Kubernetes Cluster을 구성하는 스크립트 작성

----
## 구성 환경
### (On-Premise) Server 
- Ubuntu 22.04.1 LTS
- 2CPU Cores (최소 2CPU 이상 요구)
- 4GB RAM (최소 2GB RAM 이상 요구)
- 80GB Storage

### Architecture
- 1 Master Node
- 3 Worker Node

### CNI (Container Network Interface)
- [Calico](https://docs.tigera.io/calico/3.25/about/)

![image](https://user-images.githubusercontent.com/31979193/218313468-24edced6-c239-4e48-b76b-90e7a15898a9.png)



## 설치 방법
### 1. Server 설정
- 스크립트 권한 설정  
`sudo chmod a+x setting-server.sh`
- Server 설정 스크립트 실행  
`./setting-server.sh`

#### (Note)
- 설정할 hostname을 입력해줘야 한다  
![image](https://user-images.githubusercontent.com/31979193/218313718-5513e776-3f3e-4a27-87e2-ac91aa1f43b1.png)  
- 설정할 서버들의 이름은 서로 구별되어야 한다.


## 2. runtime crio 설치
> Kubernetes 1.20.10부터 Docker 지원 중지  
> 이에 따라, crio로 구성하도록 변경   

- 스크립트 권한 설정  
`sudo chmod a+x install-crio.sh`
- crio 설치 스크립트 실행  
`./install-crio.sh` 

### (Reference)
- [Docker 지원 중지에 대한 Kubernetes 공식 입장문](https://kubernetes.io/blog/2020/12/02/dont-panic-kubernetes-and-docker/)
- [crio 설치 방법](https://github.com/cri-o/cri-o/blob/main/install.md)


## 3. kubeadm 설치
**kubeadm은 Kubernetes Cluster을 구성해주는 배포 도구이다.**   
Kubeadm외에도 kops(Kubernetes Operations), KRIB(Kubernetes Rebar Integrated Bootstrap)등이 있지만, 공식에서 언급하는 kubeadm을 이용하여 구성할 예정이다.

- 스크립트 권한 설정  
`sudo chmod a+x install-crio.sh`
- crio 설치 스크립트 실행  
`./install-crio.sh` 

### (Reference)
- [Kubeadm 설치 방법](https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

### (Note)
- Swap 메모리를 제거하는 과정이 포함되어 있다 (공식 요구)


## 4. Cluster 생성
- (Master Node) Master Node 초기화 작업 수행  
`<ip-addr>`: Master Node의 ip 주소 입력
```
sudo kubeadm init --apiserver-advertise-address=<ip-addr> \  
--pod-network-cidr=192.168.0.0/16 \ 
--cri-socket unix:///var/run/crio/crio.sock
```

- (Master Node) root 계정이 아닌 사용자도 Kubectl 사용할 수 있도록 설정
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

- (Worker Node) Worker Node 초기화 작업 수행  
Master Node 초기화 완료시 생성된 명령어 수행
```
kubeadm join <master-ip-addr> \
--token <token-value> \
--discovery-token-ca-cert-hash <ca-cert-value> \
--cri-socket unix:///var/run/crio/crio.sock
```

- (Master) CNI 설정
```
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml
```

- (Master) Kubectl 자동 완성 설정
```
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

alias k=kubectl
complete -o default -F __start_kubectl k
```

### Reference
- [kubeadm으로 클러스터 생성](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
- [Calico 설치 방법](https://docs.tigera.io/calico/3.25/getting-started/kubernetes/quickstart)
- [kubectl 치트 시트](https://kubernetes.io/ko/docs/reference/kubectl/cheatsheet/)
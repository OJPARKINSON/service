# Check to see if we can use ash, in Alpine images, or default to BASH.
SHELL_PATH = /bin/ash
SHELL = $(if $(wildcard $(SHELL_PATH)),/bin/ash,/bin/bash)

run:
	go run api/services/sales/main.go | go run api/tooling/logfmt/main.go

tidy:
	go mod tidy
	go mod vendor

# ==============================================================================
# Install dependencies

dev-gotooling:
	go install github.com/divan/expvarmon@latest
	go install github.com/rakyll/hey@latest
	go install honnef.co/go/tools/cmd/staticcheck@latest
	go install golang.org/x/vuln/cmd/govulncheck@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

dev-brew:
	brew update
	brew list kind || brew install kind
	brew list kubectl || brew install kubectl
	brew list kustomize || brew install kustomize
	brew list pgcli || brew install pgcli
	brew list watch || brew install watch
	brew list protobuf || brew install protobuf
	brew list grpcurl || brew install grpcurl

dev-apt:
	sudo apt-get update
	which kind || (curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64 && chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind)
	which kubectl || (curl -LO "https://dl.k8s.io/release/$$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl && sudo mv kubectl /usr/local/bin/)
	which kustomize || (curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && sudo mv kustomize /usr/local/bin/)
	which pgcli || sudo apt-get install -y pgcli
	which watch || sudo apt-get install -y procps
	which protoc || sudo apt-get install -y protobuf-compiler
	which grpcurl || (GRPCURL_VER=$$(curl -sSL https://api.github.com/repos/fullstorydev/grpcurl/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | tr -d 'v') && curl -sSL https://github.com/fullstorydev/grpcurl/releases/download/v$${GRPCURL_VER}/grpcurl_$${GRPCURL_VER}_linux_x86_64.tar.gz | sudo tar -xz -C /usr/local/bin grpcurl)

dev-docker:
	docker pull docker.io/$(GOLANG) & \
	docker pull docker.io/$(ALPINE) & \
	docker pull docker.io/$(KIND) & \
	docker pull docker.io/$(POSTGRES) & \
	docker pull docker.io/$(GRAFANA) & \
	docker pull docker.io/$(PROMETHEUS) & \
	docker pull docker.io/$(TEMPO) & \
	docker pull docker.io/$(LOKI) & \
	docker pull docker.io/$(PROMTAIL) & \
	wait;
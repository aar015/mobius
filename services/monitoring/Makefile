.PHONY: build

build: ## Build manifests in a podman container
	podman run -it --rm -w / \
		-v ./src:/src:z \
		-v ./vars.jsonnet:/src/vars.jsonnet:z \
		-v ./manifests:/output:z \
		golang bash -c "\
		rm -rf output/* && \
		mkdir work && \
		cp -r src/* work && \
		cd work && \
		make vendor && make && \
		cp -r manifests/* ../output"

deploy: ## Deploy current manifests to configured cluster
	echo "Deploying stack setup manifests..."
	kubectl apply -f ./manifests/setup/
	echo "Will wait 10 seconds to deploy the additional manifests.."
	sleep 10
	kubectl apply -f ./manifests/

teardown: ## Delete all monitoring stack resources from configured cluster
	kubectl delete -f ./manifests/
	kubectl delete -f ./manifests/setup/
REPO=blacktop/logstash
ORG=blacktop
NAME=logstash
# build info
LATEST?=$(shell cat LATEST)
BUILD?=$(LATEST)
BUILDS=$(LATEST) 7.8 7.7 6.8 5.6 x-pack

all: update build size test

.PHONY: update
update:
	$(foreach build,$(BUILDS),NAME=$(NAME) BUILD=$(build) $(MAKE) dockerfile;)

.PHONY: dockerfile
dockerfile: ## Update Dockerfiles
	hack/make/dockerfile

.PHONY: build
build: ## Build docker image
	cd $(BUILD); docker build -t $(ORG)/$(NAME):$(BUILD) .

.PHONY: size
size: build ## Get built image size
ifeq "$(BUILD)" "$(LATEST)"
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD)| cut -d' ' -f1)-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md
endif
	sed -i.bu '/$(BUILD)/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md

.PHONY: tag
tag:
	@echo "===> Creating Tags"
	$(foreach build,$(BUILDS),BUILD=$(build) hack/make/release;)

.PHONY: test
test: stop ## Test docker image
	docker run -it --rm --name $(NAME) $(ORG)/$(NAME):$(BUILD) logstash -e 'input { http { } } output { stdout { codec => line { format => "%{message}" }} }'

.PHONY: tar
tar: ## Export tar of docker image
	docker save $(ORG)/$(NAME):$(BUILD) -o $(NAME).tar

.PHONY: push
push: build ## Push docker image to docker registry
	@echo "===> Pushing $(ORG)/$(NAME):$(BUILD) to docker hub..."
	@docker push $(ORG)/$(NAME):$(BUILD)

.PHONY: run
run: stop ## Run docker container
	@docker run -d --name $(NAME) -p 5044:5044 $(ORG)/$(NAME):$(BUILD)

.PHONY: ssh
ssh: ## SSH into docker image
	@docker run --init -it --rm --entrypoint=sh $(ORG)/$(NAME):$(BUILD)

.PHONY: stop
stop: ## Kill running docker containers
	@docker rm -f $(NAME) || true

.PHONY: circle
circle: ci-size ## Get docker image size from CircleCI
	@sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell cat .circleci/SIZE)-blue/' README.md
	@echo "===> Image size is: $(shell cat .circleci/SIZE)"

ci-build:
	@echo "===> Getting CircleCI build number"
	@http https://circleci.com/api/v1.1/project/github/${REPO} | jq '.[0].build_num' > .circleci/build_num

ci-size: ci-build
	@echo "===> Getting image build size from CircleCI"
	@http "$(shell http https://circleci.com/api/v1.1/project/github/${REPO}/$(shell cat .circleci/build_num)/artifacts circle-token==${CIRCLE_TOKEN} | jq '.[].url')" > .circleci/SIZE

.PHONY: clean
clean: ## Clean docker image and stop all running containers
	docker-clean stop
	docker rmi $(ORG)/$(NAME):$(BUILD) || true

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

AWS_PROFILE := personal
VAULT_CMD := aws-vault exec $(AWS_PROFILE) --
# TF_CMD := $$GOPATH/bin/terraform
TF_CMD := terraform
CMD := $(VAULT_CMD) $(TF_CMD)
ENV := $(shell basename $$PWD)

check:
	$(TF_CMD) fmt -diff -recursive
	$(TF_CMD) validate

init:
	$(CMD) init
	# $(CMD) init --backend-config=backend.tfvars

plan:
	$(CMD) plan -out=$(ENV).tfplan -var-file=$(ENV).tfvars

apply:
	$(CMD) apply $(ENV).tfplan

destroy:
	$(CMD) destroy -var-file=$(ENV).tfvars

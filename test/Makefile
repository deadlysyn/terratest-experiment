AWS_PROFILE := personal
REGION := us-east-2
VAULT_CMD := aws-vault exec $(AWS_PROFILE) --
# TF_CMD := $$GOPATH/bin/terraform
TF_CMD := terraform

export TF_DATA_DIR ?= $(CURDIR)/.terraform
export TF_CLI_ARGS_init ?= -get-plugins=true

init:
	cd src && go mod init test

tidy:
	cd src && go mod tidy

test:
	$(TF_CMD) fmt --write=false -check -diff -recursive ..
	cd src && $(VAULT_CMD) go test -v -timeout 30m

clean:
	cd src && rm -rf $(TF_DATA_DIR) go.mod go.sum


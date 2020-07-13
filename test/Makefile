export TF_DATA_DIR ?= $(CURDIR)/.terraform
export TF_CLI_ARGS_init ?= -get-plugins=true

init:
	cd src && go mod init test

tidy:
	cd src && go mod tidy

test:
	terraform fmt --write=false -check -diff -recursive ..
	cd src && go test -v -timeout 30m

clean:
	cd src && rm -rf $(TF_DATA_DIR)

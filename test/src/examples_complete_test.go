package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		VarFiles:     []string{"fixtures.us-east-2.tfvars"},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	availabilityZones := terraform.OutputList(t, terraformOptions, "availability_zones")
	for _, az := range availabilityZones {
		assert.True(t, strings.HasPrefix(az, "us-east-2"))
	}

	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	assert.True(t, strings.HasPrefix(vpcID, "vpc-"))

	deploymentSubnets := terraform.OutputList(t, terraformOptions, "subnet_ids")
	for _, s := range deploymentSubnets {
		assert.False(t, aws.IsPublicSubnet(t, s, "us-east-2"))
	}

	// ...
}

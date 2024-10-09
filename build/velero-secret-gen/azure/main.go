package main

import (
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"

	"gopkg.in/yaml.v3"
)

var sealedSecretJSONFile = "credentials-velero.json"

type azureConfig struct {
	AzureSubID         string
	AzureTenantID      string
	AzureClientID      string
	AzureClientSecret  string
	AzureResourceGroup string
	AzureCloudName     string
}

type accountConfig struct {
	Id       string `json:"id"`
	TenantId string `json:"tenantId"`
}

type appConfig struct {
	AppId       string `json:"appId"`
	DisplayName string `json:"displayName"`
}

type groupConfig struct {
	Id         string      `json:"id"`
	Location   string      `json:"location"`
	ManagedBy  interface{} `json:"managedBy"`
	Name       string      `json:"name"`
	Properties struct {
		ProvisioningState string `json:"provisioningState"`
	} `json:"properties"`
	Tags map[string]string `json:"tags"`
	Type string            `json:"type"`
}

type secret struct {
	APIVersion string `yaml:"apiVersion"`
	Kind       string `yaml:"kind"`
	Metadata   struct {
		Name      string `yaml:"name"`
		Namespace string `yaml:"namespace"`
	} `yaml:"metadata"`
	Type string `yaml:"type"`
	Data struct {
		Cloud string `yaml:"cloud"`
	} `yaml:"stringData"`
}

func main() {
	// make sure valid cluster context is set
	log.Println("Please make sure you have the correct Azure cluster context set locally. i.e. kubectl is pointing at the right cluster.")

	clientSecret := flag.String("client-secret", "", "Client secret for the Velero client/app ID")
	clusterName := flag.String("cluster-name", "", "Name of the cluster")
	azExecPath := flag.String("az-exec-path", "az", "Path to the az executable")
	kubesealExecPath := flag.String("kubeseal-exec-path", "kubeseal", "Path to the kubeseal executable")
	help := flag.Bool("help", false, "Show help")
	flag.Parse()

	// print help if help flag is set
	if *help {
		flag.Usage()
		return
	}

	if *clientSecret == "" || *clusterName == "" {
		flag.Usage()

		log.Printf("missing required flags")
	}

	// check if az cli is installed
	// az --version
	log.Println("Checking if az cli is installed...")
	_, err := exec.Command("bash", "-c", "command -v az").Output()
	if err != nil {
		log.Printf("az cli is not installed: %v\n", err)

		return
	}

	// check if kubeseal is installed
	// kubeseal --version
	log.Println("Checking if kubeseal is installed...")
	_, err = exec.Command("bash", "-c", "command -v kubeseal").Output()
	if err != nil {
		log.Printf("kubeseal is not installed: %v\n", err)

		return
	}

	// check if az cli is logged in
	// az account show
	log.Println("Checking if az cli is logged in...")
	_, err = runCmd(*azExecPath, "account", "show")
	if err != nil {
		log.Printf("az cli is not logged in")

		return
	}

	log.Println("reading azure config...")
	azureCfg, err := readAzureConfig(*clientSecret, *azExecPath, *clusterName)
	if err != nil {
		log.Printf("error reading azure config: %v\n", err)

		return
	}

	// generated local secret.yaml file
	log.Println("generating sealed secret resource...")
	err = generateSecretResource(azureCfg, *kubesealExecPath)
	if err != nil {
		log.Printf("error generating secret resource: %v\n", err)

		return
	}

	log.Println("DONE! Please apply the sealed secret resource to the cluster located at kubeaid/build/velero-secret-gen/credentials-velero.json")
}

func generateSecretResource(azureCfg *azureConfig, kubesealExecPath string) error {
	// create yaml file
	// write to file

	s := &secret{
		APIVersion: "v1",
		Kind:       "Secret",
		Type:       "Opaque",
	}

	s.Metadata.Name = "credentials-velero"
	s.Metadata.Namespace = "velero"

	s.Data.Cloud = fmt.Sprintf("AZURE_SUBSCRIPTION_ID=%s\nAZURE_TENANT_ID=%s\nAZURE_CLIENT_ID=%s\nAZURE_CLIENT_SECRET=%s\nAZURE_RESOURCE_GROUP=%s\nAZURE_CLOUD_NAME=%s", azureCfg.AzureSubID, azureCfg.AzureTenantID, azureCfg.AzureClientID, azureCfg.AzureClientSecret, azureCfg.AzureResourceGroup, azureCfg.AzureCloudName)

	data, err := yaml.Marshal(s)
	if err != nil {
		return errors.New("error marshalling secret yaml")
	}

	// creating tmp file to store secret.yaml file
	tmpDir := os.TempDir()
	veleroSecretYamlFile := fmt.Sprintf("%s/%s", tmpDir, "velero-secret.yaml")

	defer func(name string) {
		err = os.Remove(name)
		if err != nil {
			log.Printf("error removing tmp file: %v\n", err)
		}
	}(veleroSecretYamlFile)

	err = os.WriteFile(veleroSecretYamlFile, data, 0644)

	if err != nil {
		return errors.New("error writing secret yaml file")
	}

	// sealing the secret
	_, err = runCmd(kubesealExecPath, "--controller-namespace", "system", "--controller-name", "sealed-secrets", "-f", veleroSecretYamlFile, "-w", sealedSecretJSONFile)
	if err != nil {
		return errors.New("error running kubeseal")
	}

	return nil
}

func readAzureConfig(clientSecret, azExecPath, clusterName string) (*azureConfig, error) {
	azureCfg := new(azureConfig)

	errChan := make(chan error, 3)
	//var cfgErr error

	go func(azureCfg *azureConfig) {
		errChan <- getTenantAndSubID(azExecPath, azureCfg)
	}(azureCfg)

	go func(azureCfg *azureConfig) {
		errChan <- getClientID(azExecPath, azureCfg)
	}(azureCfg)

	go func(clusterName string, azureCfg *azureConfig) {
		errChan <- getResourceGroup(clusterName, azExecPath, azureCfg)
	}(clusterName, azureCfg)

	goRoutinesCount := 3

	for err := range errChan {
		goRoutinesCount--

		if err != nil {
			return nil, err
		}

		if goRoutinesCount == 0 {
			break
		}
	}

	azureCfg.AzureCloudName = "AzurePublicCloud"
	azureCfg.AzureClientSecret = clientSecret

	return azureCfg, nil
}

func getTenantAndSubID(azExecPath string, config *azureConfig) error {
	// get tenant ID
	// az account show
	out, err := runCmd(azExecPath, "account", "show")
	if err != nil {
		return errors.New("error getting tenant and subscription ID")
	}

	accCfg := new(accountConfig)

	err = json.Unmarshal(out, accCfg)
	if err != nil {
		return errors.New("error unmarshalling account config")
	}

	config.AzureTenantID = accCfg.TenantId
	config.AzureSubID = accCfg.Id

	return nil
}

func getClientID(azExecPath string, config *azureConfig) error {
	// get client ID
	// az ad app list
	out, err := runCmd(azExecPath, "ad", "app", "list")
	if err != nil {
		return errors.New("error getting client ID")
	}

	appCfg := make([]*appConfig, 0)

	err = json.Unmarshal(out, &appCfg)
	if err != nil {
		return errors.New("error unmarshalling app config")
	}

	veleroApp := new(appConfig)
	for _, app := range appCfg {
		if app.DisplayName == "velero" {
			veleroApp = app
			break
		}
	}

	config.AzureClientID = veleroApp.AppId

	return nil
}

func getResourceGroup(clusterName, azExecPath string, config *azureConfig) error {
	// get resource group
	// az group list and use subscription id to get name
	out, err := runCmd(azExecPath, "group", "list")
	if err != nil {
		return errors.New("error getting resource group")
	}

	groupCfg := make([]*groupConfig, 0)

	err = json.Unmarshal(out, &groupCfg)
	if err != nil {
		return errors.New("error unmarshalling group config")
	}

	resourceGroup := ""

	for _, group := range groupCfg {
		if val, ok := group.Tags["aks-managed-cluster-name"]; ok && val == clusterName {
			resourceGroup = group.Name
			break
		}
	}

	if resourceGroup == "" {
		return errors.New("unable to find resource group")
	}

	config.AzureResourceGroup = resourceGroup

	return nil
}

func runCmd(args ...string) ([]byte, error) {
	cmd := exec.Command(args[0], args[1:]...)
	cmd.Stderr = os.Stderr

	out, err := cmd.Output()

	return out, err
}

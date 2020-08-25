/*
Copyright © 2020 NAME HERE <EMAIL ADDRESS>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"context"
	"fmt"
	"github.com/spf13/cobra"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"os"
	"os/exec"
	"strings"
)

var configmap string
var dashboard string
var namespace string
var libs string

const jsonnetExe = "/usr/local/bin/jsonnet"

// runCmd represents the run command
var runCmd = &cobra.Command{
	Use:   "run",
	Short: "generate json to configmap",
	Long:  "generate json to configmap",
	RunE: func(cmd *cobra.Command, args []string) error {
		return runCommand()
	},
}

func init() {
	rootCmd.AddCommand(runCmd)

	runCmd.Flags().StringVarP(&configmap, "configmap", "c", "cms-model", "name of configmap")
	runCmd.Flags().StringVarP(&namespace, "namespace", "n", "monitor", "namespace of configmap")
	runCmd.Flags().StringVarP(&dashboard, "dashboard", "d", "", "list of dashboard name")
	runCmd.Flags().StringVarP(&libs, "libs", "l", "libs", "libs of jsonnet")
}

func runCommand() error {
	newClient := LoadClient()
	cmsConfigmap, err := newClient.CoreV1().ConfigMaps(namespace).Get(context.TODO(), configmap, metav1.GetOptions{})
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	updateConfigMap(cmsConfigmap, newClient)
	return nil
}

func updateConfigMap(configmap *v1.ConfigMap, client *kubernetes.Clientset) {
	if dashboard == "" {
		fmt.Println("please input dashboard name")
		os.Exit(0)
	} else {
		data := make(map[string]string)
		dashboards := strings.Split(dashboard, ",")
		for _, name := range dashboards {
			key := fmt.Sprintf("%s.json", name)
			data[key] = generateJSON(name)
		}
		configmap.Data = data
		cmsConfigmap, err := client.CoreV1().ConfigMaps(namespace).Update(context.TODO(), configmap, metav1.UpdateOptions{})
		if err != nil {
			fmt.Println(err.Error())
			os.Exit(1)
		} else {
			fmt.Printf("configmap: %s update success!\nnamespace:%s\n", cmsConfigmap.Name, cmsConfigmap.Namespace)
		}
	}

}
func generateJSON(name string) string {
	name = fmt.Sprintf("/workspace/%s/%s.jsonnet", libs, name)
	cmd := commandJsonnet(name)
	//cmd.Run()
	jsonData, err := cmd.CombinedOutput()
	if err != nil {
		fmt.Println(jsonData)
		os.Exit(1)
	}
	fmt.Printf("generate %s\n",name)
	return string(jsonData)
}

func commandJsonnet(name string) *exec.Cmd {
	return exec.Command(
		jsonnetExe,
		"-J", "grafonnet-lib",
		name,
	)
}

func LoadClient() *kubernetes.Clientset {
	// creates the in-cluster config
	config, err := rest.InClusterConfig()
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	// creates the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	return clientset
}

local p = import '../params.libsonnet';
local params = p.components.atlantis;
local component  = 'atlantis';


[
  {
    "kind": "StatefulSet",
    "apiVersion": "apps/v1",
    "metadata": {
      "name": "atlantis"
    },
    "spec": {
      "serviceName": "atlantis",
      "selector": {
        "matchLabels": {
          "component": "atlantis"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "component": "atlantis"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "atlantis",
              "image": params.repository + ":" + params.tag,
              "env": [
                {
                "name": "POSTGRES_USER",
                "value": "postgres"
                },
                 {
                "name": "POSTGRES_PASSWORD",
                "value": "postgres"
                },
                 {
                "name": "POSTGRES_DB",
                "value": "news"
                },
              ],
              "ports": [
                {
                  "containerPort":4141
                }
              ]
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "atlantis"
    },
    "spec": {
      "selector": {
        "component": "atlantis"
      },
      "ports": [
        {
          "name": "atlantis",
          "targetPort": 4141,
          "port": 4141
        }
      ]
    }
  }
]

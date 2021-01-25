public enum MethodMap {
  // Using a static variable instead of file for now.
  // TODO: Move it to a file and fix issue accessing json file.
  /// :nodoc:
  public static var methodMapJSON = """
  [
    {
        "methodName" : "addGlobalHeader" ,
        "arguments" : [
            {
                "argumentName" : "headerName" ,
                "argumentType" : "String"
            },
            {
                "argumentName" : "headerValue" ,
                "argumentType" : "String"
            }
        ]
    },
    {
        "methodName" : "removeGlobalHeader" ,
        "arguments" : [
            {
                "argumentName" : "headerName" ,
                "argumentType" : "String"
            }
        ]
    },
    {
        "methodName" : "setServerUrl" ,
        "arguments" : [
            {
                "argumentName" : "serverUrl" ,
                "argumentType" : "String"
            }
        ]
    },
    {
        "methodName" : "getServerUrl",
        "arguments" : []
    },
    {
        "methodName" : "setDeviceDisplayName",
        "arguments" : [
            {
            "argumentName" : "deviceDisplayName" ,
            "argumentType" : "String"
        }
        ]
    },
    {
        "methodName" : "getDeviceDisplayName",
        "arguments" : []
    },
    {
        "methodName" : "setHeartbeatInterval",
        "arguments" : [
            {
            "argumentName" : "heartbeatIntervalInSeconds",
            "argumentType" : "Int"
        }
        ]
    },
    {
        "methodName" : "pinTrustedCertificatesPublicKey",
        "arguments" : [
            {
            "argumentName" : "certificateFileNames",
            "argumentType" : "Array<String>"
        }
        ]
    },
    {
        "methodName" : "registerChallengeHandler" ,
        "arguments" : [
            {
                "argumentName" : "securityCheckName" ,
                "argumentType" : "String"
            }
        ]
    },
    {
        "methodName" : "submitChallengeAnswer" ,
        "arguments" : [
            {
                "argumentName" : "securityCheckName" ,
                "argumentType" : "String"
            },
            {
                "argumentName" : "answer" ,
                "argumentType" : "NSDictionary"
            }
        ]
    },
    {
        "methodName" : "cancelChallenge" ,
        "arguments" : [
            {
                "argumentName" : "securityCheckName" ,
                "argumentType" : "String"
            }
        ]
    },
    {
           "methodName" : "obtainAccessToken" ,
           "arguments" : [
               {
                   "argumentName" : "scope" ,
                   "argumentType" : "String"
               }
           ]
    },
    {
        "methodName" : "init" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "url" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "timeout" ,
                   "argumentType" : "NSNumber"
               },
               {
                   "argumentName" : "scope" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "send" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "sendWithJSON" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "json" ,
                   "argumentType" : "NSDictionary"
               }
           ]
       },
       {
           "methodName" : "sendWithFormParameters" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "parameters" ,
                   "argumentType" : "NSDictionary"
               }
           ]
       },
       {
           "methodName" : "sendWithRequestBody" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "body" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "getMethod" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "addHeader" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "headerName" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "headerValue" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "setQueryParameters" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "paramName" ,
                   "argumentType" : "String"
                },
                {
                   "argumentName" : "paramValue" ,
                   "argumentType" : "String"
                }
           ]
       },
       {
           "methodName" : "getQueryParameters" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "getQueryString" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "getAllHeaders" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "getHeaders" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "headerName" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "setHeaders" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "headers" ,
                   "argumentType" : "NSDictionary"
               }
           ]
       },
       {
           "methodName" : "removeHeaders" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "headerName" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "setTimeout" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               },
               {
                   "argumentName" : "timeout" ,
                   "argumentType" : "NSNumber"
               }
           ]
       },
       {
           "methodName" : "getTimeout" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
           "methodName" : "getUrl" ,
           "arguments" : [
               {
                   "argumentName" : "uuid" ,
                   "argumentType" : "String"
               }
           ]
       },
       {
        "methodName" : "clearAccessToken" ,
        "arguments" : [
              {
                  "argumentName" : "accessToken",
                  "argumentType" : "NSDictionary"
              }
          ]
    },
    {
        "methodName" : "login" ,
        "arguments" : [
            {
                "argumentName" : "securityCheck" ,
                "argumentType" : "String"
            },
            {
                "argumentName" : "credentials",
                "argumentType" : "Array"
            }
        ]
    },
    {
        "methodName" : "logout" ,
        "arguments" : [
            {
                "argumentName" : "securityCheck" ,
                "argumentType" : "String"
            }
        ]
    },
    {
        "methodName" : "setLoginTimeOut" ,
        "arguments" : [
            {
                "argumentName" : "timeOut" ,
                "argumentType" : "NSNumber"
            }
        ]
    },
    {
        "methodName" : "isAuthorizationRequired" ,
        "arguments" : [
            {
                "argumentName" : "status" ,
                "argumentType" : "Int"
            },
            {
                "argumentName" : "headers",
                "argumentType" : "Array"
            }
        ]
    },
    {
        "methodName" : "getAuthorizationServerUrl",
        "arguments" : []
    },
    {
        "methodName" : "setAuthorizationServerUrl",
        "arguments" : [
            {
                "argumentName" : "url",
                "argumentType" : "String"
            }
        ]
    },
    {
      "methodName": "Logger.setLevel",
      "arguments": [
        {
          "argumentName": "level",
          "argumentType": "String"
        }
      ]
    },
    {
      "methodName": "Logger.getLevel",
      "arguments": []
    },
    {
      "methodName": "Logger.updateConfigFromServer",
      "arguments": []
    },
    {
      "methodName": "Logger.send",
      "arguments": []
    },
    {
      "methodName": "Logger.setCapture",
      "arguments": [
        {
          "argumentName": "flag",
          "argumentType": "Bool"
        }
      ]
    },
    {
      "methodName": "Logger.getCapture",
      "arguments": []
    },
    {
      "methodName": "Logger.setMaxFileSize",
      "arguments": [
        {
          "argumentName": "bytes",
          "argumentType": "Int32"
        }
      ]
    },
    {
      "methodName": "Logger.getMaxFileSize",
      "arguments": []
    },
    {
      "methodName": "Logger.trace",
      "arguments": [
        {
          "argumentName": "packageName",
          "argumentType": "String"
        },
        {
          "argumentName": "message",
          "argumentType": "String"
        },
        {
          "argumentName": "metadata",
          "argumentType": "NSDictionary"
        }
      ]
    },
    {
      "methodName": "Logger.debug",
      "arguments": [
        {
          "argumentName": "packageName",
          "argumentType": "String"
        },
        {
          "argumentName": "message",
          "argumentType": "String"
        },
        {
          "argumentName": "metadata",
          "argumentType": "NSDictionary"
        }
      ]
    },
    {
      "methodName": "Logger.log",
      "arguments": [
        {
          "argumentName": "packageName",
          "argumentType": "String"
        },
        {
          "argumentName": "message",
          "argumentType": "String"
        },
        {
          "argumentName": "metadata",
          "argumentType": "NSDictionary"
        }
      ]
    },
    {
      "methodName": "Logger.info",
      "arguments": [
        {
          "argumentName": "packageName",
          "argumentType": "String"
        },
        {
          "argumentName": "message",
          "argumentType": "String"
        },
        {
          "argumentName": "metadata",
          "argumentType": "NSDictionary"
        }
      ]
    },
    {
      "methodName": "Logger.warn",
      "arguments": [
        {
          "argumentName": "packageName",
          "argumentType": "String"
        },
        {
          "argumentName": "message",
          "argumentType": "String"
        },
        {
          "argumentName": "metadata",
          "argumentType": "NSDictionary"
        }
      ]
    },
    {
      "methodName": "Logger.error",
      "arguments": [
        {
          "argumentName": "packageName",
          "argumentType": "String"
        },
        {
          "argumentName": "message",
          "argumentType": "String"
        },
        {
          "argumentName": "metadata",
          "argumentType": "NSDictionary"
        }
      ]
    },
    {
      "methodName": "Logger.fatal",
      "arguments": [
        {
          "argumentName": "packageName",
          "argumentType": "String"
        },
        {
          "argumentName": "message",
          "argumentType": "String"
        },
        {
          "argumentName": "metadata",
          "argumentType": "NSDictionary"
        }
      ]
    }
  ]
  """
}

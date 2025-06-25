replicaCount: 2

image:
  repository: ${repository}
  tag: latest

containerPort: 8000

config:
  allowedHosts: "*"

secrets:
  databaseUrl: "postgres://${db_user}:${db_password}@${rds_endpoint}/db_name"
  username: ${db_user}
  password: ${db_password}
  secretKey : ${secret_key}

hpa:
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 50
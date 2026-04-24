# GCP Terraform Modules

**Autor**: Elmon (Elmon)

Colección de módulos de Terraform profesionales y reutilizables para provisionar infraestructura en Google Cloud Platform (GCP). Diseñados para ser usados en múltiples repositorios y proyectos.

## 📋 Tabla de Contenidos

- [Estructura del Proyecto](#estructura-del-proyecto)
- [Requisitos](#requisitos)
- [Módulos Disponibles](#módulos-disponibles)
- [Quick Start](#quick-start)
- [Ejemplos de Uso](#ejemplos-de-uso)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Contribuciones](#contribuciones)

---

## 📁 Estructura del Proyecto

```
gcp-terraform-modules/
├── vpc/                    # Virtual Private Cloud
├── gke/                    # Google Kubernetes Engine
├── cloud_sql/              # Cloud SQL (Managed Database)
├── cloud_nat/              # Cloud NAT (Network Address Translation)
├── cloud_run/              # Cloud Run (Serverless Containers)
├── cloud_armor/            # Cloud Armor (DDoS Protection & WAF)
├── bucket/                 # Cloud Storage Buckets
├── external_lb/            # External Load Balancer
├── psc/                    # Private Service Connection
└── apigee/                 # Google Apigee (API Management)
```

---

## Requisitos

- Terraform >= 1.0
- Google Provider >= 5.0
- Proyecto de GCP configurado
- Credenciales de GCP (`gcloud auth application-default login`)

```bash
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
```

---

## 🚀 Módulos Disponibles

### 1. VPC (Virtual Private Cloud)

**Descripción**: Crear y gestionar redes VPC con subnets en múltiples regiones.

**Características**:
- ✅ Creación de VPC
- ✅ Múltiples subnets en diferentes regiones
- ✅ Rangos IP secundarios (para GKE)
- ✅ VPC Flow Logs
- ✅ Google Private Access
- ✅ Etiquetado automático

**Variables principales**:
```hcl
module "vpc" {
  source = "./vpc"
  
  project_id                = "my-project"
  vpc_name                  = "my-vpc"
  auto_create_subnetworks   = false
  routing_mode              = "REGIONAL"
  
  subnets = [
    {
      name            = "subnet-us"
      region          = "us-central1"
      ip_cidr_range   = "10.0.0.0/20"
      private_ip_google_access = true
      enable_flow_logs = false
    }
  ]
  
  labels = {
    environment = "production"
    team        = "platform"
  }
}
```

**Outputs**:
- `network_name` - Nombre de la VPC
- `network_id` - ID de la VPC
- `subnets` - Mapa de subnets con detalles
- `subnet_ids` - Lista de IDs de subnets

---

### 2. GKE (Google Kubernetes Engine)

**Descripción**: Provisionar clusters de Kubernetes administrados.

**Características**:
- ✅ Clusters de GKE
- ✅ Node pools con autoscaling
- ✅ Nodos preemptibles
- ✅ Shielded GKE Nodes
- ✅ Network Policy
- ✅ IP Alias para rangos secundarios

**Variables principales**:
```hcl
module "gke" {
  source = "./gke"
  
  project_id     = "my-project"
  cluster_name   = "my-cluster"
  location       = "us-central1-a"
  network_name   = "my-vpc"
  subnetwork_name = "my-subnet"
  
  initial_node_count      = 3
  machine_type            = "n1-standard-2"
  preemptible_nodes       = true
  enable_autoscaling      = true
  min_node_count          = 1
  max_node_count          = 10
  
  enable_shielded_nodes   = true
  enable_ip_alias         = true
  cluster_secondary_range_name  = "pods"
  services_secondary_range_name = "services"
  release_channel         = "REGULAR"
  
  labels = {
    environment = "production"
  }
}
```

**Outputs**:
- `kubernetes_cluster_name` - Nombre del cluster
- `kubernetes_cluster_host` - Endpoint del cluster
- `client_token` - Token de autenticación
- `ca_certificate` - Certificado CA

---

### 3. Cloud SQL

**Descripción**: Base de datos SQL administrada (MySQL, PostgreSQL, SQL Server).

**Características**:
- ✅ Instancias de Cloud SQL
- ✅ Backups automáticos
- ✅ Alta disponibilidad (Regional)
- ✅ Private IP para seguridad
- ✅ Query Insights
- ✅ Encriptación en tránsito y en reposo

**Variables principales**:
```hcl
module "cloud_sql" {
  source = "./cloud_sql"
  
  project_id        = "my-project"
  instance_name     = "my-postgres"
  database_version  = "POSTGRES_15"
  region            = "us-central1"
  tier              = "db-g1-small"
  availability_type = "REGIONAL"
  
  disk_size = 20
  disk_type = "PD_SSD"
  
  enable_public_ip = false
  private_network  = google_compute_network.vpc.id
  
  backup_enabled     = true
  backup_start_time  = "03:00"
  
  username      = "admin"
  user_password = random_password.db_password.result
  
  labels = {
    environment = "production"
  }
}
```

**Outputs**:
- `instance_name` - Nombre de la instancia
- `instance_connection_name` - Connection string
- `database_version` - Versión de BD
- `private_ip_address` - IP privada
- `public_ip_address` - IP pública (si aplica)

---

### 4. Cloud NAT

**Descripción**: Network Address Translation para tráfico saliente seguro.

**Características**:
- ✅ NAT automático con IPs efímeras
- ✅ NAT con IPs estáticas
- ✅ Logging de NAT
- ✅ Configuración de timeouts

**Variables principales**:
```hcl
module "cloud_nat" {
  source = "./cloud_nat"
  
  project_id  = "my-project"
  router_name = "my-router"
  nat_name    = "my-nat"
  region      = "us-central1"
  network_name = "my-vpc"
  
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option = "AUTO_ONLY"
  
  enable_logging = true
  log_filter     = "ERRORS_ONLY"
}
```

**Outputs**:
- `router_id` - ID del router
- `router_name` - Nombre del router
- `nat_id` - ID del NAT
- `nat_name` - Nombre del NAT

---

### 5. Cloud Run

**Descripción**: Desplegar contenedores serverless.

**Características**:
- ✅ Servicio Cloud Run
- ✅ Autoscaling automático
- ✅ Variables de entorno
- ✅ Secretos desde Secret Manager
- ✅ Control de acceso público

**Variables principales**:
```hcl
module "cloud_run" {
  source = "./cloud_run"
  
  project_id  = "my-project"
  service_name = "my-service"
  region      = "us-central1"
  image       = "gcr.io/my-project/my-image:latest"
  
  memory = "512Mi"
  cpu    = "1"
  timeout_seconds = 300
  
  min_instances = 0
  max_instances = 100
  
  environment_variables = {
    ENV = "production"
    DEBUG = "false"
  }
  
  allow_public_access = true
  
  labels = {
    environment = "production"
  }
}
```

**Outputs**:
- `service_name` - Nombre del servicio
- `service_url` - URL pública del servicio
- `service_account_email` - Email de la service account

---

### 6. Cloud Armor

**Descripción**: Protección DDoS y WAF para aplicaciones.

**Características**:
- ✅ Políticas de seguridad
- ✅ Rate limiting
- ✅ Defensa DDoS adaptativa
- ✅ Reglas personalizadas (WAF)
- ✅ Logging y análisis

**Variables principales**:
```hcl
module "cloud_armor" {
  source = "./cloud_armor"
  
  project_id   = "my-project"
  policy_name  = "my-policy"
  description  = "Security policy with rate limiting"
  
  enable_layer7_ddos_defense = true
  
  security_rules = [
    {
      action      = "deny"
      priority    = 100
      description = "Block SQL injection attempts"
      match = {
        versioned_expr = "SOC_V2"
        expr = {
          expression = "evaluatePreconfiguredExpr('sqli')"
        }
      }
    }
  ]
}
```

**Outputs**:
- `policy_id` - ID de la política
- `policy_name` - Nombre de la política
- `policy_self_link` - Self-link para referencia

---

### 7. Bucket (Cloud Storage)

**Descripción**: Almacenamiento de objetos escalable.

**Características**:
- ✅ Buckets de almacenamiento
- ✅ Acceso uniforme a nivel de bucket
- ✅ Versionado
- ✅ Ciclo de vida de objetos
- ✅ Encriptación CMEK
- ✅ CORS configurable

**Variables principales**:
```hcl
module "bucket" {
  source = "./bucket"
  
  project_id  = "my-project"
  bucket_name = "my-bucket-${data.google_client_config.default.project}"
  location    = "US"
  storage_class = "STANDARD"
  
  uniform_bucket_level_access = true
  versioning_enabled          = true
  
  enable_encryption = false
  
  lifecycle_rules = [
    {
      action      = "Delete"
      age_days    = 90
    }
  ]
  
  cors_enabled = true
  cors_origins = ["https://example.com"]
}
```

**Outputs**:
- `bucket_name` - Nombre del bucket
- `bucket_id` - ID del bucket
- `bucket_url` - URL (gs://bucket-name)

---

### 8. External Load Balancer

**Descripción**: Load balancer externo para distribuir tráfico.

**Características**:
- ✅ Health checks
- ✅ Backend services
- ✅ Forwarding rules
- ✅ Session affinity
- ✅ Soporta TCP/UDP

**Variables principales**:
```hcl
module "external_lb" {
  source = "./external_lb"
  
  project_id      = "my-project"
  load_balancer_name = "my-lb"
  
  protocol    = "HTTP"
  port        = 80
  health_check_port = 80
  health_check_path = "/"
  
  health_check_interval = 10
  health_check_timeout  = 5
  healthy_threshold     = 2
  unhealthy_threshold   = 2
  
  timeout_sec      = 30
  session_affinity = "CLIENT_IP"
}
```

**Outputs**:
- `forwarding_rule_ip_address` - IP del LB
- `backend_service_id` - ID del backend
- `health_check_id` - ID del health check

---

### 9. Private Service Connection (PSC)

**Descripción**: Conectar servicios de Google de forma privada.

**Características**:
- ✅ Conexiones privadas a servicios
- ✅ Sin exposición a internet
- ✅ Bajo latency
- ✅ Resolución DNS privada

**Variables principales**:
```hcl
module "psc" {
  source = "./psc"
  
  project_id                = "my-project"
  service_connection_name   = "my-psc"
  network_id                = module.vpc.network_id
  service_name              = "compute"
  reserved_ip_range         = "10.100.0.0/16"
  enable_dns_name_resolution = true
}
```

**Outputs**:
- `psc_endpoint_id` - ID del endpoint
- `psc_endpoint_name` - Nombre del endpoint
- `reserved_ip_range_name` - Nombre del rango reservado

---

### 10. Apigee (API Management)

**Descripción**: Plataforma de gestión de APIs.

**Características**:
- ✅ Organizaciones Apigee
- ✅ Entornos
- ✅ Environment groups
- ✅ mTLS habilitag
- ✅ Analytics

**Variables principales**:
```hcl
module "apigee" {
  source = "./apigee"
  
  project_id         = "my-project"
  organization_name  = "my-org"
  description        = "API Management"
  analytics_region   = "us-east1"
  
  environment_name   = "prod"
  environment_type   = "ENVIRONMENTS_FULL"
  
  enable_mtls = false
  
  labels = {
    environment = "production"
  }
}
```

**Outputs**:
- `organization_id` - ID de la organización
- `environment_id` - ID del entorno
- `envgroup_hostnames` - Hostnames

---

## 💡 Quick Start

### 1. Usar en tu proyecto

```bash
git clone https://github.com/tu-usuario/gcp-terraform-modules.git
cd tu-proyecto-terraform
```

### 2. Crear archivo main.tf

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Usar módulos
module "vpc" {
  source = "../gcp-terraform-modules/vpc"
  
  project_id = var.project_id
  vpc_name   = "my-vpc"
  subnets = [
    {
      name          = "subnet-1"
      region        = var.region
      ip_cidr_range = "10.0.0.0/20"
    }
  ]
}

module "gke" {
  source = "../gcp-terraform-modules/gke"
  
  project_id     = var.project_id
  cluster_name   = "my-cluster"
  location       = "${var.region}-a"
  network_name   = module.vpc.network_name
  subnetwork_name = module.vpc.subnet_names[0]
}
```

### 3. Ejecutar Terraform

```bash
# Inicializar
terraform init

# Validar
terraform validate

# Planificar
terraform plan

# Aplicar
terraform apply
```

---

## 📚 Ejemplos de Uso

### Ejemplo 1: Infraestructura Básica (VPC + GKE)

```hcl
module "vpc" {
  source = "./gcp-terraform-modules/vpc"
  
  project_id     = "my-project"
  vpc_name       = "my-vpc"
  routing_mode   = "GLOBAL"
  
  subnets = [
    {
      name                    = "gke-subnet"
      region                  = "us-central1"
      ip_cidr_range           = "10.0.0.0/20"
      private_ip_google_access = true
      
      secondary_ranges = [
        {
          range_name    = "pods"
          ip_cidr_range = "10.4.0.0/14"
        },
        {
          range_name    = "services"
          ip_cidr_range = "10.8.0.0/20"
        }
      ]
    }
  ]
  
  labels = {
    environment = "production"
    team        = "platform"
  }
}

module "gke" {
  source = "./gcp-terraform-modules/gke"
  
  project_id     = "my-project"
  cluster_name   = "my-cluster"
  location       = "us-central1-a"
  network_name   = module.vpc.network_name
  subnetwork_name = "gke-subnet"
  
  initial_node_count = 3
  machine_type       = "n1-standard-2"
  
  enable_autoscaling = true
  min_node_count     = 1
  max_node_count     = 10
}

output "gke_endpoint" {
  value = module.gke.kubernetes_cluster_host
}

output "vpc_id" {
  value = module.vpc.network_id
}
```

### Ejemplo 2: Aplicación Web con Cloud Run

```hcl
module "cloud_run" {
  source = "./gcp-terraform-modules/cloud_run"
  
  project_id   = "my-project"
  service_name = "my-web-app"
  region       = "us-central1"
  image        = "gcr.io/my-project/web-app:v1.0"
  
  memory = "512Mi"
  cpu    = "1"
  
  environment_variables = {
    ENVIRONMENT = "production"
    LOG_LEVEL   = "info"
  }
  
  allow_public_access = true
  
  labels = {
    component = "web"
  }
}

output "app_url" {
  value = module.cloud_run.service_url
}
```

### Ejemplo 3: Base de Datos Segura

```hcl
module "cloud_sql" {
  source = "./gcp-terraform-modules/cloud_sql"
  
  project_id       = "my-project"
  instance_name    = "my-database"
  database_version = "POSTGRES_15"
  region           = "us-central1"
  
  tier              = "db-g1-small"
  availability_type = "REGIONAL"
  
  enable_public_ip = false
  private_network  = module.vpc.network_id
  
  backup_enabled    = true
  username          = "admin"
  user_password     = random_password.db_password.result
  
  labels = {
    environment = "production"
  }
}

resource "random_password" "db_password" {
  length  = 32
  special = true
}

output "db_connection" {
  value     = module.cloud_sql.instance_connection_name
  sensitive = true
}
```

### Ejemplo 4: Red Privada con NAT

```hcl
module "vpc" {
  source = "./gcp-terraform-modules/vpc"
  
  project_id = "my-project"
  vpc_name   = "private-vpc"
  
  subnets = [
    {
      name                      = "private-subnet"
      region                    = "us-central1"
      ip_cidr_range             = "10.0.0.0/20"
      private_ip_google_access  = true
    }
  ]
}

module "cloud_nat" {
  source = "./gcp-terraform-modules/cloud_nat"
  
  project_id  = "my-project"
  router_name = "nat-router"
  nat_name    = "outbound-nat"
  region      = "us-central1"
  network_name = module.vpc.network_name
  
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}
```

### Ejemplo 5: Almacenamiento de Datos

```hcl
module "data_bucket" {
  source = "./gcp-terraform-modules/bucket"
  
  project_id  = "my-project"
  bucket_name = "my-data-bucket-${data.google_client_config.default.project}"
  location    = "US"
  storage_class = "STANDARD"
  
  uniform_bucket_level_access = true
  versioning_enabled          = true
  
  lifecycle_rules = [
    {
      action    = "Delete"
      age_days  = 365
    },
    {
      action           = "SetStorageClass"
      storage_class    = "COLDLINE"
      age_days         = 90
    }
  ]
  
  labels = {
    data_classification = "internal"
  }
}

output "bucket_url" {
  value = module.data_bucket.bucket_url
}
```

---

## 🏆 Best Practices

### 1. Usar variables para reutilización

```hcl
variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "region" {
  description = "Región de GCP"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Ambiente"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}
```

### 2. Usar locals para lógica

```hcl
locals {
  common_labels = {
    environment = var.environment
    terraform   = "true"
    managed_by  = "terraform"
  }
  
  subnet_config = {
    dev  = { initial_count = 1, max = 5 }
    prod = { initial_count = 3, max = 20 }
  }
}
```

### 3. Usar outputs para referencia

```hcl
output "infrastructure_summary" {
  description = "Resumen de la infraestructura"
  value = {
    vpc_id        = module.vpc.network_id
    gke_endpoint  = module.gke.kubernetes_cluster_host
    db_connection = module.cloud_sql.instance_connection_name
  }
}
```

### 4. Documentar módulos

```hcl
# Descripción clara de qué hace este módulo
# y cómo usarlo en otros proyectos

module "production_infrastructure" {
  source = "../../terraform-modules/gcp-modules/vpc"
  
  # Variables requeridas
  project_id = var.project_id
  vpc_name   = "prod-vpc"
  
  # Documentación inline de opciones
  subnets = [
    {
      # Nombre único para cada subnet
      name = "prod-subnet"
      # Región de la subnet
      region = var.primary_region
      # CIDR block - debe no solaparse
      ip_cidr_range = "10.0.0.0/20"
    }
  ]
}
```

---

## 🐛 Troubleshooting

### Error: "Subnet overlaps with existing subnet"

**Problema**: Rango CIDR de subnet se superpone con otra  
**Solución**: Verificar y cambiar el rango IP

```bash
# Ver subnets existentes
gcloud compute networks subnets list --network=my-vpc

# Modificar el rango en terraform
ip_cidr_range = "10.16.0.0/20"  # Cambiar a un rango diferente
```

### Error: "Insufficient quota"

**Problema**: Cuota de proyecto excedida  
**Solución**: Aumentar cuota en GCP Console

```bash
# Comprobar cuota actual
gcloud compute project-info describe --project=PROJECT_ID \
  --format='value(quotas[name=QUOTA_NAME].usage/QUOTA_NAME.limit)'
```

### Error: "Permission denied"

**Problema**: Service account sin permisos  
**Solución**: Asignar roles necesarios

```bash
# Asignar rol
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=serviceAccount:SA@PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/compute.networkAdmin
```

### Error: "Network already exists"

**Problema**: VPC ya existe en el proyecto  
**Solución**: Importar la VPC existente

```bash
terraform import module.vpc.google_compute_network.vpc \
  projects/PROJECT_ID/global/networks/NETWORK_NAME
```

---

## 📞 Contribuciones

Para contribuir:

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Add nueva funcionalidad'`)
4. Push (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

### Estándares de Código

- Usar `terraform fmt` para formatear
- Documentar variables y outputs
- Incluir ejemplos en los comentarios
- Validar con `terraform validate`

---

## 📝 Notas Importantes

1. **Seguridad**: Nunca commitear credenciales o `.tfvars` con valores sensibles
2. **Estado**: Usar backend remoto (GCS) en producción
3. **Versionado**: Pinear versiones de módulos en `production`
4. **Testing**: Validar changelog antes de usar

---

## 📄 Licencia

Este proyecto está disponible bajo licencia MIT.

---

## 👤 Autor

**Elmon**

---

## 📞 Soporte

Para reportar problemas o sugerencias, abre un issue en el repositorio.

---

**Última actualización**: Abril 2026

Versión: 1.0.0

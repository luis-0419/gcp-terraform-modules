# External Load Balancer - Módulo Terraform

Módulo de Terraform para crear un **Load Balancer Externo (Global)** en Google Cloud Platform conectado a una VPC con backends internos.

## Características

- ✅ Load Balancer Externo Global (L4 - TCP)
- ✅ Conectado a VPC con backends internos
- ✅ Health Check automático
- ✅ Dirección IP pública global
- ✅ Session Affinity configurable
- ✅ Etiquetas personalizadas

## Requisitos

- Terraform >= 1.0
- Provider Google >= 5.0
- Una VPC con instancias o grupos de instancias como backends
- Los backends deben estar en la VPC especificada

## Uso Básico

```hcl
module "external_lb" {
  source = "./external_lb"

  project_id      = var.project_id
  load_balancer_name = "my-external-lb"
  
  # Conectar a VPC (opcional pero recomendado)
  network_name = module.vpc.network_name
  
  protocol       = "TCP"
  port           = 80
  
  health_check_port = 80
  
  labels = {
    environment = "production"
    team        = "backend"
  }
}
```

## Variables

| Variable | Descripción | Tipo | Default |
|----------|-------------|------|---------|
| `project_id` | ID del proyecto GCP | `string` | Requerido |
| `load_balancer_name` | Nombre del LB | `string` | Requerido |
| `protocol` | Protocolo (HTTP/HTTPS/TCP/UDP) | `string` | `"HTTP"` |
| `port` | Puerto de escucha | `number` | `80` |
| `health_check_port` | Puerto health check | `number` | `80` |
| `health_check_interval` | Intervalo en segundos | `number` | `10` |
| `health_check_timeout` | Timeout en segundos | `number` | `5` |
| `healthy_threshold` | Checks exitosos | `number` | `2` |
| `unhealthy_threshold` | Checks fallidos | `number` | `2` |
| `session_affinity` | Afinidad (NONE/CLIENT_IP/HEADER_FIELD) | `string` | `"NONE"` |
| `timeout_sec` | Timeout conexión | `number` | `30` |
| `network_name` | Nombre/ID de la VPC (opcional) | `string` | `null` |
| `subnetwork_name` | Nombre/ID de la subred (opcional) | `string` | `null` |
| `labels` | Etiquetas | `map(string)` | `{}` |

## Outputs

| Output | Descripción |
|--------|-------------|
| `forwarding_rule_id` | ID de la regla de reenvío |
| `forwarding_rule_ip_address` | Dirección IP pública del LB |
| `backend_service_id` | ID del backend service |
| `health_check_id` | ID del health check |

## Ejemplo Completo con VPC

```hcl
# Crear VPC
module "vpc" {
  source = "../vpc"
  
  project_id           = "my-project"
  vpc_name             = "production-vpc"
  auto_create_subnetworks = false
  
  subnets = [
    {
      name              = "backend-subnet-us-central1"
      region            = "us-central1"
      ip_cidr_range     = "10.0.0.0/24"
      private_ip_google_access = true
    }
  ]
}

# Crear instancias en la subnet
resource "google_compute_instance" "backend" {
  count = 3
  
  project      = "my-project"
  name         = "backend-${count.index}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  
  network_interface {
    network    = module.vpc.network_name
    subnetwork = "backend-subnet-us-central1"
  }
  
  service_account {
    scopes = ["cloud-platform"]
  }
}

# Crear grupo de instancias
resource "google_compute_instance_group" "backend_group" {
  project   = "my-project"
  name      = "backend-group"
  zone      = "us-central1-a"
  instances = google_compute_instance.backend[*].self_link
  
  named_port {
    name = "http"
    port = 80
  }
}

# Crear External Load Balancer conectado a VPC
module "external_lb" {
  source = "./external_lb"
  
  project_id          = "my-project"
  load_balancer_name  = "api-lb"
  
  network_name = module.vpc.network_name
  
  protocol       = "TCP"
  port           = 80
  health_check_port = 80
  
  labels = {
    app     = "api"
    env     = "prod"
  }
  
  depends_on = [google_compute_instance_group.backend_group]
}

output "external_lb_ip" {
  value = module.external_lb.forwarding_rule_ip_address
  description = "Dirección IP pública del Load Balancer"
}
```

## Conectar Backends al Load Balancer

Después de crear el Load Balancer, debes conectar tus backends (instance groups):

```hcl
resource "google_compute_backend_service_backend" "backend" {
  backend_service = module.external_lb.backend_service_id
  instance_group  = google_compute_instance_group.backend_group.self_link
  zone            = "us-central1-a"
}
```

## Flujo de Tráfico

```
Internet
   ↓
┌─────────────────────────────────────┐
│  External IP Address (Global)       │
└─────────────────────────────────────┘
   ↓
┌─────────────────────────────────────┐
│  Forwarding Rule                    │
│  (Escucha en puerto X)              │
└─────────────────────────────────────┘
   ↓
┌─────────────────────────────────────┐
│  Backend Service                    │
│  (Load balancing y health check)    │
└─────────────────────────────────────┘
   ↓
┌─────────────────────────────────────┐
│  Instance Group (en VPC)            │
│  └─ Instance 1                      │
│  └─ Instance 2                      │
│  └─ Instance 3                      │
└─────────────────────────────────────┘
```

## Notas Importantes

- El Load Balancer **es global** y distribuye tráfico a instancias en cualquier región
- Los backends deben estar saludables para recibir tráfico
- Usa `network_name` para conectarlo a tu VPC específica
- La dirección IP es **pública e inmutable** (no cambia al destruir/recrear)
- El health check debe ser accesible desde Internet

## Integración con DNS

Para usar el LB con un dominio:

```bash
# Crear registro DNS
gcloud dns record-sets create api.example.com \
  --rrdatas=$(terraform output -raw external_lb_ip) \
  --ttl=300 \
  --type=A \
  --zone=my-zone
```

## Troubleshooting

Si los backends no reciben tráfico:

1. **Verificar health check:** `gcloud compute backend-services get-health BACKEND_SERVICE_ID`
2. **Verificar firewall rules:** Los puertos deben estar abiertos
3. **Verificar conectividad:** `gcloud compute ssh INSTANCE -- curl localhost:PORT`
4. **Revisar logs:** `gcloud logging read "resource.type=http_load_balancer"`

## Licensing

Este módulo es parte del repositorio `gcp-terraform-modules`.

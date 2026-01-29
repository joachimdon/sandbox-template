# Azure Infrastructure Template - Bicep

A GitHub template for deploying Azure infrastructure using Bicep with Azure Verified Modules (AVM), and automated GitHub Actions deployment.

## 🚀 Features

- **Subscription-scoped deployment** - Deploy resource groups and resources across subscriptions
- **Azure Verified Modules (AVM)** - Uses official Microsoft modules for Virtual Network
- **Multi-environment support** - Separate parameter files for dev, test, and prod
- **Automated CI/CD** - GitHub Actions workflow with manual and automatic triggers

## 📋 Prerequisites

- Azure subscription with an existing resource group
- Service principal with **Contributor** role at **subscription level**
- GitHub repository (created from this template)

## 🔧 Getting Started

### 1. Create Your Repository

1. Click the **"Use this template"** button at the top of this page
2. Choose a name for your new repository
3. Click **"Create repository from template"**

### 2. Clone and Configure

#### 2.1 Clone Your Repository

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
```

#### 2.2 Update Configuration

**Edit `environments/dev.bicepparam`:**

```bicep
param projectName = 'yourproject'                          // Your project name
param location = 'norwayeast'                              // Azure region
param environment = 'dev'
param customerCode = 'XX'                                  // Your org code
param portfolioSubscriptionId = 'your-subscription-id'     // Target subscription

// Update tags
param intilityManaged = 'true'
param intilityMonitored = 'true'
param intilityBackup = 'false'
param deploymentModel = 'IAC'
param IntilityImplementationGuid = 'your-guid-here'
param deployer = 'YourName'

// Configure VNet
param vnetParam = {
  addressPrefixes: ['10.0.0.0/16']                        // Your IP range
  subnets: [
    {
      name: 'snet-app-${environment}'
      addressPrefixes: ['10.0.0.0/24']                    // Subnet range
      securityRules: []
      serviceEndpoints: []
      delegation: ''
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  ]
}
```

**Edit `main.bicep` - Update resource group name:**

```bicep
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  scope: subscription(portfolioSubscriptionId)
  name: 'rg-yourproject-dev'  // Change this to your existing resource group name
}

module keyVault 'br:crpclazmodules.azurecr.io/res/key-vault/vault:0.1.0' =  {
  params: {
    name: 'kv-yourprefix-${projectName}-${environment}'  // Update prefix (max 24 chars total)
    // ...
  }
}
```

**Edit `.github/workflows/deploy.yml`:**

```yaml
env:
  AZURE_RESOURCE_GROUP_DEV: 'rg-yourproject-dev'    # Your resource group
  AZURE_LOCATION: 'norwayeast'                       # Your Azure region
```

#### 2.3 Commit Changes

```bash
git add .
git commit -m "Configure for my environment"
git push
```

### 3. Add GitHub Secrets

Your service principal needs **Contributor** role at the **subscription level**.

1. Go to **Settings → Secrets and variables → Actions**
2. Add these secrets:

| Secret Name | Value |
|-------------|-------|
| `APPLICATIONCLIENTID` | Service principal application (client) ID |
| `SECRETVALUE` | Service principal client secret |
| `SUBSCRIPTIONID` | Azure subscription ID |
| `APPLICATIONTENANTID` | Azure AD tenant ID |

### 4. Deploy

**Option A: Manual trigger**

1. Go to **Actions** tab
2. Select **"Deploy Azure Infrastructure as Code"**
3. Click **"Run workflow"**
4. Select environment (`dev`, `test`, or `prod`)
5. Click **"Run workflow"**

**Monitor deployment:**
- Go to the **Actions** tab to see the workflow progress
- Click on the running workflow to see detailed logs
- Deployment typically takes 1-2 minutes


## 📁 Repository Structure

```
├── main.bicep                           # Main orchestration template (subscription scope)
├── modules/
│   └── vnet.bicep                       # Custom VNet module (unused - using AVM)
├── environments/
│   └── dev.bicepparam                   # Development environment parameters
└── .github/workflows/
    └── deploy.yml                       # GitHub Actions CI/CD workflow
```

## 🎯 What Gets Deployed

- **Virtual Network** - Using Azure Verified Module (AVM)
- **Key Vault** - Using Azure Verified Module (AVM)
- **Subnets** - Configurable subnets for your application tiers

## 🔐 Key Vault Naming

Key Vault names must be globally unique and max 24 characters:
- Format: `kv-{prefix}-{projectName}-{environment}`
- Example: `kv-myco-sandbox-dev` (18 characters)

Update the prefix in `main.bicep` to ensure uniqueness.

## ✨ Adding Resources

### Using Azure Verified Modules (AVM)

```bicep
module storage 'br/public:avm/res/storage/storage-account:0.14.3' = {
  scope: resourceGroup
  name: 'storage-deploy'
  params: {
    name: 'st${projectName}${environment}'
    location: location
    tags: tags
  }
}
```

Browse available AVM modules: [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/)

### Using Custom Modules

1. Create `modules/yourmodule.bicep`
2. Reference in `main.bicep`:
   ```bicep
   module custom 'modules/yourmodule.bicep' = {
     scope: resourceGroup
     name: 'custom-deploy'
     params: { ... }
   }
   ```

## 🌍 Multi-Environment Setup

1. Copy `environments/dev.bicepparam` to `environments/prod.bicepparam`
2. Update values for production (different IPs, resource names, tags)
3. Workflow supports environment selection via manual trigger

## 🔄 Local Deployment

```bash
az login
az deployment sub create \
  --location norwayeast \
  --template-file main.bicep \
  --parameters environments/dev.bicepparam
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Authorization failed | Service principal needs **Contributor** at **subscription** level (not just resource group) |
| Scope mismatch | `main.bicep` uses `targetScope = 'subscription'` - ensure workflow uses `az deployment sub create` |
| Resource group not found | Resource group must exist before deployment (referenced as `existing` in template) |
| Key Vault name conflict | Key Vault names are globally unique - update prefix in `main.bicep` |
| Module not found | Check module registry access - AVM modules use `br/public:`, custom registries need authentication |

## 📚 Learn More

- [Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/)
- [GitHub Actions for Azure](https://learn.microsoft.com/azure/developer/github/github-actions)
- [Bicep Modules](https://learn.microsoft.com/azure/azure-resource-manager/bicep/modules)

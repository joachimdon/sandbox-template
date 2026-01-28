# Azure Infrastructure Template - Bicep

A GitHub template for deploying Azure infrastructure with Bicep modules and automated GitHub Actions deployment.

## Getting Started

### 1. Create Your Repository

1. Click the **"Use this template"** button at the top of this page
2. Choose a name for your new repository
3. Click **"Create repository from template"**

### 2. Configure Your Deployment

#### 2.1 Clone Your Repository

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
```
#### 2.2

**Edit `environments/dev.bicepparam`:**

Update these values for your environment:

```bicep
param projectName = 'yourproject'        // Your project name
param location = 'norwayeast'            // Your Azure region
param customerCode = 'ABC'               // Your organization code

// Update VNet configuration
param vnetParam = {
  name: 'vnet-yourproject-dev'
  addressPrefixes: ['10.0.0.0/16']      // Your IP address range
  subnets: [
    {
      name: 'snet-app-dev'
      addressPrefixes: ['10.0.0.0/24']   // Your subnet range
      delegation: ''
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      routeTableRoutes: []
      securityRules: []
      serviceEndpoints: []
    }
    {
      name: 'snet-db-dev'
      addressPrefixes: ['10.0.0.0/24']   // Your subnet range
      delegation: ''
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      routeTableRoutes: []
      securityRules: []
      serviceEndpoints: []
    }
  ]
}
```

**Edit `.github/workflows/deploy.yml`:**

Update the environment variables:

```yaml
env:
  AZURE_RESOURCE_GROUP_DEV: 'rg-yourproject-dev'  # Your resource group
  AZURE_LOCATION: 'norwayeast'                     # Your Azure region
```

#### 2.3 Commit and push your changes

```bash
git add .
git commit -m "Configure for my environment"
git push

### 3. Add GitHub Secrets

You'll need a service principal with Contributor access to your Azure resource group.

1. Go to your repository on GitHub
2. Navigate to **Settings → Secrets and variables → Actions**
3. Click **"New repository secret"** for each of these:

| Secret Name | Value |
|-------------|-------|
| `APPLICATIONCLIENTID` | Service principal client ID |
| `SECRETVALUE` | Service principal client secret |
| `SUBSCRIPTIONID` | Your Azure subscription ID |
| `APPLICATIONTENANTID` | Your Azure tenant ID |

### 4. Deploy using Github Actions

1. Go to your repository on GitHub
2. Click on the **Actions** tab
3. Select **"Deploy Azure Infrastructure as Code"** workflow
4. Click **"Run workflow"** button
5. Select branch (usually `main`)
6. Click **"Run workflow"**

**Monitor deployment:**
- Go to the **Actions** tab to see the workflow progress
- Click on the running workflow to see detailed logs
- Deployment typically takes 1-2 minutes


## 📁 Repository Structure

```
├── main.bicep                    # Main orchestration template
├── modules/
│   └── vnet.bicep               # Virtual network module
├── environments/
│   └── dev.bicepparam           # Development parameters
└── .github/workflows/
    └── deploy.yml               # GitHub Actions workflow
```

## 🎯 What Gets Deployed

- **Virtual Network** with your specified address space
- **Network Security Groups** with default deny rules
- **Subnets** with NSG association

## ✨ Adding More Resources

1. Create a new module in `modules/` (e.g., `modules/storage.bicep`)
2. Add it to `main.bicep`:
   ```bicep
   module storage 'modules/storage.bicep' = {
     name: 'deploy-storage'
     params: {
       location: location
       tags: tags
     }
   }
   ```
3. Update `environments/dev.bicepparam` with required parameters

## 🔄 Manual Deployment (Optional)

To deploy locally instead of using GitHub Actions:

```bash
az login
az deployment group create \
  --resource-group rg-yourproject-dev \
  --template-file main.bicep \
  --parameters environments/dev.bicepparam
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Authorization failed | Verify service principal has Contributor role on resource group |
| Resource group not found | Ensure resource group exists and name matches in workflow |
| Missing parameter error | Check all parameters in `main.bicep` have values in `.bicepparam` |
| Workflow not triggering | Check you pushed to `main` branch |

## 📚 Learn More

- [Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [GitHub Actions for Azure](https://learn.microsoft.com/azure/developer/github/github-actions)

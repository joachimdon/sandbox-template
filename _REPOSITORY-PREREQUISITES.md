# GitHub Repository Deployment Setup Guide

This guide will walk you through the essential steps to prepare your GitHub repository for Azure deployment using GitHub Actions and Copilot.

## Prerequisites

- Access to Azure Portal with appropriate permissions
- GitHub repository with admin access
- Azure subscription

---

## 1. Configure MCP Server Settings

### Step 1.1: Access Copilot Settings
1. Navigate to your GitHub repository
2. Go to **Settings** → **Copilot** → **Coding agent**

### Step 1.2: Required Security Settings
Configure the following settings:

| Setting | Value | Description |
|---------|-------|-------------|
| **Enable firewall** | `True` | Enables security filtering for external requests |
| **Recommend allowlist** | `True` | Suggests approved URLs for access |
| **Custom allowlist** | See below | Additional trusted URLs |

#### Custom Allowlist URLs
Add these trusted Microsoft and Azure documentation URLs:
- `https://learn.microsoft.com/`
- `https://azure.github.io/Azure-Verified-Modules/`

> 💡 **Tip**: You can add additional relevant URLs as needed for your specific project requirements.

### Step 1.3: Add MCP Configuration
You can add additional relevant MCPs as needed for your specific project requirements. Default MCP use is Microsoft Learn.
1. Copy MCP configuration below

```json
{
  "mcpServers": {
    "MicrosoftLearn": {
      "type": "http",
      "url": "https://learn.microsoft.com/api/mcp",
      "tools": ["*"]
    }
  }
}
```
2. Press "Save MCP configuration"

## 2. Create Azure Service Principal and Assign Role Assigment

### Step 2.1: Create App Registration
1. Open the [Azure Portal](https://portal.azure.com)
2. Navigate to **Azure Active Directory** → **App registrations**
3. Click **New registration**
4. Configure the following settings:

   | Field | Value |
   |-------|--------|
   | **Name** | Choose a descriptive name (e.g., "customercode-application-environment") |
   | **Supported account types** | "Accounts in this organizational directory only" |
   | **Redirect URI** | Leave empty |

5. Click **Register**

### Step 2.2: Generate Client Secret
1. In your newly created app registration, navigate to **Certificates & secrets**
2. Click **New client secret**
3. Configure the secret:
   - **Description**: Provide a meaningful description (e.g., "GitHub Actions Secret")
   - **Expires**: Choose an appropriate expiration period (recommended: 12-24 months)
4. Click **Add**
5. **⚠️ Important**: Copy the generated secret value immediately and store it securely (it won't be visible again)

### Step 2.3: Collect Required Information
From your app registration's **Overview** page, copy and save:
- **Application (client) ID**
- **Directory (tenant) ID**
- **Subscription ID** (from your Azure subscription)

  
### 2.4: Add Service Principal to Subscription or Resource Group
1. Navigate to your Subscription or Resource Group
2. Go to **Access Control** → **Add** → **Add role assignment** → **Role** → **Privileged administrator rule** → **Select: Contributor**
3. Click **Next** and assign role to service principal from step 2.1
4. Click **Review and assign** 

---

## 3. Configure GitHub Repository Secrets

### Step 3.1: Add Repository Secrets
1. In your GitHub repository, navigate to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add the following secrets using the exact naming convention:

| Secret Name | Value Source | Description |
|-------------|--------------|-------------|
| `APPLICATIONCLIENTID` | Application (client) ID from Step 2.3 | Service principal client ID |
| `APPLICATIONTENANTID` | Directory (tenant) ID from Step 2.3 | Azure AD tenant ID |
| `SECRETID` | Client secret from Step 2.2 | Service principal secret |
| `SUBSCRIPTIONID` | Your Azure subscription ID | Target subscription for deployment |

### Step 3.2: Verification
After adding all secrets, verify that you have:
- ✅ `APPLICATIONCLIENTID`
- ✅ `APPLICATIONTENANTID` 
- ✅ `SECRETID`
- ✅ `SUBSCRIPTIONID`

---

## Next Steps

With these configurations complete, your repository is now ready for:
- GitHub Actions workflows that deploy to Azure
- Copilot assistance with Azure-related code generation
- Secure authentication to Azure services

> 📚 **Additional Resources**:
> - [GitHub Actions documentation](https://docs.github.com/en/actions)
> - [Azure service principals guide](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals)
> - [GitHub Copilot documentation](https://docs.github.com/en/copilot)

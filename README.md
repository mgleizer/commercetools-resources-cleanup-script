## 🧾 Description

This script is designed to work with the **commercetools API** and is used to delete all existing resources related to the used endpoint in a given project.

---

## ⚠️ Warning

**Use this script at your own risk.**  

This script will **delete all resources associated to the endpoint used**.

We strongly recommend the following precautions:

- Use an authentication token with **only the `manage_{resource}` scope associated to the endpoint**. E.g. manage_order_edits
- **Test the script in a non-production environment** before running it in a live project.

---

## 🛠 Prerequisites

Ensure your system has the following installed:

- `bash`
- `jq`

---

## 🚀 How to Run

1. **Download** the `delete_documents.sh` script from this repository.
2. **Open the script** in your preferred text editor.
3. **Edit the following variables**:
   - `API_URL`: Set this to your commercetools project’s API URL.
   - `AUTH_TOKEN`: Set this to a valid token with the required scope.
4. **Save** the file after making the necessary changes.
5. **Open a terminal** and navigate to the folder containing the script.
6. Make the script executable:

    ```bash
    chmod +x delete_documents.sh
    ```

7. Execute the script:

    ```bash
    ./delete_documents.sh
    ```

8. The script will begin deleting documents. **Wait until it finishes before closing the terminal.**

---

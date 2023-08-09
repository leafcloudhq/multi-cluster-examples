# Multi-Cluster Kubernetes

In this setup, we utilize three different Kubernetes clusters, each hosted on a distinct cloud provider:

- **Fuga**
- **OVH**
- **Leafcloud**

## Database Setup

For our database, we are using **CockroachDB**. Each of these clusters has a CockroachDB node installed, ensuring that our database remains distributed and resilient.

Using **Skupper**, we've established a link between the CockroachDB namespaces across these clusters. This facilitates the seamless replication of data among the databases, guaranteeing data consistency and availability.

## Frontend Setup

Our frontend is powered by the **Soldius Ecommerce Webshop**. An instance of this webshop is installed in each of the clusters, providing a uniform user experience regardless of the underlying infrastructure.

## Load Balancing

To ensure our frontend remains responsive and available, we utilize a **Cloudflare Load Balancer**. This load balancer intelligently routes user traffic, directing it towards healthy clusters. This way, we achieve both high availability and optimal performance.



## Installation

### In Cluster Leaf:

1. **Install CockroachDB**:
   - Install CockroachDB using the Helm chart included in this repo.
     > Note: The operator currently does not support multi-cluster.
   - Use `leaf.values` as an extra value file during installation:
     ```
     helm install cockroachdb-leaf ./helm-chart -f ./helm-chart/leaf-values.yaml
     ```
    

2. **Install Skupper**:
   - Install the `skupper` CLI tool.
   - Within the CockroachDB namespace, run:
     ```
     skupper init
     ```
   - Create tokens for the other clusters:
     ```
     skupper token create fuga.yaml
     skupper token create ovh.yaml
     ```
   - Expose the stateful set:
     ```
     skupper expose statefulset cockroachdb-leaf --headless --port 26257
     ```

3. **Install Solidus**:
   - Install Solidus using the helm chart found at `./solidus`, and use the `leaf` values during installation.

     ```
     helm upgrade --install  solidus  ./solidus-helm-chart -n solidus -f leaf-values.yaml
     ```

   

### In Fuga and OVH Cluster:

1. **Install CockroachDB**:
   - Use the Helm chart for installation and the extra value file specific to the cluster.

2. **Setup Skupper**:
   - Run:
     
     ```
     skupper init
     ```
   - Create a link to the `leaf` cluster:
     ```
     skupper link create fuga.yaml --name leaf
     ```

3. **Expose CockroachDB via Skupper**:
     ```
     skupper expose statefulset cockroachdb-fuga --headless --port 26257
     ```

4. **Create also a link between the fuga and ovh clusters**:
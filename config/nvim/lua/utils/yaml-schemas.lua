local M = {}

M.defined_schemas = {
  {
    name = "lazygit",
    uri = "https://raw.githubusercontent.com/jesseduffield/lazygit/master/schema/config.json",
  },
  {
    name = "bitbucket-pipelines",
    uri = "https://api.bitbucket.org/schemas/pipelines-configuration",
    file_pattern = "bitbucket-pipelines.{yml,yaml}"
  },
  {
    name = "AWS Cloudformation",
    uri = "https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json",
    file_pattern = "{cloudformation,cf}.{json,yml,yaml}"
  },
  {
    name = "GitHub workflow",
    uri = "https://json.schemastore.org/github-workflow.json",
    file_pattern = ".github/workflows/*.{yml,yaml}"
  },
  {
    name = "GitLab CI",
    url = "https://gitlab.com/gitlab-org/gitlab-foss/-/raw/master/app/assets/javascripts/editor/schema/ci.json",
    file_pattern = "**/*.gitlab-ci.{yml,yaml}",
  },
  {
    name = "Kustomization",
    uri = "https://www.schemastore.org/kustomization.json",
    file_pattern = "kustomization.{yaml,yml}"
  },
  {
    name = "Prometheus configs",
    uri = "https://www.schemastore.org/prometheus.json",
    file_pattern = "prometheus*.{yml,yaml}"
  },
  {
    name = "Prometheus rules",
    uri = "https://www.schemastore.org/prometheus.rules.json",
    file_pattern = "{prometheus_rules,rules}.{yml,yaml}"
  },
  {
    name = "Alertmanager",
    uri = "https://www.schemastore.org/prometheus-alertmanager.json",
    file_pattern = "alertmanager.{yml,yaml}"
  },
  {
    name = "Thanos configs",
    uri = "https://raw.githubusercontent.com/thanos-io/thanos/main/config/config.schema.json",
    file_pattern = "thanos*.{yml,yaml}"
  },
  {
    name = "Loki configs",
    uri = "https://www.schemastore.org/loki.json",
    file_pattern = "loki*.{yml,yaml}"
  },
  {
    name = "Argo application",
    uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
    file_pattern = "*application*.yml"
  },
  -- docker
  {
    name = "Docker compose",
    uri = "https://raw.githubusercontent.com/compose-spec/compose-go/master/schema/compose-spec.json",
    file_pattern = "{compose,composes}.{yml,yaml}"
  },
  {
    name = "Docker bake",
    uri = "https://www.schemastore.org/docker-bake.json",
    file_pattern = "docker-bake.*"
  },
  -- Kubernetes
  {
    name = "Helm Chart.yaml",
    url = "https://www.schemastore.org/chart.json",
    file_pattern = "Chart.yaml",
  },
  {
    name = "eksctl schema",
    uri = "https://raw.githubusercontent.com/weaveworks/eksctl/main/pkg/apis/eksctl.io/v1alpha5/assets/schema.json",
    file_pattern = "eksconfig.yaml",
  },
  {
    name = "Kubernetes (v1.30) - All-in-one",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/all.json",
  },
  {
    name = "Kubernetes (v1.30) - Deployment",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/deployment.json",
    file_pattern = "*manifests*/**/{deploy,deployment}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - DaemonSet",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/daemonset.json",
    file_pattern = "*manifests*/**/{daemon,ds,daemonset,daemonsets}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - StatefulSet",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/statefulset.json",
    file_pattern = "*manifests*/**/{sts,statefulset,statefulsets}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - ReplicaSet",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/replicaset.json",
    file_pattern = "*manifests*/**/{replicaset,replicasets,rs}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - HPA",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/horizontalpodautoscaler.json",
    file_pattern = "*{manifests,manifest}*/**/{horizontalpodautoscaler,hpa}.{yaml,yml}"
  },
  -- storage
  {
    name = "Kubernetes (v1.30) - PersistentVolume",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/persistentvolume.json",
    file_pattern = "*manifests*/**/{persistentvolume,pv}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - PersistentVolumeClaim",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/persistentvolumeclaim.json",
    file_pattern = "*manifests*/**/{persistentvolumeclaim,pvc}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - StorageClass",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/storageclass.json",
    file_pattern = "*manifests*/**/{storageclasses,storageclass}.{yaml,yml}"
  },
  -- configs
  {
    name = "Kubernetes (v1.30) - Secret",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/secret.json",
    file_pattern = "*manifests*/**/{secret,secrets}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - ConfigMap",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/configmap.json",
    file_pattern = "*manifests*/**/{cm,configmap,config,configmaps,cms}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - ServiceAccount",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/serviceaccount.json",
    file_pattern = "*manifests*/**/{serviceaccount,sa}.{yaml,yml}"
  },
  -- access
  {
    name = "Kubernetes (v1.30) - Service",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/service.json",
    file_pattern = "*manifests*/**/{svc,service,services}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - Ingress",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/ingress.json",
    file_pattern = "*manifests*/**/{ing,ingress}.{yaml,yml}"
  },
  {
    name = "Kubernetes (v1.30) - Endpoint",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone/endpoint.json",
    file_pattern = "*manifests*/**/{endpoint,ep}.{yaml,yml}"
  },
}

M.schema_modeline = "# yaml-language-server: $schema="

M.insert_modeline = function(schema_url)
  if not schema_url or schema_url == "" then
    vim.notify("No schema URL provided", vim.log.levels.WARN)
    return
  end

  local schema_modeline = M.schema_modeline .. schema_url
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)

  if #first_line > 0 and first_line[1]:match("^# yaml%-language%-server: %$schema=") then
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { schema_modeline })
  else
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { schema_modeline, "" })
  end

  vim.notify("🔖 Added schema modeline: " .. schema_modeline, vim.log.levels.INFO)
end

M.list_schemas = function()
  local items = vim.tbl_map(function(s)
    return s.name
  end, M.defined_schemas)

  vim.ui.select(items, { title = "Select YAML Schema", prompt = "Select yaml schema" }, function(selection)
    if not selection then
      vim.notify("Selection canceled.", vim.log.levels.WARN)
      return
    end

    for _, s in ipairs(M.defined_schemas) do
      if s.name == selection then
        M.insert_modeline(s.uri)
        return
      end
    end
  end)
end

---@return table
M.as_lsp_schemas = function()
  local schemas = {}
  for _, s in ipairs(M.defined_schemas) do
    if s.uri and s.file_pattern then
      schemas[s.uri] = s.file_pattern
    end
  end
  return schemas
end

return M

local env = {
  name: std.extVar('qbec.io/env'),
  namespace: std.extVar('qbec.io/defaultNs'),
};
local p = import '../params.libsonnet';
local params = p.components.atlantis;
local component  = 'atlantis';

std.native('expandHelmTemplate')(
  '../vendor/atlantis/charts/atlantis',
  params.values,
  {
    nameTemplate: params.name,
    namespace: env.namespace,
    thisFile: std.thisFile,
    verbose: true,
  }
)

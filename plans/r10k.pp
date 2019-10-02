# Plan for deploying a puppet environment with R10k
# @param [TargetSpec] nodes The nodes to deploy the environment on
# @param [String] environment The puppet environment to deploy
# @param [Boolean] catch_errors Whether to catch errors or not in the plan
# @example Running the plan
#   bolt plan run deploy::r10k environment=production --nodes puppet --run-as root
plan deploy::r10k (
  TargetSpec $nodes,
  Boolean $catch_errors = true,
  String $environment = undef,
) {
  $targets = get_targets($nodes)

  if $targets.empty { return ResultSet.new([]) }

  $r10k = run_task(
    'deploy::r10k',
    $targets,
    '_run_as' => 'root',
    'environment' => $environment,
    '_catch_errors' => $catch_errors
  )

  $cache = run_task(
    'deploy::cache',
    $targets,
    '_run_as' => 'root',
    'environment' => $environment,
    '_catch_errors' => $catch_errors
  )

  $types = run_task(
    'deploy::generate_types',
    $targets,
    '_run_as' => 'root',
    'environment' => $environment,
    '_catch_errors' => $catch_errors
  )

  $r10k.each |$result| {
    $node = $result.target.name
    if $result.ok {
      notice("${node} deployed environment ${environment} successfully")
    } else {
      fail_plan("${node} errored with a message: ${result.error.message}")
    }
  }

  $cache.each |$result| {
    $node = $result.target.name
    if $result.ok {
      notice("${node} cleared environment cache for environment ${environment}")
    } else {
      fail_plan("${node} could not clear environment cache: ${result.error.message}")
    }
  }

  $types.each |$result| {
    $node = $result.target.name
    if $result.ok {
      notice("${node} generated types successfully")
    } else {
      fail_plain("${node} could not generate types: ${result.error.message}")
    }
  }
}

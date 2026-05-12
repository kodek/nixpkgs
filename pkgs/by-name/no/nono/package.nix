{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,

  dbus,

  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nono";
  version = "0.53.0";

  __darwinAllowLocalNetworking = true; # required for tests

  src = fetchFromGitHub {
    owner = "always-further";
    repo = "nono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jK3/NDNQkeeCKP2iMIJMCq9lrDZ9ksiEnHhFmrz+gew=";
  };
  cargoHash = "sha256-OK2vlXYFdjMHqzVR6ZoRn7WEfAUVATGhk32JLoDED5c=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # fails to initialize the sandbox under '/build'
    "--skip=test_all_profiles_signal_mode_resolves"
    # panic
    "--skip=build_run_profile_patch_adds_override_deny_for_sensitive_file"
    "--skip=build_run_profile_patch_merges_read_and_write_to_allow_file"
    "--skip=prepare_profile_save_from_patch_updates_existing_user_profile"
    "--skip=would_shadow_builtin_allows_update_of_existing_user_override"
    "--skip=would_shadow_builtin_flags_known_builtin_names"
    "--skip=create_audit_state_creates_session_when_enabled"

    # audit_attestation
    # needs /bin/pwd
    "--skip=audit_verify_reports_signed_attestation_with_pinned_public_key"
    "--skip=rollback_signed_session_verifies_from_audit_dir_bundle"

    # nono-cli
    # wants a script `cripts/test-list-aliases.sh`, `git`, and `.git` history
    "--skip=alias_inventory_script_passes"
    # fails to initialize the sandbox under '/build'
    "--skip=policy::tests::test_all_groups_no_deny_within_allow_overlap"
    # not relevant for us, requires `git`
    "--skip=lint_docs_script_passes"
    # want to run `git`
    "--skip=alias_inventory_rejects_marker_missing_field"
    "--skip=alias_inventory_rejects_naked_serde_alias"
    "--skip=alias_inventory_rejects_unapproved_deprecated_module_reach_in"
    "--skip=lint_docs_accepts_clean_tree"
    "--skip=lint_docs_rejects_quoted_override_deny_outside_allowlist"

    # nono-proxy
    # fails to prepare TLS bundle inside build sandbox
    "--skip=server::tests::test_intercept_lifecycle_end_to_end"
    "--skip=server::tests::test_route_diagnostics_summarises_each_route"
    "--skip=tls_intercept::bundle::tests::bundle_contains_ephemeral_and_system_roots"
    "--skip=tls_intercept::bundle::tests::bundle_file_has_restrictive_permissions"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # panics with "Deny-within-allow overlap on Linux ... Landlock cannot enforce this. ..."
    # landlock is linux only
    "--skip=policy::tests::test_all_groups_no_deny_within_allow_overlap"
    # panics with "exact-path fallback must not recursively cover descendants"
    "--skip=capability_ext::tests::test_from_profile_allow_file_falls_back_to_exact_directory_when_present"

    # env_vars
    # don't work inside of the /nix dir
    # unsure why home is still under /nix with writableTmpDirAsHomeHook
    # Sandbox initialization failed: Refusing to grant '/nix' (source: group:system_read_macos) because it overlaps protected nono state root '/nix/build/nix-<ID>/.home/.nono'.
    "--skip=allow_net_overrides_profile_external_proxy"
    "--skip=cli_flag_overrides_env_var"
    "--skip=env_nono_allow_comma_separated"
    "--skip=env_nono_block_net"
    "--skip=env_nono_block_net_accepts_true"
    "--skip=env_nono_network_profile"
    "--skip=env_nono_profile"
    "--skip=env_nono_upstream_bypass_comma_separated"
    "--skip=env_nono_upstream_proxy"
    "--skip=legacy_env_nono_net_block_still_works"
    "--skip=environment_allow_vars_bare_star"
    "--skip=environment_allow_vars_default_allows_all"
    "--skip=environment_allow_vars_prefix_patterns"
    "--skip=environment_allow_vars_with_profile"
  ];

  meta = {
    description = "Secure, kernel-enforced sandbox for AI agents, MCP and LLM workloads";
    homepage = "https://github.com/always-further/nono";
    changelog = "https://github.com/always-further/nono/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "nono";
    # https://github.com/always-further/nono#platform-support
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

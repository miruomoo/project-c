table "audit_log_entries" {
  schema  = schema.auth
  comment = "Auth: Audit trail for user actions."
  column "instance_id" {
    null = true
    type = uuid
  }
  column "id" {
    null = false
    type = uuid
  }
  column "payload" {
    null = true
    type = json
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "ip_address" {
    null    = false
    type    = character_varying(64)
    default = ""
  }
  primary_key {
    columns = [column.id]
  }
  index "audit_logs_instance_id_idx" {
    columns = [column.instance_id]
  }
}
table "custom_oauth_providers" {
  schema = schema.auth
  column "id" {
    null    = false
    type    = uuid
    default = sql("gen_random_uuid()")
  }
  column "provider_type" {
    null = false
    type = text
  }
  column "identifier" {
    null = false
    type = text
  }
  column "name" {
    null = false
    type = text
  }
  column "client_id" {
    null = false
    type = text
  }
  column "client_secret" {
    null = false
    type = text
  }
  column "acceptable_client_ids" {
    null    = false
    type    = sql("text[]")
    default = "{}"
  }
  column "scopes" {
    null    = false
    type    = sql("text[]")
    default = "{}"
  }
  column "pkce_enabled" {
    null    = false
    type    = boolean
    default = true
  }
  column "attribute_mapping" {
    null    = false
    type    = jsonb
    default = "{}"
  }
  column "authorization_params" {
    null    = false
    type    = jsonb
    default = "{}"
  }
  column "enabled" {
    null    = false
    type    = boolean
    default = true
  }
  column "email_optional" {
    null    = false
    type    = boolean
    default = false
  }
  column "issuer" {
    null = true
    type = text
  }
  column "discovery_url" {
    null = true
    type = text
  }
  column "skip_nonce_check" {
    null    = false
    type    = boolean
    default = false
  }
  column "cached_discovery" {
    null = true
    type = jsonb
  }
  column "discovery_cached_at" {
    null = true
    type = timestamptz
  }
  column "authorization_url" {
    null = true
    type = text
  }
  column "token_url" {
    null = true
    type = text
  }
  column "userinfo_url" {
    null = true
    type = text
  }
  column "jwks_uri" {
    null = true
    type = text
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "updated_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  primary_key {
    columns = [column.id]
  }
  index "custom_oauth_providers_created_at_idx" {
    columns = [column.created_at]
  }
  index "custom_oauth_providers_enabled_idx" {
    columns = [column.enabled]
  }
  index "custom_oauth_providers_identifier_idx" {
    columns = [column.identifier]
  }
  index "custom_oauth_providers_provider_type_idx" {
    columns = [column.provider_type]
  }
  check "custom_oauth_providers_authorization_url_https" {
    expr = "((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))"
  }
  check "custom_oauth_providers_authorization_url_length" {
    expr = "((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))"
  }
  check "custom_oauth_providers_client_id_length" {
    expr = "((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))"
  }
  check "custom_oauth_providers_discovery_url_length" {
    expr = "((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))"
  }
  check "custom_oauth_providers_identifier_format" {
    expr = "(identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)"
  }
  check "custom_oauth_providers_issuer_length" {
    expr = "((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))"
  }
  check "custom_oauth_providers_jwks_uri_https" {
    expr = "((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))"
  }
  check "custom_oauth_providers_jwks_uri_length" {
    expr = "((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))"
  }
  check "custom_oauth_providers_name_length" {
    expr = "((char_length(name) >= 1) AND (char_length(name) <= 100))"
  }
  check "custom_oauth_providers_oauth2_requires_endpoints" {
    expr = "((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))"
  }
  check "custom_oauth_providers_oidc_discovery_url_https" {
    expr = "((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))"
  }
  check "custom_oauth_providers_oidc_issuer_https" {
    expr = "((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))"
  }
  check "custom_oauth_providers_oidc_requires_issuer" {
    expr = "((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))"
  }
  check "custom_oauth_providers_provider_type_check" {
    expr = "(provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))"
  }
  check "custom_oauth_providers_token_url_https" {
    expr = "((token_url IS NULL) OR (token_url ~~ 'https://%'::text))"
  }
  check "custom_oauth_providers_token_url_length" {
    expr = "((token_url IS NULL) OR (char_length(token_url) <= 2048))"
  }
  check "custom_oauth_providers_userinfo_url_https" {
    expr = "((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))"
  }
  check "custom_oauth_providers_userinfo_url_length" {
    expr = "((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048))"
  }
  unique "custom_oauth_providers_identifier_key" {
    columns = [column.identifier]
  }
}
table "flow_state" {
  schema  = schema.auth
  comment = "Stores metadata for all OAuth/SSO login flows"
  column "id" {
    null = false
    type = uuid
  }
  column "user_id" {
    null = true
    type = uuid
  }
  column "auth_code" {
    null = true
    type = text
  }
  column "code_challenge_method" {
    null = true
    type = enum.code_challenge_method
  }
  column "code_challenge" {
    null = true
    type = text
  }
  column "provider_type" {
    null = false
    type = text
  }
  column "provider_access_token" {
    null = true
    type = text
  }
  column "provider_refresh_token" {
    null = true
    type = text
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  column "authentication_method" {
    null = false
    type = text
  }
  column "auth_code_issued_at" {
    null = true
    type = timestamptz
  }
  column "invite_token" {
    null = true
    type = text
  }
  column "referrer" {
    null = true
    type = text
  }
  column "oauth_client_state_id" {
    null = true
    type = uuid
  }
  column "linking_target_id" {
    null = true
    type = uuid
  }
  column "email_optional" {
    null    = false
    type    = boolean
    default = false
  }
  primary_key {
    columns = [column.id]
  }
  index "flow_state_created_at_idx" {
    on {
      desc   = true
      column = column.created_at
    }
  }
  index "idx_auth_code" {
    columns = [column.auth_code]
  }
  index "idx_user_id_auth_method" {
    columns = [column.user_id, column.authentication_method]
  }
}
table "identities" {
  schema  = schema.auth
  comment = "Auth: Stores identities associated to a user."
  column "provider_id" {
    null = false
    type = text
  }
  column "user_id" {
    null = false
    type = uuid
  }
  column "identity_data" {
    null = false
    type = jsonb
  }
  column "provider" {
    null = false
    type = text
  }
  column "last_sign_in_at" {
    null = true
    type = timestamptz
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  column "email" {
    null    = true
    type    = text
    comment = "Auth: Email is a generated column that references the optional email property in the identity_data"
    as {
      expr = "lower((identity_data ->> 'email'::text))"
      type = STORED
    }
  }
  column "id" {
    null    = false
    type    = uuid
    default = sql("gen_random_uuid()")
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "identities_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "identities_email_idx" {
    comment = "Auth: Ensures indexed queries on the email column"
    on {
      column = column.email
      ops    = text_pattern_ops
    }
  }
  index "identities_user_id_idx" {
    columns = [column.user_id]
  }
  unique "identities_provider_id_provider_unique" {
    columns = [column.provider_id, column.provider]
  }
}
table "instances" {
  schema  = schema.auth
  comment = "Auth: Manages users across multiple sites."
  column "id" {
    null = false
    type = uuid
  }
  column "uuid" {
    null = true
    type = uuid
  }
  column "raw_base_config" {
    null = true
    type = text
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  primary_key {
    columns = [column.id]
  }
}
table "mfa_amr_claims" {
  schema  = schema.auth
  comment = "auth: stores authenticator method reference claims for multi factor authentication"
  column "session_id" {
    null = false
    type = uuid
  }
  column "created_at" {
    null = false
    type = timestamptz
  }
  column "updated_at" {
    null = false
    type = timestamptz
  }
  column "authentication_method" {
    null = false
    type = text
  }
  column "id" {
    null = false
    type = uuid
  }
  primary_key "amr_id_pk" {
    columns = [column.id]
  }
  foreign_key "mfa_amr_claims_session_id_fkey" {
    columns     = [column.session_id]
    ref_columns = [table.sessions.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  unique "mfa_amr_claims_session_id_authentication_method_pkey" {
    columns = [column.session_id, column.authentication_method]
  }
}
table "mfa_challenges" {
  schema  = schema.auth
  comment = "auth: stores metadata about challenge requests made"
  column "id" {
    null = false
    type = uuid
  }
  column "factor_id" {
    null = false
    type = uuid
  }
  column "created_at" {
    null = false
    type = timestamptz
  }
  column "verified_at" {
    null = true
    type = timestamptz
  }
  column "ip_address" {
    null = false
    type = inet
  }
  column "otp_code" {
    null = true
    type = text
  }
  column "web_authn_session_data" {
    null = true
    type = jsonb
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "mfa_challenges_auth_factor_id_fkey" {
    columns     = [column.factor_id]
    ref_columns = [table.mfa_factors.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "mfa_challenge_created_at_idx" {
    on {
      desc   = true
      column = column.created_at
    }
  }
}
table "mfa_factors" {
  schema  = schema.auth
  comment = "auth: stores metadata about factors"
  column "id" {
    null = false
    type = uuid
  }
  column "user_id" {
    null = false
    type = uuid
  }
  column "friendly_name" {
    null = true
    type = text
  }
  column "factor_type" {
    null = false
    type = enum.factor_type
  }
  column "status" {
    null = false
    type = enum.factor_status
  }
  column "created_at" {
    null = false
    type = timestamptz
  }
  column "updated_at" {
    null = false
    type = timestamptz
  }
  column "secret" {
    null = true
    type = text
  }
  column "phone" {
    null = true
    type = text
  }
  column "last_challenged_at" {
    null = true
    type = timestamptz
  }
  column "web_authn_credential" {
    null = true
    type = jsonb
  }
  column "web_authn_aaguid" {
    null = true
    type = uuid
  }
  column "last_webauthn_challenge_data" {
    null    = true
    type    = jsonb
    comment = "Stores the latest WebAuthn challenge data including attestation/assertion for customer verification"
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "mfa_factors_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "factor_id_created_at_idx" {
    columns = [column.user_id, column.created_at]
  }
  index "mfa_factors_user_friendly_name_unique" {
    unique  = true
    columns = [column.friendly_name, column.user_id]
    where   = "(TRIM(BOTH FROM friendly_name) <> ''::text)"
  }
  index "mfa_factors_user_id_idx" {
    columns = [column.user_id]
  }
  index "unique_phone_factor_per_user" {
    unique  = true
    columns = [column.user_id, column.phone]
  }
  unique "mfa_factors_last_challenged_at_key" {
    columns = [column.last_challenged_at]
  }
}
table "oauth_authorizations" {
  schema = schema.auth
  column "id" {
    null = false
    type = uuid
  }
  column "authorization_id" {
    null = false
    type = text
  }
  column "client_id" {
    null = false
    type = uuid
  }
  column "user_id" {
    null = true
    type = uuid
  }
  column "redirect_uri" {
    null = false
    type = text
  }
  column "scope" {
    null = false
    type = text
  }
  column "state" {
    null = true
    type = text
  }
  column "resource" {
    null = true
    type = text
  }
  column "code_challenge" {
    null = true
    type = text
  }
  column "code_challenge_method" {
    null = true
    type = enum.code_challenge_method
  }
  column "response_type" {
    null    = false
    type    = enum.oauth_response_type
    default = "code"
  }
  column "status" {
    null    = false
    type    = enum.oauth_authorization_status
    default = "pending"
  }
  column "authorization_code" {
    null = true
    type = text
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "expires_at" {
    null    = false
    type    = timestamptz
    default = sql("(now() + '00:03:00'::interval)")
  }
  column "approved_at" {
    null = true
    type = timestamptz
  }
  column "nonce" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "oauth_authorizations_client_id_fkey" {
    columns     = [column.client_id]
    ref_columns = [table.oauth_clients.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  foreign_key "oauth_authorizations_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "oauth_auth_pending_exp_idx" {
    columns = [column.expires_at]
    where   = "(status = 'pending'::auth.oauth_authorization_status)"
  }
  check "oauth_authorizations_authorization_code_length" {
    expr = "(char_length(authorization_code) <= 255)"
  }
  check "oauth_authorizations_code_challenge_length" {
    expr = "(char_length(code_challenge) <= 128)"
  }
  check "oauth_authorizations_expires_at_future" {
    expr = "(expires_at > created_at)"
  }
  check "oauth_authorizations_nonce_length" {
    expr = "(char_length(nonce) <= 255)"
  }
  check "oauth_authorizations_redirect_uri_length" {
    expr = "(char_length(redirect_uri) <= 2048)"
  }
  check "oauth_authorizations_resource_length" {
    expr = "(char_length(resource) <= 2048)"
  }
  check "oauth_authorizations_scope_length" {
    expr = "(char_length(scope) <= 4096)"
  }
  check "oauth_authorizations_state_length" {
    expr = "(char_length(state) <= 4096)"
  }
  unique "oauth_authorizations_authorization_code_key" {
    columns = [column.authorization_code]
  }
  unique "oauth_authorizations_authorization_id_key" {
    columns = [column.authorization_id]
  }
}
table "oauth_client_states" {
  schema  = schema.auth
  comment = "Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client."
  column "id" {
    null = false
    type = uuid
  }
  column "provider_type" {
    null = false
    type = text
  }
  column "code_verifier" {
    null = true
    type = text
  }
  column "created_at" {
    null = false
    type = timestamptz
  }
  primary_key {
    columns = [column.id]
  }
  index "idx_oauth_client_states_created_at" {
    columns = [column.created_at]
  }
}
table "oauth_clients" {
  schema = schema.auth
  column "id" {
    null = false
    type = uuid
  }
  column "client_secret_hash" {
    null = true
    type = text
  }
  column "registration_type" {
    null = false
    type = enum.oauth_registration_type
  }
  column "redirect_uris" {
    null = false
    type = text
  }
  column "grant_types" {
    null = false
    type = text
  }
  column "client_name" {
    null = true
    type = text
  }
  column "client_uri" {
    null = true
    type = text
  }
  column "logo_uri" {
    null = true
    type = text
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "updated_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "deleted_at" {
    null = true
    type = timestamptz
  }
  column "client_type" {
    null    = false
    type    = enum.oauth_client_type
    default = "confidential"
  }
  column "token_endpoint_auth_method" {
    null = false
    type = text
  }
  primary_key {
    columns = [column.id]
  }
  index "oauth_clients_deleted_at_idx" {
    columns = [column.deleted_at]
  }
  check "oauth_clients_client_name_length" {
    expr = "(char_length(client_name) <= 1024)"
  }
  check "oauth_clients_client_uri_length" {
    expr = "(char_length(client_uri) <= 2048)"
  }
  check "oauth_clients_logo_uri_length" {
    expr = "(char_length(logo_uri) <= 2048)"
  }
  check "oauth_clients_token_endpoint_auth_method_check" {
    expr = "(token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text]))"
  }
}
table "oauth_consents" {
  schema = schema.auth
  column "id" {
    null = false
    type = uuid
  }
  column "user_id" {
    null = false
    type = uuid
  }
  column "client_id" {
    null = false
    type = uuid
  }
  column "scopes" {
    null = false
    type = text
  }
  column "granted_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "revoked_at" {
    null = true
    type = timestamptz
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "oauth_consents_client_id_fkey" {
    columns     = [column.client_id]
    ref_columns = [table.oauth_clients.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  foreign_key "oauth_consents_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "oauth_consents_active_client_idx" {
    columns = [column.client_id]
    where   = "(revoked_at IS NULL)"
  }
  index "oauth_consents_active_user_client_idx" {
    columns = [column.user_id, column.client_id]
    where   = "(revoked_at IS NULL)"
  }
  index "oauth_consents_user_order_idx" {
    on {
      column = column.user_id
    }
    on {
      desc   = true
      column = column.granted_at
    }
  }
  check "oauth_consents_revoked_after_granted" {
    expr = "((revoked_at IS NULL) OR (revoked_at >= granted_at))"
  }
  check "oauth_consents_scopes_length" {
    expr = "(char_length(scopes) <= 2048)"
  }
  check "oauth_consents_scopes_not_empty" {
    expr = "(char_length(TRIM(BOTH FROM scopes)) > 0)"
  }
  unique "oauth_consents_user_client_unique" {
    columns = [column.user_id, column.client_id]
  }
}
table "one_time_tokens" {
  schema = schema.auth
  column "id" {
    null = false
    type = uuid
  }
  column "user_id" {
    null = false
    type = uuid
  }
  column "token_type" {
    null = false
    type = enum.one_time_token_type
  }
  column "token_hash" {
    null = false
    type = text
  }
  column "relates_to" {
    null = false
    type = text
  }
  column "created_at" {
    null    = false
    type    = timestamp
    default = sql("now()")
  }
  column "updated_at" {
    null    = false
    type    = timestamp
    default = sql("now()")
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "one_time_tokens_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "one_time_tokens_relates_to_hash_idx" {
    columns = [column.relates_to]
    type    = HASH
  }
  index "one_time_tokens_token_hash_hash_idx" {
    columns = [column.token_hash]
    type    = HASH
  }
  index "one_time_tokens_user_id_token_type_key" {
    unique  = true
    columns = [column.user_id, column.token_type]
  }
  check "one_time_tokens_token_hash_check" {
    expr = "(char_length(token_hash) > 0)"
  }
}
table "refresh_tokens" {
  schema  = schema.auth
  comment = "Auth: Store of tokens used to refresh JWT tokens once they expire."
  column "instance_id" {
    null = true
    type = uuid
  }
  column "id" {
    null = false
    type = bigserial
  }
  column "token" {
    null = true
    type = character_varying(255)
  }
  column "user_id" {
    null = true
    type = character_varying(255)
  }
  column "revoked" {
    null = true
    type = boolean
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  column "parent" {
    null = true
    type = character_varying(255)
  }
  column "session_id" {
    null = true
    type = uuid
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "refresh_tokens_session_id_fkey" {
    columns     = [column.session_id]
    ref_columns = [table.sessions.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "refresh_tokens_instance_id_idx" {
    columns = [column.instance_id]
  }
  index "refresh_tokens_instance_id_user_id_idx" {
    columns = [column.instance_id, column.user_id]
  }
  index "refresh_tokens_parent_idx" {
    columns = [column.parent]
  }
  index "refresh_tokens_session_id_revoked_idx" {
    columns = [column.session_id, column.revoked]
  }
  index "refresh_tokens_updated_at_idx" {
    on {
      desc   = true
      column = column.updated_at
    }
  }
  unique "refresh_tokens_token_unique" {
    columns = [column.token]
  }
}
table "saml_providers" {
  schema  = schema.auth
  comment = "Auth: Manages SAML Identity Provider connections."
  column "id" {
    null = false
    type = uuid
  }
  column "sso_provider_id" {
    null = false
    type = uuid
  }
  column "entity_id" {
    null = false
    type = text
  }
  column "metadata_xml" {
    null = false
    type = text
  }
  column "metadata_url" {
    null = true
    type = text
  }
  column "attribute_mapping" {
    null = true
    type = jsonb
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  column "name_id_format" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "saml_providers_sso_provider_id_fkey" {
    columns     = [column.sso_provider_id]
    ref_columns = [table.sso_providers.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "saml_providers_sso_provider_id_idx" {
    columns = [column.sso_provider_id]
  }
  check "entity_id not empty" {
    expr = "(char_length(entity_id) > 0)"
  }
  check "metadata_url not empty" {
    expr = "((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))"
  }
  check "metadata_xml not empty" {
    expr = "(char_length(metadata_xml) > 0)"
  }
  unique "saml_providers_entity_id_key" {
    columns = [column.entity_id]
  }
}
table "saml_relay_states" {
  schema  = schema.auth
  comment = "Auth: Contains SAML Relay State information for each Service Provider initiated login."
  column "id" {
    null = false
    type = uuid
  }
  column "sso_provider_id" {
    null = false
    type = uuid
  }
  column "request_id" {
    null = false
    type = text
  }
  column "for_email" {
    null = true
    type = text
  }
  column "redirect_to" {
    null = true
    type = text
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  column "flow_state_id" {
    null = true
    type = uuid
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "saml_relay_states_flow_state_id_fkey" {
    columns     = [column.flow_state_id]
    ref_columns = [table.flow_state.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  foreign_key "saml_relay_states_sso_provider_id_fkey" {
    columns     = [column.sso_provider_id]
    ref_columns = [table.sso_providers.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "saml_relay_states_created_at_idx" {
    on {
      desc   = true
      column = column.created_at
    }
  }
  index "saml_relay_states_for_email_idx" {
    columns = [column.for_email]
  }
  index "saml_relay_states_sso_provider_id_idx" {
    columns = [column.sso_provider_id]
  }
  check "request_id not empty" {
    expr = "(char_length(request_id) > 0)"
  }
}
table "auth" "schema_migrations" {
  schema  = schema.auth
  comment = "Auth: Manages updates to the auth system."
  column "version" {
    null = false
    type = character_varying(255)
  }
  primary_key {
    columns = [column.version]
  }
}
table "sessions" {
  schema  = schema.auth
  comment = "Auth: Stores session data associated to a user."
  column "id" {
    null = false
    type = uuid
  }
  column "user_id" {
    null = false
    type = uuid
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  column "factor_id" {
    null = true
    type = uuid
  }
  column "aal" {
    null = true
    type = enum.aal_level
  }
  column "not_after" {
    null    = true
    type    = timestamptz
    comment = "Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired."
  }
  column "refreshed_at" {
    null = true
    type = timestamp
  }
  column "user_agent" {
    null = true
    type = text
  }
  column "ip" {
    null = true
    type = inet
  }
  column "tag" {
    null = true
    type = text
  }
  column "oauth_client_id" {
    null = true
    type = uuid
  }
  column "refresh_token_hmac_key" {
    null    = true
    type    = text
    comment = "Holds a HMAC-SHA256 key used to sign refresh tokens for this session."
  }
  column "refresh_token_counter" {
    null    = true
    type    = bigint
    comment = "Holds the ID (counter) of the last issued refresh token."
  }
  column "scopes" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "sessions_oauth_client_id_fkey" {
    columns     = [column.oauth_client_id]
    ref_columns = [table.oauth_clients.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  foreign_key "sessions_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "sessions_not_after_idx" {
    on {
      desc   = true
      column = column.not_after
    }
  }
  index "sessions_oauth_client_id_idx" {
    columns = [column.oauth_client_id]
  }
  index "sessions_user_id_idx" {
    columns = [column.user_id]
  }
  index "user_id_created_at_idx" {
    columns = [column.user_id, column.created_at]
  }
  check "sessions_scopes_length" {
    expr = "(char_length(scopes) <= 4096)"
  }
}
table "sso_domains" {
  schema  = schema.auth
  comment = "Auth: Manages SSO email address domain mapping to an SSO Identity Provider."
  column "id" {
    null = false
    type = uuid
  }
  column "sso_provider_id" {
    null = false
    type = uuid
  }
  column "domain" {
    null = false
    type = text
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "sso_domains_sso_provider_id_fkey" {
    columns     = [column.sso_provider_id]
    ref_columns = [table.sso_providers.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "sso_domains_domain_idx" {
    unique = true
    on {
      expr = "lower(domain)"
    }
  }
  index "sso_domains_sso_provider_id_idx" {
    columns = [column.sso_provider_id]
  }
  check "domain not empty" {
    expr = "(char_length(domain) > 0)"
  }
}
table "sso_providers" {
  schema  = schema.auth
  comment = "Auth: Manages SSO identity provider information; see saml_providers for SAML."
  column "id" {
    null = false
    type = uuid
  }
  column "resource_id" {
    null    = true
    type    = text
    comment = "Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code."
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  column "disabled" {
    null = true
    type = boolean
  }
  primary_key {
    columns = [column.id]
  }
  index "sso_providers_resource_id_idx" {
    unique = true
    on {
      expr = "lower(resource_id)"
    }
  }
  index "sso_providers_resource_id_pattern_idx" {
    on {
      column = column.resource_id
      ops    = text_pattern_ops
    }
  }
  check "resource_id not empty" {
    expr = "((resource_id = NULL::text) OR (char_length(resource_id) > 0))"
  }
}
table "users" {
  schema  = schema.auth
  comment = "Auth: Stores user login data within a secure schema."
  column "instance_id" {
    null = true
    type = uuid
  }
  column "id" {
    null = false
    type = uuid
  }
  column "aud" {
    null = true
    type = character_varying(255)
  }
  column "role" {
    null = true
    type = character_varying(255)
  }
  column "email" {
    null = true
    type = character_varying(255)
  }
  column "encrypted_password" {
    null = true
    type = character_varying(255)
  }
  column "email_confirmed_at" {
    null = true
    type = timestamptz
  }
  column "invited_at" {
    null = true
    type = timestamptz
  }
  column "confirmation_token" {
    null = true
    type = character_varying(255)
  }
  column "confirmation_sent_at" {
    null = true
    type = timestamptz
  }
  column "recovery_token" {
    null = true
    type = character_varying(255)
  }
  column "recovery_sent_at" {
    null = true
    type = timestamptz
  }
  column "email_change_token_new" {
    null = true
    type = character_varying(255)
  }
  column "email_change" {
    null = true
    type = character_varying(255)
  }
  column "email_change_sent_at" {
    null = true
    type = timestamptz
  }
  column "last_sign_in_at" {
    null = true
    type = timestamptz
  }
  column "raw_app_meta_data" {
    null = true
    type = jsonb
  }
  column "raw_user_meta_data" {
    null = true
    type = jsonb
  }
  column "is_super_admin" {
    null = true
    type = boolean
  }
  column "created_at" {
    null = true
    type = timestamptz
  }
  column "updated_at" {
    null = true
    type = timestamptz
  }
  column "phone" {
    null    = true
    type    = text
    default = sql("NULL::character varying")
  }
  column "phone_confirmed_at" {
    null = true
    type = timestamptz
  }
  column "phone_change" {
    null    = true
    type    = text
    default = ""
  }
  column "phone_change_token" {
    null    = true
    type    = character_varying(255)
    default = ""
  }
  column "phone_change_sent_at" {
    null = true
    type = timestamptz
  }
  column "confirmed_at" {
    null = true
    type = timestamptz
    as {
      expr = "LEAST(email_confirmed_at, phone_confirmed_at)"
      type = STORED
    }
  }
  column "email_change_token_current" {
    null    = true
    type    = character_varying(255)
    default = ""
  }
  column "email_change_confirm_status" {
    null    = true
    type    = smallint
    default = 0
  }
  column "banned_until" {
    null = true
    type = timestamptz
  }
  column "reauthentication_token" {
    null    = true
    type    = character_varying(255)
    default = ""
  }
  column "reauthentication_sent_at" {
    null = true
    type = timestamptz
  }
  column "is_sso_user" {
    null    = false
    type    = boolean
    default = false
    comment = "Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails."
  }
  column "deleted_at" {
    null = true
    type = timestamptz
  }
  column "is_anonymous" {
    null    = false
    type    = boolean
    default = false
  }
  primary_key {
    columns = [column.id]
  }
  index "confirmation_token_idx" {
    unique  = true
    columns = [column.confirmation_token]
    where   = "((confirmation_token)::text !~ '^[0-9 ]*$'::text)"
  }
  index "email_change_token_current_idx" {
    unique  = true
    columns = [column.email_change_token_current]
    where   = "((email_change_token_current)::text !~ '^[0-9 ]*$'::text)"
  }
  index "email_change_token_new_idx" {
    unique  = true
    columns = [column.email_change_token_new]
    where   = "((email_change_token_new)::text !~ '^[0-9 ]*$'::text)"
  }
  index "idx_users_created_at_desc" {
    on {
      desc   = true
      column = column.created_at
    }
  }
  index "idx_users_email" {
    columns = [column.email]
  }
  index "idx_users_last_sign_in_at_desc" {
    on {
      desc   = true
      column = column.last_sign_in_at
    }
  }
  index "idx_users_name" {
    where = "((raw_user_meta_data ->> 'name'::text) IS NOT NULL)"
    on {
      expr = "((raw_user_meta_data ->> 'name'::text))"
    }
  }
  index "reauthentication_token_idx" {
    unique  = true
    columns = [column.reauthentication_token]
    where   = "((reauthentication_token)::text !~ '^[0-9 ]*$'::text)"
  }
  index "recovery_token_idx" {
    unique  = true
    columns = [column.recovery_token]
    where   = "((recovery_token)::text !~ '^[0-9 ]*$'::text)"
  }
  index "users_email_partial_key" {
    unique  = true
    columns = [column.email]
    comment = "Auth: A partial unique index that applies only when is_sso_user is false"
    where   = "(is_sso_user = false)"
  }
  index "users_instance_id_email_idx" {
    on {
      column = column.instance_id
    }
    on {
      expr = "lower((email)::text)"
    }
  }
  index "users_instance_id_idx" {
    columns = [column.instance_id]
  }
  index "users_is_anonymous_idx" {
    columns = [column.is_anonymous]
  }
  check "users_email_change_confirm_status_check" {
    expr = "((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2))"
  }
  unique "users_phone_key" {
    columns = [column.phone]
  }
}
table "webauthn_challenges" {
  schema = schema.auth
  column "id" {
    null    = false
    type    = uuid
    default = sql("gen_random_uuid()")
  }
  column "user_id" {
    null = true
    type = uuid
  }
  column "challenge_type" {
    null = false
    type = text
  }
  column "session_data" {
    null = false
    type = jsonb
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "expires_at" {
    null = false
    type = timestamptz
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "webauthn_challenges_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "webauthn_challenges_expires_at_idx" {
    columns = [column.expires_at]
  }
  index "webauthn_challenges_user_id_idx" {
    columns = [column.user_id]
  }
  check "webauthn_challenges_challenge_type_check" {
    expr = "(challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text]))"
  }
}
table "webauthn_credentials" {
  schema = schema.auth
  column "id" {
    null    = false
    type    = uuid
    default = sql("gen_random_uuid()")
  }
  column "user_id" {
    null = false
    type = uuid
  }
  column "credential_id" {
    null = false
    type = bytea
  }
  column "public_key" {
    null = false
    type = bytea
  }
  column "attestation_type" {
    null    = false
    type    = text
    default = ""
  }
  column "aaguid" {
    null = true
    type = uuid
  }
  column "sign_count" {
    null    = false
    type    = bigint
    default = 0
  }
  column "transports" {
    null    = false
    type    = jsonb
    default = "[]"
  }
  column "backup_eligible" {
    null    = false
    type    = boolean
    default = false
  }
  column "backed_up" {
    null    = false
    type    = boolean
    default = false
  }
  column "friendly_name" {
    null    = false
    type    = text
    default = ""
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "updated_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "last_used_at" {
    null = true
    type = timestamptz
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "webauthn_credentials_user_id_fkey" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
  index "webauthn_credentials_credential_id_key" {
    unique  = true
    columns = [column.credential_id]
  }
  index "webauthn_credentials_user_id_idx" {
    columns = [column.user_id]
  }
}
table "condo_metrics" {
  schema  = schema.public
  comment = "The user rated metrics of each building."
  column "id" {
    null    = false
    type    = text
    default = sql("gen_random_uuid()")
  }
  column "building_id" {
    null = false
    type = text
  }
  column "metric_type" {
    null = false
    type = enum.metrictype
  }
  column "metric_value" {
    null = true
    type = integer
  }
  column "comment" {
    null = true
    type = text
  }
  column "date_created" {
    null    = false
    type    = date
    default = sql("CURRENT_DATE")
  }
  foreign_key "condo_building_id_fkey" {
    columns     = [column.id]
    ref_columns = [table.condos.column.id]
    on_update   = CASCADE
    on_delete   = CASCADE
  }
}
table "condos" {
  schema  = schema.public
  comment = "Table contains the condo data object definition."
  column "id" {
    null    = false
    type    = text
    default = sql("gen_random_uuid()")
  }
  column "building_name" {
    null = false
    type = text
  }
  column "address" {
    null    = false
    type    = text
    comment = "Address includes number and street"
  }
  column "city" {
    null = false
    type = text
  }
  column "description" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.id]
  }
}
table "messages" {
  schema = schema.realtime
  column "topic" {
    null = false
    type = text
  }
  column "extension" {
    null = false
    type = text
  }
  column "payload" {
    null = true
    type = jsonb
  }
  column "event" {
    null = true
    type = text
  }
  column "private" {
    null    = true
    type    = boolean
    default = false
  }
  column "updated_at" {
    null    = false
    type    = timestamp
    default = sql("now()")
  }
  column "inserted_at" {
    null    = false
    type    = timestamp
    default = sql("now()")
  }
  column "id" {
    null    = false
    type    = uuid
    default = sql("gen_random_uuid()")
  }
  primary_key {
    columns = [column.id, column.inserted_at]
  }
  index "messages_inserted_at_topic_index" {
    where = "((extension = 'broadcast'::text) AND (private IS TRUE))"
    on {
      desc   = true
      column = column.inserted_at
    }
    on {
      column = column.topic
    }
  }
  partition {
    type    = RANGE
    columns = [column.inserted_at]
  }
}
table "realtime" "schema_migrations" {
  schema = schema.realtime
  column "version" {
    null = false
    type = bigint
  }
  column "inserted_at" {
    null = true
    type = timestamp(0)
  }
  primary_key {
    columns = [column.version]
  }
}
table "subscription" {
  schema = schema.realtime
  column "id" {
    null = false
    type = bigint
    identity {
      generated = ALWAYS
    }
  }
  column "subscription_id" {
    null = false
    type = uuid
  }
  column "entity" {
    null = false
    type = regclass
  }
  column "filters" {
    null    = false
    type    = sql("realtime.user_defined_filter[]")
    default = "{}"
  }
  column "claims" {
    null = false
    type = jsonb
  }
  column "claims_role" {
    null = false
    type = regrole
    as {
      expr = "realtime.to_regrole((claims ->> 'role'::text))"
      type = STORED
    }
  }
  column "created_at" {
    null    = false
    type    = timestamp
    default = sql("timezone('utc'::text, now())")
  }
  column "action_filter" {
    null    = true
    type    = text
    default = "*"
  }
  primary_key "pk_subscription" {
    columns = [column.id]
  }
  index "ix_realtime_subscription_entity" {
    columns = [column.entity]
  }
  index "subscription_subscription_id_entity_filters_action_filter_key" {
    unique  = true
    columns = [column.subscription_id, column.entity, column.filters, column.action_filter]
  }
  check "subscription_action_filter_check" {
    expr = "(action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text]))"
  }
}
table "buckets" {
  schema = schema.storage
  column "id" {
    null = false
    type = text
  }
  column "name" {
    null = false
    type = text
  }
  column "owner" {
    null    = true
    type    = uuid
    comment = "Field is deprecated, use owner_id instead"
  }
  column "created_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  column "updated_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  column "public" {
    null    = true
    type    = boolean
    default = false
  }
  column "avif_autodetection" {
    null    = true
    type    = boolean
    default = false
  }
  column "file_size_limit" {
    null = true
    type = bigint
  }
  column "allowed_mime_types" {
    null = true
    type = sql("text[]")
  }
  column "owner_id" {
    null = true
    type = text
  }
  column "type" {
    null    = false
    type    = enum.buckettype
    default = "STANDARD"
  }
  primary_key {
    columns = [column.id]
  }
  index "bname" {
    unique  = true
    columns = [column.name]
  }
}
table "buckets_analytics" {
  schema = schema.storage
  column "name" {
    null = false
    type = text
  }
  column "type" {
    null    = false
    type    = enum.buckettype
    default = "ANALYTICS"
  }
  column "format" {
    null    = false
    type    = text
    default = "ICEBERG"
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "updated_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "id" {
    null    = false
    type    = uuid
    default = sql("gen_random_uuid()")
  }
  column "deleted_at" {
    null = true
    type = timestamptz
  }
  primary_key {
    columns = [column.id]
  }
  index "buckets_analytics_unique_name_idx" {
    unique  = true
    columns = [column.name]
    where   = "(deleted_at IS NULL)"
  }
}
table "buckets_vectors" {
  schema = schema.storage
  column "id" {
    null = false
    type = text
  }
  column "type" {
    null    = false
    type    = enum.buckettype
    default = "VECTOR"
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "updated_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  primary_key {
    columns = [column.id]
  }
}
table "migrations" {
  schema = schema.storage
  column "id" {
    null = false
    type = integer
  }
  column "name" {
    null = false
    type = character_varying(100)
  }
  column "hash" {
    null = false
    type = character_varying(40)
  }
  column "executed_at" {
    null    = true
    type    = timestamp
    default = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.id]
  }
  unique "migrations_name_key" {
    columns = [column.name]
  }
}
table "objects" {
  schema = schema.storage
  column "id" {
    null    = false
    type    = uuid
    default = sql("gen_random_uuid()")
  }
  column "bucket_id" {
    null = true
    type = text
  }
  column "name" {
    null = true
    type = text
  }
  column "owner" {
    null    = true
    type    = uuid
    comment = "Field is deprecated, use owner_id instead"
  }
  column "created_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  column "updated_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  column "last_accessed_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  column "metadata" {
    null = true
    type = jsonb
  }
  column "path_tokens" {
    null = true
    type = sql("text[]")
    as {
      expr = "string_to_array(name, '/'::text)"
      type = STORED
    }
  }
  column "version" {
    null = true
    type = text
  }
  column "owner_id" {
    null = true
    type = text
  }
  column "user_metadata" {
    null = true
    type = jsonb
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "objects_bucketId_fkey" {
    columns     = [column.bucket_id]
    ref_columns = [table.buckets.column.id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
  index "bucketid_objname" {
    unique  = true
    columns = [column.bucket_id, column.name]
  }
  index "idx_objects_bucket_id_name" {
    columns = [column.bucket_id, column.name]
  }
  index "idx_objects_bucket_id_name_lower" {
    on {
      column = column.bucket_id
    }
    on {
      expr = "lower(name)"
    }
  }
  index "name_prefix_search" {
    on {
      column = column.name
      ops    = text_pattern_ops
    }
  }
}
table "s3_multipart_uploads" {
  schema = schema.storage
  column "id" {
    null = false
    type = text
  }
  column "in_progress_size" {
    null    = false
    type    = bigint
    default = 0
  }
  column "upload_signature" {
    null = false
    type = text
  }
  column "bucket_id" {
    null = false
    type = text
  }
  column "key" {
    null    = false
    type    = text
    collate = "C"
  }
  column "version" {
    null = false
    type = text
  }
  column "owner_id" {
    null = true
    type = text
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "user_metadata" {
    null = true
    type = jsonb
  }
  column "metadata" {
    null = true
    type = jsonb
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "s3_multipart_uploads_bucket_id_fkey" {
    columns     = [column.bucket_id]
    ref_columns = [table.buckets.column.id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
  index "idx_multipart_uploads_list" {
    columns = [column.bucket_id, column.key, column.created_at]
  }
}
table "s3_multipart_uploads_parts" {
  schema = schema.storage
  column "id" {
    null    = false
    type    = uuid
    default = sql("gen_random_uuid()")
  }
  column "upload_id" {
    null = false
    type = text
  }
  column "size" {
    null    = false
    type    = bigint
    default = 0
  }
  column "part_number" {
    null = false
    type = integer
  }
  column "bucket_id" {
    null = false
    type = text
  }
  column "key" {
    null    = false
    type    = text
    collate = "C"
  }
  column "etag" {
    null = false
    type = text
  }
  column "owner_id" {
    null = true
    type = text
  }
  column "version" {
    null = false
    type = text
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "s3_multipart_uploads_parts_bucket_id_fkey" {
    columns     = [column.bucket_id]
    ref_columns = [table.buckets.column.id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
  foreign_key "s3_multipart_uploads_parts_upload_id_fkey" {
    columns     = [column.upload_id]
    ref_columns = [table.s3_multipart_uploads.column.id]
    on_update   = NO_ACTION
    on_delete   = CASCADE
  }
}
table "vector_indexes" {
  schema = schema.storage
  column "id" {
    null    = false
    type    = text
    default = sql("gen_random_uuid()")
  }
  column "name" {
    null    = false
    type    = text
    collate = "C"
  }
  column "bucket_id" {
    null = false
    type = text
  }
  column "data_type" {
    null = false
    type = text
  }
  column "dimension" {
    null = false
    type = integer
  }
  column "distance_metric" {
    null = false
    type = text
  }
  column "metadata_configuration" {
    null = true
    type = jsonb
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "updated_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "vector_indexes_bucket_id_fkey" {
    columns     = [column.bucket_id]
    ref_columns = [table.buckets_vectors.column.id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
  }
  index "vector_indexes_name_bucket_id_idx" {
    unique  = true
    columns = [column.name, column.bucket_id]
  }
}
enum "factor_type" {
  schema = schema.auth
  values = ["totp", "webauthn", "phone"]
}
enum "factor_status" {
  schema = schema.auth
  values = ["unverified", "verified"]
}
enum "aal_level" {
  schema = schema.auth
  values = ["aal1", "aal2", "aal3"]
}
enum "code_challenge_method" {
  schema = schema.auth
  values = ["s256", "plain"]
}
enum "one_time_token_type" {
  schema = schema.auth
  values = ["confirmation_token", "reauthentication_token", "recovery_token", "email_change_token_new", "email_change_token_current", "phone_change_token"]
}
enum "oauth_registration_type" {
  schema = schema.auth
  values = ["dynamic", "manual"]
}
enum "oauth_authorization_status" {
  schema = schema.auth
  values = ["pending", "approved", "denied", "expired"]
}
enum "oauth_response_type" {
  schema = schema.auth
  values = ["code"]
}
enum "oauth_client_type" {
  schema = schema.auth
  values = ["public", "confidential"]
}
enum "metrictype" {
  schema = schema.public
  values = ["AGE", "ELEVATOR_QUALITY", "UTILITIES_COST", "SOUNDPROOFING", "SAFETY", "NEIGHBOURHOOD", "CONCIERGE", "AMENITIES", "MAINTENANCE", "CLEANLINESS"]
}
enum "equality_op" {
  schema = schema.realtime
  values = ["eq", "neq", "lt", "lte", "gt", "gte", "in"]
}
enum "action" {
  schema = schema.realtime
  values = ["INSERT", "UPDATE", "DELETE", "TRUNCATE", "ERROR"]
}
enum "buckettype" {
  schema = schema.storage
  values = ["STANDARD", "ANALYTICS", "VECTOR"]
}
schema "auth" {
}
schema "extensions" {
}
schema "graphql" {
}
schema "graphql_public" {
}
schema "pgbouncer" {
}
schema "public" {
  comment = "standard public schema"
}
schema "realtime" {
}
schema "storage" {
}
schema "vault" {
}

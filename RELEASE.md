# Pre-Deployment Checklist for CDEK API Client

> **Last Updated:** January 2026  
> This checklist follows RubyGems best practices and security guidelines for 2026.

## Pre-Release: Versioning & Documentation

* [ ] **Decide version bump** using [Semantic Versioning][15]:
  - **MAJOR** (x.0.0): Breaking changes that require user action
  - **MINOR** (x.y.0): New features, backwards compatible
  - **PATCH** (x.y.z): Bug fixes, internal improvements
* [ ] **Update `CHANGELOG.md`** following [Keep a Changelog][7] format:
  - Add entries under `[Unreleased]` section
  - Include all user-facing changes (Added, Changed, Deprecated, Removed, Fixed, Security)
  - Use clear, descriptive language
  - Add comparison links for version tags
* [ ] **Update gem version** in `lib/cdek_api_client/version.rb`
* [ ] **Verify changelog format** matches Keep a Changelog standards
* [ ] **Review all commits** since last release to ensure nothing is missed

## Gemspec Validation

* [ ] **Verify runtime dependencies** are declared in `.gemspec` (not Gemfile). ([bundler.io][2])
* [ ] **Check all required metadata fields** are present:
  - `name`, `version`, `authors`, `email`
  - `summary` (short, < 140 chars)
  - `description` (detailed)
  - `homepage` (valid URL)
  - `license` (MIT in this case)
  - `required_ruby_version` (>= 3.0)
* [ ] **Verify metadata URIs** are correct and accessible:
  - `homepage_uri`
  - `source_code_uri`
  - `changelog_uri`
  - `github_repo` (if applicable)
* [ ] **Confirm MFA requirement**: `metadata['rubygems_mfa_required'] = 'true'` is set ([guides.rubygems.org][9])
* [ ] **For private gems**: Set `metadata['allowed_push_host']` if needed ([guides.rubygems.org][1])
* [ ] **Verify `spec.files`** includes all necessary files (lib, README, CHANGELOG)
* [ ] **Check no secrets or sensitive data** are included in packaged files

## Testing & Quality Assurance

* [ ] **Run full test suite**: `bundle exec rspec` passes on all supported Ruby versions
* [ ] **Run linter**: `bundle exec rubocop` passes with no offenses
* [ ] **Security audit**: `bundle exec bundle audit check --update` is clean
  - Document any ignored vulnerabilities with justification if needed ([GitHub][5])
* [ ] **Verify CI/CD pipeline** passes (GitHub Actions workflow)
* [ ] **Test across Ruby versions** (if applicable): Ensure compatibility with required_ruby_version
* [ ] **Check documentation builds**: `bundle exec yard doc` generates without errors

## Build & Local Verification

* [ ] **Build the gem**: `bundle exec gem build cdek_api_client.gemspec` (creates `*.gem` file)
* [ ] **Inspect gem contents**: `gem spec cdek_api_client-<version>.gem` to verify metadata
* [ ] **Install locally**: `gem install ./cdek_api_client-<version>.gem`
* [ ] **Smoke test**: Require and use the gem in a minimal script to verify it works
* [ ] **Verify packaged files**: Check that only intended files are included (no secrets, no test files, no large data files)
* [ ] **Check gem size**: Ensure it's reasonable (not unexpectedly large)

## Security & Access Control

* [ ] **RubyGems account MFA**: Verify MFA is enabled for **both UI and API** operations ([guides.rubygems.org][8])
  - Prefer WebAuthn/security devices when possible for stronger security
  - Store recovery codes securely
* [ ] **Gem-level MFA requirement**: Confirm `rubygems_mfa_required: 'true'` in gemspec ([guides.rubygems.org][9])
* [ ] **All gem owners** have MFA enabled (check via RubyGems UI)
* [ ] **Trusted Publishing setup** (recommended for 2026):
  - Verify trusted publisher is configured on RubyGems.org
  - Confirm workflow file name matches trusted publisher configuration
  - Ensure GitHub repository owner/name matches exactly
  - If using GitHub Environment, verify it's configured correctly ([guides.rubygems.org][3])
* [ ] **If using API key** (not recommended, prefer trusted publishing):
  - Key is scoped appropriately ([guides.rubygems.org][10])
  - Key is rotated regularly
  - CI uses `GEM_HOST_API_KEY` environment variable (never committed)
* [ ] **Review gem owners**: Remove any inactive or unnecessary owners
* [ ] **Check RubyGems status**: Verify RubyGems.org is operational before release

## Release Execution

* [ ] **Create release commit**:
  - Update version in `lib/cdek_api_client/version.rb`
  - Update `CHANGELOG.md` with release date and version
  - Commit with message: `"Release v<version>"`
* [ ] **Create and push git tag**:
  - Tag format: `v<version>` (e.g., `v0.3.0`)
  - Push tag: `git push origin v<version>`
* [ ] **Publish via preferred method**:
  - **Recommended (2026)**: GitHub Actions with Trusted Publishing
    - Create GitHub Release (triggers workflow automatically)
    - Workflow uses `rubygems/release-gem@v1` action
    - No manual intervention needed ([guides.rubygems.org][3])
  - **Alternative**: Manual via `gem push` (requires MFA)
    - `gem push cdek_api_client-<version>.gem`
    - Only if trusted publishing is not available

## Post-Release Verification

* [ ] **Verify gem appears on RubyGems.org**:
  - Check gem page: `https://rubygems.org/gems/cdek_api_client`
  - Confirm version number is correct
  - Verify "Published with MFA" badge is visible
  - Check "New versions require MFA" indicator is present
* [ ] **Verify metadata displays correctly**:
  - Homepage link works
  - Source code URI is correct
  - Changelog URI links to correct section
  - License is displayed
* [ ] **Test installation**:
  - `gem install cdek_api_client -v <version>` works
  - `bundle install` with gem in Gemfile works
* [ ] **Verify GitHub Release** (if created):
  - Release notes are accurate
  - Tag points to correct commit
  - Release includes changelog summary
* [ ] **Update documentation** (if needed):
  - README examples still work
  - Any breaking changes are documented
* [ ] **Announce release** (optional but recommended):
  - Update project status/roadmap
  - Notify users of significant changes
  - Share on relevant channels (if applicable)

## Emergency Procedures

* [ ] **If release is broken**: Know how to yank a version
  - `gem yank cdek_api_client -v <version>`
  - Document the yank reason
  - Release a fixed version promptly ([guides.rubygems.org][14])
* [ ] **Security vulnerability response**: Have a process for:
  - Receiving vulnerability reports
  - Releasing security patches
  - Communicating with users

## Additional Best Practices (2026)

* [ ] **Dependency management**:
  - Use pessimistic version constraints (`~> x.y`) for dependencies
  - Regularly update dependencies via Dependabot or similar
  - Review dependency changes before merging
* [ ] **Documentation**:
  - Keep README up to date
  - Ensure code examples work
  - Document any breaking changes clearly
* [ ] **CI/CD improvements**:
  - Consider adding Ruby version matrix testing
  - Add automated changelog validation
  - Consider automated dependency updates
* [ ] **Monitoring**:
  - Monitor gem download statistics
  - Watch for issues or bug reports
  - Track dependency health

---

## References

[1]: https://guides.rubygems.org/publishing/ "Publishing your gem - RubyGems Guides"
[2]: https://bundler.io/guides/creating_gem.html "Bundler: How to create a Ruby gem with Bundler"
[3]: https://guides.rubygems.org/trusted-publishing/releasing-gems/ "Releasing gems with a trusted publisher - RubyGems Guides"
[4]: https://guides.rubygems.org/security/ "Security - RubyGems Guides"
[5]: https://github.com/rubysec/bundler-audit "rubysec/bundler-audit: Patch-level verification for bundled dependencies"
[6]: https://docs.github.com/en/code-security/dependabot "Configuring Dependabot version updates"
[7]: https://keepachangelog.com/en/1.0.0/ "Keep a Changelog"
[8]: https://guides.rubygems.org/setting-up-multifactor-authentication/ "Setting up multi-factor authentication - RubyGems Guides"
[9]: https://guides.rubygems.org/mfa-requirement-opt-in/ "MFA requirement opt-in - RubyGems Guides"
[10]: https://guides.rubygems.org/api-key-scopes/ "API key scopes - RubyGems Guides"
[11]: https://schneems.com/blogs/2016-03-18-bundler-release-tasks "Easier Gem Releases with Bundler Release Tasks"
[12]: https://guides.rubygems.org/specification-reference/ "Specification Reference - RubyGems Guides"
[13]: https://guides.rubygems.org/managing-owners-using-ui/ "Managing Owners via UI - RubyGems Guides"
[14]: https://guides.rubygems.org/removing-a-published-gem/ "Removing a published gem - RubyGems Guides"
[15]: https://semver.org/spec/v2.0.0.html "Semantic Versioning 2.0.0"
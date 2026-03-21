# Launch Checklist

## Pre-Launch

### Templates
- [ ] Test each template with `dbt seed && dbt run && dbt test` locally (using DuckDB)
- [ ] Run `dbt docs generate` and review docs site for each template
- [ ] Verify all models compile without errors
- [ ] Check all tests pass
- [ ] Review staging model column mappings — document edge cases

### GitHub Setup
- [ ] Make repository public
- [ ] Add topics: `dbt`, `analytics-engineering`, `saas`, `ecommerce`, `fintech`, `open-source`
- [ ] Add a `CONTRIBUTING.md`
- [ ] Add screenshots of `dbt docs` output to README
- [ ] Create first GitHub Release with a tag (e.g. `v1.0.0`)
- [ ] Add to `awesome-dbt` list (GitHub PR)

### Gumroad Setup (optional — for email capture)
- [ ] Create Gumroad account
- [ ] Create product for each template using copy from `marketplace/gumroad/`
- [ ] Set price to $0 with "pay what you want" enabled
- [ ] Upload ZIP files (run `bash marketplace/scripts/package_templates.sh` first)
- [ ] Test download flow end-to-end
- [ ] Note: primary value here is collecting buyer emails for update announcements

### Distribution
- [ ] Post launch thread on Twitter/X (use templates in `social-post-templates.md`)
- [ ] Post on LinkedIn
- [ ] Submit to r/dataengineering
- [ ] Post in dbt Slack (#tools-and-integrations)
- [ ] Post in Analytics Engineering Discord
- [ ] Email your newsletter (if you have one)
- [ ] Submit to Data Engineering Weekly newsletter

---

## Post-Launch

### Week 1
- [ ] Respond to every issue/comment within 24 hours
- [ ] Note common questions → add to README FAQ sections
- [ ] Check GitHub stars and referral traffic

### Month 1
- [ ] Incorporate any community feedback / bug fixes
- [ ] Cut a `v1.1.0` release
- [ ] Ask early users for testimonials to add to README
- [ ] Consider a 4th template based on most-requested industry

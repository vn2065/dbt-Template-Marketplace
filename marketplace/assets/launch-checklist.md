# Launch Checklist

## Pre-Launch

### Templates
- [ ] Test each template with `dbt seed && dbt run && dbt test` locally (using DuckDB)
- [ ] Run `dbt docs generate` and review docs site for each template
- [ ] Verify all models compile without errors
- [ ] Check all tests pass
- [ ] Review staging model column mappings — document edge cases
- [ ] Package each template into a zip: `bash marketplace/scripts/package_templates.sh`
- [ ] Test each zip unpacks correctly

### Gumroad Setup
- [ ] Create Gumroad account at gumroad.com
- [ ] Connect Stripe for payouts
- [ ] Create product for each template (use copy from `marketplace/gumroad/`)
- [ ] Upload ZIP files as product assets
- [ ] Add a PDF setup guide to each product
- [ ] Set up bundle product at $349
- [ ] Configure 30% affiliate commission
- [ ] Add 14-day refund policy
- [ ] Set up custom domain (optional): store.yourdomain.com
- [ ] Test purchase flow end-to-end (buy your own product)
- [ ] Verify download/delivery works

### Content
- [ ] Write setup guide PDFs (one per template)
- [ ] Record 5-min walkthrough video (optional but high-converting)
- [ ] Take screenshots of `dbt docs` for listing images
- [ ] Create social graphics (Figma or Canva)

### Distribution
- [ ] Post launch thread on Twitter/X
- [ ] Post on LinkedIn
- [ ] Submit to r/dataengineering
- [ ] Post in dbt Slack (#tools-and-integrations or #analytics-engineering)
- [ ] Post in relevant Discord servers (Data Engineering, Analytics Engineering)
- [ ] Email your newsletter (if you have one)
- [ ] Submit to relevant newsletters (Data Engineering Weekly, Benn Stancil, etc.)

### SEO (optional but valuable)
- [ ] Write a blog post: "How I built a SaaS MRR model in dbt"
- [ ] Submit to dev.to / Hashnode
- [ ] Add to your GitHub profile README

---

## Post-Launch

### Week 1
- [ ] Respond to every customer email within 24 hours
- [ ] Note common questions → add to FAQ in listing
- [ ] Check analytics: views, conversion rate, refunds
- [ ] Ask first 3 customers for feedback/testimonials

### Month 1
- [ ] Collect testimonials → add to listings
- [ ] Fix any bugs reported by customers
- [ ] Release update to existing customers (Gumroad sends automatically)
- [ ] Analyze which template sells best → double down
- [ ] Consider a 4th template based on demand signals

### Ongoing
- [ ] Update templates when dbt releases major versions
- [ ] Add new metrics based on customer requests
- [ ] Build email list from buyers for future launches

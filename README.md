# Customer Discovery & Outreach Skill

Codex skill for B2B lead discovery and customer-list operations: Xiaoman OKKI public-sea collection, resumable pagination/virtual scrolling, deduplication, contact and email qualification, country/timezone enrichment, company and buyer research, Excel delivery, and outreach performance reporting.

## Install

Place this folder in a Codex skills directory and keep the folder name `customer-discovery-outreach`. Codex discovers the skill from its `SKILL.md` frontmatter. The skill can also be used as a reference repository without installation.

## Contents

- `SKILL.md`: shared workflow, routing and data-handling rules.
- `references/public-sea-collection.md`: page/API collection, virtual scrolling, checkpoints and audit counts.
- `references/qualification-and-dedup.md`: email evidence, buyer classification, filters and deduplication.
- `references/company-research.md`: OKKI/CRM matching, trade signals, suppliers, buyers and decision makers.
- `references/dashboard-and-outreach.md`: coverage, sent, delivery, opens, replies, bounces and follow-up metrics.
- `scripts/`: opt-in Windows task that publishes changes to this repository every five minutes.

## Automatic updates

Run `scripts/install-auto-publish-task.ps1` once from this checked-out repository. It registers a current-user scheduled task that checks the skill files every five minutes and commits/pushes changes to the configured `origin` branch. Git must already be authenticated. The publisher stages only `SKILL.md`, `README.md`, `.gitignore`, `agents/`, `references/` and `scripts/`; it does not stage CRM exports or other files.

To stop automatic publishing, run:

```powershell
Unregister-ScheduledTask -TaskName 'CodexSkillAutoPublish-CustomerDiscoveryOutreach' -Confirm:$false
```

No customer lists, credentials, CRM cookies, message logs, or local runtime state belong in this public repository.

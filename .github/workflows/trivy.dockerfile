# Pin inmutable de Trivy para ci-simple.yml (GHSA-69fq-xp46-6x23: nunca :latest).
# Dependabot (ecosistema docker, directory /.github/workflows) mantiene version+digest.
FROM docker.io/aquasec/trivy:0.75.0@sha256:af6acf9a6b85dfe389a1941505c0ce9efef52a4719635e1a962f022a3d855daa

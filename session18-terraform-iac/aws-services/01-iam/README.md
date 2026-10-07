# AWS IAM — Identity & Access Management

IAM controls **who can access which resources** in an AWS account. Identities authenticate through credentials, and policies determine the actions they may perform.

---

## Core Concepts

### Users
An individual identity for a person or service that needs long-term AWS access. Each user has credentials (password for console, access keys for CLI/SDK).

### Groups
A collection of users. Attach a policy to a group once, and all users in it inherit the permissions. Easier than attaching policies per user.

### Roles
An identity that AWS resources *assume* temporarily. No long-term credentials — AWS hands out short-lived tokens. Used for EC2 instances, Lambda functions, cross-account access, federated users.

### Policies
JSON documents listing which actions are **Allow**ed or **Deny**ed on which resources.

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::my-bucket/*"
  }]
}
```

Common identity policy options are **AWS managed** policies, **customer managed** policies, and **inline** policies embedded in a user, group, or role.

### Permissions
The actions an identity may perform on a resource. AWS evaluates the applicable policies; an explicit deny overrides an allow. [AWS policy evaluation](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)

---

## Least Privilege

Only grant the minimum permissions needed for the task. Don't attach `AdministratorAccess` because "it works." Start with nothing, add specific actions.

---

## IAM Best Practices

1. Reserve root access for tasks that require it. Prefer federation and temporary credentials for people.
2. Enable MFA on root and all human users.
3. Use roles for applications, never embed access keys in code.
4. Where long-term keys are necessary, protect them, replace them when needed, and remove unused keys.
5. Audit with IAM Access Analyzer and CloudTrail.
6. Use groups for permissions, not direct user attachments.
7. Start with managed policies where appropriate, then narrow permissions to the access required.

These practices follow the [AWS IAM security guidance](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html).

---

## Common Use Cases

- **EC2 instance role** so an app can read from S3 without hardcoded keys.
- **Cross-account roles** so a dev account can deploy to a prod account.
- **Federated login** via Google/Okta/SSO using identity providers.
- **CI/CD service roles** so GitHub Actions can push images to ECR.

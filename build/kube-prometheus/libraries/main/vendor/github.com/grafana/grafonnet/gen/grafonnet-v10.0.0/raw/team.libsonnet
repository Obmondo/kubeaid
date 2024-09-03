// This file is generated, do not manually edit.
{
  '#': { help: 'grafonnet.team', name: 'team' },
  '#withAccessControl': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'AccessControl metadata associated with a given resource.' } },
  withAccessControl(value): {
    accessControl: value,
  },
  '#withAccessControlMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'AccessControl metadata associated with a given resource.' } },
  withAccessControlMixin(value): {
    accessControl+: value,
  },
  '#withAvatarUrl': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: "AvatarUrl is the team's avatar URL." } },
  withAvatarUrl(value): {
    avatarUrl: value,
  },
  '#withEmail': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'Email of the team.' } },
  withEmail(value): {
    email: value,
  },
  '#withMemberCount': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['integer'] }], help: 'MemberCount is the number of the team members.' } },
  withMemberCount(value): {
    memberCount: value,
  },
  '#withName': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'Name of the team.' } },
  withName(value): {
    name: value,
  },
  '#withOrgId': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['integer'] }], help: 'OrgId is the ID of an organisation the team belongs to.' } },
  withOrgId(value): {
    orgId: value,
  },
  '#withPermission': { 'function': { args: [{ default: null, enums: [0, 1, 2, 4], name: 'value', type: ['integer'] }], help: '' } },
  withPermission(value): {
    permission: value,
  },
}

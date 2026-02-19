# Security Reference

> Extracted from Xcode 26.2 SDK (macOS 26.2) — 5,545 symbols, 341 types
> **⭐ New** = introduced in macOS/iOS 26

**341 types · 0 new in macOS 26**

---

## All Types

### Protocols

#### `OS_sec_certificate`
```swift
protocol OS_sec_certificate : NSObjectProtocol
```

#### `OS_sec_identity`
```swift
protocol OS_sec_identity : NSObjectProtocol
```

#### `OS_sec_object`
```swift
protocol OS_sec_object : NSObjectProtocol
```

#### `OS_sec_protocol_metadata`
```swift
protocol OS_sec_protocol_metadata : NSObjectProtocol
```

#### `OS_sec_protocol_options`
```swift
protocol OS_sec_protocol_options : NSObjectProtocol
```

#### `OS_sec_trust`
```swift
protocol OS_sec_trust : NSObjectProtocol
```

### Structs

#### `AuthorizationExternalForm`
```swift
struct AuthorizationExternalForm
```

#### `AuthorizationFlags`
```swift
struct AuthorizationFlags
```

#### `AuthorizationItem`
```swift
struct AuthorizationItem
```

#### `AuthorizationItemSet`
```swift
struct AuthorizationItemSet
```

#### `CMSSignedAttributes`
```swift
struct CMSSignedAttributes
```

#### `CSSM_APPLE_CL_CSR_REQUEST`
```swift
struct CSSM_APPLE_CL_CSR_REQUEST
```

#### `CSSM_APPLE_TP_ACTION_DATA`
```swift
struct CSSM_APPLE_TP_ACTION_DATA
```

#### `CSSM_APPLE_TP_CERT_REQUEST`
```swift
struct CSSM_APPLE_TP_CERT_REQUEST
```

#### `CSSM_APPLE_TP_CRL_OPTIONS`
```swift
struct CSSM_APPLE_TP_CRL_OPTIONS
```

#### `CSSM_APPLE_TP_NAME_OID`
```swift
struct CSSM_APPLE_TP_NAME_OID
```

#### `CSSM_APPLE_TP_SMIME_OPTIONS`
```swift
struct CSSM_APPLE_TP_SMIME_OPTIONS
```

#### `CSSM_APPLE_TP_SSL_OPTIONS`
```swift
struct CSSM_APPLE_TP_SSL_OPTIONS
```

#### `CSSM_TP_APPLE_EVIDENCE_HEADER`
```swift
struct CSSM_TP_APPLE_EVIDENCE_HEADER
```

#### `SecAccessControlCreateFlags`
*macOS 10.10*

```swift
struct SecAccessControlCreateFlags
```

#### `SecAsn1AlgId`
*macOS 10.0*

```swift
struct SecAsn1AlgId
```

#### `SecAsn1PubKeyInfo`
*macOS 10.0*

```swift
struct SecAsn1PubKeyInfo
```

#### `SecAsn1Template_struct`
```swift
struct SecAsn1Template_struct
```

#### `SecCSFlags`
```swift
struct SecCSFlags
```

#### `SecCodeSignatureFlags`
```swift
struct SecCodeSignatureFlags
```

#### `SecCodeStatus`
```swift
struct SecCodeStatus
```

#### `SecItemImportExportFlags`
```swift
struct SecItemImportExportFlags
```

#### `SecItemImportExportKeyParameters`
```swift
struct SecItemImportExportKeyParameters
```

#### `SecKeyAlgorithm`
*macOS 10.12*

```swift
struct SecKeyAlgorithm
```

#### `SecKeyImportExportFlags`
```swift
struct SecKeyImportExportFlags
```

#### `SecKeyImportExportParameters`
```swift
struct SecKeyImportExportParameters
```

#### `SecKeyKeyExchangeParameter`
*macOS 10.12*

```swift
struct SecKeyKeyExchangeParameter
```

#### `SecKeyUsage`
```swift
struct SecKeyUsage
```

#### `SecKeychainAttribute`
```swift
struct SecKeychainAttribute
```

#### `SecKeychainAttributeInfo`
```swift
struct SecKeychainAttributeInfo
```

#### `SecKeychainAttributeList`
```swift
struct SecKeychainAttributeList
```

#### `SecKeychainCallbackInfo`
```swift
struct SecKeychainCallbackInfo
```

#### `SecKeychainEventMask`
```swift
struct SecKeychainEventMask
```

#### `SecKeychainPromptSelector`
```swift
struct SecKeychainPromptSelector
```

#### `SecKeychainSettings`
```swift
struct SecKeychainSettings
```

#### `SecPadding`
*macOS 10.6*

```swift
struct SecPadding
```

#### `SecTrustOptionFlags`
```swift
struct SecTrustOptionFlags
```

#### `SecTrustSettingsKeyUsage`
```swift
struct SecTrustSettingsKeyUsage
```

#### `SessionAttributeBits`
```swift
struct SessionAttributeBits
```

#### `SessionCreationFlags`
```swift
struct SessionCreationFlags
```

#### `cssm_acl_keychain_prompt_selector`
```swift
struct cssm_acl_keychain_prompt_selector
```

#### `cssm_acl_process_subject_selector`
```swift
struct cssm_acl_process_subject_selector
```

#### `cssm_applecspdl_db_change_password_parameters`
```swift
struct cssm_applecspdl_db_change_password_parameters
```

#### `cssm_applecspdl_db_is_locked_parameters`
```swift
struct cssm_applecspdl_db_is_locked_parameters
```

#### `cssm_applecspdl_db_settings_parameters`
```swift
struct cssm_applecspdl_db_settings_parameters
```

#### `cssm_appledl_open_parameters`
```swift
struct cssm_appledl_open_parameters
```

#### `cssm_appledl_open_parameters_mask`
```swift
struct cssm_appledl_open_parameters_mask
```

#### `cssm_authorizationgroup`
```swift
struct cssm_authorizationgroup
```

#### `cssm_csp_operational_statistics`
```swift
struct cssm_csp_operational_statistics
```

#### `cssm_data`
```swift
struct cssm_data
```

#### `cssm_date`
```swift
struct cssm_date
```

#### `cssm_db_schema_index_info`
```swift
struct cssm_db_schema_index_info
```

#### `cssm_dl_db_handle`
```swift
struct cssm_dl_db_handle
```

#### `cssm_dl_pkcs11_attributes`
```swift
struct cssm_dl_pkcs11_attributes
```

#### `cssm_func_name_addr`
```swift
struct cssm_func_name_addr
```

#### `cssm_guid`
```swift
struct cssm_guid
```

#### `cssm_key_size`
```swift
struct cssm_key_size
```

#### `cssm_kr_name`
```swift
struct cssm_kr_name
```

#### `cssm_list`
```swift
struct cssm_list
```

#### `cssm_memory_funcs`
```swift
struct cssm_memory_funcs
```

#### `cssm_name_list`
```swift
struct cssm_name_list
```

#### `cssm_parsed_cert`
```swift
struct cssm_parsed_cert
```

#### `cssm_parsed_crl`
```swift
struct cssm_parsed_crl
```

#### `cssm_query_size_data`
```swift
struct cssm_query_size_data
```

#### `cssm_range`
```swift
struct cssm_range
```

#### `cssm_tp_result_set`
```swift
struct cssm_tp_result_set
```

#### `cssm_version`
```swift
struct cssm_version
```

#### `extension_data_format`
```swift
struct extension_data_format
```

### Classes

#### `CMSDecoder`
```swift
class CMSDecoder
```

#### `CMSEncoder`
```swift
class CMSEncoder
```

#### `SSLContext`
```swift
class SSLContext
```

#### `SecACL`
```swift
class SecACL
```

#### `SecAccess`
```swift
class SecAccess
```

#### `SecAccessControl`
```swift
class SecAccessControl
```

#### `SecCertificate`
```swift
class SecCertificate
```

#### `SecCode`
```swift
class SecCode
```

#### `SecIdentity`
```swift
class SecIdentity
```

#### `SecIdentitySearch`
```swift
class SecIdentitySearch
```

#### `SecKey`
```swift
class SecKey
```

#### `SecKeychain`
*macOS 10.0*

```swift
class SecKeychain
```

#### `SecKeychainItem`
```swift
class SecKeychainItem
```

#### `SecKeychainSearch`
```swift
class SecKeychainSearch
```

#### `SecPassword`
```swift
class SecPassword
```

#### `SecPolicy`
```swift
class SecPolicy
```

#### `SecPolicySearch`
```swift
class SecPolicySearch
```

#### `SecRequirement`
```swift
class SecRequirement
```

#### `SecStaticCode`
```swift
class SecStaticCode
```

#### `SecTask`
```swift
class SecTask
```

#### `SecTrust`
```swift
class SecTrust
```

#### `SecTrustedApplication`
```swift
class SecTrustedApplication
```

### Enums

#### `CMSCertificateChainMode`
```swift
enum CMSCertificateChainMode
```

#### `CMSSignerStatus`
```swift
enum CMSSignerStatus
```

#### `SSLAuthenticate`
```swift
enum SSLAuthenticate
```

#### `SSLCiphersuiteGroup`
```swift
enum SSLCiphersuiteGroup
```

#### `SSLClientCertificateState`
```swift
enum SSLClientCertificateState
```

#### `SSLConnectionType`
```swift
enum SSLConnectionType
```

#### `SSLProtocol`
```swift
enum SSLProtocol
```

#### `SSLProtocolSide`
```swift
@frozen enum SSLProtocolSide
```

#### `SSLSessionOption`
```swift
enum SSLSessionOption
```

#### `SSLSessionState`
```swift
@frozen enum SSLSessionState
```

#### `SecAuthenticationType`
```swift
enum SecAuthenticationType
```

#### `SecCSDigestAlgorithm`
```swift
enum SecCSDigestAlgorithm
```

#### `SecCredentialType`
*macOS 10.3*

```swift
enum SecCredentialType
```

#### `SecExternalFormat`
```swift
enum SecExternalFormat
```

#### `SecExternalItemType`
```swift
enum SecExternalItemType
```

#### `SecItemAttr`
```swift
enum SecItemAttr
```

#### `SecItemClass`
```swift
enum SecItemClass
```

#### `SecKeyOperationType`
*macOS 10.12*

```swift
enum SecKeyOperationType
```

#### `SecKeySizes`
*macOS 10.9*

```swift
enum SecKeySizes
```

#### `SecKeychainEvent`
```swift
enum SecKeychainEvent
```

#### `SecPreferencesDomain`
```swift
enum SecPreferencesDomain
```

#### `SecProtocolType`
```swift
enum SecProtocolType
```

#### `SecRequirementType`
```swift
enum SecRequirementType
```

#### `SecTransformMetaAttributeType`
*macOS 10.7*

```swift
enum SecTransformMetaAttributeType
```

#### `SecTrustResultType`
```swift
enum SecTrustResultType
```

#### `SecTrustSettingsDomain`
```swift
enum SecTrustSettingsDomain
```

#### `SecTrustSettingsResult`
```swift
enum SecTrustSettingsResult
```

#### `tls_ciphersuite_group_t`
```swift
enum tls_ciphersuite_group_t
```

#### `tls_ciphersuite_t`
```swift
enum tls_ciphersuite_t
```

#### `tls_protocol_version_t`
*macOS 10.15*

```swift
enum tls_protocol_version_t
```

### Type Aliases

#### `AuthorizationAsyncCallback`
```swift
typealias AuthorizationAsyncCallback = (OSStatus, UnsafeMutablePointer<AuthorizationRights>?) -> Void
```

#### `AuthorizationEnvironment`
```swift
typealias AuthorizationEnvironment = AuthorizationItemSet
```

#### `AuthorizationRef`
```swift
typealias AuthorizationRef = OpaquePointer
```

#### `AuthorizationRights`
```swift
typealias AuthorizationRights = AuthorizationItemSet
```

#### `AuthorizationString`
```swift
typealias AuthorizationString = UnsafePointer<CChar>
```

#### `CE_CrlNumber`
```swift
typealias CE_CrlNumber = uint32
```

#### `CE_DataType`
```swift
typealias CE_DataType = __CE_DataType
```

#### `CE_DeltaCrl`
```swift
typealias CE_DeltaCrl = uint32
```

#### `CE_ExtendedKeyUsage`
```swift
typealias CE_ExtendedKeyUsage = __CE_ExtendedKeyUsage
```

#### `CE_GeneralNameType`
```swift
typealias CE_GeneralNameType = __CE_GeneralNameType
```

#### `CSSM_ACL_AUTHORIZATION_TAG`
```swift
typealias CSSM_ACL_AUTHORIZATION_TAG = sint32
```

#### `CSSM_ACL_EDIT_MODE`
```swift
typealias CSSM_ACL_EDIT_MODE = uint32
```

#### `CSSM_ACL_HANDLE`
```swift
typealias CSSM_ACL_HANDLE = CSSM_HANDLE
```

#### `CSSM_ACL_KEYCHAIN_PROMPT_SELECTOR`
```swift
typealias CSSM_ACL_KEYCHAIN_PROMPT_SELECTOR = cssm_acl_keychain_prompt_selector
```

#### `CSSM_ACL_PREAUTH_TRACKING_STATE`
```swift
typealias CSSM_ACL_PREAUTH_TRACKING_STATE = uint32
```

#### `CSSM_ACL_PROCESS_SUBJECT_SELECTOR`
```swift
typealias CSSM_ACL_PROCESS_SUBJECT_SELECTOR = cssm_acl_process_subject_selector
```

#### `CSSM_ACL_SUBJECT_TYPE`
```swift
typealias CSSM_ACL_SUBJECT_TYPE = sint32
```

#### `CSSM_AC_HANDLE`
```swift
typealias CSSM_AC_HANDLE = CSSM_MODULE_HANDLE
```

#### `CSSM_ALGORITHMS`
```swift
typealias CSSM_ALGORITHMS = uint32
```

#### `CSSM_APPLECSPDL_DB_CHANGE_PASSWORD_PARAMETERS`
```swift
typealias CSSM_APPLECSPDL_DB_CHANGE_PASSWORD_PARAMETERS = cssm_applecspdl_db_change_password_parameters
```

#### `CSSM_APPLECSPDL_DB_CHANGE_PASSWORD_PARAMETERS_PTR`
```swift
typealias CSSM_APPLECSPDL_DB_CHANGE_PASSWORD_PARAMETERS_PTR = UnsafeMutablePointer<cssm_applecspdl_db_change_password_parameters>
```

#### `CSSM_APPLECSPDL_DB_IS_LOCKED_PARAMETERS`
```swift
typealias CSSM_APPLECSPDL_DB_IS_LOCKED_PARAMETERS = cssm_applecspdl_db_is_locked_parameters
```

#### `CSSM_APPLECSPDL_DB_IS_LOCKED_PARAMETERS_PTR`
```swift
typealias CSSM_APPLECSPDL_DB_IS_LOCKED_PARAMETERS_PTR = UnsafeMutablePointer<cssm_applecspdl_db_is_locked_parameters>
```

#### `CSSM_APPLECSPDL_DB_SETTINGS_PARAMETERS`
```swift
typealias CSSM_APPLECSPDL_DB_SETTINGS_PARAMETERS = cssm_applecspdl_db_settings_parameters
```

#### `CSSM_APPLECSPDL_DB_SETTINGS_PARAMETERS_PTR`
```swift
typealias CSSM_APPLECSPDL_DB_SETTINGS_PARAMETERS_PTR = UnsafeMutablePointer<cssm_applecspdl_db_settings_parameters>
```

#### `CSSM_APPLEDL_OPEN_PARAMETERS`
```swift
typealias CSSM_APPLEDL_OPEN_PARAMETERS = cssm_appledl_open_parameters
```

#### `CSSM_APPLEDL_OPEN_PARAMETERS_PTR`
```swift
typealias CSSM_APPLEDL_OPEN_PARAMETERS_PTR = UnsafeMutablePointer<cssm_appledl_open_parameters>
```

#### `CSSM_APPLE_TP_ACTION_FLAGS`
```swift
typealias CSSM_APPLE_TP_ACTION_FLAGS = uint32
```

#### `CSSM_APPLE_TP_CRL_OPT_FLAGS`
```swift
typealias CSSM_APPLE_TP_CRL_OPT_FLAGS = uint32
```

#### `CSSM_ATTACH_FLAGS`
```swift
typealias CSSM_ATTACH_FLAGS = uint32
```

#### `CSSM_ATTRIBUTE_TYPE`
```swift
typealias CSSM_ATTRIBUTE_TYPE = uint32
```

#### `CSSM_BER_TAG`
```swift
typealias CSSM_BER_TAG = uint8
```

#### `CSSM_BITMASK`
```swift
typealias CSSM_BITMASK = uint32
```

#### `CSSM_BOOL`
```swift
typealias CSSM_BOOL = sint32
```

#### `CSSM_CALLOC`
```swift
typealias CSSM_CALLOC = (uint32, CSSM_SIZE, UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
```

#### `CSSM_CC_HANDLE`
```swift
typealias CSSM_CC_HANDLE = CSSM_LONG_HANDLE
```

#### `CSSM_CERTGROUP_TYPE`
```swift
typealias CSSM_CERTGROUP_TYPE = uint32
```

#### `CSSM_CERTGROUP_TYPE_PTR`
```swift
typealias CSSM_CERTGROUP_TYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_CERT_BUNDLE_ENCODING`
```swift
typealias CSSM_CERT_BUNDLE_ENCODING = uint32
```

#### `CSSM_CERT_BUNDLE_TYPE`
```swift
typealias CSSM_CERT_BUNDLE_TYPE = uint32
```

#### `CSSM_CERT_ENCODING`
```swift
typealias CSSM_CERT_ENCODING = uint32
```

#### `CSSM_CERT_ENCODING_PTR`
```swift
typealias CSSM_CERT_ENCODING_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_CERT_PARSE_FORMAT`
```swift
typealias CSSM_CERT_PARSE_FORMAT = uint32
```

#### `CSSM_CERT_PARSE_FORMAT_PTR`
```swift
typealias CSSM_CERT_PARSE_FORMAT_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_CERT_TYPE`
```swift
typealias CSSM_CERT_TYPE = uint32
```

#### `CSSM_CERT_TYPE_PTR`
```swift
typealias CSSM_CERT_TYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_CL_HANDLE`
```swift
typealias CSSM_CL_HANDLE = CSSM_MODULE_HANDLE
```

#### `CSSM_CL_TEMPLATE_TYPE`
```swift
typealias CSSM_CL_TEMPLATE_TYPE = uint32
```

#### `CSSM_CONTEXT_EVENT`
```swift
typealias CSSM_CONTEXT_EVENT = uint32
```

#### `CSSM_CONTEXT_TYPE`
```swift
typealias CSSM_CONTEXT_TYPE = uint32
```

#### `CSSM_CRLGROUP_TYPE`
```swift
typealias CSSM_CRLGROUP_TYPE = uint32
```

#### `CSSM_CRLGROUP_TYPE_PTR`
```swift
typealias CSSM_CRLGROUP_TYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_CRL_ENCODING`
```swift
typealias CSSM_CRL_ENCODING = uint32
```

#### `CSSM_CRL_ENCODING_PTR`
```swift
typealias CSSM_CRL_ENCODING_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_CRL_PARSE_FORMAT`
```swift
typealias CSSM_CRL_PARSE_FORMAT = uint32
```

#### `CSSM_CRL_PARSE_FORMAT_PTR`
```swift
typealias CSSM_CRL_PARSE_FORMAT_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_CRL_TYPE`
```swift
typealias CSSM_CRL_TYPE = uint32
```

#### `CSSM_CRL_TYPE_PTR`
```swift
typealias CSSM_CRL_TYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_CSPTYPE`
```swift
typealias CSSM_CSPTYPE = uint32
```

#### `CSSM_CSP_FLAGS`
```swift
typealias CSSM_CSP_FLAGS = uint32
```

#### `CSSM_CSP_HANDLE`
```swift
typealias CSSM_CSP_HANDLE = CSSM_MODULE_HANDLE
```

#### `CSSM_CSP_READER_FLAGS`
```swift
typealias CSSM_CSP_READER_FLAGS = uint32
```

#### `CSSM_DB_ACCESS_TYPE`
```swift
typealias CSSM_DB_ACCESS_TYPE = uint32
```

#### `CSSM_DB_ACCESS_TYPE_PTR`
```swift
typealias CSSM_DB_ACCESS_TYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_DB_ATTRIBUTE_FORMAT`
```swift
typealias CSSM_DB_ATTRIBUTE_FORMAT = uint32
```

#### `CSSM_DB_ATTRIBUTE_FORMAT_PTR`
```swift
typealias CSSM_DB_ATTRIBUTE_FORMAT_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_DB_ATTRIBUTE_NAME_FORMAT`
```swift
typealias CSSM_DB_ATTRIBUTE_NAME_FORMAT = uint32
```

#### `CSSM_DB_ATTRIBUTE_NAME_FORMAT_PTR`
```swift
typealias CSSM_DB_ATTRIBUTE_NAME_FORMAT_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_DB_CONJUNCTIVE`
```swift
typealias CSSM_DB_CONJUNCTIVE = uint32
```

#### `CSSM_DB_CONJUNCTIVE_PTR`
```swift
typealias CSSM_DB_CONJUNCTIVE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_DB_HANDLE`
```swift
typealias CSSM_DB_HANDLE = CSSM_MODULE_HANDLE
```

#### `CSSM_DB_INDEXED_DATA_LOCATION`
```swift
typealias CSSM_DB_INDEXED_DATA_LOCATION = uint32
```

#### `CSSM_DB_INDEX_TYPE`
```swift
typealias CSSM_DB_INDEX_TYPE = uint32
```

#### `CSSM_DB_MODIFY_MODE`
```swift
typealias CSSM_DB_MODIFY_MODE = uint32
```

#### `CSSM_DB_OPERATOR`
```swift
typealias CSSM_DB_OPERATOR = uint32
```

#### `CSSM_DB_OPERATOR_PTR`
```swift
typealias CSSM_DB_OPERATOR_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_DB_RECORDTYPE`
```swift
typealias CSSM_DB_RECORDTYPE = uint32
```

#### `CSSM_DB_RETRIEVAL_MODES`
```swift
typealias CSSM_DB_RETRIEVAL_MODES = uint32
```

#### `CSSM_DLTYPE`
```swift
typealias CSSM_DLTYPE = uint32
```

#### `CSSM_DLTYPE_PTR`
```swift
typealias CSSM_DLTYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_DL_CUSTOM_ATTRIBUTES`
```swift
typealias CSSM_DL_CUSTOM_ATTRIBUTES = UnsafeMutableRawPointer
```

#### `CSSM_DL_FFS_ATTRIBUTES`
```swift
typealias CSSM_DL_FFS_ATTRIBUTES = UnsafeMutableRawPointer
```

#### `CSSM_DL_HANDLE`
```swift
typealias CSSM_DL_HANDLE = CSSM_MODULE_HANDLE
```

#### `CSSM_DL_LDAP_ATTRIBUTES`
```swift
typealias CSSM_DL_LDAP_ATTRIBUTES = UnsafeMutableRawPointer
```

#### `CSSM_DL_ODBC_ATTRIBUTES`
```swift
typealias CSSM_DL_ODBC_ATTRIBUTES = UnsafeMutableRawPointer
```

#### `CSSM_DL_PKCS11_ATTRIBUTE`
```swift
typealias CSSM_DL_PKCS11_ATTRIBUTE = UnsafeMutablePointer<cssm_dl_pkcs11_attributes>
```

#### `CSSM_DL_PKCS11_ATTRIBUTE_PTR`
```swift
typealias CSSM_DL_PKCS11_ATTRIBUTE_PTR = UnsafeMutablePointer<cssm_dl_pkcs11_attributes>
```

#### `CSSM_ENCRYPT_MODE`
```swift
typealias CSSM_ENCRYPT_MODE = uint32
```

#### `CSSM_EVIDENCE_FORM`
```swift
typealias CSSM_EVIDENCE_FORM = uint32
```

#### `CSSM_FREE`
```swift
typealias CSSM_FREE = (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> Void
```

#### `CSSM_HANDLE`
```swift
typealias CSSM_HANDLE = CSSM_INTPTR
```

#### `CSSM_HANDLE_PTR`
```swift
typealias CSSM_HANDLE_PTR = UnsafeMutablePointer<CSSM_INTPTR>
```

#### `CSSM_HEADERVERSION`
```swift
typealias CSSM_HEADERVERSION = uint32
```

#### `CSSM_INTPTR`
```swift
typealias CSSM_INTPTR = Int
```

#### `CSSM_KEYATTR_FLAGS`
```swift
typealias CSSM_KEYATTR_FLAGS = uint32
```

#### `CSSM_KEYBLOB_FORMAT`
```swift
typealias CSSM_KEYBLOB_FORMAT = uint32
```

#### `CSSM_KEYBLOB_TYPE`
```swift
typealias CSSM_KEYBLOB_TYPE = uint32
```

#### `CSSM_KEYCLASS`
```swift
typealias CSSM_KEYCLASS = uint32
```

#### `CSSM_KEYUSE`
```swift
typealias CSSM_KEYUSE = uint32
```

#### `CSSM_KEY_HIERARCHY`
```swift
typealias CSSM_KEY_HIERARCHY = CSSM_BITMASK
```

#### `CSSM_KEY_TYPE`
```swift
typealias CSSM_KEY_TYPE = CSSM_ALGORITHMS
```

#### `CSSM_KRSP_HANDLE`
```swift
typealias CSSM_KRSP_HANDLE = uint32
```

#### `CSSM_KR_POLICY_FLAGS`
```swift
typealias CSSM_KR_POLICY_FLAGS = uint32
```

#### `CSSM_KR_POLICY_TYPE`
```swift
typealias CSSM_KR_POLICY_TYPE = uint32
```

#### `CSSM_LIST_ELEMENT_PTR`
```swift
typealias CSSM_LIST_ELEMENT_PTR = UnsafeMutablePointer<cssm_list_element>
```

#### `CSSM_LIST_ELEMENT_TYPE`
```swift
typealias CSSM_LIST_ELEMENT_TYPE = uint32
```

#### `CSSM_LIST_ELEMENT_TYPE_PTR`
```swift
typealias CSSM_LIST_ELEMENT_TYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_LIST_TYPE`
```swift
typealias CSSM_LIST_TYPE = uint32
```

#### `CSSM_LIST_TYPE_PTR`
```swift
typealias CSSM_LIST_TYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_LONG_HANDLE`
```swift
typealias CSSM_LONG_HANDLE = uint64
```

#### `CSSM_LONG_HANDLE_PTR`
```swift
typealias CSSM_LONG_HANDLE_PTR = UnsafeMutablePointer<uint64>
```

#### `CSSM_MALLOC`
```swift
typealias CSSM_MALLOC = (CSSM_SIZE, UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
```

#### `CSSM_MANAGER_EVENT_TYPES`
```swift
typealias CSSM_MANAGER_EVENT_TYPES = uint32
```

#### `CSSM_MODULE_EVENT`
```swift
typealias CSSM_MODULE_EVENT = uint32
```

#### `CSSM_MODULE_EVENT_PTR`
```swift
typealias CSSM_MODULE_EVENT_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_MODULE_HANDLE`
```swift
typealias CSSM_MODULE_HANDLE = CSSM_HANDLE
```

#### `CSSM_MODULE_HANDLE_PTR`
```swift
typealias CSSM_MODULE_HANDLE_PTR = UnsafeMutablePointer<CSSM_HANDLE>
```

#### `CSSM_NET_ADDRESS_TYPE`
```swift
typealias CSSM_NET_ADDRESS_TYPE = uint32
```

#### `CSSM_NET_PROTOCOL`
```swift
typealias CSSM_NET_PROTOCOL = uint32
```

#### `CSSM_PADDING`
```swift
typealias CSSM_PADDING = uint32
```

#### `CSSM_PKCS5_PBKDF2_PRF`
```swift
typealias CSSM_PKCS5_PBKDF2_PRF = uint32
```

#### `CSSM_PKCS_OAEP_MGF`
```swift
typealias CSSM_PKCS_OAEP_MGF = uint32
```

#### `CSSM_PKCS_OAEP_PSOURCE`
```swift
typealias CSSM_PKCS_OAEP_PSOURCE = uint32
```

#### `CSSM_PRIVILEGE`
```swift
typealias CSSM_PRIVILEGE = uint64
```

#### `CSSM_PRIVILEGE_SCOPE`
```swift
typealias CSSM_PRIVILEGE_SCOPE = uint32
```

#### `CSSM_PROC_ADDR`
```swift
typealias CSSM_PROC_ADDR = () -> Void
```

#### `CSSM_PROC_ADDR_PTR`
```swift
typealias CSSM_PROC_ADDR_PTR = UnsafeMutablePointer<CSSM_PROC_ADDR?>
```

#### `CSSM_PVC_MODE`
```swift
typealias CSSM_PVC_MODE = CSSM_BITMASK
```

#### `CSSM_QUERY_FLAGS`
```swift
typealias CSSM_QUERY_FLAGS = uint32
```

#### `CSSM_REALLOC`
```swift
typealias CSSM_REALLOC = (UnsafeMutableRawPointer?, CSSM_SIZE, UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
```

#### `CSSM_RETURN`
```swift
typealias CSSM_RETURN = sint32
```

#### `CSSM_SAMPLE_TYPE`
```swift
typealias CSSM_SAMPLE_TYPE = CSSM_WORDID_TYPE
```

#### `CSSM_SC_FLAGS`
```swift
typealias CSSM_SC_FLAGS = uint32
```

#### `CSSM_SERVICE_MASK`
```swift
typealias CSSM_SERVICE_MASK = uint32
```

#### `CSSM_SERVICE_TYPE`
```swift
typealias CSSM_SERVICE_TYPE = CSSM_SERVICE_MASK
```

#### `CSSM_SIZE`
```swift
typealias CSSM_SIZE = Int
```

#### `CSSM_STRING`
#### `CSSM_TIMESTRING`
```swift
typealias CSSM_TIMESTRING = UnsafeMutablePointer<CChar>
```

#### `CSSM_TP_ACTION`
```swift
typealias CSSM_TP_ACTION = uint32
```

#### `CSSM_TP_APPLE_CERT_STATUS`
```swift
typealias CSSM_TP_APPLE_CERT_STATUS = uint32
```

#### `CSSM_TP_AUTHORITY_REQUEST_TYPE`
```swift
typealias CSSM_TP_AUTHORITY_REQUEST_TYPE = uint32
```

#### `CSSM_TP_AUTHORITY_REQUEST_TYPE_PTR`
```swift
typealias CSSM_TP_AUTHORITY_REQUEST_TYPE_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_TP_CERTCHANGE_ACTION`
```swift
typealias CSSM_TP_CERTCHANGE_ACTION = uint32
```

#### `CSSM_TP_CERTCHANGE_REASON`
```swift
typealias CSSM_TP_CERTCHANGE_REASON = uint32
```

#### `CSSM_TP_CERTCHANGE_STATUS`
```swift
typealias CSSM_TP_CERTCHANGE_STATUS = uint32
```

#### `CSSM_TP_CERTISSUE_STATUS`
```swift
typealias CSSM_TP_CERTISSUE_STATUS = uint32
```

#### `CSSM_TP_CERTNOTARIZE_STATUS`
```swift
typealias CSSM_TP_CERTNOTARIZE_STATUS = uint32
```

#### `CSSM_TP_CERTRECLAIM_STATUS`
```swift
typealias CSSM_TP_CERTRECLAIM_STATUS = uint32
```

#### `CSSM_TP_CERTVERIFY_STATUS`
```swift
typealias CSSM_TP_CERTVERIFY_STATUS = uint32
```

#### `CSSM_TP_CONFIRM_STATUS`
```swift
typealias CSSM_TP_CONFIRM_STATUS = uint32
```

#### `CSSM_TP_CONFIRM_STATUS_PTR`
```swift
typealias CSSM_TP_CONFIRM_STATUS_PTR = UnsafeMutablePointer<uint32>
```

#### `CSSM_TP_CRLISSUE_STATUS`
```swift
typealias CSSM_TP_CRLISSUE_STATUS = uint32
```

#### `CSSM_TP_FORM_TYPE`
```swift
typealias CSSM_TP_FORM_TYPE = uint32
```

#### `CSSM_TP_HANDLE`
```swift
typealias CSSM_TP_HANDLE = CSSM_MODULE_HANDLE
```

#### `CSSM_TP_SERVICES`
```swift
typealias CSSM_TP_SERVICES = uint32
```

#### `CSSM_TP_STOP_ON`
```swift
typealias CSSM_TP_STOP_ON = uint32
```

#### `CSSM_USEE_TAG`
```swift
typealias CSSM_USEE_TAG = CSSM_PRIVILEGE
```

#### `CSSM_WORDID_TYPE`
```swift
typealias CSSM_WORDID_TYPE = sint32
```

#### `CSSM_X509EXT_DATA_FORMAT`
```swift
typealias CSSM_X509EXT_DATA_FORMAT = extension_data_format
```

#### `CSSM_X509_OPTION`
```swift
typealias CSSM_X509_OPTION = CSSM_BOOL
```

#### `MDS_HANDLE`
```swift
typealias MDS_HANDLE = CSSM_DL_HANDLE
```

#### `SSLCipherSuite`
```swift
typealias SSLCipherSuite = UInt16
```

#### `SSLConnectionRef`
```swift
typealias SSLConnectionRef = UnsafeRawPointer
```

#### `SSLReadFunc`
```swift
typealias SSLReadFunc = (SSLConnectionRef, UnsafeMutableRawPointer, UnsafeMutablePointer<Int>) -> OSStatus
```

#### `SSLWriteFunc`
```swift
typealias SSLWriteFunc = (SSLConnectionRef, UnsafeRawPointer, UnsafeMutablePointer<Int>) -> OSStatus
```

#### `SecAFPServerSignature`
```swift
typealias SecAFPServerSignature = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
```

#### `SecAccessOwnerType`
```swift
typealias SecAccessOwnerType = UInt32
```

#### `SecAsn1Item`
*macOS 10.0*

```swift
typealias SecAsn1Item = cssm_data
```

#### `SecAsn1Oid`
*macOS 10.0*

```swift
typealias SecAsn1Oid = cssm_data
```

#### `SecAsn1Template`
*macOS 10.0*

```swift
typealias SecAsn1Template = SecAsn1Template_struct
```

#### `SecAsn1TemplateChooser`
*macOS 10.0*

```swift
typealias SecAsn1TemplateChooser = (UnsafeMutableRawPointer, DarwinBoolean, UnsafePointer<CChar>, Int, UnsafeMutableRawPointer) -> UnsafePointer<SecAsn1Template>?
```

#### `SecAsn1TemplateChooserPtr`
*macOS 10.0*

```swift
typealias SecAsn1TemplateChooserPtr = (UnsafeMutableRawPointer, DarwinBoolean, UnsafePointer<CChar>, Int, UnsafeMutableRawPointer) -> UnsafePointer<SecAsn1Template>?
```

#### `SecGroupTransform`
*macOS 10.7*

```swift
typealias SecGroupTransform = CFTypeRef
```

#### `SecGuestRef`
```swift
typealias SecGuestRef = UInt32
```

#### `SecKeyGeneratePairBlock`
```swift
typealias SecKeyGeneratePairBlock = (SecKey, SecKey, CFError) -> Void
```

#### `SecKeychainAttrType`
```swift
typealias SecKeychainAttrType = OSType
```

#### `SecKeychainAttributePtr`
```swift
typealias SecKeychainAttributePtr = UnsafeMutablePointer<SecKeychainAttribute>
```

#### `SecKeychainCallback`
*macOS 10.2*

```swift
typealias SecKeychainCallback = (SecKeychainEvent, UnsafeMutablePointer<SecKeychainCallbackInfo>, UnsafeMutableRawPointer?) -> OSStatus
```

#### `SecKeychainStatus`
```swift
typealias SecKeychainStatus = UInt32
```

#### `SecMessageBlock`
```swift
typealias SecMessageBlock = (CFTypeRef?, CFError?, Bool) -> Void
```

#### `SecPublicKeyHash`
```swift
typealias SecPublicKeyHash = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
```

#### `SecRandomRef`
```swift
typealias SecRandomRef = OpaquePointer
```

#### `SecTransform`
*macOS 10.7*

```swift
typealias SecTransform = CFTypeRef
```

#### `SecTransformActionBlock`
*macOS 10.7*

```swift
typealias SecTransformActionBlock = () -> Unmanaged<CFTypeRef>?
```

#### `SecTransformAttribute`
*macOS 10.7*

```swift
typealias SecTransformAttribute = CFTypeRef
```

#### `SecTransformAttributeActionBlock`
*macOS 10.7*

```swift
typealias SecTransformAttributeActionBlock = (SecTransformAttribute, CFTypeRef) -> Unmanaged<CFTypeRef>?
```

#### `SecTransformCreateFP`
*macOS 10.7*

```swift
typealias SecTransformCreateFP = (CFString, SecTransform, SecTransformImplementationRef) -> () -> Unmanaged<CFError>?
```

#### `SecTransformDataBlock`
```swift
typealias SecTransformDataBlock = (CFTypeRef) -> Unmanaged<CFTypeRef>?
```

#### `SecTransformImplementationRef`
```swift
typealias SecTransformImplementationRef = OpaquePointer
```

#### `SecTransformInstanceBlock`
```swift
typealias SecTransformInstanceBlock = () -> Unmanaged<CFError>?
```

#### `SecTransformStringOrAttribute`
*macOS 10.7*

```swift
typealias SecTransformStringOrAttribute = CFTypeRef
```

#### `SecTrustCallback`
```swift
typealias SecTrustCallback = (SecTrust, SecTrustResultType) -> Void
```

#### `SecTrustWithErrorCallback`
```swift
typealias SecTrustWithErrorCallback = (SecTrust, Bool, CFError?) -> Void
```

#### `SecuritySessionId`
```swift
typealias SecuritySessionId = UInt32
```

#### `sec_certificate_t`
```swift
typealias sec_certificate_t = any OS_sec_certificate
```

#### `sec_identity_t`
```swift
typealias sec_identity_t = any OS_sec_identity
```

#### `sec_object_t`
```swift
typealias sec_object_t = any OS_sec_object
```

#### `sec_protocol_challenge_complete_t`
```swift
typealias sec_protocol_challenge_complete_t = (sec_identity_t?) -> Void
```

#### `sec_protocol_challenge_t`
```swift
typealias sec_protocol_challenge_t = (sec_protocol_metadata_t, @escaping sec_protocol_challenge_complete_t) -> Void
```

#### `sec_protocol_key_update_complete_t`
```swift
typealias sec_protocol_key_update_complete_t = () -> Void
```

#### `sec_protocol_key_update_t`
```swift
typealias sec_protocol_key_update_t = (sec_protocol_metadata_t, @escaping sec_protocol_key_update_complete_t) -> Void
```

#### `sec_protocol_metadata_t`
```swift
typealias sec_protocol_metadata_t = any OS_sec_protocol_metadata
```

#### `sec_protocol_options_t`
```swift
typealias sec_protocol_options_t = any OS_sec_protocol_options
```

#### `sec_protocol_pre_shared_key_selection_complete_t`
```swift
typealias sec_protocol_pre_shared_key_selection_complete_t = (dispatch_data_t?) -> Void
```

#### `sec_protocol_pre_shared_key_selection_t`
```swift
typealias sec_protocol_pre_shared_key_selection_t = (sec_protocol_metadata_t, dispatch_data_t?, @escaping sec_protocol_pre_shared_key_selection_complete_t) -> Void
```

#### `sec_protocol_verify_complete_t`
```swift
typealias sec_protocol_verify_complete_t = (Bool) -> Void
```

#### `sec_protocol_verify_t`
```swift
typealias sec_protocol_verify_t = (sec_protocol_metadata_t, sec_trust_t, @escaping sec_protocol_verify_complete_t) -> Void
```

#### `sec_trust_t`
```swift
typealias sec_trust_t = any OS_sec_trust
```

#### `sint16`
```swift
typealias sint16 = Int16
```

#### `sint32`
```swift
typealias sint32 = Int32
```

#### `sint64`
```swift
typealias sint64 = Int64
```

#### `sint8`
```swift
typealias sint8 = Int8
```

#### `uint16`
```swift
typealias uint16 = UInt16
```

#### `uint32`
```swift
typealias uint32 = UInt32
```

#### `uint64`
```swift
typealias uint64 = UInt64
```

#### `uint8`
```swift
typealias uint8 = UInt8
```

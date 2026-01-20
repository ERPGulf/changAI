USE frappe_erp_schema;
DROP TABLE IF EXISTS `__global_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `__global_search` (
  `doctype` varchar(100) DEFAULT NULL,
  `name` varchar(140) DEFAULT NULL,
  `title` varchar(140) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `published` int(1) NOT NULL DEFAULT 0,
  UNIQUE KEY `doctype_name` (`doctype`,`name`),
  FULLTEXT KEY `content` (`content`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAbout Us Team Member`
--

DROP TABLE IF EXISTS `tabAbout Us Team Member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAbout Us Team Member` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `full_name` varchar(140) DEFAULT NULL,
  `image_link` text DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAccess Log`
--

DROP TABLE IF EXISTS `tabAccess Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAccess Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `export_from` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `reference_document` varchar(140) DEFAULT NULL,
  `timestamp` datetime(6) DEFAULT NULL,
  `file_type` varchar(140) DEFAULT NULL,
  `method` varchar(140) DEFAULT NULL,
  `report_name` varchar(140) DEFAULT NULL,
  `filters` longtext DEFAULT NULL,
  `page` longtext DEFAULT NULL,
  `columns` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAccount`
--

DROP TABLE IF EXISTS `tabAccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAccount` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `account_name` varchar(140) DEFAULT NULL,
  `account_number` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `root_type` varchar(140) DEFAULT NULL,
  `report_type` varchar(140) DEFAULT NULL,
  `account_currency` varchar(140) DEFAULT NULL,
  `parent_account` varchar(140) DEFAULT NULL,
  `account_type` varchar(140) DEFAULT NULL,
  `tax_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `freeze_account` varchar(140) DEFAULT NULL,
  `balance_must_be` varchar(140) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `include_in_gross` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent_account` (`parent_account`),
  KEY `account_type` (`account_type`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAccount Closing Balance`
--

DROP TABLE IF EXISTS `tabAccount Closing Balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAccount Closing Balance` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `closing_date` date DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `debit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `credit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `account_currency` varchar(140) DEFAULT NULL,
  `debit_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `credit_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `project` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `period_closing_voucher` varchar(140) DEFAULT NULL,
  `is_period_closing_voucher_entry` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `closing_date` (`closing_date`),
  KEY `account` (`account`),
  KEY `company` (`company`),
  KEY `period_closing_voucher` (`period_closing_voucher`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAccounting Dimension`
--

DROP TABLE IF EXISTS `tabAccounting Dimension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAccounting Dimension` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `fieldname` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `label` (`label`),
  KEY `document_type` (`document_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAccounting Dimension Detail`
--

DROP TABLE IF EXISTS `tabAccounting Dimension Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAccounting Dimension Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `reference_document` varchar(140) DEFAULT NULL,
  `default_dimension` varchar(140) DEFAULT NULL,
  `mandatory_for_bs` int(1) NOT NULL DEFAULT 0,
  `mandatory_for_pl` int(1) NOT NULL DEFAULT 0,
  `automatically_post_balancing_accounting_entry` int(1) NOT NULL DEFAULT 0,
  `offsetting_account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAccounting Dimension Filter`
--

DROP TABLE IF EXISTS `tabAccounting Dimension Filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAccounting Dimension Filter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `accounting_dimension` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `apply_restriction_on_values` int(1) NOT NULL DEFAULT 1,
  `allow_or_restrict` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAccounting Period`
--

DROP TABLE IF EXISTS `tabAccounting Period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAccounting Period` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `period_name` varchar(140) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabActivity Cost`
--

DROP TABLE IF EXISTS `tabActivity Cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabActivity Cost` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `activity_type` varchar(140) DEFAULT NULL,
  `employee` varchar(140) DEFAULT NULL,
  `employee_name` varchar(140) DEFAULT NULL,
  `department` varchar(140) DEFAULT NULL,
  `billing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `costing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `title` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabActivity Log`
--

DROP TABLE IF EXISTS `tabActivity Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabActivity Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `subject` text DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `communication_date` datetime(6) DEFAULT NULL,
  `ip_address` varchar(140) DEFAULT NULL,
  `operation` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `reference_owner` varchar(140) DEFAULT NULL,
  `timeline_doctype` varchar(140) DEFAULT NULL,
  `timeline_name` varchar(140) DEFAULT NULL,
  `link_doctype` varchar(140) DEFAULT NULL,
  `link_name` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`),
  KEY `reference_doctype_reference_name_index` (`reference_doctype`,`reference_name`),
  KEY `timeline_doctype_timeline_name_index` (`timeline_doctype`,`timeline_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabActivity Type`
--

DROP TABLE IF EXISTS `tabActivity Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabActivity Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `activity_type` varchar(140) DEFAULT NULL,
  `costing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAddress`
--

DROP TABLE IF EXISTS `tabAddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAddress` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `address_title` varchar(140) DEFAULT NULL,
  `address_type` varchar(140) DEFAULT NULL,
  `address_line1` varchar(240) DEFAULT NULL,
  `address_line2` varchar(240) DEFAULT NULL,
  `city` varchar(140) DEFAULT NULL,
  `county` varchar(140) DEFAULT NULL,
  `state` varchar(140) DEFAULT NULL,
  `country` varchar(140) DEFAULT NULL,
  `pincode` varchar(140) DEFAULT NULL,
  `email_id` varchar(140) DEFAULT NULL,
  `phone` varchar(140) DEFAULT NULL,
  `fax` varchar(140) DEFAULT NULL,
  `is_primary_address` int(1) NOT NULL DEFAULT 0,
  `is_shipping_address` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `is_your_company_address` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `city` (`city`),
  KEY `country` (`country`),
  KEY `pincode` (`pincode`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAddress Template`
--

DROP TABLE IF EXISTS `tabAddress Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAddress Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `country` varchar(140) DEFAULT NULL,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `template` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `country` (`country`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAdvance Payment Ledger Entry`
--

DROP TABLE IF EXISTS `tabAdvance Payment Ledger Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAdvance Payment Ledger Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `against_voucher_type` varchar(140) DEFAULT NULL,
  `against_voucher_no` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `currency` varchar(140) DEFAULT NULL,
  `event` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAdvance Tax`
--

DROP TABLE IF EXISTS `tabAdvance Tax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAdvance Tax` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_type` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `reference_detail` varchar(140) DEFAULT NULL,
  `account_head` varchar(140) DEFAULT NULL,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAdvance Taxes and Charges`
--

DROP TABLE IF EXISTS `tabAdvance Taxes and Charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAdvance Taxes and Charges` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `add_deduct_tax` varchar(140) DEFAULT NULL,
  `charge_type` varchar(140) DEFAULT NULL,
  `row_id` varchar(140) DEFAULT NULL,
  `account_head` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `included_in_paid_amount` int(1) NOT NULL DEFAULT 0,
  `cost_center` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `currency` varchar(140) DEFAULT NULL,
  `tax_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_tax_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `account_head` (`account_head`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAllowed Dimension`
--

DROP TABLE IF EXISTS `tabAllowed Dimension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAllowed Dimension` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `accounting_dimension` varchar(140) DEFAULT NULL,
  `dimension_value` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAllowed To Transact With`
--

DROP TABLE IF EXISTS `tabAllowed To Transact With`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAllowed To Transact With` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAmended Document Naming Settings`
--

DROP TABLE IF EXISTS `tabAmended Document Naming Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAmended Document Naming Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `action` varchar(140) DEFAULT 'Amend Counter',
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `document_type` (`document_type`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabApplicable On Account`
--

DROP TABLE IF EXISTS `tabApplicable On Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabApplicable On Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `applicable_on_account` varchar(140) DEFAULT NULL,
  `is_mandatory` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAppointment`
--

DROP TABLE IF EXISTS `tabAppointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAppointment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `scheduled_time` datetime(6) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `customer_phone_number` varchar(140) DEFAULT NULL,
  `customer_skype` varchar(140) DEFAULT NULL,
  `customer_email` varchar(140) DEFAULT NULL,
  `customer_details` longtext DEFAULT NULL,
  `appointment_with` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `calendar_event` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAppointment Booking Slots`
--

DROP TABLE IF EXISTS `tabAppointment Booking Slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAppointment Booking Slots` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `day_of_week` varchar(140) DEFAULT NULL,
  `from_time` time(6) DEFAULT NULL,
  `to_time` time(6) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset`
--

DROP TABLE IF EXISTS `tabAsset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `asset_owner` varchar(140) DEFAULT NULL,
  `asset_owner_company` varchar(140) DEFAULT NULL,
  `is_existing_asset` int(1) NOT NULL DEFAULT 0,
  `is_composite_asset` int(1) NOT NULL DEFAULT 0,
  `supplier` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `journal_entry_for_scrap` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `asset_name` varchar(140) DEFAULT NULL,
  `asset_category` varchar(140) DEFAULT NULL,
  `location` varchar(140) DEFAULT NULL,
  `split_from` varchar(140) DEFAULT NULL,
  `custodian` varchar(140) DEFAULT NULL,
  `department` varchar(140) DEFAULT NULL,
  `disposal_date` date DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `purchase_receipt` varchar(140) DEFAULT NULL,
  `purchase_receipt_item` varchar(140) DEFAULT NULL,
  `purchase_invoice` varchar(140) DEFAULT NULL,
  `purchase_invoice_item` varchar(140) DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `available_for_use_date` date DEFAULT NULL,
  `gross_purchase_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `asset_quantity` int(11) NOT NULL DEFAULT 1,
  `additional_asset_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_asset_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `calculate_depreciation` int(1) NOT NULL DEFAULT 0,
  `opening_accumulated_depreciation` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `opening_number_of_booked_depreciations` int(11) NOT NULL DEFAULT 0,
  `is_fully_depreciated` int(1) NOT NULL DEFAULT 0,
  `depreciation_method` varchar(140) DEFAULT NULL,
  `value_after_depreciation` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_number_of_depreciations` int(11) NOT NULL DEFAULT 0,
  `frequency_of_depreciation` int(11) NOT NULL DEFAULT 0,
  `next_depreciation_date` date DEFAULT NULL,
  `policy_number` varchar(140) DEFAULT NULL,
  `insurer` varchar(140) DEFAULT NULL,
  `insured_value` varchar(140) DEFAULT NULL,
  `insurance_start_date` date DEFAULT NULL,
  `insurance_end_date` date DEFAULT NULL,
  `comprehensive_insurance` varchar(140) DEFAULT NULL,
  `maintenance_required` int(1) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT 'Draft',
  `booked_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `purchase_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `default_finance_book` varchar(140) DEFAULT NULL,
  `depr_entry_posting_status` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Activity`
--

DROP TABLE IF EXISTS `tabAsset Activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Activity` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `asset` varchar(140) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `subject` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Capitalization`
--

DROP TABLE IF EXISTS `tabAsset Capitalization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Capitalization` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `capitalization_method` varchar(140) DEFAULT NULL,
  `target_item_code` varchar(140) DEFAULT NULL,
  `target_item_name` varchar(140) DEFAULT NULL,
  `target_asset` varchar(140) DEFAULT NULL,
  `target_asset_name` varchar(140) DEFAULT NULL,
  `target_qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `target_asset_location` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `finance_book` varchar(140) DEFAULT NULL,
  `target_batch_no` varchar(140) DEFAULT NULL,
  `target_serial_no` text DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `target_is_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `target_has_batch_no` int(1) NOT NULL DEFAULT 0,
  `target_has_serial_no` int(1) NOT NULL DEFAULT 0,
  `stock_items_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `asset_items_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `service_items_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `target_incoming_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cost_center` varchar(140) DEFAULT NULL,
  `target_fixed_asset_account` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `posting_date` (`posting_date`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Capitalization Asset Item`
--

DROP TABLE IF EXISTS `tabAsset Capitalization Asset Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Capitalization Asset Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `asset` varchar(140) DEFAULT NULL,
  `asset_name` varchar(140) DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `current_asset_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `asset_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cost_center` varchar(140) DEFAULT NULL,
  `fixed_asset_account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Capitalization Service Item`
--

DROP TABLE IF EXISTS `tabAsset Capitalization Service Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Capitalization Service Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cost_center` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Capitalization Stock Item`
--

DROP TABLE IF EXISTS `tabAsset Capitalization Stock Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Capitalization Stock Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `purchase_receipt_item` varchar(140) DEFAULT NULL,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Category`
--

DROP TABLE IF EXISTS `tabAsset Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Category` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `asset_category_name` varchar(140) DEFAULT NULL,
  `enable_cwip_accounting` int(1) NOT NULL DEFAULT 0,
  `non_depreciable_category` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `asset_category_name` (`asset_category_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Category Account`
--

DROP TABLE IF EXISTS `tabAsset Category Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Category Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company_name` varchar(140) DEFAULT NULL,
  `fixed_asset_account` varchar(140) DEFAULT NULL,
  `accumulated_depreciation_account` varchar(140) DEFAULT NULL,
  `depreciation_expense_account` varchar(140) DEFAULT NULL,
  `capital_work_in_progress_account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Depreciation Schedule`
--

DROP TABLE IF EXISTS `tabAsset Depreciation Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Depreciation Schedule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `asset` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `gross_purchase_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `opening_accumulated_depreciation` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `opening_number_of_booked_depreciations` int(11) NOT NULL DEFAULT 0,
  `finance_book` varchar(140) DEFAULT NULL,
  `finance_book_id` int(11) NOT NULL DEFAULT 0,
  `depreciation_method` varchar(140) DEFAULT NULL,
  `total_number_of_depreciations` int(11) NOT NULL DEFAULT 0,
  `rate_of_depreciation` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `daily_prorata_based` int(1) NOT NULL DEFAULT 0,
  `shift_based` int(1) NOT NULL DEFAULT 0,
  `frequency_of_depreciation` int(11) NOT NULL DEFAULT 0,
  `expected_value_after_useful_life` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `notes` text DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Finance Book`
--

DROP TABLE IF EXISTS `tabAsset Finance Book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Finance Book` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `finance_book` varchar(140) DEFAULT NULL,
  `depreciation_method` varchar(140) DEFAULT NULL,
  `total_number_of_depreciations` int(11) NOT NULL DEFAULT 0,
  `total_number_of_booked_depreciations` int(11) NOT NULL DEFAULT 0,
  `daily_prorata_based` int(1) NOT NULL DEFAULT 0,
  `shift_based` int(1) NOT NULL DEFAULT 0,
  `frequency_of_depreciation` int(11) NOT NULL DEFAULT 0,
  `depreciation_start_date` date DEFAULT NULL,
  `salvage_value_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expected_value_after_useful_life` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `value_after_depreciation` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_of_depreciation` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Maintenance`
--

DROP TABLE IF EXISTS `tabAsset Maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Maintenance` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `asset_name` varchar(140) DEFAULT NULL,
  `asset_category` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `maintenance_team` varchar(140) DEFAULT NULL,
  `maintenance_manager` varchar(140) DEFAULT NULL,
  `maintenance_manager_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `asset_name` (`asset_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Maintenance Log`
--

DROP TABLE IF EXISTS `tabAsset Maintenance Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Maintenance Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `asset_maintenance` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `asset_name` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `task` varchar(140) DEFAULT NULL,
  `task_name` varchar(140) DEFAULT NULL,
  `maintenance_type` varchar(140) DEFAULT NULL,
  `periodicity` varchar(140) DEFAULT NULL,
  `has_certificate` int(1) NOT NULL DEFAULT 0,
  `certificate_attachement` text DEFAULT NULL,
  `maintenance_status` varchar(140) DEFAULT NULL,
  `assign_to_name` varchar(140) DEFAULT NULL,
  `task_assignee_email` varchar(140) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `completion_date` date DEFAULT NULL,
  `description` varchar(140) DEFAULT NULL,
  `actions_performed` longtext DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Maintenance Task`
--

DROP TABLE IF EXISTS `tabAsset Maintenance Task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Maintenance Task` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `maintenance_task` varchar(140) DEFAULT NULL,
  `maintenance_type` varchar(140) DEFAULT NULL,
  `maintenance_status` varchar(140) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `periodicity` varchar(140) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `certificate_required` int(1) NOT NULL DEFAULT 0,
  `assign_to` varchar(140) DEFAULT NULL,
  `assign_to_name` varchar(140) DEFAULT NULL,
  `next_due_date` date DEFAULT NULL,
  `last_completion_date` date DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `certificate_required` (`certificate_required`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Maintenance Team`
--

DROP TABLE IF EXISTS `tabAsset Maintenance Team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Maintenance Team` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `maintenance_team_name` varchar(140) DEFAULT NULL,
  `maintenance_manager` varchar(140) DEFAULT NULL,
  `maintenance_manager_name` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `maintenance_team_name` (`maintenance_team_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Movement`
--

DROP TABLE IF EXISTS `tabAsset Movement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Movement` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `purpose` varchar(140) DEFAULT NULL,
  `transaction_date` datetime(6) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Movement Item`
--

DROP TABLE IF EXISTS `tabAsset Movement Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Movement Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `asset` varchar(140) DEFAULT NULL,
  `source_location` varchar(140) DEFAULT NULL,
  `from_employee` varchar(140) DEFAULT NULL,
  `asset_name` varchar(140) DEFAULT NULL,
  `target_location` varchar(140) DEFAULT NULL,
  `to_employee` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Repair`
--

DROP TABLE IF EXISTS `tabAsset Repair`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Repair` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `asset` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `asset_name` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `failure_date` datetime(6) DEFAULT NULL,
  `repair_status` varchar(140) DEFAULT 'Pending',
  `completion_date` datetime(6) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `purchase_invoice` varchar(140) DEFAULT NULL,
  `capitalize_repair_cost` int(1) NOT NULL DEFAULT 0,
  `stock_consumption` int(1) NOT NULL DEFAULT 0,
  `repair_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_repair_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `increase_in_asset_life` int(11) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `actions_performed` longtext DEFAULT NULL,
  `downtime` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Repair Consumed Item`
--

DROP TABLE IF EXISTS `tabAsset Repair Consumed Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Repair Consumed Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `consumed_quantity` varchar(140) DEFAULT NULL,
  `total_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `serial_no` text DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Shift Allocation`
--

DROP TABLE IF EXISTS `tabAsset Shift Allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Shift Allocation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `asset` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `amended_from` (`amended_from`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Shift Factor`
--

DROP TABLE IF EXISTS `tabAsset Shift Factor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Shift Factor` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `shift_name` varchar(140) DEFAULT NULL,
  `shift_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `default` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `shift_name` (`shift_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAsset Value Adjustment`
--

DROP TABLE IF EXISTS `tabAsset Value Adjustment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAsset Value Adjustment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `asset` varchar(140) DEFAULT NULL,
  `asset_category` varchar(140) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `current_asset_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `new_asset_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `difference_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `difference_account` varchar(140) DEFAULT NULL,
  `journal_entry` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;


--
-- Table structure for table `tabAssignment Rule`
--

DROP TABLE IF EXISTS `tabAssignment Rule`;
CREATE TABLE `tabAssignment Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `due_date_based_on` varchar(140) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `description` text,
  `assign_condition` longtext DEFAULT NULL,
  `unassign_condition` longtext DEFAULT NULL,
  `close_condition` longtext DEFAULT NULL,
  `rule` varchar(140) DEFAULT NULL,
  `field` varchar(140) DEFAULT NULL,
  `last_user` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
);
DROP TABLE IF EXISTS `tabAssignment Rule Day`;
CREATE TABLE `tabAssignment Rule Day` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `day` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
);
DROP TABLE IF EXISTS `tabAssignment Rule User`;

CREATE TABLE `tabAssignment Rule User` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAuthorization Rule`
--

DROP TABLE IF EXISTS `tabAuthorization Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAuthorization Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `transaction` varchar(140) DEFAULT NULL,
  `based_on` varchar(140) DEFAULT NULL,
  `customer_or_item` varchar(140) DEFAULT NULL,
  `master_name` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `system_role` varchar(140) DEFAULT NULL,
  `to_emp` varchar(140) DEFAULT NULL,
  `system_user` varchar(140) DEFAULT NULL,
  `to_designation` varchar(140) DEFAULT NULL,
  `approving_role` varchar(140) DEFAULT NULL,
  `approving_user` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAuto Email Report`
--

DROP TABLE IF EXISTS `tabAuto Email Report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAuto Email Report` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `report` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT 'User',
  `enabled` int(1) NOT NULL DEFAULT 1,
  `report_type` varchar(140) DEFAULT NULL,
  `reference_report` varchar(140) DEFAULT NULL,
  `send_if_data` int(1) NOT NULL DEFAULT 1,
  `data_modified_till` int(11) NOT NULL DEFAULT 0,
  `no_of_rows` int(11) NOT NULL DEFAULT 100,
  `filters` text DEFAULT NULL,
  `filter_meta` text DEFAULT NULL,
  `from_date_field` varchar(140) DEFAULT NULL,
  `to_date_field` varchar(140) DEFAULT NULL,
  `dynamic_date_period` varchar(140) DEFAULT NULL,
  `use_first_day_of_period` int(1) NOT NULL DEFAULT 0,
  `email_to` text DEFAULT NULL,
  `day_of_week` varchar(140) DEFAULT 'Monday',
  `sender` varchar(140) DEFAULT NULL,
  `frequency` varchar(140) DEFAULT NULL,
  `format` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAuto Repeat`
--

DROP TABLE IF EXISTS `tabAuto Repeat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAuto Repeat` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_document` varchar(140) DEFAULT NULL,
  `submit_on_creation` int(1) NOT NULL DEFAULT 0,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `frequency` varchar(140) DEFAULT NULL,
  `repeat_on_day` int(11) NOT NULL DEFAULT 0,
  `repeat_on_last_day` int(1) NOT NULL DEFAULT 0,
  `next_schedule_date` date DEFAULT NULL,
  `notify_by_email` int(1) NOT NULL DEFAULT 0,
  `recipients` text DEFAULT NULL,
  `template` varchar(140) DEFAULT NULL,
  `subject` varchar(140) DEFAULT NULL,
  `message` text,
  `print_format` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `next_schedule_date` (`next_schedule_date`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAuto Repeat Day`
--

DROP TABLE IF EXISTS `tabAuto Repeat Day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAuto Repeat Day` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `day` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabAvailability Of Slots`
--

DROP TABLE IF EXISTS `tabAvailability Of Slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabAvailability Of Slots` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `day_of_week` varchar(140) DEFAULT NULL,
  `from_time` time(6) DEFAULT NULL,
  `to_time` time(6) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM`
--

DROP TABLE IF EXISTS `tabBOM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `quantity` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `is_active` int(1) NOT NULL DEFAULT 1,
  `is_default` int(1) NOT NULL DEFAULT 1,
  `allow_alternative_item` int(1) NOT NULL DEFAULT 0,
  `set_rate_of_sub_assembly_item_based_on_bom` int(1) NOT NULL DEFAULT 1,
  `project` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `rm_cost_as_per` varchar(140) DEFAULT 'Valuation Rate',
  `buying_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `with_operations` int(1) NOT NULL DEFAULT 0,
  `transfer_material_against` varchar(140) DEFAULT 'Work Order',
  `routing` varchar(140) DEFAULT NULL,
  `fg_based_operating_cost` int(1) NOT NULL DEFAULT 0,
  `operating_cost_per_bom_quantity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `process_loss_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `process_loss_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `raw_material_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `scrap_material_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_raw_material_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_scrap_material_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `has_variants` int(1) NOT NULL DEFAULT 0,
  `inspection_required` int(1) NOT NULL DEFAULT 0,
  `quality_inspection_template` varchar(140) DEFAULT NULL,
  `show_in_website` int(1) NOT NULL DEFAULT 0,
  `route` text DEFAULT NULL,
  `website_image` text DEFAULT NULL,
  `thumbnail` varchar(140) DEFAULT NULL,
  `show_items` int(1) NOT NULL DEFAULT 0,
  `show_operations` int(1) NOT NULL DEFAULT 0,
  `web_long_description` longtext DEFAULT NULL,
  `bom_creator` varchar(140) DEFAULT NULL,
  `bom_creator_item` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item` (`item`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Creator`
--

DROP TABLE IF EXISTS `tabBOM Creator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Creator` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `project` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `rm_cost_as_per` varchar(140) DEFAULT 'Valuation Rate',
  `set_rate_based_on_warehouse` int(1) NOT NULL DEFAULT 0,
  `buying_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `default_warehouse` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `raw_material_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `remarks` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `error_log` text DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Creator Item`
--

DROP TABLE IF EXISTS `tabBOM Creator Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Creator Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `fg_item` varchar(140) DEFAULT NULL,
  `source_warehouse` varchar(140) DEFAULT NULL,
  `is_expandable` int(1) NOT NULL DEFAULT 0,
  `sourced_by_supplier` int(1) NOT NULL DEFAULT 0,
  `bom_created` int(1) NOT NULL DEFAULT 0,
  `allow_alternative_item` int(1) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `do_not_explode` int(1) NOT NULL DEFAULT 1,
  `parent_row_no` varchar(140) DEFAULT NULL,
  `fg_reference_id` varchar(140) DEFAULT NULL,
  `instruction` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Explosion Item`
--

DROP TABLE IF EXISTS `tabBOM Explosion Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Explosion Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `source_warehouse` varchar(140) DEFAULT NULL,
  `operation` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `image` text DEFAULT NULL,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `qty_consumed_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `include_item_in_manufacturing` int(1) NOT NULL DEFAULT 0,
  `sourced_by_supplier` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Item`
--

DROP TABLE IF EXISTS `tabBOM Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `operation` varchar(140) DEFAULT NULL,
  `do_not_explode` int(1) NOT NULL DEFAULT 0,
  `bom_no` varchar(140) DEFAULT NULL,
  `source_warehouse` varchar(140) DEFAULT NULL,
  `allow_alternative_item` int(1) NOT NULL DEFAULT 0,
  `is_stock_item` int(1) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `qty_consumed_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `has_variants` int(1) NOT NULL DEFAULT 0,
  `include_item_in_manufacturing` int(1) NOT NULL DEFAULT 0,
  `original_item` varchar(140) DEFAULT NULL,
  `sourced_by_supplier` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `bom_no` (`bom_no`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Operation`
--

DROP TABLE IF EXISTS `tabBOM Operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Operation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sequence_id` int(11) NOT NULL DEFAULT 0,
  `operation` varchar(140) DEFAULT NULL,
  `workstation_type` varchar(140) DEFAULT NULL,
  `workstation` varchar(140) DEFAULT NULL,
  `time_in_mins` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `fixed_time` int(1) NOT NULL DEFAULT 0,
  `hour_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_hour_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `batch_size` int(11) NOT NULL DEFAULT 0,
  `set_cost_based_on_bom_qty` int(1) NOT NULL DEFAULT 0,
  `cost_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_cost_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` longtext DEFAULT NULL,
  `image` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Scrap Item`
--

DROP TABLE IF EXISTS `tabBOM Scrap Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Scrap Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Update Batch`
--

DROP TABLE IF EXISTS `tabBOM Update Batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Update Batch` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 0,
  `batch_no` int(11) NOT NULL DEFAULT 0,
  `boms_updated` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Update Log`
--

DROP TABLE IF EXISTS `tabBOM Update Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Update Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `update_type` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `current_bom` varchar(140) DEFAULT NULL,
  `new_bom` varchar(140) DEFAULT NULL,
  `error_log` varchar(140) DEFAULT NULL,
  `current_level` int(11) NOT NULL DEFAULT 0,
  `processed_boms` longtext DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Website Item`
--

DROP TABLE IF EXISTS `tabBOM Website Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Website Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `website_image` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBOM Website Operation`
--

DROP TABLE IF EXISTS `tabBOM Website Operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBOM Website Operation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `operation` varchar(140) DEFAULT NULL,
  `workstation` varchar(140) DEFAULT NULL,
  `time_in_mins` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `website_image` text DEFAULT NULL,
  `thumbnail` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank`
--

DROP TABLE IF EXISTS `tabBank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `bank_name` varchar(140) DEFAULT NULL,
  `swift_number` varchar(140) DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `plaid_access_token` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `bank_name` (`bank_name`),
  UNIQUE KEY `swift_number` (`swift_number`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Account`
--

DROP TABLE IF EXISTS `tabBank Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account_name` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `bank` varchar(140) DEFAULT NULL,
  `account_type` varchar(140) DEFAULT NULL,
  `account_subtype` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `is_company_account` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `iban` varchar(30) DEFAULT NULL,
  `branch_code` varchar(140) DEFAULT NULL,
  `bank_account_no` varchar(30) DEFAULT NULL,
  `integration_id` varchar(140) DEFAULT NULL,
  `last_integration_date` date DEFAULT NULL,
  `mask` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `integration_id` (`integration_id`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Account Subtype`
--

DROP TABLE IF EXISTS `tabBank Account Subtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Account Subtype` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account_subtype` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `account_subtype` (`account_subtype`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Account Type`
--

DROP TABLE IF EXISTS `tabBank Account Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Account Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account_type` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `account_type` (`account_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Clearance Detail`
--

DROP TABLE IF EXISTS `tabBank Clearance Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Clearance Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `payment_document` varchar(140) DEFAULT NULL,
  `payment_entry` varchar(140) DEFAULT NULL,
  `against_account` varchar(140) DEFAULT NULL,
  `amount` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `cheque_number` varchar(140) DEFAULT NULL,
  `cheque_date` date DEFAULT NULL,
  `clearance_date` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Guarantee`
--

DROP TABLE IF EXISTS `tabBank Guarantee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Guarantee` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `bg_type` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_docname` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `start_date` date DEFAULT NULL,
  `validity` int(11) NOT NULL DEFAULT 0,
  `end_date` date DEFAULT NULL,
  `bank` varchar(140) DEFAULT NULL,
  `bank_account` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `bank_account_no` varchar(140) DEFAULT NULL,
  `iban` varchar(140) DEFAULT NULL,
  `branch_code` varchar(140) DEFAULT NULL,
  `swift_number` varchar(140) DEFAULT NULL,
  `more_information` longtext DEFAULT NULL,
  `bank_guarantee_number` varchar(140) DEFAULT NULL,
  `name_of_beneficiary` varchar(140) DEFAULT NULL,
  `margin_money` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `fixed_deposit_number` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `bank_guarantee_number` (`bank_guarantee_number`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Statement Import`
--

DROP TABLE IF EXISTS `tabBank Statement Import`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Statement Import` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `bank_account` varchar(140) DEFAULT NULL,
  `bank` varchar(140) DEFAULT NULL,
  `custom_delimiters` int(1) NOT NULL DEFAULT 0,
  `delimiter_options` varchar(140) DEFAULT ',;\\t|',
  `google_sheets_url` varchar(140) DEFAULT NULL,
  `import_file` text DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Pending',
  `template_options` longtext DEFAULT NULL,
  `template_warnings` longtext DEFAULT NULL,
  `show_failed_logs` int(1) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT 'Bank Transaction',
  `import_type` varchar(140) DEFAULT 'Insert New Records',
  `submit_after_import` int(1) NOT NULL DEFAULT 1,
  `mute_emails` int(1) NOT NULL DEFAULT 1,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Transaction`
--

DROP TABLE IF EXISTS `tabBank Transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Transaction` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT 'ACC-BTN-.YYYY.-',
  `date` date DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Pending',
  `bank_account` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `deposit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `withdrawal` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `currency` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `reference_number` varchar(140) DEFAULT NULL,
  `transaction_id` varchar(140) DEFAULT NULL,
  `transaction_type` varchar(50) DEFAULT NULL,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `unallocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `bank_party_name` varchar(140) DEFAULT NULL,
  `bank_party_account_number` varchar(140) DEFAULT NULL,
  `bank_party_iban` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Transaction Mapping`
--

DROP TABLE IF EXISTS `tabBank Transaction Mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Transaction Mapping` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `bank_transaction_field` varchar(140) DEFAULT NULL,
  `file_field` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBank Transaction Payments`
--

DROP TABLE IF EXISTS `tabBank Transaction Payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBank Transaction Payments` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `payment_document` varchar(140) DEFAULT NULL,
  `payment_entry` varchar(140) DEFAULT NULL,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `clearance_date` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBatch`
--

DROP TABLE IF EXISTS `tabBatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBatch` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `use_batchwise_valuation` int(1) NOT NULL DEFAULT 0,
  `batch_id` varchar(140) DEFAULT NULL,
  `item` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `parent_batch` varchar(140) DEFAULT NULL,
  `manufacturing_date` date DEFAULT NULL,
  `batch_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `qty_to_produce` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `produced_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `batch_id` (`batch_id`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBin`
--

DROP TABLE IF EXISTS `tabBin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBin` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `planned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `indented_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ordered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `projected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reserved_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reserved_qty_for_production` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reserved_qty_for_sub_contract` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reserved_qty_for_production_plan` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reserved_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `unique_item_warehouse` (`item_code`,`warehouse`),
  KEY `warehouse` (`warehouse`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBisect Nodes`
--

DROP TABLE IF EXISTS `tabBisect Nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBisect Nodes` (
  `name` bigint(20) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `root` varchar(140) DEFAULT NULL,
  `left_child` varchar(140) DEFAULT NULL,
  `right_child` varchar(140) DEFAULT NULL,
  `period_from_date` datetime(6) DEFAULT NULL,
  `period_to_date` datetime(6) DEFAULT NULL,
  `difference` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `balance_sheet_summary` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `profit_loss_summary` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `generated` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBlanket Order`
--

DROP TABLE IF EXISTS `tabBlanket Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBlanket Order` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `blanket_order_type` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `order_no` varchar(140) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `company` (`company`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBlanket Order Item`
--

DROP TABLE IF EXISTS `tabBlanket Order Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBlanket Order Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `party_item_code` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ordered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `terms_and_conditions` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBlock Module`
--

DROP TABLE IF EXISTS `tabBlock Module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBlock Module` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBlog Category`
--

DROP TABLE IF EXISTS `tabBlog Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBlog Category` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `published` int(1) NOT NULL DEFAULT 1,
  `title` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `preview_image` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `route` (`route`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBlog Post`
--

DROP TABLE IF EXISTS `tabBlog Post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBlog Post` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `blog_category` varchar(140) DEFAULT NULL,
  `blogger` varchar(140) DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `read_time` int(11) NOT NULL DEFAULT 0,
  `published_on` date DEFAULT NULL,
  `published` int(1) NOT NULL DEFAULT 0,
  `featured` int(1) NOT NULL DEFAULT 0,
  `hide_cta` int(1) NOT NULL DEFAULT 0,
  `enable_email_notification` int(1) NOT NULL DEFAULT 1,
  `disable_comments` int(1) NOT NULL DEFAULT 0,
  `disable_likes` int(1) NOT NULL DEFAULT 0,
  `blog_intro` text DEFAULT NULL,
  `content_type` varchar(140) DEFAULT 'Markdown',
  `content` longtext DEFAULT NULL,
  `content_md` longtext DEFAULT NULL,
  `content_html` longtext DEFAULT NULL,
  `email_sent` int(1) NOT NULL DEFAULT 0,
  `meta_title` varchar(60) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_image` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `route` (`route`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBlogger`
--

DROP TABLE IF EXISTS `tabBlogger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBlogger` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `short_name` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `avatar` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `short_name` (`short_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBranch`
--

DROP TABLE IF EXISTS `tabBranch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBranch` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `branch` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBrand`
--

DROP TABLE IF EXISTS `tabBrand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBrand` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `brand` (`brand`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBudget`
--

DROP TABLE IF EXISTS `tabBudget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBudget` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `budget_against` varchar(140) DEFAULT 'Cost Center',
  `company` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `fiscal_year` varchar(140) DEFAULT NULL,
  `monthly_distribution` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `applicable_on_material_request` int(1) NOT NULL DEFAULT 0,
  `action_if_annual_budget_exceeded_on_mr` varchar(140) DEFAULT 'Stop',
  `action_if_accumulated_monthly_budget_exceeded_on_mr` varchar(140) DEFAULT 'Warn',
  `applicable_on_purchase_order` int(1) NOT NULL DEFAULT 0,
  `action_if_annual_budget_exceeded_on_po` varchar(140) DEFAULT 'Stop',
  `action_if_accumulated_monthly_budget_exceeded_on_po` varchar(140) DEFAULT 'Warn',
  `applicable_on_booking_actual_expenses` int(1) NOT NULL DEFAULT 0,
  `action_if_annual_budget_exceeded` varchar(140) DEFAULT 'Stop',
  `action_if_accumulated_monthly_budget_exceeded` varchar(140) DEFAULT 'Warn',
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBudget Account`
--

DROP TABLE IF EXISTS `tabBudget Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBudget Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `budget_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `account` (`account`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabBulk Transaction Log Detail`
--

DROP TABLE IF EXISTS `tabBulk Transaction Log Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabBulk Transaction Log Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `from_doctype` varchar(140) DEFAULT NULL,
  `transaction_name` varchar(140) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time(6) DEFAULT NULL,
  `transaction_status` varchar(140) DEFAULT NULL,
  `error_description` longtext DEFAULT NULL,
  `to_doctype` varchar(140) DEFAULT NULL,
  `retried` int(11) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `from_doctype` (`from_doctype`),
  KEY `transaction_name` (`transaction_name`),
  KEY `date` (`date`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCRM Note`
--

DROP TABLE IF EXISTS `tabCRM Note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCRM Note` (
  `name` bigint(20) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `note` longtext DEFAULT NULL,
  `added_by` varchar(140) DEFAULT NULL,
  `added_on` datetime(6) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCalendar View`
--

DROP TABLE IF EXISTS `tabCalendar View`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCalendar View` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `subject_field` varchar(140) DEFAULT NULL,
  `start_date_field` varchar(140) DEFAULT NULL,
  `end_date_field` varchar(140) DEFAULT NULL,
  `all_day` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCall Log`
--

DROP TABLE IF EXISTS `tabCall Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCall Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `id` varchar(140) DEFAULT NULL,
  `from` varchar(140) DEFAULT NULL,
  `to` varchar(140) DEFAULT NULL,
  `call_received_by` varchar(140) DEFAULT NULL,
  `employee_user_id` varchar(140) DEFAULT NULL,
  `medium` varchar(140) DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `duration` decimal(21,9) DEFAULT NULL,
  `recording_url` varchar(140) DEFAULT NULL,
  `type_of_call` varchar(140) DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `id` (`id`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCampaign`
--

DROP TABLE IF EXISTS `tabCampaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCampaign` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `campaign_name` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCampaign Email Schedule`
--

DROP TABLE IF EXISTS `tabCampaign Email Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCampaign Email Schedule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_template` varchar(140) DEFAULT NULL,
  `send_after_days` int(11) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCampaign Item`
--

DROP TABLE IF EXISTS `tabCampaign Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCampaign Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `campaign` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCashier Closing`
--

DROP TABLE IF EXISTS `tabCashier Closing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCashier Closing` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT 'POS-CLO-',
  `user` varchar(140) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `from_time` time(6) DEFAULT NULL,
  `time` time(6) DEFAULT NULL,
  `expense` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `custody` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returns` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outstanding_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCashier Closing Payments`
--

DROP TABLE IF EXISTS `tabCashier Closing Payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCashier Closing Payments` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabChangAI Query Log`
--

DROP TABLE IF EXISTS `tabChangAI Query Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabChangAI Query Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `question` varchar(140) DEFAULT NULL,
  `doc` varchar(140) DEFAULT NULL,
  `top_fields` varchar(140) DEFAULT NULL,
  `fields` varchar(140) DEFAULT NULL,
  `query` text DEFAULT NULL,
  `response` text DEFAULT NULL,
  `jinja2_template_form` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabChangAI Settings`
--

DROP TABLE IF EXISTS `tabChangAI Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabChangAI Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `test` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabChangelog Feed`
--

DROP TABLE IF EXISTS `tabChangelog Feed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabChangelog Feed` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `app_name` varchar(140) DEFAULT NULL,
  `link` longtext DEFAULT NULL,
  `posting_timestamp` datetime(6) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `posting_timestamp` (`posting_timestamp`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCheque Print Template`
--

DROP TABLE IF EXISTS `tabCheque Print Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCheque Print Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `has_print_format` int(1) NOT NULL DEFAULT 0,
  `bank_name` varchar(140) DEFAULT NULL,
  `cheque_size` varchar(140) DEFAULT 'Regular',
  `starting_position_from_top_edge` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cheque_width` decimal(21,9) NOT NULL DEFAULT 20.000000000,
  `cheque_height` decimal(21,9) NOT NULL DEFAULT 9.000000000,
  `scanned_cheque` text DEFAULT NULL,
  `is_account_payable` int(1) NOT NULL DEFAULT 1,
  `acc_pay_dist_from_top_edge` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `acc_pay_dist_from_left_edge` decimal(21,9) NOT NULL DEFAULT 9.000000000,
  `message_to_show` varchar(140) DEFAULT 'Acc. Payee',
  `date_dist_from_top_edge` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `date_dist_from_left_edge` decimal(21,9) NOT NULL DEFAULT 15.000000000,
  `payer_name_from_top_edge` decimal(21,9) NOT NULL DEFAULT 2.000000000,
  `payer_name_from_left_edge` decimal(21,9) NOT NULL DEFAULT 3.000000000,
  `amt_in_words_from_top_edge` decimal(21,9) NOT NULL DEFAULT 3.000000000,
  `amt_in_words_from_left_edge` decimal(21,9) NOT NULL DEFAULT 4.000000000,
  `amt_in_word_width` decimal(21,9) NOT NULL DEFAULT 15.000000000,
  `amt_in_words_line_spacing` decimal(21,9) NOT NULL DEFAULT 0.500000000,
  `amt_in_figures_from_top_edge` decimal(21,9) NOT NULL DEFAULT 3.500000000,
  `amt_in_figures_from_left_edge` decimal(21,9) NOT NULL DEFAULT 16.000000000,
  `acc_no_dist_from_top_edge` decimal(21,9) NOT NULL DEFAULT 5.000000000,
  `acc_no_dist_from_left_edge` decimal(21,9) NOT NULL DEFAULT 4.000000000,
  `signatory_from_top_edge` decimal(21,9) NOT NULL DEFAULT 6.000000000,
  `signatory_from_left_edge` decimal(21,9) NOT NULL DEFAULT 15.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabClient Script`
--

DROP TABLE IF EXISTS `tabClient Script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabClient Script` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `dt` varchar(140) DEFAULT NULL,
  `view` varchar(140) DEFAULT 'Form',
  `module` varchar(140) DEFAULT NULL,
  `enabled` int(1) NOT NULL DEFAULT 0,
  `script` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabClosed Document`
--

DROP TABLE IF EXISTS `tabClosed Document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabClosed Document` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `closed` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabClosing Stock Balance`
--

DROP TABLE IF EXISTS `tabClosing Stock Balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabClosing Stock Balance` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `include_uom` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `warehouse_type` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCode List`
--

DROP TABLE IF EXISTS `tabCode List`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCode List` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `canonical_uri` varchar(140) DEFAULT NULL,
  `url` varchar(140) DEFAULT NULL,
  `default_common_code` varchar(140) DEFAULT NULL,
  `version` varchar(140) DEFAULT NULL,
  `publisher` varchar(140) DEFAULT NULL,
  `publisher_id` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabColor`
--

DROP TABLE IF EXISTS `tabColor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabColor` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `color` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabComment`
--

DROP TABLE IF EXISTS `tabComment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabComment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `comment_type` varchar(140) DEFAULT 'Comment',
  `comment_email` varchar(140) DEFAULT NULL,
  `subject` text DEFAULT NULL,
  `comment_by` varchar(140) DEFAULT NULL,
  `published` int(1) NOT NULL DEFAULT 0,
  `seen` int(1) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `reference_owner` varchar(140) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `ip_address` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`),
  KEY `reference_doctype_reference_name_index` (`reference_doctype`,`reference_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCommon Code`
--

DROP TABLE IF EXISTS `tabCommon Code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCommon Code` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `code_list` varchar(140) DEFAULT NULL,
  `title` varchar(300) DEFAULT NULL,
  `common_code` varchar(300) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `additional_data` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `code_list` (`code_list`),
  KEY `common_code` (`common_code`),
  KEY `modified` (`modified`),
  KEY `code_list_common_code_index` (`code_list`,`common_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCommunication`
--

DROP TABLE IF EXISTS `tabCommunication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCommunication` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `subject` text DEFAULT NULL,
  `communication_medium` varchar(140) DEFAULT NULL,
  `sender` varchar(255) DEFAULT NULL,
  `recipients` longtext DEFAULT NULL,
  `cc` longtext DEFAULT NULL,
  `bcc` longtext DEFAULT NULL,
  `phone_no` varchar(140) DEFAULT NULL,
  `delivery_status` varchar(140) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `text_content` longtext DEFAULT NULL,
  `communication_type` varchar(140) DEFAULT 'Communication',
  `comment_type` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `sent_or_received` varchar(140) DEFAULT NULL,
  `communication_date` datetime(6) DEFAULT NULL,
  `read_receipt` int(1) NOT NULL DEFAULT 0,
  `send_after` datetime(6) DEFAULT NULL,
  `sender_full_name` varchar(140) DEFAULT NULL,
  `read_by_recipient` int(1) NOT NULL DEFAULT 0,
  `read_by_recipient_on` datetime(6) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `reference_owner` varchar(140) DEFAULT NULL,
  `email_account` varchar(140) DEFAULT NULL,
  `in_reply_to` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `email_template` varchar(140) DEFAULT NULL,
  `unread_notification_sent` int(1) NOT NULL DEFAULT 0,
  `seen` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `message_id` text DEFAULT NULL,
  `uid` int(11) NOT NULL DEFAULT 0,
  `imap_folder` varchar(140) DEFAULT NULL,
  `email_status` varchar(140) DEFAULT NULL,
  `has_attachment` int(1) NOT NULL DEFAULT 0,
  `rating` int(11) NOT NULL DEFAULT 0,
  `feedback_request` varchar(140) DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_owner` (`reference_owner`),
  KEY `modified` (`modified`),
  KEY `reference_doctype_reference_name_index` (`reference_doctype`,`reference_name`),
  KEY `status_communication_type_index` (`status`,`communication_type`),
  KEY `message_id_index` (`message_id`(140))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCommunication Link`
--

DROP TABLE IF EXISTS `tabCommunication Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCommunication Link` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `link_doctype` varchar(140) DEFAULT NULL,
  `link_name` varchar(140) DEFAULT NULL,
  `link_title` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`),
  KEY `link_doctype_link_name_index` (`link_doctype`,`link_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCommunication Medium`
--

DROP TABLE IF EXISTS `tabCommunication Medium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCommunication Medium` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `communication_channel` varchar(140) DEFAULT NULL,
  `communication_medium_type` varchar(140) DEFAULT NULL,
  `catch_all` varchar(140) DEFAULT NULL,
  `provider` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCommunication Medium Timeslot`
--

DROP TABLE IF EXISTS `tabCommunication Medium Timeslot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCommunication Medium Timeslot` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `day_of_week` varchar(140) DEFAULT NULL,
  `from_time` time(6) DEFAULT NULL,
  `to_time` time(6) DEFAULT NULL,
  `employee_group` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCompany`
--

DROP TABLE IF EXISTS `tabCompany`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCompany` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company_name` varchar(140) DEFAULT NULL,
  `abbr` varchar(140) DEFAULT NULL,
  `default_currency` varchar(140) DEFAULT NULL,
  `country` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `default_holiday_list` varchar(140) DEFAULT NULL,
  `default_letter_head` varchar(140) DEFAULT NULL,
  `tax_id` varchar(140) DEFAULT NULL,
  `domain` varchar(140) DEFAULT NULL,
  `date_of_establishment` date DEFAULT NULL,
  `parent_company` varchar(140) DEFAULT NULL,
  `company_logo` text DEFAULT NULL,
  `date_of_incorporation` date DEFAULT NULL,
  `phone_no` varchar(140) DEFAULT NULL,
  `email` varchar(140) DEFAULT NULL,
  `company_description` longtext DEFAULT NULL,
  `date_of_commencement` date DEFAULT NULL,
  `fax` varchar(140) DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `registration_details` longtext DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `create_chart_of_accounts_based_on` varchar(140) DEFAULT NULL,
  `existing_company` varchar(140) DEFAULT NULL,
  `chart_of_accounts` varchar(140) DEFAULT NULL,
  `default_bank_account` varchar(140) DEFAULT NULL,
  `default_cash_account` varchar(140) DEFAULT NULL,
  `default_receivable_account` varchar(140) DEFAULT NULL,
  `default_payable_account` varchar(140) DEFAULT NULL,
  `write_off_account` varchar(140) DEFAULT NULL,
  `unrealized_profit_loss_account` varchar(140) DEFAULT NULL,
  `allow_account_creation_against_child_company` int(1) NOT NULL DEFAULT 0,
  `default_expense_account` varchar(140) DEFAULT NULL,
  `default_income_account` varchar(140) DEFAULT NULL,
  `default_discount_account` varchar(140) DEFAULT NULL,
  `payment_terms` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `default_finance_book` varchar(140) DEFAULT NULL,
  `exchange_gain_loss_account` varchar(140) DEFAULT NULL,
  `unrealized_exchange_gain_loss_account` varchar(140) DEFAULT NULL,
  `round_off_account` varchar(140) DEFAULT NULL,
  `round_off_cost_center` varchar(140) DEFAULT NULL,
  `round_off_for_opening` varchar(140) DEFAULT NULL,
  `default_deferred_revenue_account` varchar(140) DEFAULT NULL,
  `default_deferred_expense_account` varchar(140) DEFAULT NULL,
  `book_advance_payments_in_separate_party_account` int(1) NOT NULL DEFAULT 0,
  `reconcile_on_advance_payment_date` int(1) NOT NULL DEFAULT 0,
  `reconciliation_takes_effect_on` varchar(140) DEFAULT 'Oldest Of Invoice Or Advance',
  `default_advance_received_account` varchar(140) DEFAULT NULL,
  `default_advance_paid_account` varchar(140) DEFAULT NULL,
  `auto_exchange_rate_revaluation` int(1) NOT NULL DEFAULT 0,
  `auto_err_frequency` varchar(140) DEFAULT NULL,
  `submit_err_jv` int(1) NOT NULL DEFAULT 0,
  `exception_budget_approver_role` varchar(140) DEFAULT NULL,
  `accumulated_depreciation_account` varchar(140) DEFAULT NULL,
  `depreciation_expense_account` varchar(140) DEFAULT NULL,
  `series_for_depreciation_entry` varchar(140) DEFAULT NULL,
  `expenses_included_in_asset_valuation` varchar(140) DEFAULT NULL,
  `disposal_account` varchar(140) DEFAULT NULL,
  `depreciation_cost_center` varchar(140) DEFAULT NULL,
  `capital_work_in_progress_account` varchar(140) DEFAULT NULL,
  `asset_received_but_not_billed` varchar(140) DEFAULT NULL,
  `default_buying_terms` varchar(140) DEFAULT NULL,
  `sales_monthly_history` text DEFAULT NULL,
  `monthly_sales_target` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_monthly_sales` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `default_selling_terms` varchar(140) DEFAULT NULL,
  `default_warehouse_for_sales_return` varchar(140) DEFAULT NULL,
  `credit_limit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `transactions_annual_history` longtext DEFAULT NULL,
  `enable_perpetual_inventory` int(1) NOT NULL DEFAULT 1,
  `enable_provisional_accounting_for_non_stock_items` int(1) NOT NULL DEFAULT 0,
  `default_inventory_account` varchar(140) DEFAULT NULL,
  `stock_adjustment_account` varchar(140) DEFAULT NULL,
  `default_in_transit_warehouse` varchar(140) DEFAULT NULL,
  `stock_received_but_not_billed` varchar(140) DEFAULT NULL,
  `default_provisional_account` varchar(140) DEFAULT NULL,
  `expenses_included_in_valuation` varchar(140) DEFAULT NULL,
  `default_operating_cost_account` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `company_name` (`company_name`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCompany History`
--

DROP TABLE IF EXISTS `tabCompany History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCompany History` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `year` varchar(140) DEFAULT NULL,
  `highlight` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCompetitor`
--

DROP TABLE IF EXISTS `tabCompetitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCompetitor` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `competitor_name` varchar(140) DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `competitor_name` (`competitor_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCompetitor Detail`
--

DROP TABLE IF EXISTS `tabCompetitor Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCompetitor Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `competitor` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabConnected App`
--

DROP TABLE IF EXISTS `tabConnected App`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabConnected App` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `provider_name` varchar(140) DEFAULT NULL,
  `openid_configuration` varchar(140) DEFAULT NULL,
  `client_id` varchar(140) DEFAULT NULL,
  `redirect_uri` varchar(140) DEFAULT NULL,
  `client_secret` text DEFAULT NULL,
  `authorization_uri` text DEFAULT NULL,
  `token_uri` varchar(140) DEFAULT NULL,
  `revocation_uri` varchar(140) DEFAULT NULL,
  `userinfo_uri` varchar(140) DEFAULT NULL,
  `introspection_uri` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabConsole Log`
--

DROP TABLE IF EXISTS `tabConsole Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabConsole Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `script` longtext DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `committed` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabContact`
--

DROP TABLE IF EXISTS `tabContact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabContact` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `first_name` varchar(140) DEFAULT NULL,
  `middle_name` varchar(140) DEFAULT NULL,
  `last_name` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `email_id` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `address` varchar(140) DEFAULT NULL,
  `sync_with_google_contacts` int(1) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT 'Passive',
  `salutation` varchar(140) DEFAULT NULL,
  `designation` varchar(140) DEFAULT NULL,
  `gender` varchar(140) DEFAULT NULL,
  `phone` varchar(140) DEFAULT NULL,
  `mobile_no` varchar(140) DEFAULT NULL,
  `company_name` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `google_contacts` varchar(140) DEFAULT NULL,
  `google_contacts_id` varchar(140) DEFAULT NULL,
  `pulled_from_google_contacts` int(1) NOT NULL DEFAULT 0,
  `is_primary_contact` int(1) NOT NULL DEFAULT 0,
  `department` varchar(140) DEFAULT NULL,
  `unsubscribed` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `is_billing_contact` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `email_id` (`email_id`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabContact Email`
--

DROP TABLE IF EXISTS `tabContact Email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabContact Email` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_id` varchar(140) DEFAULT NULL,
  `is_primary` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabContact Phone`
--

DROP TABLE IF EXISTS `tabContact Phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabContact Phone` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `phone` varchar(140) DEFAULT NULL,
  `is_primary_phone` int(1) NOT NULL DEFAULT 0,
  `is_primary_mobile_no` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabContract`
--

DROP TABLE IF EXISTS `tabContract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabContract` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `party_type` varchar(140) DEFAULT 'Customer',
  `is_signed` int(1) NOT NULL DEFAULT 0,
  `party_name` varchar(140) DEFAULT NULL,
  `party_user` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `fulfilment_status` varchar(140) DEFAULT NULL,
  `party_full_name` varchar(140) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `signee` varchar(140) DEFAULT NULL,
  `signed_on` datetime(6) DEFAULT NULL,
  `ip_address` varchar(140) DEFAULT NULL,
  `contract_template` varchar(140) DEFAULT NULL,
  `contract_terms` longtext DEFAULT NULL,
  `requires_fulfilment` int(1) NOT NULL DEFAULT 0,
  `fulfilment_deadline` date DEFAULT NULL,
  `signee_company` longtext DEFAULT NULL,
  `signed_by_company` varchar(140) DEFAULT NULL,
  `document_type` varchar(140) DEFAULT NULL,
  `document_name` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabContract Fulfilment Checklist`
--

DROP TABLE IF EXISTS `tabContract Fulfilment Checklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabContract Fulfilment Checklist` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fulfilled` int(1) NOT NULL DEFAULT 0,
  `requirement` varchar(140) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabContract Template`
--

DROP TABLE IF EXISTS `tabContract Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabContract Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `contract_terms` longtext DEFAULT NULL,
  `requires_fulfilment` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `title` (`title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabContract Template Fulfilment Terms`
--

DROP TABLE IF EXISTS `tabContract Template Fulfilment Terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabContract Template Fulfilment Terms` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `requirement` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCost Center`
--

DROP TABLE IF EXISTS `tabCost Center`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCost Center` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `cost_center_name` varchar(140) DEFAULT NULL,
  `cost_center_number` varchar(140) DEFAULT NULL,
  `parent_cost_center` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCost Center Allocation`
--

DROP TABLE IF EXISTS `tabCost Center Allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCost Center Allocation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `main_cost_center` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCost Center Allocation Percentage`
--

DROP TABLE IF EXISTS `tabCost Center Allocation Percentage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCost Center Allocation Percentage` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `cost_center` varchar(140) DEFAULT NULL,
  `percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCountry`
--

DROP TABLE IF EXISTS `tabCountry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCountry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `country_name` varchar(140) DEFAULT NULL,
  `date_format` varchar(140) DEFAULT NULL,
  `time_format` varchar(140) DEFAULT 'HH:mm:ss',
  `time_zones` text DEFAULT NULL,
  `code` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `country_name` (`country_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCoupon Code`
--

DROP TABLE IF EXISTS `tabCoupon Code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCoupon Code` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `coupon_name` varchar(140) DEFAULT NULL,
  `coupon_type` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `coupon_code` varchar(140) DEFAULT NULL,
  `pricing_rule` varchar(140) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_upto` date DEFAULT NULL,
  `maximum_use` int(11) NOT NULL DEFAULT 0,
  `used` int(11) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `coupon_name` (`coupon_name`),
  UNIQUE KEY `coupon_code` (`coupon_code`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCurrency`
--

DROP TABLE IF EXISTS `tabCurrency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCurrency` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `currency_name` varchar(140) DEFAULT NULL,
  `enabled` int(1) NOT NULL DEFAULT 0,
  `fraction` varchar(140) DEFAULT NULL,
  `fraction_units` int(11) NOT NULL DEFAULT 0,
  `smallest_currency_fraction_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `symbol` varchar(140) DEFAULT NULL,
  `symbol_on_right` int(1) NOT NULL DEFAULT 0,
  `number_format` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `currency_name` (`currency_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCurrency Exchange`
--

DROP TABLE IF EXISTS `tabCurrency Exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCurrency Exchange` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL,
  `from_currency` varchar(140) DEFAULT NULL,
  `to_currency` varchar(140) DEFAULT NULL,
  `exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `for_buying` int(1) NOT NULL DEFAULT 1,
  `for_selling` int(1) NOT NULL DEFAULT 1,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCurrency Exchange Settings Details`
--

DROP TABLE IF EXISTS `tabCurrency Exchange Settings Details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCurrency Exchange Settings Details` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `key` varchar(140) DEFAULT NULL,
  `value` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCurrency Exchange Settings Result`
--

DROP TABLE IF EXISTS `tabCurrency Exchange Settings Result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCurrency Exchange Settings Result` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `key` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustom DocPerm`
--

DROP TABLE IF EXISTS `tabCustom DocPerm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustom DocPerm` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `role` varchar(140) DEFAULT NULL,
  `if_owner` int(1) NOT NULL DEFAULT 0,
  `permlevel` int(11) NOT NULL DEFAULT 0,
  `select` int(1) NOT NULL DEFAULT 0,
  `read` int(1) NOT NULL DEFAULT 1,
  `write` int(1) NOT NULL DEFAULT 0,
  `create` int(1) NOT NULL DEFAULT 0,
  `delete` int(1) NOT NULL DEFAULT 0,
  `submit` int(1) NOT NULL DEFAULT 0,
  `cancel` int(1) NOT NULL DEFAULT 0,
  `amend` int(1) NOT NULL DEFAULT 0,
  `report` int(1) NOT NULL DEFAULT 0,
  `export` int(1) NOT NULL DEFAULT 1,
  `import` int(1) NOT NULL DEFAULT 0,
  `share` int(1) NOT NULL DEFAULT 0,
  `print` int(1) NOT NULL DEFAULT 0,
  `email` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustom Field`
--

DROP TABLE IF EXISTS `tabCustom Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustom Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_system_generated` int(1) NOT NULL DEFAULT 0,
  `dt` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `placeholder` varchar(140) DEFAULT NULL,
  `fieldname` varchar(140) DEFAULT NULL,
  `insert_after` varchar(140) DEFAULT NULL,
  `length` int(11) NOT NULL DEFAULT 0,
  `link_filters` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`link_filters`)),
  `fieldtype` varchar(140) DEFAULT 'Data',
  `precision` varchar(140) DEFAULT NULL,
  `hide_seconds` int(1) NOT NULL DEFAULT 0,
  `hide_days` int(1) NOT NULL DEFAULT 0,
  `options` text DEFAULT NULL,
  `sort_options` int(1) NOT NULL DEFAULT 0,
  `fetch_from` text DEFAULT NULL,
  `fetch_if_empty` int(1) NOT NULL DEFAULT 0,
  `collapsible` int(1) NOT NULL DEFAULT 0,
  `collapsible_depends_on` longtext DEFAULT NULL,
  `default` text DEFAULT NULL,
  `depends_on` longtext DEFAULT NULL,
  `mandatory_depends_on` longtext DEFAULT NULL,
  `read_only_depends_on` longtext DEFAULT NULL,
  `non_negative` int(1) NOT NULL DEFAULT 0,
  `reqd` int(1) NOT NULL DEFAULT 0,
  `unique` int(1) NOT NULL DEFAULT 0,
  `is_virtual` int(1) NOT NULL DEFAULT 0,
  `read_only` int(1) NOT NULL DEFAULT 0,
  `ignore_user_permissions` int(1) NOT NULL DEFAULT 0,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `print_hide` int(1) NOT NULL DEFAULT 0,
  `print_hide_if_no_value` int(1) NOT NULL DEFAULT 0,
  `print_width` varchar(140) DEFAULT NULL,
  `no_copy` int(1) NOT NULL DEFAULT 0,
  `allow_on_submit` int(1) NOT NULL DEFAULT 0,
  `in_list_view` int(1) NOT NULL DEFAULT 0,
  `in_standard_filter` int(1) NOT NULL DEFAULT 0,
  `in_global_search` int(1) NOT NULL DEFAULT 0,
  `in_preview` int(1) NOT NULL DEFAULT 0,
  `bold` int(1) NOT NULL DEFAULT 0,
  `report_hide` int(1) NOT NULL DEFAULT 0,
  `search_index` int(1) NOT NULL DEFAULT 0,
  `allow_in_quick_entry` int(1) NOT NULL DEFAULT 0,
  `ignore_xss_filter` int(1) NOT NULL DEFAULT 0,
  `translatable` int(1) NOT NULL DEFAULT 0,
  `hide_border` int(1) NOT NULL DEFAULT 0,
  `show_dashboard` int(1) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `permlevel` int(11) NOT NULL DEFAULT 0,
  `width` varchar(140) DEFAULT NULL,
  `columns` int(11) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `dt` (`dt`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustom HTML Block`
--

DROP TABLE IF EXISTS `tabCustom HTML Block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustom HTML Block` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `private` int(1) NOT NULL DEFAULT 0,
  `html` longtext DEFAULT NULL,
  `script` longtext DEFAULT NULL,
  `style` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustom Role`
--

DROP TABLE IF EXISTS `tabCustom Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustom Role` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `page` varchar(140) DEFAULT NULL,
  `report` varchar(140) DEFAULT NULL,
  `ref_doctype` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustomer`
--

DROP TABLE IF EXISTS `tabCustomer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustomer` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `salutation` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `customer_type` varchar(140) DEFAULT 'Company',
  `customer_group` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `gender` varchar(140) DEFAULT NULL,
  `lead_name` varchar(140) DEFAULT NULL,
  `opportunity_name` varchar(140) DEFAULT NULL,
  `prospect_name` varchar(140) DEFAULT NULL,
  `account_manager` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `default_currency` varchar(140) DEFAULT NULL,
  `default_bank_account` varchar(140) DEFAULT NULL,
  `default_price_list` varchar(140) DEFAULT NULL,
  `is_internal_customer` int(1) NOT NULL DEFAULT 0,
  `represents_company` varchar(140) DEFAULT NULL,
  `market_segment` varchar(140) DEFAULT NULL,
  `industry` varchar(140) DEFAULT NULL,
  `customer_pos_id` varchar(140) DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `customer_details` text DEFAULT NULL,
  `customer_primary_address` varchar(140) DEFAULT NULL,
  `primary_address` text DEFAULT NULL,
  `customer_primary_contact` varchar(140) DEFAULT NULL,
  `mobile_no` varchar(140) DEFAULT NULL,
  `email_id` varchar(140) DEFAULT NULL,
  `tax_id` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `tax_withholding_category` varchar(140) DEFAULT NULL,
  `payment_terms` varchar(140) DEFAULT NULL,
  `loyalty_program` varchar(140) DEFAULT NULL,
  `loyalty_program_tier` varchar(140) DEFAULT NULL,
  `default_sales_partner` varchar(140) DEFAULT NULL,
  `default_commission_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `so_required` int(1) NOT NULL DEFAULT 0,
  `dn_required` int(1) NOT NULL DEFAULT 0,
  `is_frozen` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `represents_company` (`represents_company`),
  KEY `customer_name` (`customer_name`),
  KEY `customer_group` (`customer_group`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustomer Credit Limit`
--

DROP TABLE IF EXISTS `tabCustomer Credit Limit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustomer Credit Limit` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `credit_limit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `bypass_credit_limit_check` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustomer Group`
--

DROP TABLE IF EXISTS `tabCustomer Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustomer Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `customer_group_name` varchar(140) DEFAULT NULL,
  `parent_customer_group` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `default_price_list` varchar(140) DEFAULT NULL,
  `payment_terms` varchar(140) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `customer_group_name` (`customer_group_name`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustomer Group Item`
--

DROP TABLE IF EXISTS `tabCustomer Group Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustomer Group Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `customer_group` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustomer Item`
--

DROP TABLE IF EXISTS `tabCustomer Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustomer Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `customer` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustomize Form Field`
--

DROP TABLE IF EXISTS `tabCustomize Form Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustomize Form Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_system_generated` int(1) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT 'Data',
  `fieldname` varchar(140) DEFAULT NULL,
  `non_negative` int(1) NOT NULL DEFAULT 0,
  `reqd` int(1) NOT NULL DEFAULT 0,
  `unique` int(1) NOT NULL DEFAULT 0,
  `is_virtual` int(1) NOT NULL DEFAULT 0,
  `in_list_view` int(1) NOT NULL DEFAULT 0,
  `in_standard_filter` int(1) NOT NULL DEFAULT 0,
  `in_global_search` int(1) NOT NULL DEFAULT 0,
  `in_preview` int(1) NOT NULL DEFAULT 0,
  `bold` int(1) NOT NULL DEFAULT 0,
  `no_copy` int(1) NOT NULL DEFAULT 0,
  `allow_in_quick_entry` int(1) NOT NULL DEFAULT 0,
  `translatable` int(1) NOT NULL DEFAULT 1,
  `link_filters` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`link_filters`)),
  `default` text DEFAULT NULL,
  `precision` varchar(140) DEFAULT NULL,
  `length` int(11) NOT NULL DEFAULT 0,
  `options` text DEFAULT NULL,
  `sort_options` int(1) NOT NULL DEFAULT 0,
  `fetch_from` text DEFAULT NULL,
  `fetch_if_empty` int(1) NOT NULL DEFAULT 0,
  `show_dashboard` int(1) NOT NULL DEFAULT 0,
  `depends_on` longtext DEFAULT NULL,
  `permlevel` int(11) NOT NULL DEFAULT 0,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `read_only` int(1) NOT NULL DEFAULT 0,
  `collapsible` int(1) NOT NULL DEFAULT 0,
  `allow_bulk_edit` int(1) NOT NULL DEFAULT 0,
  `collapsible_depends_on` longtext DEFAULT NULL,
  `ignore_user_permissions` int(1) NOT NULL DEFAULT 0,
  `allow_on_submit` int(1) NOT NULL DEFAULT 0,
  `report_hide` int(1) NOT NULL DEFAULT 0,
  `remember_last_selected_value` int(1) NOT NULL DEFAULT 0,
  `hide_border` int(1) NOT NULL DEFAULT 0,
  `ignore_xss_filter` int(1) NOT NULL DEFAULT 0,
  `mandatory_depends_on` longtext DEFAULT NULL,
  `read_only_depends_on` longtext DEFAULT NULL,
  `in_filter` int(1) NOT NULL DEFAULT 0,
  `hide_seconds` int(1) NOT NULL DEFAULT 0,
  `hide_days` int(1) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `placeholder` varchar(140) DEFAULT NULL,
  `print_hide` int(1) NOT NULL DEFAULT 0,
  `print_hide_if_no_value` int(1) NOT NULL DEFAULT 0,
  `print_width` varchar(140) DEFAULT NULL,
  `columns` int(11) NOT NULL DEFAULT 0,
  `width` varchar(140) DEFAULT NULL,
  `is_custom_field` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `label` (`label`),
  KEY `fieldtype` (`fieldtype`),
  KEY `fieldname` (`fieldname`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabCustoms Tariff Number`
--

DROP TABLE IF EXISTS `tabCustoms Tariff Number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabCustoms Tariff Number` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `tariff_number` varchar(140) DEFAULT NULL,
  `description` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `tariff_number` (`tariff_number`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDashboard`
--

DROP TABLE IF EXISTS `tabDashboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDashboard` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `dashboard_name` varchar(140) DEFAULT NULL,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `chart_options` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `dashboard_name` (`dashboard_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDashboard Chart`
--

DROP TABLE IF EXISTS `tabDashboard Chart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDashboard Chart` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `chart_name` varchar(140) DEFAULT NULL,
  `chart_type` varchar(140) DEFAULT NULL,
  `report_name` varchar(140) DEFAULT NULL,
  `use_report_chart` int(1) NOT NULL DEFAULT 0,
  `x_field` varchar(140) DEFAULT NULL,
  `source` varchar(140) DEFAULT NULL,
  `document_type` varchar(140) DEFAULT NULL,
  `parent_document_type` varchar(140) DEFAULT NULL,
  `based_on` varchar(140) DEFAULT NULL,
  `value_based_on` varchar(140) DEFAULT NULL,
  `group_by_type` varchar(140) DEFAULT 'Count',
  `group_by_based_on` varchar(140) DEFAULT NULL,
  `aggregate_function_based_on` varchar(140) DEFAULT NULL,
  `number_of_groups` int(11) NOT NULL DEFAULT 0,
  `is_public` int(1) NOT NULL DEFAULT 0,
  `heatmap_year` varchar(140) DEFAULT NULL,
  `timespan` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `time_interval` varchar(140) DEFAULT NULL,
  `timeseries` int(1) NOT NULL DEFAULT 0,
  `type` varchar(140) DEFAULT 'Line',
  `filters_json` longtext DEFAULT NULL,
  `dynamic_filters_json` longtext DEFAULT NULL,
  `custom_options` longtext DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `last_synced_on` datetime(6) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `show_values_over_chart` int(1) NOT NULL DEFAULT 0,
  `currency` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `chart_name` (`chart_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDashboard Chart Field`
--

DROP TABLE IF EXISTS `tabDashboard Chart Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDashboard Chart Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `y_field` varchar(140) DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDashboard Chart Link`
--

DROP TABLE IF EXISTS `tabDashboard Chart Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDashboard Chart Link` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `chart` varchar(140) DEFAULT NULL,
  `width` varchar(140) DEFAULT 'Half',
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDashboard Chart Source`
--

DROP TABLE IF EXISTS `tabDashboard Chart Source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDashboard Chart Source` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `source_name` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `timeseries` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `source_name` (`source_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDashboard Settings`
--

DROP TABLE IF EXISTS `tabDashboard Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDashboard Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `chart_config` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabData Import`
--

DROP TABLE IF EXISTS `tabData Import`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabData Import` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `import_type` varchar(140) DEFAULT NULL,
  `import_file` text DEFAULT NULL,
  `payload_count` int(11) NOT NULL DEFAULT 0,
  `google_sheets_url` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Pending',
  `submit_after_import` int(1) NOT NULL DEFAULT 0,
  `mute_emails` int(1) NOT NULL DEFAULT 1,
  `template_options` longtext DEFAULT NULL,
  `template_warnings` longtext DEFAULT NULL,
  `show_failed_logs` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabData Import Log`
--

DROP TABLE IF EXISTS `tabData Import Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabData Import Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `data_import` varchar(140) DEFAULT NULL,
  `row_indexes` longtext DEFAULT NULL,
  `success` int(1) NOT NULL DEFAULT 0,
  `docname` varchar(140) DEFAULT NULL,
  `messages` longtext DEFAULT NULL,
  `exception` text DEFAULT NULL,
  `log_index` int(11) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDefaultValue`
--

DROP TABLE IF EXISTS `tabDefaultValue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDefaultValue` (
  `name` varchar(255) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(255) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(255) DEFAULT NULL,
  `parentfield` varchar(255) DEFAULT NULL,
  `parenttype` varchar(255) DEFAULT NULL,
  `idx` int(8) NOT NULL DEFAULT 0,
  `defvalue` text DEFAULT NULL,
  `defkey` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`),
  KEY `defaultvalue_parent_defkey_index` (`parent`,`defkey`),
  KEY `defaultvalue_parent_parenttype_index` (`parent`,`parenttype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDeleted Document`
--

DROP TABLE IF EXISTS `tabDeleted Document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDeleted Document` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `deleted_name` varchar(140) DEFAULT NULL,
  `deleted_doctype` varchar(140) DEFAULT NULL,
  `restored` int(1) NOT NULL DEFAULT 0,
  `new_name` varchar(140) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDelivery Note`
--

DROP TABLE IF EXISTS `tabDelivery Note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDelivery Note` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{customer_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `tax_id` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `is_return` int(1) NOT NULL DEFAULT 0,
  `issue_credit_note` int(1) NOT NULL DEFAULT 0,
  `return_against` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `selling_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `set_target_warehouse` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_category` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` varchar(240) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `in_words` varchar(240) DEFAULT NULL,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `other_charges_calculation` longtext DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `shipping_address_name` varchar(140) DEFAULT NULL,
  `shipping_address` text DEFAULT NULL,
  `dispatch_address_name` varchar(140) DEFAULT NULL,
  `dispatch_address` text DEFAULT NULL,
  `company_address` varchar(140) DEFAULT NULL,
  `company_address_display` text DEFAULT NULL,
  `company_contact_person` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `per_billed` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `status` varchar(140) DEFAULT 'Draft',
  `per_installed` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `installation_status` varchar(140) DEFAULT NULL,
  `per_returned` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `transporter` varchar(140) DEFAULT NULL,
  `driver` varchar(140) DEFAULT NULL,
  `lr_no` varchar(140) DEFAULT NULL,
  `vehicle_no` varchar(140) DEFAULT NULL,
  `transporter_name` varchar(140) DEFAULT NULL,
  `driver_name` varchar(140) DEFAULT NULL,
  `lr_date` date DEFAULT NULL,
  `po_no` text DEFAULT NULL,
  `po_date` date DEFAULT NULL,
  `sales_partner` varchar(140) DEFAULT NULL,
  `amount_eligible_for_commission` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `commission_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_commission` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `print_without_amount` int(1) NOT NULL DEFAULT 0,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `is_internal_customer` int(1) NOT NULL DEFAULT 0,
  `represents_company` varchar(140) DEFAULT NULL,
  `inter_company_reference` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `source` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `excise_page` varchar(140) DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer` (`customer`),
  KEY `posting_date` (`posting_date`),
  KEY `return_against` (`return_against`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDelivery Note Item`
--

DROP TABLE IF EXISTS `tabDelivery Note Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDelivery Note Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `barcode` varchar(140) DEFAULT NULL,
  `has_item_scanned` int(1) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `customer_item_code` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `margin_type` varchar(140) DEFAULT NULL,
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `stock_uom_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `grant_commission` int(1) NOT NULL DEFAULT 0,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billed_amt` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `incoming_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `target_warehouse` varchar(140) DEFAULT NULL,
  `quality_inspection` varchar(140) DEFAULT NULL,
  `allow_zero_valuation_rate` int(1) NOT NULL DEFAULT 0,
  `against_sales_order` varchar(140) DEFAULT NULL,
  `so_detail` varchar(140) DEFAULT NULL,
  `against_sales_invoice` varchar(140) DEFAULT NULL,
  `si_detail` varchar(140) DEFAULT NULL,
  `dn_detail` varchar(140) DEFAULT NULL,
  `against_pick_list` varchar(140) DEFAULT NULL,
  `pick_list_item` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_batch_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `company_total_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `installed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `packed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `received_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expense_account` varchar(140) DEFAULT NULL,
  `item_tax_rate` text DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `purchase_order` varchar(140) DEFAULT NULL,
  `purchase_order_item` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `against_sales_order` (`against_sales_order`),
  KEY `so_detail` (`so_detail`),
  KEY `against_sales_invoice` (`against_sales_invoice`),
  KEY `si_detail` (`si_detail`),
  KEY `dn_detail` (`dn_detail`),
  KEY `against_pick_list` (`against_pick_list`),
  KEY `serial_and_batch_bundle` (`serial_and_batch_bundle`),
  KEY `batch_no` (`batch_no`),
  KEY `purchase_order` (`purchase_order`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDelivery Stop`
--

DROP TABLE IF EXISTS `tabDelivery Stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDelivery Stop` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `customer` varchar(140) DEFAULT NULL,
  `address` varchar(140) DEFAULT NULL,
  `locked` int(1) NOT NULL DEFAULT 0,
  `customer_address` text DEFAULT NULL,
  `visited` int(1) NOT NULL DEFAULT 0,
  `delivery_note` varchar(140) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `contact` varchar(140) DEFAULT NULL,
  `email_sent_to` varchar(140) DEFAULT NULL,
  `customer_contact` text DEFAULT NULL,
  `distance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `estimated_arrival` datetime(6) DEFAULT NULL,
  `lat` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `lng` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `details` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDelivery Trip`
--

DROP TABLE IF EXISTS `tabDelivery Trip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDelivery Trip` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `email_notification_sent` int(1) NOT NULL DEFAULT 0,
  `driver` varchar(140) DEFAULT NULL,
  `driver_name` varchar(140) DEFAULT NULL,
  `driver_email` varchar(140) DEFAULT NULL,
  `driver_address` varchar(140) DEFAULT NULL,
  `total_distance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `vehicle` varchar(140) DEFAULT NULL,
  `departure_time` datetime(6) DEFAULT NULL,
  `employee` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDepartment`
--

DROP TABLE IF EXISTS `tabDepartment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDepartment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `department_name` varchar(140) DEFAULT NULL,
  `parent_department` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDependent Task`
--

DROP TABLE IF EXISTS `tabDependent Task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDependent Task` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `task` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDepreciation Schedule`
--

DROP TABLE IF EXISTS `tabDepreciation Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDepreciation Schedule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `schedule_date` date DEFAULT NULL,
  `depreciation_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `accumulated_depreciation_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `journal_entry` varchar(140) DEFAULT NULL,
  `shift` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDesignation`
--

DROP TABLE IF EXISTS `tabDesignation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDesignation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `designation_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `designation_name` (`designation_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDesktop Icon`
--

DROP TABLE IF EXISTS `tabDesktop Icon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDesktop Icon` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `module_name` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `standard` int(1) NOT NULL DEFAULT 0,
  `custom` int(1) NOT NULL DEFAULT 0,
  `app` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(140) DEFAULT NULL,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `blocked` int(1) NOT NULL DEFAULT 0,
  `force_show` int(1) NOT NULL DEFAULT 0,
  `type` varchar(140) DEFAULT NULL,
  `_doctype` varchar(140) DEFAULT NULL,
  `_report` varchar(140) DEFAULT NULL,
  `link` text DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `icon` varchar(140) DEFAULT NULL,
  `reverse` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `unique_module_name_owner_standard` (`module_name`,`owner`,`standard`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDiscounted Invoice`
--

DROP TABLE IF EXISTS `tabDiscounted Invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDiscounted Invoice` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sales_invoice` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `outstanding_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `debit_to` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `sales_invoice` (`sales_invoice`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDiscussion Reply`
--

DROP TABLE IF EXISTS `tabDiscussion Reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDiscussion Reply` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `topic` varchar(140) DEFAULT NULL,
  `reply` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDiscussion Topic`
--

DROP TABLE IF EXISTS `tabDiscussion Topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDiscussion Topic` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_docname` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocField`
--

DROP TABLE IF EXISTS `tabDocField`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocField` (
  `name` varchar(255) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(255) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(255) DEFAULT NULL,
  `parentfield` varchar(255) DEFAULT NULL,
  `parenttype` varchar(255) DEFAULT NULL,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fieldname` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `oldfieldname` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT 'Data',
  `oldfieldtype` varchar(140) DEFAULT NULL,
  `options` text DEFAULT NULL,
  `search_index` int(1) NOT NULL DEFAULT 0,
  `show_dashboard` int(1) NOT NULL DEFAULT 0,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `set_only_once` int(1) NOT NULL DEFAULT 0,
  `allow_in_quick_entry` int(1) NOT NULL DEFAULT 0,
  `print_hide` int(1) NOT NULL DEFAULT 0,
  `report_hide` int(1) NOT NULL DEFAULT 0,
  `reqd` int(1) NOT NULL DEFAULT 0,
  `bold` int(1) NOT NULL DEFAULT 0,
  `in_global_search` int(1) NOT NULL DEFAULT 0,
  `collapsible` int(1) NOT NULL DEFAULT 0,
  `unique` int(1) NOT NULL DEFAULT 0,
  `no_copy` int(1) NOT NULL DEFAULT 0,
  `allow_on_submit` int(1) NOT NULL DEFAULT 0,
  `show_preview_popup` int(1) NOT NULL DEFAULT 0,
  `trigger` varchar(255) DEFAULT NULL,
  `collapsible_depends_on` longtext DEFAULT NULL,
  `mandatory_depends_on` longtext DEFAULT NULL,
  `read_only_depends_on` longtext DEFAULT NULL,
  `depends_on` longtext DEFAULT NULL,
  `permlevel` int(11) NOT NULL DEFAULT 0,
  `ignore_user_permissions` int(1) NOT NULL DEFAULT 0,
  `width` varchar(10) DEFAULT NULL,
  `print_width` varchar(10) DEFAULT NULL,
  `columns` int(11) NOT NULL DEFAULT 0,
  `default` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `in_list_view` int(1) NOT NULL DEFAULT 0,
  `fetch_if_empty` int(1) NOT NULL DEFAULT 0,
  `in_filter` int(1) NOT NULL DEFAULT 0,
  `remember_last_selected_value` int(1) NOT NULL DEFAULT 0,
  `ignore_xss_filter` int(1) NOT NULL DEFAULT 0,
  `print_hide_if_no_value` int(1) NOT NULL DEFAULT 0,
  `allow_bulk_edit` int(1) NOT NULL DEFAULT 0,
  `in_standard_filter` int(1) NOT NULL DEFAULT 0,
  `in_preview` int(1) NOT NULL DEFAULT 0,
  `read_only` int(1) NOT NULL DEFAULT 0,
  `precision` varchar(140) DEFAULT NULL,
  `max_height` varchar(10) DEFAULT NULL,
  `length` int(11) NOT NULL DEFAULT 0,
  `translatable` int(1) NOT NULL DEFAULT 0,
  `hide_border` int(1) NOT NULL DEFAULT 0,
  `hide_days` int(1) NOT NULL DEFAULT 0,
  `hide_seconds` int(1) NOT NULL DEFAULT 0,
  `non_negative` int(1) NOT NULL DEFAULT 0,
  `is_virtual` int(1) NOT NULL DEFAULT 0,
  `sort_options` int(1) NOT NULL DEFAULT 0,
  `link_filters` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`link_filters`)),
  `fetch_from` text DEFAULT NULL,
  `show_on_timeline` int(1) NOT NULL DEFAULT 0,
  `make_attachment_public` int(1) NOT NULL DEFAULT 0,
  `documentation_url` varchar(140) DEFAULT NULL,
  `placeholder` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`),
  KEY `label` (`label`),
  KEY `fieldtype` (`fieldtype`),
  KEY `fieldname` (`fieldname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocPerm`
--

DROP TABLE IF EXISTS `tabDocPerm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocPerm` (
  `name` varchar(255) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(255) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(255) DEFAULT NULL,
  `parentfield` varchar(255) DEFAULT NULL,
  `parenttype` varchar(255) DEFAULT NULL,
  `idx` int(8) NOT NULL DEFAULT 0,
  `permlevel` int(11) DEFAULT 0,
  `role` varchar(140) DEFAULT NULL,
  `match` varchar(255) DEFAULT NULL,
  `read` int(1) NOT NULL DEFAULT 1,
  `write` int(1) NOT NULL DEFAULT 1,
  `create` int(1) NOT NULL DEFAULT 1,
  `submit` int(1) NOT NULL DEFAULT 0,
  `cancel` int(1) NOT NULL DEFAULT 0,
  `delete` int(1) NOT NULL DEFAULT 1,
  `amend` int(1) NOT NULL DEFAULT 0,
  `report` int(1) NOT NULL DEFAULT 1,
  `export` int(1) NOT NULL DEFAULT 1,
  `import` int(1) NOT NULL DEFAULT 0,
  `share` int(1) NOT NULL DEFAULT 1,
  `print` int(1) NOT NULL DEFAULT 1,
  `email` int(1) NOT NULL DEFAULT 1,
  `if_owner` int(1) NOT NULL DEFAULT 0,
  `select` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocShare`
--

DROP TABLE IF EXISTS `tabDocShare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocShare` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `share_doctype` varchar(140) DEFAULT NULL,
  `share_name` varchar(140) DEFAULT NULL,
  `read` int(1) NOT NULL DEFAULT 0,
  `write` int(1) NOT NULL DEFAULT 0,
  `share` int(1) NOT NULL DEFAULT 0,
  `submit` int(1) NOT NULL DEFAULT 0,
  `everyone` int(1) NOT NULL DEFAULT 0,
  `notify_by_email` int(1) NOT NULL DEFAULT 1,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `user` (`user`),
  KEY `share_doctype` (`share_doctype`),
  KEY `share_name` (`share_name`),
  KEY `everyone` (`everyone`),
  KEY `modified` (`modified`),
  KEY `user_share_doctype_index` (`user`,`share_doctype`),
  KEY `share_doctype_share_name_index` (`share_doctype`,`share_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocType`
--

DROP TABLE IF EXISTS `tabDocType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocType` (
  `name` varchar(255) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(255) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `search_fields` varchar(140) DEFAULT NULL,
  `issingle` int(1) NOT NULL DEFAULT 0,
  `is_virtual` int(1) NOT NULL DEFAULT 0,
  `is_tree` int(1) NOT NULL DEFAULT 0,
  `istable` int(1) NOT NULL DEFAULT 0,
  `editable_grid` int(1) NOT NULL DEFAULT 1,
  `track_changes` int(1) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `restrict_to_domain` varchar(140) DEFAULT NULL,
  `app` varchar(255) DEFAULT NULL,
  `autoname` varchar(140) DEFAULT NULL,
  `naming_rule` varchar(40) DEFAULT NULL,
  `title_field` varchar(140) DEFAULT NULL,
  `image_field` varchar(140) DEFAULT NULL,
  `timeline_field` varchar(140) DEFAULT NULL,
  `sort_field` varchar(140) DEFAULT 'modified',
  `sort_order` varchar(140) DEFAULT 'DESC',
  `description` text DEFAULT NULL,
  `colour` varchar(255) DEFAULT NULL,
  `read_only` int(1) NOT NULL DEFAULT 0,
  `in_create` int(1) NOT NULL DEFAULT 0,
  `menu_index` int(11) DEFAULT NULL,
  `parent_node` varchar(255) DEFAULT NULL,
  `smallicon` varchar(255) DEFAULT NULL,
  `allow_copy` int(1) NOT NULL DEFAULT 0,
  `allow_rename` int(1) NOT NULL DEFAULT 1,
  `allow_import` int(1) NOT NULL DEFAULT 0,
  `hide_toolbar` int(1) NOT NULL DEFAULT 0,
  `track_seen` int(1) NOT NULL DEFAULT 0,
  `max_attachments` int(11) NOT NULL DEFAULT 0,
  `print_outline` varchar(255) DEFAULT NULL,
  `document_type` varchar(140) DEFAULT NULL,
  `icon` varchar(140) DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `tag_fields` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `_last_update` varchar(32) DEFAULT NULL,
  `engine` varchar(140) DEFAULT 'InnoDB',
  `default_print_format` varchar(140) DEFAULT NULL,
  `is_submittable` int(1) NOT NULL DEFAULT 0,
  `show_name_in_global_search` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `custom` int(1) NOT NULL DEFAULT 0,
  `beta` int(1) NOT NULL DEFAULT 0,
  `has_web_view` int(1) NOT NULL DEFAULT 0,
  `allow_guest_to_view` int(1) NOT NULL DEFAULT 0,
  `route` varchar(140) DEFAULT NULL,
  `is_published_field` varchar(140) DEFAULT NULL,
  `website_search_field` varchar(140) DEFAULT NULL,
  `email_append_to` int(1) NOT NULL DEFAULT 0,
  `subject_field` varchar(140) DEFAULT NULL,
  `sender_field` varchar(140) DEFAULT NULL,
  `show_title_field_in_link` int(1) NOT NULL DEFAULT 0,
  `migration_hash` varchar(140) DEFAULT NULL,
  `translated_doctype` int(1) NOT NULL DEFAULT 0,
  `is_calendar_and_gantt` int(1) NOT NULL DEFAULT 0,
  `quick_entry` int(1) NOT NULL DEFAULT 0,
  `track_views` int(1) NOT NULL DEFAULT 0,
  `queue_in_background` int(1) NOT NULL DEFAULT 0,
  `documentation` varchar(140) DEFAULT NULL,
  `nsm_parent_field` varchar(140) DEFAULT NULL,
  `allow_events_in_timeline` int(1) NOT NULL DEFAULT 0,
  `allow_auto_repeat` int(1) NOT NULL DEFAULT 0,
  `make_attachments_public` int(1) NOT NULL DEFAULT 0,
  `default_view` varchar(140) DEFAULT NULL,
  `force_re_route_to_default_view` int(1) NOT NULL DEFAULT 0,
  `show_preview_popup` int(1) NOT NULL DEFAULT 0,
  `default_email_template` varchar(140) DEFAULT NULL,
  `sender_name_field` varchar(140) DEFAULT NULL,
  `index_web_pages_for_search` int(1) NOT NULL DEFAULT 1,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `grid_page_length` int(11) NOT NULL DEFAULT 50,
  `protect_attached_files` int(1) NOT NULL DEFAULT 0,
  `row_format` varchar(140) DEFAULT 'Dynamic',
  PRIMARY KEY (`name`),
  KEY `module_index` (`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocType Action`
--

DROP TABLE IF EXISTS `tabDocType Action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocType Action` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  `idx` int(8) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `group` varchar(140) DEFAULT NULL,
  `action_type` varchar(140) DEFAULT NULL,
  `action` text DEFAULT NULL,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `custom` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocType Layout`
--

DROP TABLE IF EXISTS `tabDocType Layout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocType Layout` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `client_script` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocType Layout Field`
--

DROP TABLE IF EXISTS `tabDocType Layout Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocType Layout Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `fieldname` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocType Link`
--

DROP TABLE IF EXISTS `tabDocType Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocType Link` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  `idx` int(8) NOT NULL DEFAULT 0,
  `group` varchar(140) DEFAULT NULL,
  `link_doctype` varchar(140) DEFAULT NULL,
  `link_fieldname` varchar(140) DEFAULT NULL,
  `parent_doctype` varchar(140) DEFAULT NULL,
  `table_fieldname` varchar(140) DEFAULT NULL,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `is_child_table` int(1) NOT NULL DEFAULT 0,
  `custom` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocType State`
--

DROP TABLE IF EXISTS `tabDocType State`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocType State` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `color` varchar(140) DEFAULT 'Blue',
  `custom` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocument Follow`
--

DROP TABLE IF EXISTS `tabDocument Follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocument Follow` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `ref_doctype` varchar(140) DEFAULT NULL,
  `ref_docname` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `ref_doctype` (`ref_doctype`),
  KEY `ref_docname` (`ref_docname`),
  KEY `user` (`user`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocument Naming Rule`
--

DROP TABLE IF EXISTS `tabDocument Naming Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocument Naming Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `priority` int(11) NOT NULL DEFAULT 0,
  `prefix` varchar(140) DEFAULT NULL,
  `counter` int(11) NOT NULL DEFAULT 0,
  `prefix_digits` int(11) NOT NULL DEFAULT 5,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocument Naming Rule Condition`
--

DROP TABLE IF EXISTS `tabDocument Naming Rule Condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocument Naming Rule Condition` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `field` varchar(140) DEFAULT NULL,
  `condition` varchar(140) DEFAULT NULL,
  `value` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDocument Share Key`
--

DROP TABLE IF EXISTS `tabDocument Share Key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDocument Share Key` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_docname` varchar(140) DEFAULT NULL,
  `key` varchar(140) DEFAULT NULL,
  `expires_on` date DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_doctype` (`reference_doctype`),
  KEY `reference_docname` (`reference_docname`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDomain`
--

DROP TABLE IF EXISTS `tabDomain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDomain` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `domain` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `domain` (`domain`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDowntime Entry`
--

DROP TABLE IF EXISTS `tabDowntime Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDowntime Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `workstation` varchar(140) DEFAULT NULL,
  `operator` varchar(140) DEFAULT NULL,
  `from_time` datetime(6) DEFAULT NULL,
  `to_time` datetime(6) DEFAULT NULL,
  `downtime` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stop_reason` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDriver`
--

DROP TABLE IF EXISTS `tabDriver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDriver` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `transporter` varchar(140) DEFAULT NULL,
  `employee` varchar(140) DEFAULT NULL,
  `cell_number` varchar(140) DEFAULT NULL,
  `address` varchar(140) DEFAULT NULL,
  `license_number` varchar(140) DEFAULT NULL,
  `issuing_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDriving License Category`
--

DROP TABLE IF EXISTS `tabDriving License Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDriving License Category` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `class` varchar(140) DEFAULT NULL,
  `description` varchar(140) DEFAULT NULL,
  `issuing_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDunning`
--

DROP TABLE IF EXISTS `tabDunning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDunning` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT 'DUNN-.MM.-.YY.-',
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Unresolved',
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `dunning_type` varchar(140) DEFAULT NULL,
  `rate_of_interest` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_interest` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `dunning_fee` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `dunning_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_dunning_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `spacer` varchar(140) DEFAULT NULL,
  `total_outstanding` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `language` varchar(140) DEFAULT NULL,
  `body_text` longtext DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `closing_text` longtext DEFAULT NULL,
  `income_account` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `company_address` varchar(140) DEFAULT NULL,
  `company_address_display` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDunning Letter Text`
--

DROP TABLE IF EXISTS `tabDunning Letter Text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDunning Letter Text` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `language` varchar(140) DEFAULT NULL,
  `is_default_language` int(1) NOT NULL DEFAULT 0,
  `body_text` longtext DEFAULT NULL,
  `closing_text` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDunning Type`
--

DROP TABLE IF EXISTS `tabDunning Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDunning Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `dunning_type` varchar(140) DEFAULT NULL,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `dunning_fee` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_of_interest` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `income_account` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `dunning_type` (`dunning_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabDynamic Link`
--

DROP TABLE IF EXISTS `tabDynamic Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabDynamic Link` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `link_doctype` varchar(140) DEFAULT NULL,
  `link_name` varchar(140) DEFAULT NULL,
  `link_title` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`),
  KEY `link_doctype_link_name_index` (`link_doctype`,`link_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Account`
--

DROP TABLE IF EXISTS `tabEmail Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_id` varchar(140) DEFAULT NULL,
  `email_account_name` varchar(140) DEFAULT NULL,
  `domain` varchar(140) DEFAULT NULL,
  `service` varchar(140) DEFAULT NULL,
  `auth_method` varchar(140) DEFAULT 'Basic',
  `password` text DEFAULT NULL,
  `awaiting_password` int(1) NOT NULL DEFAULT 0,
  `ascii_encode_password` int(1) NOT NULL DEFAULT 0,
  `connected_app` varchar(140) DEFAULT NULL,
  `connected_user` varchar(140) DEFAULT NULL,
  `login_id_is_different` int(1) NOT NULL DEFAULT 0,
  `login_id` varchar(140) DEFAULT NULL,
  `enable_incoming` int(1) NOT NULL DEFAULT 0,
  `default_incoming` int(1) NOT NULL DEFAULT 0,
  `use_imap` int(1) NOT NULL DEFAULT 0,
  `use_ssl` int(1) NOT NULL DEFAULT 0,
  `use_starttls` int(1) NOT NULL DEFAULT 0,
  `email_server` varchar(140) DEFAULT NULL,
  `incoming_port` varchar(140) DEFAULT NULL,
  `attachment_limit` int(11) NOT NULL DEFAULT 0,
  `email_sync_option` varchar(140) DEFAULT 'UNSEEN',
  `initial_sync_count` varchar(140) DEFAULT '250',
  `append_emails_to_sent_folder` int(1) NOT NULL DEFAULT 0,
  `append_to` varchar(140) DEFAULT NULL,
  `create_contact` int(1) NOT NULL DEFAULT 1,
  `enable_automatic_linking` int(1) NOT NULL DEFAULT 0,
  `notify_if_unreplied` int(1) NOT NULL DEFAULT 0,
  `unreplied_for_mins` int(11) NOT NULL DEFAULT 30,
  `send_notification_to` text DEFAULT NULL,
  `enable_outgoing` int(1) NOT NULL DEFAULT 0,
  `use_tls` int(1) NOT NULL DEFAULT 0,
  `use_ssl_for_outgoing` int(1) NOT NULL DEFAULT 0,
  `smtp_server` varchar(140) DEFAULT NULL,
  `smtp_port` varchar(140) DEFAULT NULL,
  `default_outgoing` int(1) NOT NULL DEFAULT 0,
  `always_use_account_email_id_as_sender` int(1) NOT NULL DEFAULT 0,
  `always_use_account_name_as_sender_name` int(1) NOT NULL DEFAULT 0,
  `send_unsubscribe_message` int(1) NOT NULL DEFAULT 1,
  `track_email_status` int(1) NOT NULL DEFAULT 1,
  `no_smtp_authentication` int(1) NOT NULL DEFAULT 0,
  `add_signature` int(1) NOT NULL DEFAULT 0,
  `signature` longtext DEFAULT NULL,
  `enable_auto_reply` int(1) NOT NULL DEFAULT 0,
  `auto_reply_message` longtext DEFAULT NULL,
  `footer` longtext DEFAULT NULL,
  `brand_logo` text DEFAULT NULL,
  `uidvalidity` varchar(140) DEFAULT NULL,
  `uidnext` int(11) NOT NULL DEFAULT 0,
  `no_failed` int(11) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `backend_app_flow` int(1) NOT NULL DEFAULT 0,
  `sent_folder_name` varchar(140) DEFAULT NULL,
  `always_bcc` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `email_id` (`email_id`),
  UNIQUE KEY `email_account_name` (`email_account_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Campaign`
--

DROP TABLE IF EXISTS `tabEmail Campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Campaign` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `campaign_name` varchar(140) DEFAULT NULL,
  `email_campaign_for` varchar(140) DEFAULT 'Lead',
  `recipient` varchar(140) DEFAULT NULL,
  `sender` varchar(140) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Digest`
--

DROP TABLE IF EXISTS `tabEmail Digest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Digest` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `frequency` varchar(140) DEFAULT NULL,
  `next_send` varchar(140) DEFAULT NULL,
  `income` int(1) NOT NULL DEFAULT 0,
  `expenses_booked` int(1) NOT NULL DEFAULT 0,
  `income_year_to_date` int(1) NOT NULL DEFAULT 0,
  `expense_year_to_date` int(1) NOT NULL DEFAULT 0,
  `bank_balance` int(1) NOT NULL DEFAULT 0,
  `credit_balance` int(1) NOT NULL DEFAULT 0,
  `invoiced_amount` int(1) NOT NULL DEFAULT 0,
  `payables` int(1) NOT NULL DEFAULT 0,
  `sales_orders_to_bill` int(1) NOT NULL DEFAULT 0,
  `purchase_orders_to_bill` int(1) NOT NULL DEFAULT 0,
  `sales_order` int(1) NOT NULL DEFAULT 0,
  `purchase_order` int(1) NOT NULL DEFAULT 0,
  `sales_orders_to_deliver` int(1) NOT NULL DEFAULT 0,
  `purchase_orders_to_receive` int(1) NOT NULL DEFAULT 0,
  `sales_invoice` int(1) NOT NULL DEFAULT 0,
  `purchase_invoice` int(1) NOT NULL DEFAULT 0,
  `new_quotations` int(1) NOT NULL DEFAULT 0,
  `pending_quotations` int(1) NOT NULL DEFAULT 0,
  `issue` int(1) NOT NULL DEFAULT 0,
  `project` int(1) NOT NULL DEFAULT 0,
  `purchase_orders_items_overdue` int(1) NOT NULL DEFAULT 0,
  `calendar_events` int(1) NOT NULL DEFAULT 0,
  `todo_list` int(1) NOT NULL DEFAULT 0,
  `notifications` int(1) NOT NULL DEFAULT 0,
  `add_quote` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Digest Recipient`
--

DROP TABLE IF EXISTS `tabEmail Digest Recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Digest Recipient` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `recipient` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Domain`
--

DROP TABLE IF EXISTS `tabEmail Domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Domain` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `domain_name` varchar(140) DEFAULT NULL,
  `email_server` varchar(140) DEFAULT NULL,
  `use_imap` int(1) NOT NULL DEFAULT 0,
  `use_ssl` int(1) NOT NULL DEFAULT 0,
  `use_starttls` int(1) NOT NULL DEFAULT 0,
  `incoming_port` varchar(140) DEFAULT NULL,
  `attachment_limit` int(11) NOT NULL DEFAULT 0,
  `smtp_server` varchar(140) DEFAULT NULL,
  `use_tls` int(1) NOT NULL DEFAULT 0,
  `use_ssl_for_outgoing` int(1) NOT NULL DEFAULT 0,
  `smtp_port` varchar(140) DEFAULT NULL,
  `append_emails_to_sent_folder` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `sent_folder_name` varchar(140) DEFAULT 'Sent',
  PRIMARY KEY (`name`),
  UNIQUE KEY `domain_name` (`domain_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Flag Queue`
--

DROP TABLE IF EXISTS `tabEmail Flag Queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Flag Queue` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_completed` int(1) NOT NULL DEFAULT 0,
  `communication` varchar(140) DEFAULT NULL,
  `action` varchar(140) DEFAULT NULL,
  `email_account` varchar(140) DEFAULT NULL,
  `uid` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Group`
--

DROP TABLE IF EXISTS `tabEmail Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `total_subscribers` int(11) NOT NULL DEFAULT 0,
  `confirmation_email_template` varchar(140) DEFAULT NULL,
  `welcome_email_template` varchar(140) DEFAULT NULL,
  `welcome_url` varchar(140) DEFAULT NULL,
  `add_query_parameters` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `title` (`title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Group Member`
--

DROP TABLE IF EXISTS `tabEmail Group Member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Group Member` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_group` varchar(140) DEFAULT NULL,
  `email` varchar(140) DEFAULT NULL,
  `unsubscribed` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `unique_email_group_email` (`email_group`,`email`),
  KEY `email_group` (`email_group`),
  KEY `unsubscribed` (`unsubscribed`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Queue`
--

DROP TABLE IF EXISTS `tabEmail Queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Queue` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sender` varchar(140) DEFAULT NULL,
  `show_as_cc` text DEFAULT NULL,
  `message` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Not Sent',
  `error` longtext DEFAULT NULL,
  `message_id` text DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `communication` varchar(140) DEFAULT NULL,
  `send_after` datetime(6) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 1,
  `add_unsubscribe_link` int(1) NOT NULL DEFAULT 1,
  `unsubscribe_param` varchar(140) DEFAULT NULL,
  `unsubscribe_method` varchar(140) DEFAULT NULL,
  `expose_recipients` varchar(140) DEFAULT NULL,
  `attachments` longtext DEFAULT NULL,
  `retry` int(11) NOT NULL DEFAULT 0,
  `email_account` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_name` (`reference_name`),
  KEY `communication` (`communication`),
  KEY `modified` (`modified`),
  KEY `index_bulk_flush` (`status`,`send_after`,`priority`,`creation`),
  KEY `message_id_index` (`message_id`(140))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Queue Recipient`
--

DROP TABLE IF EXISTS `tabEmail Queue Recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Queue Recipient` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `recipient` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Not Sent',
  `error` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `status` (`status`),
  KEY `parent` (`parent`),
  KEY `modified_index` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Rule`
--

DROP TABLE IF EXISTS `tabEmail Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_id` varchar(140) DEFAULT NULL,
  `is_spam` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `email_id` (`email_id`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Template`
--

DROP TABLE IF EXISTS `tabEmail Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `subject` varchar(140) DEFAULT NULL,
  `use_html` int(1) NOT NULL DEFAULT 0,
  `response_html` longtext DEFAULT NULL,
  `response` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmail Unsubscribe`
--

DROP TABLE IF EXISTS `tabEmail Unsubscribe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmail Unsubscribe` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `global_unsubscribe` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `email` (`email`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmployee`
--

DROP TABLE IF EXISTS `tabEmployee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmployee` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `employee` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `first_name` varchar(140) DEFAULT NULL,
  `middle_name` varchar(140) DEFAULT NULL,
  `last_name` varchar(140) DEFAULT NULL,
  `employee_name` varchar(140) DEFAULT NULL,
  `gender` varchar(140) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `salutation` varchar(140) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  `image` text DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Active',
  `user_id` varchar(140) DEFAULT NULL,
  `create_user_permission` int(1) NOT NULL DEFAULT 1,
  `company` varchar(140) DEFAULT NULL,
  `department` varchar(140) DEFAULT NULL,
  `employee_number` varchar(140) DEFAULT NULL,
  `designation` varchar(140) DEFAULT NULL,
  `reports_to` varchar(140) DEFAULT NULL,
  `branch` varchar(140) DEFAULT NULL,
  `scheduled_confirmation_date` date DEFAULT NULL,
  `final_confirmation_date` date DEFAULT NULL,
  `contract_end_date` date DEFAULT NULL,
  `notice_number_of_days` int(11) NOT NULL DEFAULT 0,
  `date_of_retirement` date DEFAULT NULL,
  `cell_number` varchar(140) DEFAULT NULL,
  `personal_email` varchar(140) DEFAULT NULL,
  `company_email` varchar(140) DEFAULT NULL,
  `prefered_contact_email` varchar(140) DEFAULT NULL,
  `prefered_email` varchar(140) DEFAULT NULL,
  `unsubscribed` int(1) NOT NULL DEFAULT 0,
  `current_address` text DEFAULT NULL,
  `current_accommodation_type` varchar(140) DEFAULT NULL,
  `permanent_address` text DEFAULT NULL,
  `permanent_accommodation_type` varchar(140) DEFAULT NULL,
  `person_to_be_contacted` varchar(140) DEFAULT NULL,
  `emergency_phone_number` varchar(140) DEFAULT NULL,
  `relation` varchar(140) DEFAULT NULL,
  `attendance_device_id` varchar(140) DEFAULT NULL,
  `holiday_list` varchar(140) DEFAULT NULL,
  `ctc` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `salary_currency` varchar(140) DEFAULT NULL,
  `salary_mode` varchar(140) DEFAULT NULL,
  `bank_name` varchar(140) DEFAULT NULL,
  `bank_ac_no` varchar(140) DEFAULT NULL,
  `iban` varchar(140) DEFAULT NULL,
  `marital_status` varchar(140) DEFAULT NULL,
  `family_background` text DEFAULT NULL,
  `blood_group` varchar(140) DEFAULT NULL,
  `health_details` text DEFAULT NULL,
  `passport_number` varchar(140) DEFAULT NULL,
  `valid_upto` date DEFAULT NULL,
  `date_of_issue` date DEFAULT NULL,
  `place_of_issue` varchar(140) DEFAULT NULL,
  `bio` longtext DEFAULT NULL,
  `resignation_letter_date` date DEFAULT NULL,
  `relieving_date` date DEFAULT NULL,
  `held_on` date DEFAULT NULL,
  `new_workplace` varchar(140) DEFAULT NULL,
  `leave_encashed` varchar(140) DEFAULT NULL,
  `encashment_date` date DEFAULT NULL,
  `reason_for_leaving` text DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `attendance_device_id` (`attendance_device_id`),
  KEY `status` (`status`),
  KEY `designation` (`designation`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmployee Education`
--

DROP TABLE IF EXISTS `tabEmployee Education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmployee Education` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `school_univ` text DEFAULT NULL,
  `qualification` varchar(140) DEFAULT NULL,
  `level` varchar(140) DEFAULT NULL,
  `year_of_passing` int(11) NOT NULL DEFAULT 0,
  `class_per` varchar(140) DEFAULT NULL,
  `maj_opt_subj` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmployee External Work History`
--

DROP TABLE IF EXISTS `tabEmployee External Work History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmployee External Work History` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company_name` varchar(140) DEFAULT NULL,
  `designation` varchar(140) DEFAULT NULL,
  `salary` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `address` text DEFAULT NULL,
  `contact` varchar(140) DEFAULT NULL,
  `total_experience` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmployee Group`
--

DROP TABLE IF EXISTS `tabEmployee Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmployee Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `employee_group_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `employee_group_name` (`employee_group_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmployee Group Table`
--

DROP TABLE IF EXISTS `tabEmployee Group Table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmployee Group Table` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `employee` varchar(140) DEFAULT NULL,
  `employee_name` varchar(140) DEFAULT NULL,
  `user_id` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEmployee Internal Work History`
--

DROP TABLE IF EXISTS `tabEmployee Internal Work History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEmployee Internal Work History` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `branch` varchar(140) DEFAULT NULL,
  `department` varchar(140) DEFAULT NULL,
  `designation` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEnergy Point Log`
--

DROP TABLE IF EXISTS `tabEnergy Point Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEnergy Point Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `rule` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `reverted` int(1) NOT NULL DEFAULT 0,
  `revert_of` varchar(140) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `seen` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `user` (`user`),
  KEY `reference_name` (`reference_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEnergy Point Rule`
--

DROP TABLE IF EXISTS `tabEnergy Point Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEnergy Point Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `rule_name` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `for_doc_event` varchar(140) DEFAULT 'Custom',
  `field_to_check` varchar(140) DEFAULT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `for_assigned_users` int(1) NOT NULL DEFAULT 0,
  `user_field` varchar(140) DEFAULT NULL,
  `multiplier_field` varchar(140) DEFAULT NULL,
  `max_points` int(11) NOT NULL DEFAULT 0,
  `apply_only_once` int(1) NOT NULL DEFAULT 0,
  `condition` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `rule_name` (`rule_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabError Log`
--

DROP TABLE IF EXISTS `tabError Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabError Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `seen` int(1) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `method` varchar(140) DEFAULT NULL,
  `error` longtext DEFAULT NULL,
  `trace_id` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_doctype` (`reference_doctype`),
  KEY `modified` (`modified`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEvent`
--

DROP TABLE IF EXISTS `tabEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEvent` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `subject` text DEFAULT NULL,
  `event_category` varchar(140) DEFAULT NULL,
  `event_type` varchar(140) DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `send_reminder` int(1) NOT NULL DEFAULT 1,
  `repeat_this_event` int(1) NOT NULL DEFAULT 0,
  `starts_on` datetime(6) DEFAULT NULL,
  `ends_on` datetime(6) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Open',
  `sender` varchar(140) DEFAULT NULL,
  `all_day` int(1) NOT NULL DEFAULT 0,
  `sync_with_google_calendar` int(1) NOT NULL DEFAULT 0,
  `add_video_conferencing` int(1) NOT NULL DEFAULT 0,
  `google_calendar` varchar(140) DEFAULT NULL,
  `google_calendar_id` varchar(140) DEFAULT NULL,
  `google_calendar_event_id` varchar(320) DEFAULT NULL,
  `google_meet_link` text DEFAULT NULL,
  `pulled_from_google_calendar` int(1) NOT NULL DEFAULT 0,
  `repeat_on` varchar(140) DEFAULT NULL,
  `repeat_till` date DEFAULT NULL,
  `monday` int(1) NOT NULL DEFAULT 0,
  `tuesday` int(1) NOT NULL DEFAULT 0,
  `wednesday` int(1) NOT NULL DEFAULT 0,
  `thursday` int(1) NOT NULL DEFAULT 0,
  `friday` int(1) NOT NULL DEFAULT 0,
  `saturday` int(1) NOT NULL DEFAULT 0,
  `sunday` int(1) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `event_type` (`event_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabEvent Participants`
--

DROP TABLE IF EXISTS `tabEvent Participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabEvent Participants` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_docname` varchar(140) DEFAULT NULL,
  `email` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabExchange Rate Revaluation`
--

DROP TABLE IF EXISTS `tabExchange Rate Revaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabExchange Rate Revaluation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `posting_date` date DEFAULT NULL,
  `rounding_loss_allowance` decimal(21,9) NOT NULL DEFAULT 0.050000000,
  `company` varchar(140) DEFAULT NULL,
  `gain_loss_unbooked` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `gain_loss_booked` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_gain_loss` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabExchange Rate Revaluation Account`
--

DROP TABLE IF EXISTS `tabExchange Rate Revaluation Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabExchange Rate Revaluation Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `account_currency` varchar(140) DEFAULT NULL,
  `balance_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `new_balance_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `current_exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `new_exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `balance_in_base_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `new_balance_in_base_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `gain_loss` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `zero_balance` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabFile`
--

DROP TABLE IF EXISTS `tabFile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabFile` (
  `name` varchar(255) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(255) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(255) DEFAULT NULL,
  `parentfield` varchar(255) DEFAULT NULL,
  `parenttype` varchar(255) DEFAULT NULL,
  `idx` int(8) NOT NULL DEFAULT 0,
  `file_name` varchar(140) DEFAULT NULL,
  `file_url` longtext DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `attached_to_name` varchar(140) DEFAULT NULL,
  `file_size` bigint(20) NOT NULL DEFAULT 0,
  `attached_to_doctype` varchar(140) DEFAULT NULL,
  `is_private` int(1) NOT NULL DEFAULT 0,
  `file_type` varchar(140) DEFAULT NULL,
  `is_home_folder` int(1) NOT NULL DEFAULT 0,
  `is_attachments_folder` int(1) NOT NULL DEFAULT 0,
  `thumbnail_url` text DEFAULT NULL,
  `folder` varchar(255) DEFAULT NULL,
  `is_folder` int(1) NOT NULL DEFAULT 0,
  `attached_to_field` varchar(140) DEFAULT NULL,
  `old_parent` varchar(140) DEFAULT NULL,
  `content_hash` varchar(140) DEFAULT NULL,
  `uploaded_to_dropbox` int(1) NOT NULL DEFAULT 0,
  `uploaded_to_google_drive` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`),
  KEY `attached_to_doctype_attached_to_name_index` (`attached_to_doctype`,`attached_to_name`),
  KEY `file_url_index` (`file_url`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabFinance Book`
--

DROP TABLE IF EXISTS `tabFinance Book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabFinance Book` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `finance_book_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabFiscal Year`
--

DROP TABLE IF EXISTS `tabFiscal Year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabFiscal Year` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `year` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `is_short_year` int(1) NOT NULL DEFAULT 0,
  `year_start_date` date DEFAULT NULL,
  `year_end_date` date DEFAULT NULL,
  `auto_created` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `year` (`year`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabFiscal Year Company`
--

DROP TABLE IF EXISTS `tabFiscal Year Company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabFiscal Year Company` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabForm Tour`
--

DROP TABLE IF EXISTS `tabForm Tour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabForm Tour` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `view_name` varchar(140) DEFAULT NULL,
  `workspace_name` varchar(140) DEFAULT NULL,
  `list_name` varchar(140) DEFAULT 'List',
  `report_name` varchar(140) DEFAULT NULL,
  `dashboard_name` varchar(140) DEFAULT NULL,
  `new_document_form` int(1) NOT NULL DEFAULT 0,
  `page_name` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `ui_tour` int(1) NOT NULL DEFAULT 0,
  `track_steps` int(1) NOT NULL DEFAULT 0,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `save_on_complete` int(1) NOT NULL DEFAULT 0,
  `first_document` int(1) NOT NULL DEFAULT 0,
  `include_name_field` int(1) NOT NULL DEFAULT 0,
  `page_route` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `title` (`title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabForm Tour Step`
--

DROP TABLE IF EXISTS `tabForm Tour Step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabForm Tour Step` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `ui_tour` int(1) NOT NULL DEFAULT 0,
  `is_table_field` int(1) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `parent_fieldname` varchar(140) DEFAULT NULL,
  `fieldname` varchar(140) DEFAULT NULL,
  `element_selector` varchar(140) DEFAULT NULL,
  `parent_element_selector` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `ondemand_description` longtext DEFAULT NULL,
  `position` varchar(140) DEFAULT 'Bottom',
  `hide_buttons` int(1) NOT NULL DEFAULT 0,
  `popover_element` int(1) NOT NULL DEFAULT 0,
  `modal_trigger` int(1) NOT NULL DEFAULT 0,
  `offset_x` int(11) NOT NULL DEFAULT 0,
  `offset_y` int(11) NOT NULL DEFAULT 0,
  `next_on_click` int(1) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT '0',
  `has_next_condition` int(1) NOT NULL DEFAULT 0,
  `next_step_condition` longtext DEFAULT NULL,
  `next_form_tour` varchar(140) DEFAULT NULL,
  `child_doctype` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabGL Entry`
--

DROP TABLE IF EXISTS `tabGL Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabGL Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `posting_date` date DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `fiscal_year` varchar(140) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `account_currency` varchar(140) DEFAULT NULL,
  `against` text DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `voucher_subtype` text DEFAULT NULL,
  `transaction_currency` varchar(140) DEFAULT NULL,
  `against_voucher_type` varchar(140) DEFAULT NULL,
  `against_voucher` varchar(140) DEFAULT NULL,
  `voucher_detail_no` varchar(140) DEFAULT NULL,
  `transaction_exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `debit_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `debit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `debit_in_transaction_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `credit_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `credit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `credit_in_transaction_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `is_opening` varchar(140) DEFAULT NULL,
  `is_advance` varchar(140) DEFAULT NULL,
  `to_rename` int(1) NOT NULL DEFAULT 1,
  `is_cancelled` int(1) NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `posting_date` (`posting_date`),
  KEY `account` (`account`),
  KEY `party_type` (`party_type`),
  KEY `party` (`party`),
  KEY `voucher_no` (`voucher_no`),
  KEY `against_voucher` (`against_voucher`),
  KEY `voucher_detail_no` (`voucher_detail_no`),
  KEY `company` (`company`),
  KEY `to_rename` (`to_rename`),
  KEY `modified` (`modified`),
  KEY `voucher_type_voucher_no_index` (`voucher_type`,`voucher_no`),
  KEY `posting_date_company_index` (`posting_date`,`company`),
  KEY `party_type_party_index` (`party_type`,`party`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabGender`
--

DROP TABLE IF EXISTS `tabGender`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabGender` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `gender` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `gender` (`gender`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabGlobal Search DocType`
--

DROP TABLE IF EXISTS `tabGlobal Search DocType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabGlobal Search DocType` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabGoogle Calendar`
--

DROP TABLE IF EXISTS `tabGoogle Calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabGoogle Calendar` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enable` int(1) NOT NULL DEFAULT 1,
  `calendar_name` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `pull_from_google_calendar` int(1) NOT NULL DEFAULT 1,
  `push_to_google_calendar` int(1) NOT NULL DEFAULT 1,
  `google_calendar_id` varchar(140) DEFAULT NULL,
  `refresh_token` text DEFAULT NULL,
  `authorization_code` text DEFAULT NULL,
  `next_sync_token` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `sync_as_public` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  UNIQUE KEY `calendar_name` (`calendar_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabGoogle Contacts`
--

DROP TABLE IF EXISTS `tabGoogle Contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabGoogle Contacts` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enable` int(1) NOT NULL DEFAULT 0,
  `email_id` varchar(140) DEFAULT NULL,
  `last_sync_on` datetime(6) DEFAULT NULL,
  `authorization_code` text DEFAULT NULL,
  `refresh_token` text DEFAULT NULL,
  `next_sync_token` text DEFAULT NULL,
  `pull_from_google_contacts` int(1) NOT NULL DEFAULT 0,
  `push_to_google_contacts` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabHas Domain`
--

DROP TABLE IF EXISTS `tabHas Domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabHas Domain` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `domain` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabHas Role`
--

DROP TABLE IF EXISTS `tabHas Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabHas Role` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `role` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabHelp Article`
--

DROP TABLE IF EXISTS `tabHelp Article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabHelp Article` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `category` varchar(140) DEFAULT NULL,
  `published` int(1) NOT NULL DEFAULT 0,
  `author` varchar(140) DEFAULT 'user_fullname',
  `level` varchar(140) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `likes` int(11) NOT NULL DEFAULT 0,
  `route` varchar(140) DEFAULT NULL,
  `helpful` int(11) NOT NULL DEFAULT 0,
  `not_helpful` int(11) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabHelp Category`
--

DROP TABLE IF EXISTS `tabHelp Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabHelp Category` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `category_name` varchar(140) DEFAULT NULL,
  `category_description` text DEFAULT NULL,
  `published` int(1) NOT NULL DEFAULT 0,
  `help_articles` int(11) NOT NULL DEFAULT 0,
  `route` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabHoliday`
--

DROP TABLE IF EXISTS `tabHoliday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabHoliday` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `holiday_date` date DEFAULT NULL,
  `weekly_off` int(1) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabHoliday List`
--

DROP TABLE IF EXISTS `tabHoliday List`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabHoliday List` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `holiday_list_name` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `total_holidays` int(11) NOT NULL DEFAULT 0,
  `weekly_off` varchar(140) DEFAULT NULL,
  `country` varchar(140) DEFAULT NULL,
  `subdivision` varchar(140) DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `holiday_list_name` (`holiday_list_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabHomepage Section`
--

DROP TABLE IF EXISTS `tabHomepage Section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabHomepage Section` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `section_based_on` varchar(140) DEFAULT NULL,
  `no_of_columns` varchar(140) DEFAULT '3',
  `section_html` longtext DEFAULT NULL,
  `section_order` int(11) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabHomepage Section Card`
--

DROP TABLE IF EXISTS `tabHomepage Section Card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabHomepage Section Card` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `subtitle` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `content` text DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIMAP Folder`
--

DROP TABLE IF EXISTS `tabIMAP Folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIMAP Folder` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `folder_name` varchar(140) DEFAULT NULL,
  `append_to` varchar(140) DEFAULT NULL,
  `uidvalidity` varchar(140) DEFAULT NULL,
  `uidnext` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabImport Supplier Invoice`
--

DROP TABLE IF EXISTS `tabImport Supplier Invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabImport Supplier Invoice` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `invoice_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `supplier_group` varchar(140) DEFAULT NULL,
  `tax_account` varchar(140) DEFAULT NULL,
  `default_buying_price_list` varchar(140) DEFAULT NULL,
  `zip_file` text DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIncoming Call Handling Schedule`
--

DROP TABLE IF EXISTS `tabIncoming Call Handling Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIncoming Call Handling Schedule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `day_of_week` varchar(140) DEFAULT NULL,
  `from_time` time(6) DEFAULT '09:00:00.000000',
  `to_time` time(6) DEFAULT '17:00:00.000000',
  `agent_group` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIncoming Call Settings`
--

DROP TABLE IF EXISTS `tabIncoming Call Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIncoming Call Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `call_routing` varchar(140) DEFAULT 'Sequential',
  `greeting_message` varchar(140) DEFAULT NULL,
  `agent_busy_message` varchar(140) DEFAULT NULL,
  `agent_unavailable_message` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIncoterm`
--

DROP TABLE IF EXISTS `tabIncoterm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIncoterm` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `code` varchar(3) DEFAULT NULL,
  `title` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `code` (`code`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIndustry Type`
--

DROP TABLE IF EXISTS `tabIndustry Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIndustry Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `industry` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `industry` (`industry`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabInstallation Note`
--

DROP TABLE IF EXISTS `tabInstallation Note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabInstallation Note` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `inst_date` date DEFAULT NULL,
  `inst_time` time(6) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `company` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer` (`customer`),
  KEY `territory` (`territory`),
  KEY `inst_date` (`inst_date`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabInstallation Note Item`
--

DROP TABLE IF EXISTS `tabInstallation Note Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabInstallation Note Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` longtext DEFAULT NULL,
  `prevdoc_detail_docname` varchar(140) DEFAULT NULL,
  `prevdoc_docname` varchar(140) DEFAULT NULL,
  `prevdoc_doctype` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `prevdoc_docname` (`prevdoc_docname`),
  KEY `prevdoc_doctype` (`prevdoc_doctype`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabInstalled Application`
--

DROP TABLE IF EXISTS `tabInstalled Application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabInstalled Application` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `app_name` varchar(140) DEFAULT NULL,
  `app_version` varchar(140) DEFAULT NULL,
  `git_branch` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  `has_setup_wizard` int(1) NOT NULL DEFAULT 0,
  `is_setup_complete` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIntegration Request`
--

DROP TABLE IF EXISTS `tabIntegration Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIntegration Request` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `request_id` varchar(140) DEFAULT NULL,
  `integration_request_service` varchar(140) DEFAULT NULL,
  `is_remote_request` int(1) NOT NULL DEFAULT 0,
  `request_description` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Queued',
  `url` text DEFAULT NULL,
  `request_headers` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `output` longtext DEFAULT NULL,
  `error` longtext DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_docname` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabInventory Dimension`
--

DROP TABLE IF EXISTS `tabInventory Dimension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabInventory Dimension` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `dimension_name` varchar(140) DEFAULT NULL,
  `reference_document` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `source_fieldname` varchar(140) DEFAULT NULL,
  `target_fieldname` varchar(140) DEFAULT NULL,
  `apply_to_all_doctypes` int(1) NOT NULL DEFAULT 1,
  `validate_negative_stock` int(1) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `type_of_transaction` varchar(140) DEFAULT NULL,
  `fetch_from_parent` varchar(140) DEFAULT NULL,
  `istable` int(1) NOT NULL DEFAULT 0,
  `condition` longtext DEFAULT NULL,
  `reqd` int(1) NOT NULL DEFAULT 0,
  `mandatory_depends_on` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `dimension_name` (`dimension_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabInvoice Discounting`
--

DROP TABLE IF EXISTS `tabInvoice Discounting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabInvoice Discounting` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `posting_date` date DEFAULT NULL,
  `loan_start_date` date DEFAULT NULL,
  `loan_period` int(11) NOT NULL DEFAULT 0,
  `loan_end_date` date DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `total_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `bank_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `short_term_loan` varchar(140) DEFAULT NULL,
  `bank_account` varchar(140) DEFAULT NULL,
  `bank_charges_account` varchar(140) DEFAULT NULL,
  `accounts_receivable_credit` varchar(140) DEFAULT NULL,
  `accounts_receivable_discounted` varchar(140) DEFAULT NULL,
  `accounts_receivable_unpaid` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIssue`
--

DROP TABLE IF EXISTS `tabIssue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIssue` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `subject` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `raised_by` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Open',
  `priority` varchar(140) DEFAULT NULL,
  `issue_type` varchar(140) DEFAULT NULL,
  `issue_split_from` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `service_level_agreement` varchar(140) DEFAULT NULL,
  `response_by` datetime(6) DEFAULT NULL,
  `agreement_status` varchar(140) DEFAULT 'First Response Due',
  `sla_resolution_by` datetime(6) DEFAULT NULL,
  `service_level_agreement_creation` datetime(6) DEFAULT NULL,
  `on_hold_since` datetime(6) DEFAULT NULL,
  `total_hold_time` decimal(21,9) DEFAULT NULL,
  `first_response_time` decimal(21,9) DEFAULT NULL,
  `first_responded_on` datetime(6) DEFAULT NULL,
  `avg_response_time` decimal(21,9) DEFAULT NULL,
  `resolution_details` longtext DEFAULT NULL,
  `opening_date` date DEFAULT NULL,
  `opening_time` time(6) DEFAULT NULL,
  `sla_resolution_date` datetime(6) DEFAULT NULL,
  `resolution_time` decimal(21,9) DEFAULT NULL,
  `user_resolution_time` decimal(21,9) DEFAULT NULL,
  `lead` varchar(140) DEFAULT NULL,
  `contact` varchar(140) DEFAULT NULL,
  `email_account` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `via_customer_portal` int(1) NOT NULL DEFAULT 0,
  `attachment` text DEFAULT NULL,
  `content_type` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer` (`customer`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIssue Priority`
--

DROP TABLE IF EXISTS `tabIssue Priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIssue Priority` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabIssue Type`
--

DROP TABLE IF EXISTS `tabIssue Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabIssue Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem`
--

DROP TABLE IF EXISTS `tabItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `allow_alternative_item` int(1) NOT NULL DEFAULT 0,
  `is_stock_item` int(1) NOT NULL DEFAULT 1,
  `has_variants` int(1) NOT NULL DEFAULT 0,
  `opening_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `standard_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `auto_create_assets` int(1) NOT NULL DEFAULT 0,
  `is_grouped_asset` int(1) NOT NULL DEFAULT 0,
  `asset_category` varchar(140) DEFAULT NULL,
  `asset_naming_series` varchar(140) DEFAULT NULL,
  `over_delivery_receipt_allowance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `over_billing_allowance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `image` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `shelf_life_in_days` int(11) NOT NULL DEFAULT 0,
  `end_of_life` date DEFAULT '2099-12-31',
  `default_material_request_type` varchar(140) DEFAULT 'Purchase',
  `valuation_method` varchar(140) DEFAULT NULL,
  `warranty_period` varchar(140) DEFAULT NULL,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `allow_negative_stock` int(1) NOT NULL DEFAULT 0,
  `has_batch_no` int(1) NOT NULL DEFAULT 0,
  `create_new_batch` int(1) NOT NULL DEFAULT 0,
  `batch_number_series` varchar(140) DEFAULT NULL,
  `has_expiry_date` int(1) NOT NULL DEFAULT 0,
  `retain_sample` int(1) NOT NULL DEFAULT 0,
  `sample_quantity` int(11) NOT NULL DEFAULT 0,
  `has_serial_no` int(1) NOT NULL DEFAULT 0,
  `serial_no_series` varchar(140) DEFAULT NULL,
  `variant_of` varchar(140) DEFAULT NULL,
  `variant_based_on` varchar(140) DEFAULT 'Item Attribute',
  `enable_deferred_expense` int(1) NOT NULL DEFAULT 0,
  `no_of_months_exp` int(11) NOT NULL DEFAULT 0,
  `enable_deferred_revenue` int(1) NOT NULL DEFAULT 0,
  `no_of_months` int(11) NOT NULL DEFAULT 0,
  `purchase_uom` varchar(140) DEFAULT NULL,
  `min_order_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `safety_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_purchase_item` int(1) NOT NULL DEFAULT 1,
  `lead_time_days` int(11) NOT NULL DEFAULT 0,
  `last_purchase_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_customer_provided_item` int(1) NOT NULL DEFAULT 0,
  `customer` varchar(140) DEFAULT NULL,
  `delivered_by_supplier` int(1) NOT NULL DEFAULT 0,
  `country_of_origin` varchar(140) DEFAULT NULL,
  `customs_tariff_number` varchar(140) DEFAULT NULL,
  `sales_uom` varchar(140) DEFAULT NULL,
  `grant_commission` int(1) NOT NULL DEFAULT 1,
  `is_sales_item` int(1) NOT NULL DEFAULT 1,
  `max_discount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `inspection_required_before_purchase` int(1) NOT NULL DEFAULT 0,
  `quality_inspection_template` varchar(140) DEFAULT NULL,
  `inspection_required_before_delivery` int(1) NOT NULL DEFAULT 0,
  `include_item_in_manufacturing` int(1) NOT NULL DEFAULT 1,
  `is_sub_contracted_item` int(1) NOT NULL DEFAULT 0,
  `default_bom` varchar(140) DEFAULT NULL,
  `customer_code` text DEFAULT NULL,
  `default_item_manufacturer` varchar(140) DEFAULT NULL,
  `default_manufacturer_part_no` varchar(140) DEFAULT NULL,
  `total_projected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `item_code` (`item_code`),
  KEY `item_name` (`item_name`),
  KEY `item_group` (`item_group`),
  KEY `disabled` (`disabled`),
  KEY `variant_of` (`variant_of`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Alternative`
--

DROP TABLE IF EXISTS `tabItem Alternative`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Alternative` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `alternative_item_code` varchar(140) DEFAULT NULL,
  `two_way` int(1) NOT NULL DEFAULT 0,
  `item_name` varchar(140) DEFAULT NULL,
  `alternative_item_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Attribute`
--

DROP TABLE IF EXISTS `tabItem Attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Attribute` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `attribute_name` varchar(140) DEFAULT NULL,
  `numeric_values` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `from_range` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `increment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `to_range` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `attribute_name` (`attribute_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Attribute Value`
--

DROP TABLE IF EXISTS `tabItem Attribute Value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Attribute Value` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `attribute_value` varchar(140) DEFAULT NULL,
  `abbr` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `abbr` (`abbr`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Barcode`
--

DROP TABLE IF EXISTS `tabItem Barcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Barcode` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `barcode` varchar(140) DEFAULT NULL,
  `barcode_type` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `barcode` (`barcode`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Customer Detail`
--

DROP TABLE IF EXISTS `tabItem Customer Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Customer Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `customer_name` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `ref_code` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer_name` (`customer_name`),
  KEY `ref_code` (`ref_code`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Default`
--

DROP TABLE IF EXISTS `tabItem Default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Default` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `default_warehouse` varchar(140) DEFAULT NULL,
  `default_price_list` varchar(140) DEFAULT NULL,
  `default_discount_account` varchar(140) DEFAULT NULL,
  `buying_cost_center` varchar(140) DEFAULT NULL,
  `default_supplier` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `default_provisional_account` varchar(140) DEFAULT NULL,
  `selling_cost_center` varchar(140) DEFAULT NULL,
  `income_account` varchar(140) DEFAULT NULL,
  `deferred_expense_account` varchar(140) DEFAULT NULL,
  `deferred_revenue_account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `default_warehouse` (`default_warehouse`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Group`
--

DROP TABLE IF EXISTS `tabItem Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_group_name` varchar(140) DEFAULT NULL,
  `parent_item_group` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `image` text DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `item_group_name` (`item_group_name`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Manufacturer`
--

DROP TABLE IF EXISTS `tabItem Manufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Manufacturer` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `manufacturer` varchar(140) DEFAULT NULL,
  `manufacturer_part_no` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Price`
--

DROP TABLE IF EXISTS `tabItem Price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Price` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `packing_unit` int(11) NOT NULL DEFAULT 0,
  `item_name` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `item_description` text DEFAULT NULL,
  `price_list` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `buying` int(1) NOT NULL DEFAULT 0,
  `selling` int(1) NOT NULL DEFAULT 0,
  `currency` varchar(140) DEFAULT NULL,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valid_from` date DEFAULT NULL,
  `lead_time_days` int(11) NOT NULL DEFAULT 0,
  `valid_upto` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `reference` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `price_list` (`price_list`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Quality Inspection Parameter`
--

DROP TABLE IF EXISTS `tabItem Quality Inspection Parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Quality Inspection Parameter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `specification` varchar(140) DEFAULT NULL,
  `parameter_group` varchar(140) DEFAULT NULL,
  `value` varchar(140) DEFAULT NULL,
  `numeric` int(1) NOT NULL DEFAULT 1,
  `min_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `formula_based_criteria` int(1) NOT NULL DEFAULT 0,
  `acceptance_formula` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Reorder`
--

DROP TABLE IF EXISTS `tabItem Reorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Reorder` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `warehouse_group` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `warehouse_reorder_level` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `warehouse_reorder_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `material_request_type` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Supplier`
--

DROP TABLE IF EXISTS `tabItem Supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Supplier` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_part_no` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Tax`
--

DROP TABLE IF EXISTS `tabItem Tax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Tax` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `minimum_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `maximum_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Tax Template`
--

DROP TABLE IF EXISTS `tabItem Tax Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Tax Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Tax Template Detail`
--

DROP TABLE IF EXISTS `tabItem Tax Template Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Tax Template Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `tax_type` varchar(140) DEFAULT NULL,
  `tax_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Variant`
--

DROP TABLE IF EXISTS `tabItem Variant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Variant` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_attribute` varchar(140) DEFAULT NULL,
  `item_attribute_value` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Variant Attribute`
--

DROP TABLE IF EXISTS `tabItem Variant Attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Variant Attribute` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `variant_of` varchar(140) DEFAULT NULL,
  `attribute` varchar(140) DEFAULT NULL,
  `attribute_value` varchar(140) DEFAULT NULL,
  `numeric_values` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `from_range` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `increment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `to_range` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `variant_of` (`variant_of`),
  KEY `attribute` (`attribute`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabItem Website Specification`
--

DROP TABLE IF EXISTS `tabItem Website Specification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabItem Website Specification` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJob Card`
--

DROP TABLE IF EXISTS `tabJob Card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJob Card` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT 'PO-JOB.#####',
  `work_order` varchar(140) DEFAULT NULL,
  `bom_no` varchar(140) DEFAULT NULL,
  `production_item` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `for_quantity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_completed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `process_loss_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expected_start_date` datetime(6) DEFAULT NULL,
  `time_required` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expected_end_date` datetime(6) DEFAULT NULL,
  `actual_start_date` datetime(6) DEFAULT NULL,
  `total_time_in_mins` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_end_date` datetime(6) DEFAULT NULL,
  `operation` varchar(140) DEFAULT NULL,
  `wip_warehouse` varchar(140) DEFAULT NULL,
  `workstation_type` varchar(140) DEFAULT NULL,
  `workstation` varchar(140) DEFAULT NULL,
  `quality_inspection_template` varchar(140) DEFAULT NULL,
  `quality_inspection` varchar(140) DEFAULT NULL,
  `for_job_card` varchar(140) DEFAULT NULL,
  `is_corrective_job_card` int(1) NOT NULL DEFAULT 0,
  `hour_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `for_operation` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `transferred_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `requested_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `status` varchar(140) DEFAULT 'Open',
  `operation_row_number` varchar(140) DEFAULT NULL,
  `operation_id` varchar(140) DEFAULT NULL,
  `sequence_id` int(11) NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `barcode` longtext DEFAULT NULL,
  `job_started` int(1) NOT NULL DEFAULT 0,
  `started_time` datetime(6) DEFAULT NULL,
  `current_time` int(11) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `work_order` (`work_order`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJob Card Item`
--

DROP TABLE IF EXISTS `tabJob Card Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJob Card Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `source_warehouse` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `required_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `transferred_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allow_alternative_item` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJob Card Operation`
--

DROP TABLE IF EXISTS `tabJob Card Operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJob Card Operation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sub_operation` varchar(140) DEFAULT NULL,
  `completed_time` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Pending',
  `completed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJob Card Scheduled Time`
--

DROP TABLE IF EXISTS `tabJob Card Scheduled Time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJob Card Scheduled Time` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `from_time` datetime(6) DEFAULT NULL,
  `to_time` datetime(6) DEFAULT NULL,
  `time_in_mins` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJob Card Scrap Item`
--

DROP TABLE IF EXISTS `tabJob Card Scrap Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJob Card Scrap Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJob Card Time Log`
--

DROP TABLE IF EXISTS `tabJob Card Time Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJob Card Time Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `employee` varchar(140) DEFAULT NULL,
  `from_time` datetime(6) DEFAULT NULL,
  `to_time` datetime(6) DEFAULT NULL,
  `time_in_mins` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `completed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `operation` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJournal Entry`
--

DROP TABLE IF EXISTS `tabJournal Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJournal Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_system_generated` int(1) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `voucher_type` varchar(140) DEFAULT 'Journal Entry',
  `naming_series` varchar(140) DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `process_deferred_accounting` varchar(140) DEFAULT NULL,
  `reversal_of` varchar(140) DEFAULT NULL,
  `tax_withholding_category` varchar(140) DEFAULT NULL,
  `from_template` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `apply_tds` int(1) NOT NULL DEFAULT 0,
  `cheque_no` varchar(140) DEFAULT NULL,
  `cheque_date` date DEFAULT NULL,
  `user_remark` text DEFAULT NULL,
  `total_debit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_credit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `difference` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `multi_currency` int(1) NOT NULL DEFAULT 0,
  `total_amount_currency` varchar(140) DEFAULT NULL,
  `total_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_amount_in_words` varchar(140) DEFAULT NULL,
  `clearance_date` date DEFAULT NULL,
  `remark` text DEFAULT NULL,
  `paid_loan` varchar(140) DEFAULT NULL,
  `inter_company_journal_entry_reference` varchar(140) DEFAULT NULL,
  `bill_no` varchar(140) DEFAULT NULL,
  `bill_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `write_off_based_on` varchar(140) DEFAULT 'Accounts Receivable',
  `write_off_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pay_to_recd_from` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `payment_order` varchar(140) DEFAULT NULL,
  `is_opening` varchar(140) DEFAULT 'No',
  `stock_entry` varchar(140) DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `voucher_type` (`voucher_type`),
  KEY `company` (`company`),
  KEY `posting_date` (`posting_date`),
  KEY `cheque_no` (`cheque_no`),
  KEY `cheque_date` (`cheque_date`),
  KEY `clearance_date` (`clearance_date`),
  KEY `is_opening` (`is_opening`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJournal Entry Account`
--

DROP TABLE IF EXISTS `tabJournal Entry Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJournal Entry Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `account_type` varchar(140) DEFAULT NULL,
  `bank_account` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `account_currency` varchar(140) DEFAULT NULL,
  `exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `debit_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `debit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `credit_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `credit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reference_type` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `reference_due_date` date DEFAULT NULL,
  `reference_detail_no` varchar(140) DEFAULT NULL,
  `is_advance` varchar(140) DEFAULT NULL,
  `user_remark` text DEFAULT NULL,
  `against_account` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `account` (`account`),
  KEY `party_type` (`party_type`),
  KEY `reference_type` (`reference_type`),
  KEY `reference_name` (`reference_name`),
  KEY `reference_detail_no` (`reference_detail_no`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJournal Entry Template`
--

DROP TABLE IF EXISTS `tabJournal Entry Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJournal Entry Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `template_title` varchar(140) DEFAULT NULL,
  `voucher_type` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `is_opening` varchar(140) DEFAULT 'No',
  `multi_currency` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `template_title` (`template_title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabJournal Entry Template Account`
--

DROP TABLE IF EXISTS `tabJournal Entry Template Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabJournal Entry Template Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabKanban Board`
--

DROP TABLE IF EXISTS `tabKanban Board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabKanban Board` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `kanban_board_name` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `field_name` varchar(140) DEFAULT NULL,
  `private` int(1) NOT NULL DEFAULT 0,
  `show_labels` int(1) NOT NULL DEFAULT 0,
  `filters` longtext DEFAULT NULL,
  `fields` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `kanban_board_name` (`kanban_board_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabKanban Board Column`
--

DROP TABLE IF EXISTS `tabKanban Board Column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabKanban Board Column` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `column_name` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Active',
  `indicator` varchar(140) DEFAULT 'Gray',
  `order` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLDAP Group Mapping`
--

DROP TABLE IF EXISTS `tabLDAP Group Mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLDAP Group Mapping` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `ldap_group` varchar(140) DEFAULT NULL,
  `erpnext_role` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLanded Cost Item`
--

DROP TABLE IF EXISTS `tabLanded Cost Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLanded Cost Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `receipt_document_type` varchar(140) DEFAULT NULL,
  `receipt_document` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `applicable_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `purchase_receipt_item` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLanded Cost Purchase Receipt`
--

DROP TABLE IF EXISTS `tabLanded Cost Purchase Receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLanded Cost Purchase Receipt` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `receipt_document_type` varchar(140) DEFAULT NULL,
  `receipt_document` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLanded Cost Taxes and Charges`
--

DROP TABLE IF EXISTS `tabLanded Cost Taxes and Charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLanded Cost Taxes and Charges` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `expense_account` varchar(140) DEFAULT NULL,
  `account_currency` varchar(140) DEFAULT NULL,
  `exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` text DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `has_corrective_cost` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLanded Cost Voucher`
--

DROP TABLE IF EXISTS `tabLanded Cost Voucher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLanded Cost Voucher` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distribute_charges_based_on` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLanguage`
--

DROP TABLE IF EXISTS `tabLanguage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLanguage` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `language_code` varchar(140) DEFAULT NULL,
  `language_name` varchar(140) DEFAULT NULL,
  `flag` varchar(140) DEFAULT NULL,
  `based_on` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `language_code` (`language_code`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLead`
--

DROP TABLE IF EXISTS `tabLead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLead` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `salutation` varchar(140) DEFAULT NULL,
  `first_name` varchar(140) DEFAULT NULL,
  `middle_name` varchar(140) DEFAULT NULL,
  `last_name` varchar(140) DEFAULT NULL,
  `lead_name` varchar(140) DEFAULT NULL,
  `job_title` varchar(140) DEFAULT NULL,
  `gender` varchar(140) DEFAULT NULL,
  `source` varchar(140) DEFAULT NULL,
  `lead_owner` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Lead',
  `customer` varchar(140) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `request_type` varchar(140) DEFAULT NULL,
  `email_id` varchar(140) DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `mobile_no` varchar(140) DEFAULT NULL,
  `whatsapp_no` varchar(140) DEFAULT NULL,
  `phone` varchar(140) DEFAULT NULL,
  `phone_ext` varchar(140) DEFAULT NULL,
  `company_name` varchar(140) DEFAULT NULL,
  `no_of_employees` varchar(140) DEFAULT NULL,
  `annual_revenue` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `industry` varchar(140) DEFAULT NULL,
  `market_segment` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `fax` varchar(140) DEFAULT NULL,
  `city` varchar(140) DEFAULT NULL,
  `state` varchar(140) DEFAULT NULL,
  `country` varchar(140) DEFAULT NULL,
  `qualification_status` varchar(140) DEFAULT NULL,
  `qualified_by` varchar(140) DEFAULT NULL,
  `qualified_on` date DEFAULT NULL,
  `campaign_name` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `title` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `unsubscribed` int(1) NOT NULL DEFAULT 0,
  `blog_subscriber` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `lead_name` (`lead_name`),
  KEY `lead_owner` (`lead_owner`),
  KEY `status` (`status`),
  KEY `email_id` (`email_id`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLead Source`
--

DROP TABLE IF EXISTS `tabLead Source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLead Source` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `source_name` varchar(140) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `source_name` (`source_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLedger Health`
--

DROP TABLE IF EXISTS `tabLedger Health`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLedger Health` (
  `name` bigint(20) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `checked_on` datetime(6) DEFAULT NULL,
  `debit_credit_mismatch` int(1) NOT NULL DEFAULT 0,
  `general_and_payment_ledger_mismatch` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLedger Health Monitor Company`
--

DROP TABLE IF EXISTS `tabLedger Health Monitor Company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLedger Health Monitor Company` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLedger Merge`
--

DROP TABLE IF EXISTS `tabLedger Merge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLedger Merge` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `root_type` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `account_name` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLedger Merge Accounts`
--

DROP TABLE IF EXISTS `tabLedger Merge Accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLedger Merge Accounts` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `account_name` varchar(140) DEFAULT NULL,
  `merged` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLetter Head`
--

DROP TABLE IF EXISTS `tabLetter Head`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLetter Head` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `letter_head_name` varchar(140) DEFAULT NULL,
  `source` varchar(140) DEFAULT NULL,
  `footer_source` varchar(140) DEFAULT 'HTML',
  `disabled` int(1) NOT NULL DEFAULT 0,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `image` text DEFAULT NULL,
  `image_height` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `image_width` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `align` varchar(140) DEFAULT 'Left',
  `content` longtext DEFAULT NULL,
  `footer` longtext DEFAULT NULL,
  `footer_image` text DEFAULT NULL,
  `footer_image_height` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `footer_image_width` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `footer_align` varchar(140) DEFAULT NULL,
  `header_script` longtext DEFAULT NULL,
  `footer_script` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `letter_head_name` (`letter_head_name`),
  KEY `is_default` (`is_default`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLinked Location`
--

DROP TABLE IF EXISTS `tabLinked Location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLinked Location` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `location` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabList Filter`
--

DROP TABLE IF EXISTS `tabList Filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabList Filter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `filter_name` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `for_user` varchar(140) DEFAULT NULL,
  `filters` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabList View Settings`
--

DROP TABLE IF EXISTS `tabList View Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabList View Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disable_count` int(1) NOT NULL DEFAULT 0,
  `disable_comment_count` int(1) NOT NULL DEFAULT 0,
  `disable_sidebar_stats` int(1) NOT NULL DEFAULT 0,
  `disable_auto_refresh` int(1) NOT NULL DEFAULT 0,
  `allow_edit` int(1) NOT NULL DEFAULT 0,
  `total_fields` varchar(140) DEFAULT NULL,
  `fields` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `disable_automatic_recency_filters` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLocation`
--

DROP TABLE IF EXISTS `tabLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLocation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `location_name` varchar(140) DEFAULT NULL,
  `parent_location` varchar(140) DEFAULT NULL,
  `is_container` int(1) NOT NULL DEFAULT 0,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `latitude` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `longitude` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `area` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `area_uom` varchar(140) DEFAULT NULL,
  `location` longtext DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `location_name` (`location_name`),
  KEY `parent_location` (`parent_location`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLog Setting User`
--

DROP TABLE IF EXISTS `tabLog Setting User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLog Setting User` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `user` (`user`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLogs To Clear`
--

DROP TABLE IF EXISTS `tabLogs To Clear`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLogs To Clear` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `ref_doctype` varchar(140) DEFAULT NULL,
  `days` int(11) NOT NULL DEFAULT 30,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLost Reason Detail`
--

DROP TABLE IF EXISTS `tabLost Reason Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLost Reason Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `lost_reason` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLower Deduction Certificate`
--

DROP TABLE IF EXISTS `tabLower Deduction Certificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLower Deduction Certificate` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `tax_withholding_category` varchar(140) DEFAULT NULL,
  `fiscal_year` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `certificate_no` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `pan_no` varchar(140) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_upto` date DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `certificate_limit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `certificate_no` (`certificate_no`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLoyalty Point Entry`
--

DROP TABLE IF EXISTS `tabLoyalty Point Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLoyalty Point Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `loyalty_program` varchar(140) DEFAULT NULL,
  `loyalty_program_tier` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `invoice_type` varchar(140) DEFAULT NULL,
  `invoice` varchar(140) DEFAULT NULL,
  `redeem_against` varchar(140) DEFAULT NULL,
  `loyalty_points` int(11) NOT NULL DEFAULT 0,
  `purchase_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expiry_date` date DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLoyalty Point Entry Redemption`
--

DROP TABLE IF EXISTS `tabLoyalty Point Entry Redemption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLoyalty Point Entry Redemption` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sales_invoice` varchar(140) DEFAULT NULL,
  `redemption_date` date DEFAULT NULL,
  `redeemed_points` int(11) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLoyalty Program`
--

DROP TABLE IF EXISTS `tabLoyalty Program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLoyalty Program` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `loyalty_program_name` varchar(140) DEFAULT NULL,
  `loyalty_program_type` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `customer_territory` varchar(140) DEFAULT NULL,
  `auto_opt_in` int(1) NOT NULL DEFAULT 0,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expiry_duration` int(11) NOT NULL DEFAULT 0,
  `expense_account` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `loyalty_program_name` (`loyalty_program_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabLoyalty Program Collection`
--

DROP TABLE IF EXISTS `tabLoyalty Program Collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabLoyalty Program Collection` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `tier_name` varchar(140) DEFAULT NULL,
  `min_spent` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `collection_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaintenance Schedule`
--

DROP TABLE IF EXISTS `tabMaintenance Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaintenance Schedule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `transaction_date` date DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_mobile` varchar(140) DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer` (`customer`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaintenance Schedule Detail`
--

DROP TABLE IF EXISTS `tabMaintenance Schedule Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaintenance Schedule Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `scheduled_date` date DEFAULT NULL,
  `actual_date` date DEFAULT NULL,
  `sales_person` varchar(140) DEFAULT NULL,
  `completion_status` varchar(140) DEFAULT 'Pending',
  `serial_no` text DEFAULT NULL,
  `item_reference` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `scheduled_date` (`scheduled_date`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaintenance Schedule Item`
--

DROP TABLE IF EXISTS `tabMaintenance Schedule Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaintenance Schedule Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `periodicity` varchar(140) DEFAULT NULL,
  `no_of_visits` int(11) NOT NULL DEFAULT 0,
  `sales_person` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `start_date` (`start_date`),
  KEY `end_date` (`end_date`),
  KEY `sales_order` (`sales_order`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaintenance Team Member`
--

DROP TABLE IF EXISTS `tabMaintenance Team Member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaintenance Team Member` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `team_member` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `maintenance_role` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaintenance Visit`
--

DROP TABLE IF EXISTS `tabMaintenance Visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaintenance Visit` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` varchar(140) DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `maintenance_schedule` varchar(140) DEFAULT NULL,
  `maintenance_schedule_detail` varchar(140) DEFAULT NULL,
  `mntc_date` date DEFAULT NULL,
  `mntc_time` time(6) DEFAULT NULL,
  `completion_status` varchar(140) DEFAULT NULL,
  `maintenance_type` varchar(140) DEFAULT 'Unscheduled',
  `customer_feedback` text DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `amended_from` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaintenance Visit Purpose`
--

DROP TABLE IF EXISTS `tabMaintenance Visit Purpose`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaintenance Visit Purpose` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `service_person` varchar(140) DEFAULT NULL,
  `serial_no` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `work_done` text DEFAULT NULL,
  `prevdoc_doctype` varchar(140) DEFAULT NULL,
  `prevdoc_docname` varchar(140) DEFAULT NULL,
  `maintenance_schedule_detail` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabManufacturer`
--

DROP TABLE IF EXISTS `tabManufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabManufacturer` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `short_name` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `country` varchar(140) DEFAULT NULL,
  `logo` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `short_name` (`short_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMarket Segment`
--

DROP TABLE IF EXISTS `tabMarket Segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMarket Segment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `market_segment` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `market_segment` (`market_segment`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMarketing Campaign`
--

DROP TABLE IF EXISTS `tabMarketing Campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMarketing Campaign` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `campaign_description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaterial Request`
--

DROP TABLE IF EXISTS `tabMaterial Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaterial Request` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `title` varchar(140) DEFAULT '{material_request_type}',
  `material_request_type` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `buying_price_list` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `set_from_warehouse` varchar(140) DEFAULT NULL,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `per_ordered` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `transfer_status` varchar(140) DEFAULT NULL,
  `per_received` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `letter_head` varchar(140) DEFAULT NULL,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `job_card` varchar(140) DEFAULT NULL,
  `work_order` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `company` (`company`),
  KEY `transaction_date` (`transaction_date`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaterial Request Item`
--

DROP TABLE IF EXISTS `tabMaterial Request Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaterial Request Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `from_warehouse` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `min_order_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `projected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ordered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `received_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expense_account` varchar(140) DEFAULT NULL,
  `wip_composite_asset` varchar(140) DEFAULT NULL,
  `manufacturer` varchar(140) DEFAULT NULL,
  `manufacturer_part_no` varchar(140) DEFAULT NULL,
  `bom_no` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `lead_time_date` date DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `sales_order_item` varchar(140) DEFAULT NULL,
  `production_plan` varchar(140) DEFAULT NULL,
  `material_request_plan_item` varchar(140) DEFAULT NULL,
  `job_card_item` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `item_name` (`item_name`),
  KEY `item_group` (`item_group`),
  KEY `sales_order_item` (`sales_order_item`),
  KEY `parent` (`parent`),
  KEY `item_code_warehouse_index` (`item_code`,`warehouse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMaterial Request Plan Item`
--

DROP TABLE IF EXISTS `tabMaterial Request Plan Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMaterial Request Plan Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `from_warehouse` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `material_request_type` varchar(140) DEFAULT NULL,
  `quantity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `required_bom_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `schedule_date` date DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` longtext DEFAULT NULL,
  `min_order_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `sales_order` varchar(140) DEFAULT NULL,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `requested_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reserved_qty_for_production` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ordered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `projected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `safety_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `from_warehouse` (`from_warehouse`),
  KEY `warehouse` (`warehouse`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMilestone`
--

DROP TABLE IF EXISTS `tabMilestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMilestone` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_type` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `track_field` varchar(140) DEFAULT NULL,
  `value` varchar(140) DEFAULT NULL,
  `milestone_tracker` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_type` (`reference_type`),
  KEY `modified` (`modified`),
  KEY `reference_type_reference_name_index` (`reference_type`,`reference_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMilestone Tracker`
--

DROP TABLE IF EXISTS `tabMilestone Tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMilestone Tracker` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `track_field` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `document_type` (`document_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMode of Payment`
--

DROP TABLE IF EXISTS `tabMode of Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMode of Payment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `type` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `mode_of_payment` (`mode_of_payment`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMode of Payment Account`
--

DROP TABLE IF EXISTS `tabMode of Payment Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMode of Payment Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `default_account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabModule Def`
--

DROP TABLE IF EXISTS `tabModule Def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabModule Def` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `module_name` varchar(140) DEFAULT NULL,
  `custom` int(1) NOT NULL DEFAULT 0,
  `package` varchar(140) DEFAULT NULL,
  `app_name` varchar(140) DEFAULT NULL,
  `restrict_to_domain` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `module_name` (`module_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabModule Onboarding`
--

DROP TABLE IF EXISTS `tabModule Onboarding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabModule Onboarding` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `subtitle` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `success_message` varchar(140) DEFAULT NULL,
  `documentation_url` varchar(140) DEFAULT NULL,
  `is_complete` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabModule Profile`
--

DROP TABLE IF EXISTS `tabModule Profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabModule Profile` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `module_profile_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `module_profile_name` (`module_profile_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMonthly Distribution`
--

DROP TABLE IF EXISTS `tabMonthly Distribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMonthly Distribution` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `distribution_id` varchar(140) DEFAULT NULL,
  `fiscal_year` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `distribution_id` (`distribution_id`),
  KEY `fiscal_year` (`fiscal_year`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabMonthly Distribution Percentage`
--

DROP TABLE IF EXISTS `tabMonthly Distribution Percentage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabMonthly Distribution Percentage` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `month` varchar(140) DEFAULT NULL,
  `percentage_allocation` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNavbar Item`
--

DROP TABLE IF EXISTS `tabNavbar Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNavbar Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_label` varchar(140) DEFAULT NULL,
  `item_type` varchar(140) DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `action` varchar(140) DEFAULT NULL,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  `condition` longtext DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNetwork Printer Settings`
--

DROP TABLE IF EXISTS `tabNetwork Printer Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNetwork Printer Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `server_ip` varchar(140) DEFAULT 'localhost',
  `port` int(11) NOT NULL DEFAULT 631,
  `printer_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNewsletter`
--

DROP TABLE IF EXISTS `tabNewsletter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNewsletter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_sent_at` datetime(6) DEFAULT NULL,
  `total_recipients` int(11) NOT NULL DEFAULT 0,
  `total_views` int(11) NOT NULL DEFAULT 0,
  `email_sent` int(1) NOT NULL DEFAULT 0,
  `sender_name` varchar(140) DEFAULT NULL,
  `sender_email` varchar(140) DEFAULT NULL,
  `send_from` varchar(140) DEFAULT NULL,
  `subject` text DEFAULT NULL,
  `content_type` varchar(140) DEFAULT NULL,
  `message` longtext DEFAULT NULL,
  `message_md` longtext DEFAULT NULL,
  `message_html` longtext DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `send_unsubscribe_link` int(1) NOT NULL DEFAULT 1,
  `send_webview_link` int(1) NOT NULL DEFAULT 0,
  `scheduled_to_send` int(11) NOT NULL DEFAULT 0,
  `schedule_sending` int(1) NOT NULL DEFAULT 0,
  `schedule_send` datetime(6) DEFAULT NULL,
  `published` int(1) NOT NULL DEFAULT 0,
  `route` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNewsletter Attachment`
--

DROP TABLE IF EXISTS `tabNewsletter Attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNewsletter Attachment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `attachment` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNewsletter Email Group`
--

DROP TABLE IF EXISTS `tabNewsletter Email Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNewsletter Email Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_group` varchar(140) DEFAULT NULL,
  `total_subscribers` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNon Conformance`
--

DROP TABLE IF EXISTS `tabNon Conformance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNon Conformance` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `subject` varchar(140) DEFAULT NULL,
  `procedure` varchar(140) DEFAULT NULL,
  `process_owner` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `corrective_action` longtext DEFAULT NULL,
  `preventive_action` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNote`
--

DROP TABLE IF EXISTS `tabNote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNote` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `public` int(1) NOT NULL DEFAULT 0,
  `notify_on_login` int(1) NOT NULL DEFAULT 0,
  `notify_on_every_login` int(1) NOT NULL DEFAULT 0,
  `expire_notification_on` date DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `expire_notification_on` (`expire_notification_on`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNote Seen By`
--

DROP TABLE IF EXISTS `tabNote Seen By`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNote Seen By` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNotification`
--

DROP TABLE IF EXISTS `tabNotification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNotification` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `channel` varchar(140) DEFAULT 'Email',
  `slack_webhook_url` varchar(140) DEFAULT NULL,
  `subject` varchar(140) DEFAULT NULL,
  `event` varchar(140) DEFAULT NULL,
  `document_type` varchar(140) DEFAULT NULL,
  `method` varchar(140) DEFAULT NULL,
  `date_changed` varchar(140) DEFAULT NULL,
  `days_in_advance` int(11) NOT NULL DEFAULT 0,
  `value_changed` varchar(140) DEFAULT NULL,
  `sender` varchar(140) DEFAULT NULL,
  `send_system_notification` int(1) NOT NULL DEFAULT 0,
  `sender_email` varchar(140) DEFAULT NULL,
  `condition` longtext DEFAULT NULL,
  `set_property_after_alert` varchar(140) DEFAULT NULL,
  `property_value` varchar(140) DEFAULT NULL,
  `send_to_all_assignees` int(1) NOT NULL DEFAULT 0,
  `message_type` varchar(140) DEFAULT 'Markdown',
  `message` longtext,
  `attach_print` int(1) NOT NULL DEFAULT 0,
  `print_format` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `event` (`event`),
  KEY `document_type` (`document_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNotification Log`
--

DROP TABLE IF EXISTS `tabNotification Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNotification Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `subject` text DEFAULT NULL,
  `for_user` varchar(140) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `email_content` longtext DEFAULT NULL,
  `document_type` varchar(140) DEFAULT NULL,
  `read` int(1) NOT NULL DEFAULT 0,
  `document_name` varchar(140) DEFAULT NULL,
  `attached_file` longtext DEFAULT NULL,
  `from_user` varchar(140) DEFAULT NULL,
  `link` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `for_user` (`for_user`),
  KEY `document_name` (`document_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNotification Recipient`
--

DROP TABLE IF EXISTS `tabNotification Recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNotification Recipient` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `receiver_by_document_field` varchar(140) DEFAULT NULL,
  `receiver_by_role` varchar(140) DEFAULT NULL,
  `cc` longtext DEFAULT NULL,
  `bcc` longtext DEFAULT NULL,
  `condition` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNotification Settings`
--

DROP TABLE IF EXISTS `tabNotification Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNotification Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `enable_email_notifications` int(1) NOT NULL DEFAULT 1,
  `enable_email_mention` int(1) NOT NULL DEFAULT 1,
  `enable_email_assignment` int(1) NOT NULL DEFAULT 1,
  `enable_email_threads_on_assigned_document` int(1) NOT NULL DEFAULT 1,
  `enable_email_energy_point` int(1) NOT NULL DEFAULT 1,
  `enable_email_share` int(1) NOT NULL DEFAULT 1,
  `enable_email_event_reminders` int(1) NOT NULL DEFAULT 1,
  `user` varchar(140) DEFAULT NULL,
  `seen` int(1) NOT NULL DEFAULT 0,
  `energy_points_system_notifications` int(1) NOT NULL DEFAULT 1,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNotification Subscribed Document`
--

DROP TABLE IF EXISTS `tabNotification Subscribed Document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNotification Subscribed Document` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNumber Card`
--

DROP TABLE IF EXISTS `tabNumber Card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNumber Card` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `report_name` varchar(140) DEFAULT NULL,
  `method` varchar(140) DEFAULT NULL,
  `function` varchar(140) DEFAULT NULL,
  `aggregate_function_based_on` varchar(140) DEFAULT NULL,
  `document_type` varchar(140) DEFAULT NULL,
  `parent_document_type` varchar(140) DEFAULT NULL,
  `report_field` varchar(140) DEFAULT NULL,
  `report_function` varchar(140) DEFAULT NULL,
  `is_public` int(1) NOT NULL DEFAULT 0,
  `filters_config` longtext DEFAULT NULL,
  `show_percentage_stats` int(1) NOT NULL DEFAULT 1,
  `stats_time_interval` varchar(140) DEFAULT 'Daily',
  `filters_json` longtext DEFAULT NULL,
  `dynamic_filters_json` longtext DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `background_color` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabNumber Card Link`
--

DROP TABLE IF EXISTS `tabNumber Card Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabNumber Card Link` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `card` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOAuth Authorization Code`
--

DROP TABLE IF EXISTS `tabOAuth Authorization Code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOAuth Authorization Code` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `client` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `scopes` text DEFAULT NULL,
  `authorization_code` varchar(140) DEFAULT NULL,
  `expiration_time` datetime(6) DEFAULT NULL,
  `redirect_uri_bound_to_authorization_code` varchar(140) DEFAULT NULL,
  `validity` varchar(140) DEFAULT NULL,
  `nonce` varchar(140) DEFAULT NULL,
  `code_challenge` varchar(140) DEFAULT NULL,
  `code_challenge_method` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `authorization_code` (`authorization_code`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOAuth Bearer Token`
--

DROP TABLE IF EXISTS `tabOAuth Bearer Token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOAuth Bearer Token` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `client` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `scopes` text DEFAULT NULL,
  `access_token` varchar(140) DEFAULT NULL,
  `refresh_token` varchar(140) DEFAULT NULL,
  `expiration_time` datetime(6) DEFAULT NULL,
  `expires_in` int(11) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `access_token` (`access_token`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOAuth Client`
--

DROP TABLE IF EXISTS `tabOAuth Client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOAuth Client` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `client_id` varchar(140) DEFAULT NULL,
  `app_name` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `client_secret` varchar(140) DEFAULT NULL,
  `skip_authorization` int(1) NOT NULL DEFAULT 0,
  `scopes` text,
  `redirect_uris` text DEFAULT NULL,
  `default_redirect_uri` varchar(140) DEFAULT NULL,
  `grant_type` varchar(140) DEFAULT NULL,
  `response_type` varchar(140) DEFAULT 'Code',
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOAuth Client Role`
--

DROP TABLE IF EXISTS `tabOAuth Client Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOAuth Client Role` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `role` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOAuth Scope`
--

DROP TABLE IF EXISTS `tabOAuth Scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOAuth Scope` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `scope` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOnboarding Permission`
--

DROP TABLE IF EXISTS `tabOnboarding Permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOnboarding Permission` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `role` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOnboarding Step`
--

DROP TABLE IF EXISTS `tabOnboarding Step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOnboarding Step` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `is_complete` int(1) NOT NULL DEFAULT 0,
  `is_skipped` int(1) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `intro_video_url` varchar(140) DEFAULT NULL,
  `action` varchar(140) DEFAULT NULL,
  `action_label` varchar(140) DEFAULT NULL,
  `reference_document` varchar(140) DEFAULT NULL,
  `show_full_form` int(1) NOT NULL DEFAULT 0,
  `show_form_tour` int(1) NOT NULL DEFAULT 0,
  `form_tour` varchar(140) DEFAULT NULL,
  `is_single` int(1) NOT NULL DEFAULT 0,
  `reference_report` varchar(140) DEFAULT NULL,
  `report_reference_doctype` varchar(140) DEFAULT NULL,
  `report_type` varchar(140) DEFAULT NULL,
  `report_description` varchar(140) DEFAULT NULL,
  `path` varchar(140) DEFAULT NULL,
  `callback_title` varchar(140) DEFAULT NULL,
  `callback_message` text DEFAULT NULL,
  `validate_action` int(1) NOT NULL DEFAULT 1,
  `field` varchar(140) DEFAULT NULL,
  `value_to_validate` varchar(140) DEFAULT NULL,
  `video_url` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOnboarding Step Map`
--

DROP TABLE IF EXISTS `tabOnboarding Step Map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOnboarding Step Map` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `step` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOpening Invoice Creation Tool Item`
--

DROP TABLE IF EXISTS `tabOpening Invoice Creation Tool Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOpening Invoice Creation Tool Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `invoice_number` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `temporary_opening_account` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `item_name` varchar(140) DEFAULT 'Opening Invoice Item',
  `outstanding_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `qty` varchar(140) DEFAULT '1',
  `cost_center` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOperation`
--

DROP TABLE IF EXISTS `tabOperation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOperation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `workstation` varchar(140) DEFAULT NULL,
  `is_corrective_operation` int(1) NOT NULL DEFAULT 0,
  `create_job_card_based_on_batch_size` int(1) NOT NULL DEFAULT 0,
  `quality_inspection_template` varchar(140) DEFAULT NULL,
  `batch_size` int(11) NOT NULL DEFAULT 1,
  `total_operation_time` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOpportunity`
--

DROP TABLE IF EXISTS `tabOpportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOpportunity` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `opportunity_from` varchar(140) DEFAULT NULL,
  `party_name` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Open',
  `opportunity_type` varchar(140) DEFAULT 'Sales',
  `source` varchar(140) DEFAULT NULL,
  `opportunity_owner` varchar(140) DEFAULT NULL,
  `sales_stage` varchar(140) DEFAULT 'Prospecting',
  `expected_closing` date DEFAULT NULL,
  `probability` decimal(21,9) NOT NULL DEFAULT 100.000000000,
  `no_of_employees` varchar(140) DEFAULT NULL,
  `annual_revenue` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `customer_group` varchar(140) DEFAULT NULL,
  `industry` varchar(140) DEFAULT NULL,
  `market_segment` varchar(140) DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `city` varchar(140) DEFAULT NULL,
  `state` varchar(140) DEFAULT NULL,
  `country` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `opportunity_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_opportunity_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `company` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `title` varchar(140) DEFAULT NULL,
  `first_response_time` decimal(21,9) DEFAULT NULL,
  `order_lost_reason` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `job_title` varchar(140) DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `contact_mobile` varchar(140) DEFAULT NULL,
  `whatsapp` varchar(140) DEFAULT NULL,
  `phone` varchar(140) DEFAULT NULL,
  `phone_ext` varchar(140) DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer_group` (`customer_group`),
  KEY `territory` (`territory`),
  KEY `company` (`company`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOpportunity Item`
--

DROP TABLE IF EXISTS `tabOpportunity Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOpportunity Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `brand` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `image` text DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOpportunity Lost Reason`
--

DROP TABLE IF EXISTS `tabOpportunity Lost Reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOpportunity Lost Reason` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `lost_reason` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `lost_reason` (`lost_reason`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOpportunity Lost Reason Detail`
--

DROP TABLE IF EXISTS `tabOpportunity Lost Reason Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOpportunity Lost Reason Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `lost_reason` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOpportunity Type`
--

DROP TABLE IF EXISTS `tabOpportunity Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOpportunity Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabOverdue Payment`
--

DROP TABLE IF EXISTS `tabOverdue Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabOverdue Payment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sales_invoice` varchar(140) DEFAULT NULL,
  `payment_schedule` varchar(140) DEFAULT NULL,
  `dunning_level` int(11) NOT NULL DEFAULT 1,
  `payment_term` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `overdue_days` varchar(140) DEFAULT NULL,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `invoice_portion` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `payment_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outstanding` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discounted_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `interest` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Closing Entry`
--

DROP TABLE IF EXISTS `tabPOS Closing Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Closing Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `period_start_date` datetime(6) DEFAULT NULL,
  `period_end_date` datetime(6) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `pos_opening_entry` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `company` varchar(140) DEFAULT NULL,
  `pos_profile` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_quantity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `error_message` text DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Closing Entry Detail`
--

DROP TABLE IF EXISTS `tabPOS Closing Entry Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Closing Entry Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `opening_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expected_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `closing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `difference` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Closing Entry Taxes`
--

DROP TABLE IF EXISTS `tabPOS Closing Entry Taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Closing Entry Taxes` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account_head` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Customer Group`
--

DROP TABLE IF EXISTS `tabPOS Customer Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Customer Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `customer_group` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Field`
--

DROP TABLE IF EXISTS `tabPOS Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fieldname` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT NULL,
  `options` text DEFAULT NULL,
  `default_value` varchar(140) DEFAULT NULL,
  `reqd` int(1) NOT NULL DEFAULT 0,
  `read_only` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Invoice`
--

DROP TABLE IF EXISTS `tabPOS Invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Invoice` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{customer_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `tax_id` varchar(140) DEFAULT NULL,
  `pos_profile` varchar(140) DEFAULT NULL,
  `consolidated_invoice` varchar(140) DEFAULT NULL,
  `is_pos` int(1) NOT NULL DEFAULT 1,
  `is_return` int(1) NOT NULL DEFAULT 0,
  `update_billed_amount_in_sales_order` int(1) NOT NULL DEFAULT 0,
  `update_billed_amount_in_delivery_note` int(1) NOT NULL DEFAULT 1,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `due_date` date DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `return_against` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `po_no` varchar(140) DEFAULT NULL,
  `po_date` date DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` varchar(140) DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `shipping_address_name` varchar(140) DEFAULT NULL,
  `shipping_address` text DEFAULT NULL,
  `company_address` varchar(140) DEFAULT NULL,
  `company_address_display` text DEFAULT NULL,
  `company_contact_person` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `selling_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `update_stock` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `total_billing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `other_charges_calculation` longtext DEFAULT NULL,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `loyalty_points` int(11) NOT NULL DEFAULT 0,
  `loyalty_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `redeem_loyalty_points` int(1) NOT NULL DEFAULT 0,
  `loyalty_program` varchar(140) DEFAULT NULL,
  `loyalty_redemption_account` varchar(140) DEFAULT NULL,
  `loyalty_redemption_cost_center` varchar(140) DEFAULT NULL,
  `coupon_code` varchar(140) DEFAULT NULL,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` varchar(140) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `in_words` varchar(140) DEFAULT NULL,
  `total_advance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outstanding_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allocate_advances_automatically` int(1) NOT NULL DEFAULT 0,
  `payment_terms_template` varchar(140) DEFAULT NULL,
  `cash_bank_account` varchar(140) DEFAULT NULL,
  `base_paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_change_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `change_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `account_for_change_amount` varchar(140) DEFAULT NULL,
  `write_off_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_write_off_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `write_off_outstanding_amount_automatically` int(1) NOT NULL DEFAULT 0,
  `write_off_account` varchar(140) DEFAULT NULL,
  `write_off_cost_center` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `language` varchar(140) DEFAULT NULL,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `inter_company_invoice_reference` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `is_discounted` int(1) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT 'Draft',
  `source` varchar(140) DEFAULT NULL,
  `debit_to` varchar(140) DEFAULT NULL,
  `party_account_currency` varchar(140) DEFAULT NULL,
  `is_opening` varchar(140) DEFAULT 'No',
  `remarks` text DEFAULT NULL,
  `sales_partner` varchar(140) DEFAULT NULL,
  `amount_eligible_for_commission` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `commission_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_commission` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `against_income_account` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer` (`customer`),
  KEY `posting_date` (`posting_date`),
  KEY `return_against` (`return_against`),
  KEY `debit_to` (`debit_to`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Invoice Item`
--

DROP TABLE IF EXISTS `tabPOS Invoice Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Invoice Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `barcode` varchar(140) DEFAULT NULL,
  `has_item_scanned` int(1) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `customer_item_code` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `margin_type` varchar(140) DEFAULT NULL,
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `grant_commission` int(1) NOT NULL DEFAULT 0,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `delivered_by_supplier` int(1) NOT NULL DEFAULT 0,
  `income_account` varchar(140) DEFAULT NULL,
  `is_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `asset` varchar(140) DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `deferred_revenue_account` varchar(140) DEFAULT NULL,
  `service_stop_date` date DEFAULT NULL,
  `enable_deferred_revenue` int(1) NOT NULL DEFAULT 0,
  `service_start_date` date DEFAULT NULL,
  `service_end_date` date DEFAULT NULL,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `target_warehouse` varchar(140) DEFAULT NULL,
  `quality_inspection` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `allow_zero_valuation_rate` int(1) NOT NULL DEFAULT 0,
  `item_tax_rate` text DEFAULT NULL,
  `actual_batch_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `so_detail` varchar(140) DEFAULT NULL,
  `pos_invoice_item` varchar(140) DEFAULT NULL,
  `delivery_note` varchar(140) DEFAULT NULL,
  `dn_detail` varchar(140) DEFAULT NULL,
  `delivered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `sales_order` (`sales_order`),
  KEY `so_detail` (`so_detail`),
  KEY `delivery_note` (`delivery_note`),
  KEY `dn_detail` (`dn_detail`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Invoice Merge Log`
--

DROP TABLE IF EXISTS `tabPOS Invoice Merge Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Invoice Merge Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `merge_invoices_based_on` varchar(140) DEFAULT NULL,
  `pos_closing_entry` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `consolidated_invoice` varchar(140) DEFAULT NULL,
  `consolidated_credit_note` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Invoice Reference`
--

DROP TABLE IF EXISTS `tabPOS Invoice Reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Invoice Reference` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `pos_invoice` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_return` int(1) NOT NULL DEFAULT 0,
  `return_against` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Item Group`
--

DROP TABLE IF EXISTS `tabPOS Item Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Item Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_group` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Opening Entry`
--

DROP TABLE IF EXISTS `tabPOS Opening Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Opening Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `period_start_date` datetime(6) DEFAULT NULL,
  `period_end_date` date DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `posting_date` date DEFAULT NULL,
  `set_posting_date` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `pos_profile` varchar(140) DEFAULT NULL,
  `pos_closing_entry` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Opening Entry Detail`
--

DROP TABLE IF EXISTS `tabPOS Opening Entry Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Opening Entry Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `opening_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Payment Method`
--

DROP TABLE IF EXISTS `tabPOS Payment Method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Payment Method` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `default` int(1) NOT NULL DEFAULT 0,
  `allow_in_returns` int(1) NOT NULL DEFAULT 0,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Profile`
--

DROP TABLE IF EXISTS `tabPOS Profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Profile` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `country` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `warehouse` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `company_address` varchar(140) DEFAULT NULL,
  `hide_images` int(1) NOT NULL DEFAULT 0,
  `hide_unavailable_items` int(1) NOT NULL DEFAULT 0,
  `auto_add_item_to_cart` int(1) NOT NULL DEFAULT 0,
  `validate_stock_on_save` int(1) NOT NULL DEFAULT 0,
  `print_receipt_on_order_complete` int(1) NOT NULL DEFAULT 0,
  `update_stock` int(1) NOT NULL DEFAULT 1,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `allow_rate_change` int(1) NOT NULL DEFAULT 0,
  `allow_discount_change` int(1) NOT NULL DEFAULT 0,
  `disable_grand_total_to_default_mop` int(1) NOT NULL DEFAULT 0,
  `allow_partial_payment` int(1) NOT NULL DEFAULT 0,
  `print_format` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `selling_price_list` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `write_off_account` varchar(140) DEFAULT NULL,
  `write_off_cost_center` varchar(140) DEFAULT NULL,
  `write_off_limit` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `account_for_change_amount` varchar(140) DEFAULT NULL,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `income_account` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Profile User`
--

DROP TABLE IF EXISTS `tabPOS Profile User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Profile User` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `default` int(1) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPOS Search Fields`
--

DROP TABLE IF EXISTS `tabPOS Search Fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPOS Search Fields` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `field` varchar(140) DEFAULT NULL,
  `fieldname` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPSOA Cost Center`
--

DROP TABLE IF EXISTS `tabPSOA Cost Center`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPSOA Cost Center` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `cost_center_name` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPSOA Project`
--

DROP TABLE IF EXISTS `tabPSOA Project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPSOA Project` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `project_name` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPackage`
--

DROP TABLE IF EXISTS `tabPackage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPackage` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `package_name` varchar(140) DEFAULT NULL,
  `readme` longtext DEFAULT NULL,
  `license_type` varchar(140) DEFAULT NULL,
  `license` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPackage Import`
--

DROP TABLE IF EXISTS `tabPackage Import`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPackage Import` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `attach_package` text DEFAULT NULL,
  `activate` int(1) NOT NULL DEFAULT 0,
  `force` int(1) NOT NULL DEFAULT 0,
  `log` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPackage Release`
--

DROP TABLE IF EXISTS `tabPackage Release`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPackage Release` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `package` varchar(140) DEFAULT NULL,
  `publish` int(1) NOT NULL DEFAULT 0,
  `path` text DEFAULT NULL,
  `major` int(11) NOT NULL DEFAULT 0,
  `minor` int(11) NOT NULL DEFAULT 0,
  `patch` int(11) NOT NULL DEFAULT 0,
  `release_notes` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPacked Item`
--

DROP TABLE IF EXISTS `tabPacked Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPacked Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `parent_item` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `target_warehouse` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `delivered_by_supplier` int(1) NOT NULL DEFAULT 0,
  `serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `actual_batch_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `projected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ordered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `packed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `incoming_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `picked_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `prevdoc_doctype` varchar(140) DEFAULT NULL,
  `parent_detail_docname` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent_detail_docname` (`parent_detail_docname`),
  KEY `parent` (`parent`),
  KEY `item_code_warehouse_index` (`item_code`,`warehouse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPacking Slip`
--

DROP TABLE IF EXISTS `tabPacking Slip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPacking Slip` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `delivery_note` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `from_case_no` int(11) NOT NULL DEFAULT 0,
  `to_case_no` int(11) NOT NULL DEFAULT 0,
  `net_weight_pkg` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_weight_uom` varchar(140) DEFAULT NULL,
  `gross_weight_pkg` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `gross_weight_uom` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPacking Slip Item`
--

DROP TABLE IF EXISTS `tabPacking Slip Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPacking Slip Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `weight_uom` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `dn_detail` varchar(140) DEFAULT NULL,
  `pi_detail` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPage`
--

DROP TABLE IF EXISTS `tabPage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPage` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `system_page` int(1) NOT NULL DEFAULT 0,
  `page_name` varchar(140) DEFAULT NULL,
  `title` varchar(140) DEFAULT NULL,
  `icon` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `restrict_to_domain` varchar(140) DEFAULT NULL,
  `standard` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `page_name` (`page_name`),
  KEY `standard` (`standard`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabParty Account`
--

DROP TABLE IF EXISTS `tabParty Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabParty Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `advance_account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabParty Link`
--

DROP TABLE IF EXISTS `tabParty Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabParty Link` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `primary_role` varchar(140) DEFAULT NULL,
  `secondary_role` varchar(140) DEFAULT NULL,
  `primary_party` varchar(140) DEFAULT NULL,
  `secondary_party` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabParty Specific Item`
--

DROP TABLE IF EXISTS `tabParty Specific Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabParty Specific Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `restrict_based_on` varchar(140) DEFAULT NULL,
  `based_on_value` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabParty Type`
--

DROP TABLE IF EXISTS `tabParty Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabParty Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `party_type` varchar(140) DEFAULT NULL,
  `account_type` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPatch Log`
--

DROP TABLE IF EXISTS `tabPatch Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPatch Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `patch` longtext DEFAULT NULL,
  `skipped` int(1) NOT NULL DEFAULT 0,
  `traceback` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPause SLA On Status`
--

DROP TABLE IF EXISTS `tabPause SLA On Status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPause SLA On Status` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Entry`
--

DROP TABLE IF EXISTS `tabPayment Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `payment_type` varchar(140) DEFAULT NULL,
  `payment_order_status` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `party_name` varchar(140) DEFAULT NULL,
  `book_advance_payments_in_separate_party_account` int(1) NOT NULL DEFAULT 0,
  `reconcile_on_advance_payment_date` int(1) NOT NULL DEFAULT 0,
  `bank_account` varchar(140) DEFAULT NULL,
  `party_bank_account` varchar(140) DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `party_balance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `paid_from` varchar(140) DEFAULT NULL,
  `paid_from_account_type` varchar(140) DEFAULT NULL,
  `paid_from_account_currency` varchar(140) DEFAULT NULL,
  `paid_from_account_balance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `paid_to` varchar(140) DEFAULT NULL,
  `paid_to_account_type` varchar(140) DEFAULT NULL,
  `paid_to_account_currency` varchar(140) DEFAULT NULL,
  `paid_to_account_balance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `paid_amount_after_tax` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `source_exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_paid_amount_after_tax` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `received_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `received_amount_after_tax` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `target_exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_received_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_received_amount_after_tax` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `unallocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `difference_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `purchase_taxes_and_charges_template` varchar(140) DEFAULT NULL,
  `sales_taxes_and_charges_template` varchar(140) DEFAULT NULL,
  `apply_tax_withholding_amount` int(1) NOT NULL DEFAULT 0,
  `tax_withholding_category` varchar(140) DEFAULT NULL,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reference_no` varchar(140) DEFAULT NULL,
  `reference_date` date DEFAULT NULL,
  `clearance_date` date DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `custom_remarks` int(1) NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `base_in_words` text DEFAULT NULL,
  `is_opening` varchar(140) DEFAULT 'No',
  `letter_head` varchar(140) DEFAULT NULL,
  `print_heading` varchar(140) DEFAULT NULL,
  `bank` varchar(140) DEFAULT NULL,
  `bank_account_no` varchar(140) DEFAULT NULL,
  `payment_order` varchar(140) DEFAULT NULL,
  `in_words` text DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `title` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `party_type` (`party_type`),
  KEY `reference_date` (`reference_date`),
  KEY `is_opening` (`is_opening`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Entry Deduction`
--

DROP TABLE IF EXISTS `tabPayment Entry Deduction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Entry Deduction` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_exchange_gain_loss` int(1) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Entry Reference`
--

DROP TABLE IF EXISTS `tabPayment Entry Reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Entry Reference` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `bill_no` varchar(140) DEFAULT NULL,
  `payment_term` varchar(140) DEFAULT NULL,
  `payment_term_outstanding` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `account_type` varchar(140) DEFAULT NULL,
  `payment_type` varchar(140) DEFAULT NULL,
  `reconcile_effect_on` date DEFAULT NULL,
  `total_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outstanding_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `exchange_gain_loss` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `account` varchar(140) DEFAULT NULL,
  `payment_request` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_doctype` (`reference_doctype`),
  KEY `reference_name` (`reference_name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Gateway Account`
--

DROP TABLE IF EXISTS `tabPayment Gateway Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Gateway Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `payment_gateway` varchar(140) DEFAULT NULL,
  `payment_channel` varchar(140) DEFAULT 'Email',
  `is_default` int(1) NOT NULL DEFAULT 0,
  `payment_account` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `message` text,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Ledger Entry`
--

DROP TABLE IF EXISTS `tabPayment Ledger Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Ledger Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `posting_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `account_type` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `voucher_detail_no` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `against_voucher_type` varchar(140) DEFAULT NULL,
  `against_voucher_no` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `account_currency` varchar(140) DEFAULT NULL,
  `amount_in_account_currency` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `delinked` int(1) NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `posting_date` (`posting_date`),
  KEY `company` (`company`),
  KEY `account` (`account`),
  KEY `party_type` (`party_type`),
  KEY `party` (`party`),
  KEY `voucher_detail_no` (`voucher_detail_no`),
  KEY `voucher_type` (`voucher_type`),
  KEY `voucher_no` (`voucher_no`),
  KEY `against_voucher_type` (`against_voucher_type`),
  KEY `against_voucher_no` (`against_voucher_no`),
  KEY `modified` (`modified`),
  KEY `against_voucher_no_against_voucher_type_index` (`against_voucher_no`,`against_voucher_type`),
  KEY `voucher_no_voucher_type_index` (`voucher_no`,`voucher_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Order`
--

DROP TABLE IF EXISTS `tabPayment Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Order` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT 'PMO-',
  `company` varchar(140) DEFAULT NULL,
  `payment_order_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `company_bank` varchar(140) DEFAULT NULL,
  `company_bank_account` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Order Reference`
--

DROP TABLE IF EXISTS `tabPayment Order Reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Order Reference` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `supplier` varchar(140) DEFAULT NULL,
  `payment_request` varchar(140) DEFAULT NULL,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `bank_account` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `payment_reference` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Request`
--

DROP TABLE IF EXISTS `tabPayment Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Request` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `payment_request_type` varchar(140) DEFAULT 'Inward',
  `transaction_date` date DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `party_name` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `currency` varchar(140) DEFAULT NULL,
  `is_a_subscription` int(1) NOT NULL DEFAULT 0,
  `outstanding_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `party_account_currency` varchar(140) DEFAULT NULL,
  `bank_account` varchar(140) DEFAULT NULL,
  `bank` varchar(140) DEFAULT NULL,
  `bank_account_no` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `iban` varchar(140) DEFAULT NULL,
  `branch_code` varchar(140) DEFAULT NULL,
  `swift_number` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `print_format` varchar(140) DEFAULT NULL,
  `email_to` varchar(140) DEFAULT NULL,
  `subject` varchar(140) DEFAULT NULL,
  `payment_gateway_account` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `make_sales_invoice` int(1) NOT NULL DEFAULT 0,
  `message` text DEFAULT NULL,
  `mute_email` int(1) NOT NULL DEFAULT 0,
  `payment_url` varchar(500) DEFAULT NULL,
  `payment_gateway` varchar(140) DEFAULT NULL,
  `payment_account` varchar(140) DEFAULT NULL,
  `payment_channel` varchar(140) DEFAULT NULL,
  `payment_order` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `phone_number` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_name` (`reference_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Schedule`
--

DROP TABLE IF EXISTS `tabPayment Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Schedule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `payment_term` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `invoice_portion` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_type` varchar(140) DEFAULT 'Percentage',
  `discount_date` date DEFAULT NULL,
  `discount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `payment_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outstanding` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discounted_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_payment_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_outstanding` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Term`
--

DROP TABLE IF EXISTS `tabPayment Term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Term` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `payment_term_name` varchar(140) DEFAULT NULL,
  `invoice_portion` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `due_date_based_on` varchar(140) DEFAULT NULL,
  `credit_days` int(11) NOT NULL DEFAULT 0,
  `credit_months` int(11) NOT NULL DEFAULT 0,
  `discount_type` varchar(140) DEFAULT 'Percentage',
  `discount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_validity_based_on` varchar(140) DEFAULT 'Day(s) after invoice date',
  `discount_validity` int(11) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `payment_term_name` (`payment_term_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Terms Template`
--

DROP TABLE IF EXISTS `tabPayment Terms Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Terms Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `template_name` varchar(140) DEFAULT NULL,
  `allocate_payment_based_on_payment_terms` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `template_name` (`template_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPayment Terms Template Detail`
--

DROP TABLE IF EXISTS `tabPayment Terms Template Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPayment Terms Template Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `payment_term` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `invoice_portion` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `due_date_based_on` varchar(140) DEFAULT NULL,
  `credit_days` int(11) NOT NULL DEFAULT 0,
  `credit_months` int(11) NOT NULL DEFAULT 0,
  `discount_type` varchar(140) DEFAULT 'Percentage',
  `discount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_validity_based_on` varchar(140) DEFAULT 'Day(s) after invoice date',
  `discount_validity` int(11) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPegged Currency Details`
--

DROP TABLE IF EXISTS `tabPegged Currency Details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPegged Currency Details` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `source_currency` varchar(140) DEFAULT NULL,
  `pegged_against` varchar(140) DEFAULT NULL,
  `pegged_exchange_rate` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPeriod Closing Voucher`
--

DROP TABLE IF EXISTS `tabPeriod Closing Voucher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPeriod Closing Voucher` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `transaction_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `fiscal_year` varchar(140) DEFAULT NULL,
  `period_start_date` date DEFAULT NULL,
  `period_end_date` date DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `closing_account_head` varchar(140) DEFAULT NULL,
  `gle_processing_status` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPersonal Data Deletion Request`
--

DROP TABLE IF EXISTS `tabPersonal Data Deletion Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPersonal Data Deletion Request` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Pending Verification',
  `anonymization_matrix` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPersonal Data Deletion Step`
--

DROP TABLE IF EXISTS `tabPersonal Data Deletion Step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPersonal Data Deletion Step` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `partial` int(1) NOT NULL DEFAULT 0,
  `fields` text DEFAULT NULL,
  `filtered_by` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPersonal Data Download Request`
--

DROP TABLE IF EXISTS `tabPersonal Data Download Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPersonal Data Download Request` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `user_name` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPick List`
--

DROP TABLE IF EXISTS `tabPick List`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPick List` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `purpose` varchar(140) DEFAULT 'Material Transfer for Manufacture',
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `work_order` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `for_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent_warehouse` varchar(140) DEFAULT NULL,
  `consider_rejected_warehouses` int(1) NOT NULL DEFAULT 0,
  `pick_manually` int(1) NOT NULL DEFAULT 0,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `scan_mode` int(1) NOT NULL DEFAULT 0,
  `prompt_qty` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT 'Draft',
  `delivery_status` varchar(140) DEFAULT NULL,
  `per_delivered` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPick List Item`
--

DROP TABLE IF EXISTS `tabPick List Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPick List Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `picked_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_reserved_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `delivered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `sales_order_item` varchar(140) DEFAULT NULL,
  `product_bundle_item` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `serial_and_batch_bundle` (`serial_and_batch_bundle`),
  KEY `batch_no` (`batch_no`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPlant Floor`
--

DROP TABLE IF EXISTS `tabPlant Floor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPlant Floor` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `floor_name` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `floor_name` (`floor_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPortal Menu Item`
--

DROP TABLE IF EXISTS `tabPortal Menu Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPortal Menu Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `enabled` int(1) NOT NULL DEFAULT 0,
  `route` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `role` varchar(140) DEFAULT NULL,
  `target` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPortal User`
--

DROP TABLE IF EXISTS `tabPortal User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPortal User` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `user` (`user`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPrepared Report`
--

DROP TABLE IF EXISTS `tabPrepared Report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPrepared Report` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT 'Queued',
  `report_name` varchar(140) DEFAULT NULL,
  `job_id` varchar(140) DEFAULT NULL,
  `report_end_time` datetime(6) DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `filters` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `peak_memory_usage` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `status` (`status`),
  KEY `report_name` (`report_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPrice List`
--

DROP TABLE IF EXISTS `tabPrice List`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPrice List` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `price_list_name` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `buying` int(1) NOT NULL DEFAULT 0,
  `selling` int(1) NOT NULL DEFAULT 0,
  `price_not_uom_dependent` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `price_list_name` (`price_list_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPrice List Country`
--

DROP TABLE IF EXISTS `tabPrice List Country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPrice List Country` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `country` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPricing Rule`
--

DROP TABLE IF EXISTS `tabPricing Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPricing Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT 'PRLE-.####',
  `title` varchar(140) DEFAULT NULL,
  `disable` int(1) NOT NULL DEFAULT 0,
  `apply_on` varchar(140) DEFAULT 'Item Code',
  `price_or_product_discount` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `mixed_conditions` int(1) NOT NULL DEFAULT 0,
  `is_cumulative` int(1) NOT NULL DEFAULT 0,
  `coupon_code_based` int(1) NOT NULL DEFAULT 0,
  `apply_rule_on_other` varchar(140) DEFAULT NULL,
  `other_item_code` varchar(140) DEFAULT NULL,
  `other_item_group` varchar(140) DEFAULT NULL,
  `other_brand` varchar(140) DEFAULT NULL,
  `selling` int(1) NOT NULL DEFAULT 0,
  `buying` int(1) NOT NULL DEFAULT 0,
  `applicable_for` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `sales_partner` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_group` varchar(140) DEFAULT NULL,
  `min_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `min_amt` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_amt` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `same_item` int(1) NOT NULL DEFAULT 0,
  `free_item` varchar(140) DEFAULT NULL,
  `free_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `free_item_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `free_item_uom` varchar(140) DEFAULT NULL,
  `round_free_qty` int(1) NOT NULL DEFAULT 0,
  `dont_enforce_free_item_qty` int(1) NOT NULL DEFAULT 0,
  `is_recursive` int(1) NOT NULL DEFAULT 0,
  `recurse_for` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `apply_recursion_over` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valid_from` date DEFAULT NULL,
  `valid_upto` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `margin_type` varchar(140) DEFAULT 'Percentage',
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_or_discount` varchar(140) DEFAULT 'Discount Percentage',
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `for_price_list` varchar(140) DEFAULT NULL,
  `condition` longtext DEFAULT NULL,
  `apply_multiple_pricing_rules` int(1) NOT NULL DEFAULT 0,
  `apply_discount_on_rate` int(1) NOT NULL DEFAULT 0,
  `threshold_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `validate_applied_rule` int(1) NOT NULL DEFAULT 0,
  `rule_description` text DEFAULT NULL,
  `has_priority` int(1) NOT NULL DEFAULT 0,
  `priority` varchar(140) DEFAULT NULL,
  `promotional_scheme_id` varchar(140) DEFAULT NULL,
  `promotional_scheme` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `warehouse` (`warehouse`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPricing Rule Brand`
--

DROP TABLE IF EXISTS `tabPricing Rule Brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPricing Rule Brand` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `brand` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `brand` (`brand`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPricing Rule Detail`
--

DROP TABLE IF EXISTS `tabPricing Rule Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPricing Rule Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `pricing_rule` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `margin_type` varchar(140) DEFAULT NULL,
  `rate_or_discount` varchar(140) DEFAULT NULL,
  `child_docname` varchar(140) DEFAULT NULL,
  `rule_applied` int(1) NOT NULL DEFAULT 1,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPricing Rule Item Code`
--

DROP TABLE IF EXISTS `tabPricing Rule Item Code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPricing Rule Item Code` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPricing Rule Item Group`
--

DROP TABLE IF EXISTS `tabPricing Rule Item Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPricing Rule Item Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_group` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_group` (`item_group`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPrint Format`
--

DROP TABLE IF EXISTS `tabPrint Format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPrint Format` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `doc_type` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `default_print_language` varchar(140) DEFAULT NULL,
  `standard` varchar(140) DEFAULT 'No',
  `custom_format` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `print_format_type` varchar(140) DEFAULT 'Jinja',
  `raw_printing` int(1) NOT NULL DEFAULT 0,
  `html` longtext DEFAULT NULL,
  `raw_commands` longtext DEFAULT NULL,
  `margin_top` decimal(21,9) NOT NULL DEFAULT 15.000000000,
  `margin_bottom` decimal(21,9) NOT NULL DEFAULT 15.000000000,
  `margin_left` decimal(21,9) NOT NULL DEFAULT 15.000000000,
  `margin_right` decimal(21,9) NOT NULL DEFAULT 15.000000000,
  `align_labels_right` int(1) NOT NULL DEFAULT 0,
  `show_section_headings` int(1) NOT NULL DEFAULT 0,
  `line_breaks` int(1) NOT NULL DEFAULT 0,
  `absolute_value` int(1) NOT NULL DEFAULT 0,
  `font_size` int(11) NOT NULL DEFAULT 14,
  `font` varchar(140) DEFAULT NULL,
  `page_number` varchar(140) DEFAULT 'Hide',
  `css` longtext DEFAULT NULL,
  `format_data` longtext DEFAULT NULL,
  `print_format_builder` int(1) NOT NULL DEFAULT 0,
  `print_format_builder_beta` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `pdf_generator` varchar(140) DEFAULT 'wkhtmltopdf',
  PRIMARY KEY (`name`),
  KEY `standard` (`standard`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPrint Format Field Template`
--

DROP TABLE IF EXISTS `tabPrint Format Field Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPrint Format Field Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `field` varchar(140) DEFAULT NULL,
  `template_file` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `standard` int(1) NOT NULL DEFAULT 0,
  `template` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPrint Heading`
--

DROP TABLE IF EXISTS `tabPrint Heading`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPrint Heading` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `print_heading` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `print_heading` (`print_heading`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPrint Style`
--

DROP TABLE IF EXISTS `tabPrint Style`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPrint Style` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `print_style_name` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `standard` int(1) NOT NULL DEFAULT 0,
  `css` longtext DEFAULT NULL,
  `preview` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `print_style_name` (`print_style_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProcess Deferred Accounting`
--

DROP TABLE IF EXISTS `tabProcess Deferred Accounting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProcess Deferred Accounting` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProcess Payment Reconciliation`
--

DROP TABLE IF EXISTS `tabProcess Payment Reconciliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProcess Payment Reconciliation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `receivable_payable_account` varchar(140) DEFAULT NULL,
  `default_advance_account` varchar(140) DEFAULT NULL,
  `from_invoice_date` date DEFAULT NULL,
  `to_invoice_date` date DEFAULT NULL,
  `from_payment_date` date DEFAULT NULL,
  `to_payment_date` date DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `bank_cash_account` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `error_log` longtext DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProcess Payment Reconciliation Log`
--

DROP TABLE IF EXISTS `tabProcess Payment Reconciliation Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProcess Payment Reconciliation Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `process_pr` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `allocated` int(1) NOT NULL DEFAULT 0,
  `reconciled` int(1) NOT NULL DEFAULT 0,
  `total_allocations` int(11) NOT NULL DEFAULT 0,
  `reconciled_entries` int(11) NOT NULL DEFAULT 0,
  `error_log` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProcess Payment Reconciliation Log Allocations`
--

DROP TABLE IF EXISTS `tabProcess Payment Reconciliation Log Allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProcess Payment Reconciliation Log Allocations` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_type` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `reference_row` varchar(140) DEFAULT NULL,
  `invoice_type` varchar(140) DEFAULT NULL,
  `invoice_number` varchar(140) DEFAULT NULL,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `unreconciled_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_advance` varchar(140) DEFAULT NULL,
  `difference_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `gain_loss_posting_date` date DEFAULT NULL,
  `difference_account` varchar(140) DEFAULT NULL,
  `exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `currency` varchar(140) DEFAULT NULL,
  `reconciled` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProcess Statement Of Accounts`
--

DROP TABLE IF EXISTS `tabProcess Statement Of Accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProcess Statement Of Accounts` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `report` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `categorize_by` varchar(140) DEFAULT 'Categorize by Voucher (Consolidated)',
  `territory` varchar(140) DEFAULT NULL,
  `ignore_exchange_rate_revaluation_journals` int(1) NOT NULL DEFAULT 0,
  `ignore_cr_dr_notes` int(1) NOT NULL DEFAULT 0,
  `to_date` date DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `payment_terms_template` varchar(140) DEFAULT NULL,
  `sales_partner` varchar(140) DEFAULT NULL,
  `sales_person` varchar(140) DEFAULT NULL,
  `show_remarks` int(1) NOT NULL DEFAULT 0,
  `based_on_payment_terms` int(1) NOT NULL DEFAULT 0,
  `customer_collection` varchar(140) DEFAULT NULL,
  `collection_name` varchar(140) DEFAULT NULL,
  `primary_mandatory` int(1) NOT NULL DEFAULT 1,
  `show_net_values_in_party_account` int(1) NOT NULL DEFAULT 0,
  `orientation` varchar(140) DEFAULT NULL,
  `include_break` int(1) NOT NULL DEFAULT 1,
  `include_ageing` int(1) NOT NULL DEFAULT 0,
  `ageing_based_on` varchar(140) DEFAULT 'Due Date',
  `letter_head` varchar(140) DEFAULT NULL,
  `terms_and_conditions` varchar(140) DEFAULT NULL,
  `enable_auto_email` int(1) NOT NULL DEFAULT 0,
  `sender` varchar(140) DEFAULT NULL,
  `frequency` varchar(140) DEFAULT NULL,
  `filter_duration` int(11) NOT NULL DEFAULT 1,
  `start_date` date DEFAULT NULL,
  `pdf_name` varchar(140) DEFAULT NULL,
  `subject` varchar(140) DEFAULT NULL,
  `body` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProcess Statement Of Accounts CC`
--

DROP TABLE IF EXISTS `tabProcess Statement Of Accounts CC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProcess Statement Of Accounts CC` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `cc` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProcess Statement Of Accounts Customer`
--

DROP TABLE IF EXISTS `tabProcess Statement Of Accounts Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProcess Statement Of Accounts Customer` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `billing_email` varchar(140) DEFAULT NULL,
  `primary_email` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProcess Subscription`
--

DROP TABLE IF EXISTS `tabProcess Subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProcess Subscription` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `posting_date` date DEFAULT NULL,
  `subscription` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduct Bundle`
--

DROP TABLE IF EXISTS `tabProduct Bundle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduct Bundle` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `new_item_code` varchar(140) DEFAULT NULL,
  `description` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduct Bundle Item`
--

DROP TABLE IF EXISTS `tabProduct Bundle Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduct Bundle Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` longtext DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduction Plan`
--

DROP TABLE IF EXISTS `tabProduction Plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduction Plan` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `get_items_from` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `sales_order_status` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `from_delivery_date` date DEFAULT NULL,
  `to_delivery_date` date DEFAULT NULL,
  `combine_items` int(1) NOT NULL DEFAULT 0,
  `combine_sub_items` int(1) NOT NULL DEFAULT 0,
  `sub_assembly_warehouse` varchar(140) DEFAULT NULL,
  `skip_available_sub_assembly_item` int(1) NOT NULL DEFAULT 0,
  `include_non_stock_items` int(1) NOT NULL DEFAULT 1,
  `include_subcontracted_items` int(1) NOT NULL DEFAULT 1,
  `consider_minimum_order_qty` int(1) NOT NULL DEFAULT 0,
  `include_safety_stock` int(1) NOT NULL DEFAULT 0,
  `ignore_existing_ordered_qty` int(1) NOT NULL DEFAULT 0,
  `for_warehouse` varchar(140) DEFAULT NULL,
  `total_planned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_produced_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `status` varchar(140) DEFAULT 'Draft',
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduction Plan Item`
--

DROP TABLE IF EXISTS `tabProduction Plan Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduction Plan Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `include_exploded_items` int(1) NOT NULL DEFAULT 1,
  `item_code` varchar(140) DEFAULT NULL,
  `bom_no` varchar(140) DEFAULT NULL,
  `planned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `planned_start_date` datetime(6) DEFAULT NULL,
  `pending_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ordered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` longtext DEFAULT NULL,
  `produced_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `sales_order` varchar(140) DEFAULT NULL,
  `sales_order_item` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `product_bundle_item` varchar(140) DEFAULT NULL,
  `item_reference` varchar(140) DEFAULT NULL,
  `temporary_name` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduction Plan Item Reference`
--

DROP TABLE IF EXISTS `tabProduction Plan Item Reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduction Plan Item Reference` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_reference` varchar(140) DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `sales_order_item` varchar(140) DEFAULT NULL,
  `qty` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduction Plan Material Request`
--

DROP TABLE IF EXISTS `tabProduction Plan Material Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduction Plan Material Request` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_date` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduction Plan Material Request Warehouse`
--

DROP TABLE IF EXISTS `tabProduction Plan Material Request Warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduction Plan Material Request Warehouse` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `warehouse` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduction Plan Sales Order`
--

DROP TABLE IF EXISTS `tabProduction Plan Sales Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduction Plan Sales Order` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sales_order` varchar(140) DEFAULT NULL,
  `sales_order_date` date DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProduction Plan Sub Assembly Item`
--

DROP TABLE IF EXISTS `tabProduction Plan Sub Assembly Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProduction Plan Sub Assembly Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `production_item` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `fg_warehouse` varchar(140) DEFAULT NULL,
  `parent_item_code` varchar(140) DEFAULT NULL,
  `schedule_date` datetime(6) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `bom_no` varchar(140) DEFAULT NULL,
  `bom_level` int(11) NOT NULL DEFAULT 0,
  `type_of_manufacturing` varchar(140) DEFAULT 'In House',
  `supplier` varchar(140) DEFAULT NULL,
  `wo_produced_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `purchase_order` varchar(140) DEFAULT NULL,
  `production_plan_item` varchar(140) DEFAULT NULL,
  `ordered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `received_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `indent` int(11) NOT NULL DEFAULT 0,
  `uom` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `projected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProject`
--

DROP TABLE IF EXISTS `tabProject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProject` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `project_name` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Open',
  `project_type` varchar(140) DEFAULT NULL,
  `is_active` varchar(140) DEFAULT NULL,
  `percent_complete_method` varchar(140) DEFAULT 'Task Completion',
  `percent_complete` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `project_template` varchar(140) DEFAULT NULL,
  `expected_start_date` date DEFAULT NULL,
  `expected_end_date` date DEFAULT NULL,
  `priority` varchar(140) DEFAULT NULL,
  `department` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `copied_from` varchar(140) DEFAULT NULL,
  `notes` longtext DEFAULT NULL,
  `actual_start_date` date DEFAULT NULL,
  `actual_time` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_end_date` date DEFAULT NULL,
  `estimated_costing` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_costing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_purchase_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `company` varchar(140) DEFAULT NULL,
  `total_sales_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_billable_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_billed_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_consumed_material_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cost_center` varchar(140) DEFAULT NULL,
  `gross_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `per_gross_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `collect_progress` int(1) NOT NULL DEFAULT 0,
  `holiday_list` varchar(140) DEFAULT NULL,
  `frequency` varchar(140) DEFAULT NULL,
  `from_time` time(6) DEFAULT NULL,
  `to_time` time(6) DEFAULT NULL,
  `first_email` time(6) DEFAULT NULL,
  `second_email` time(6) DEFAULT NULL,
  `daily_time_to_send` time(6) DEFAULT NULL,
  `day_to_send` varchar(140) DEFAULT NULL,
  `weekly_time_to_send` time(6) DEFAULT NULL,
  `subject` varchar(140) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `project_name` (`project_name`),
  KEY `status` (`status`),
  KEY `customer` (`customer`),
  KEY `collect_progress` (`collect_progress`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProject Template`
--

DROP TABLE IF EXISTS `tabProject Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProject Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `project_type` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProject Template Task`
--

DROP TABLE IF EXISTS `tabProject Template Task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProject Template Task` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `task` varchar(140) DEFAULT NULL,
  `subject` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProject Type`
--

DROP TABLE IF EXISTS `tabProject Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProject Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `project_type` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProject Update`
--

DROP TABLE IF EXISTS `tabProject Update`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProject Update` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `sent` int(1) NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL,
  `time` time(6) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `date` (`date`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProject User`
--

DROP TABLE IF EXISTS `tabProject User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProject User` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `email` varchar(140) DEFAULT NULL,
  `image` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `welcome_email_sent` int(1) NOT NULL DEFAULT 0,
  `view_attachments` int(1) NOT NULL DEFAULT 0,
  `hide_timesheets` int(1) NOT NULL DEFAULT 0,
  `project_status` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `user` (`user`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPromotional Scheme`
--

DROP TABLE IF EXISTS `tabPromotional Scheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPromotional Scheme` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `apply_on` varchar(140) DEFAULT 'Item Code',
  `disable` int(1) NOT NULL DEFAULT 0,
  `mixed_conditions` int(1) NOT NULL DEFAULT 0,
  `is_cumulative` int(1) NOT NULL DEFAULT 0,
  `apply_rule_on_other` varchar(140) DEFAULT NULL,
  `other_item_code` varchar(140) DEFAULT NULL,
  `other_item_group` varchar(140) DEFAULT NULL,
  `other_brand` varchar(140) DEFAULT NULL,
  `selling` int(1) NOT NULL DEFAULT 0,
  `buying` int(1) NOT NULL DEFAULT 0,
  `applicable_for` varchar(140) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_upto` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPromotional Scheme Price Discount`
--

DROP TABLE IF EXISTS `tabPromotional Scheme Price Discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPromotional Scheme Price Discount` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disable` int(1) NOT NULL DEFAULT 0,
  `apply_multiple_pricing_rules` int(1) NOT NULL DEFAULT 0,
  `rule_description` text DEFAULT NULL,
  `min_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `min_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_or_discount` varchar(140) DEFAULT 'Discount Percentage',
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `for_price_list` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `threshold_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `validate_applied_rule` int(1) NOT NULL DEFAULT 0,
  `priority` varchar(140) DEFAULT NULL,
  `apply_discount_on_rate` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPromotional Scheme Product Discount`
--

DROP TABLE IF EXISTS `tabPromotional Scheme Product Discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPromotional Scheme Product Discount` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disable` int(1) NOT NULL DEFAULT 0,
  `apply_multiple_pricing_rules` int(1) NOT NULL DEFAULT 0,
  `rule_description` text DEFAULT NULL,
  `min_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `min_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `same_item` int(1) NOT NULL DEFAULT 0,
  `free_item` varchar(140) DEFAULT NULL,
  `free_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `free_item_uom` varchar(140) DEFAULT NULL,
  `free_item_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `round_free_qty` int(1) NOT NULL DEFAULT 0,
  `warehouse` varchar(140) DEFAULT NULL,
  `threshold_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `priority` varchar(140) DEFAULT NULL,
  `is_recursive` int(1) NOT NULL DEFAULT 0,
  `recurse_for` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `apply_recursion_over` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProperty Setter`
--

DROP TABLE IF EXISTS `tabProperty Setter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProperty Setter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_system_generated` int(1) NOT NULL DEFAULT 0,
  `doctype_or_field` varchar(140) DEFAULT NULL,
  `doc_type` varchar(140) DEFAULT NULL,
  `field_name` varchar(140) DEFAULT NULL,
  `row_name` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `property` varchar(140) DEFAULT NULL,
  `property_type` varchar(140) DEFAULT NULL,
  `value` text DEFAULT NULL,
  `default_value` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `doc_type` (`doc_type`),
  KEY `field_name` (`field_name`),
  KEY `property` (`property`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProspect`
--

DROP TABLE IF EXISTS `tabProspect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProspect` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company_name` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `no_of_employees` varchar(140) DEFAULT NULL,
  `annual_revenue` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `market_segment` varchar(140) DEFAULT NULL,
  `industry` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `prospect_owner` varchar(140) DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `fax` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `company_name` (`company_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProspect Lead`
--

DROP TABLE IF EXISTS `tabProspect Lead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProspect Lead` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `lead` varchar(140) DEFAULT NULL,
  `lead_name` varchar(140) DEFAULT NULL,
  `email` varchar(140) DEFAULT NULL,
  `mobile_no` varchar(140) DEFAULT NULL,
  `lead_owner` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabProspect Opportunity`
--

DROP TABLE IF EXISTS `tabProspect Opportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabProspect Opportunity` (
  `name` bigint(20) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `opportunity` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stage` varchar(140) DEFAULT NULL,
  `deal_owner` varchar(140) DEFAULT NULL,
  `probability` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expected_closing` date DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Invoice`
--

DROP TABLE IF EXISTS `tabPurchase Invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Invoice` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{supplier_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `tax_id` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `due_date` date DEFAULT NULL,
  `is_paid` int(1) NOT NULL DEFAULT 0,
  `is_return` int(1) NOT NULL DEFAULT 0,
  `return_against` varchar(140) DEFAULT NULL,
  `update_outstanding_for_self` int(1) NOT NULL DEFAULT 1,
  `update_billed_amount_in_purchase_order` int(1) NOT NULL DEFAULT 0,
  `update_billed_amount_in_purchase_receipt` int(1) NOT NULL DEFAULT 1,
  `apply_tds` int(1) NOT NULL DEFAULT 0,
  `tax_withholding_category` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `bill_no` varchar(140) DEFAULT NULL,
  `bill_date` date DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `use_transaction_date_exchange_rate` int(1) NOT NULL DEFAULT 0,
  `buying_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `update_stock` int(1) NOT NULL DEFAULT 0,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `set_from_warehouse` varchar(140) DEFAULT NULL,
  `is_subcontracted` int(1) NOT NULL DEFAULT 0,
  `rejected_warehouse` varchar(140) DEFAULT NULL,
  `supplier_warehouse` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_withholding_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_tax_withholding_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_category` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `base_taxes_and_charges_added` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_taxes_and_charges_deducted` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges_added` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges_deducted` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` varchar(240) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `use_company_roundoff_cost_center` int(1) NOT NULL DEFAULT 0,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `in_words` varchar(240) DEFAULT NULL,
  `total_advance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outstanding_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `other_charges_calculation` longtext DEFAULT NULL,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `base_paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `clearance_date` date DEFAULT NULL,
  `cash_bank_account` varchar(140) DEFAULT NULL,
  `paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allocate_advances_automatically` int(1) NOT NULL DEFAULT 0,
  `only_include_allocated_payments` int(1) NOT NULL DEFAULT 0,
  `write_off_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_write_off_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `write_off_account` varchar(140) DEFAULT NULL,
  `write_off_cost_center` varchar(140) DEFAULT NULL,
  `supplier_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` text DEFAULT NULL,
  `dispatch_address` varchar(140) DEFAULT NULL,
  `dispatch_address_display` longtext DEFAULT NULL,
  `shipping_address` varchar(140) DEFAULT NULL,
  `shipping_address_display` text DEFAULT NULL,
  `billing_address` varchar(140) DEFAULT NULL,
  `billing_address_display` text DEFAULT NULL,
  `payment_terms_template` varchar(140) DEFAULT NULL,
  `ignore_default_payment_terms_template` int(1) NOT NULL DEFAULT 0,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `per_received` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `credit_to` varchar(140) DEFAULT NULL,
  `party_account_currency` varchar(140) DEFAULT NULL,
  `is_opening` varchar(140) DEFAULT 'No',
  `against_expense_account` text DEFAULT NULL,
  `unrealized_profit_loss_account` varchar(140) DEFAULT NULL,
  `subscription` varchar(140) DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `on_hold` int(1) NOT NULL DEFAULT 0,
  `release_date` date DEFAULT NULL,
  `hold_comment` text DEFAULT NULL,
  `is_internal_supplier` int(1) NOT NULL DEFAULT 0,
  `represents_company` varchar(140) DEFAULT NULL,
  `supplier_group` varchar(140) DEFAULT NULL,
  `inter_company_invoice_reference` varchar(140) DEFAULT NULL,
  `is_old_subcontracting_flow` int(1) NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `supplier` (`supplier`),
  KEY `posting_date` (`posting_date`),
  KEY `return_against` (`return_against`),
  KEY `bill_no` (`bill_no`),
  KEY `credit_to` (`credit_to`),
  KEY `release_date` (`release_date`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Invoice Advance`
--

DROP TABLE IF EXISTS `tabPurchase Invoice Advance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Invoice Advance` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_type` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `reference_row` varchar(140) DEFAULT NULL,
  `advance_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `exchange_gain_loss` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ref_exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `difference_posting_date` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Invoice Item`
--

DROP TABLE IF EXISTS `tabPurchase Invoice Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Invoice Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `product_bundle` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `received_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rejected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `margin_type` varchar(140) DEFAULT NULL,
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `stock_uom_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `apply_tds` int(1) NOT NULL DEFAULT 1,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `sales_incoming_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `landed_cost_voucher_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rm_supp_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `warehouse` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `from_warehouse` varchar(140) DEFAULT NULL,
  `quality_inspection` varchar(140) DEFAULT NULL,
  `rejected_warehouse` varchar(140) DEFAULT NULL,
  `rejected_serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `rejected_serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `manufacturer` varchar(140) DEFAULT NULL,
  `manufacturer_part_no` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `wip_composite_asset` varchar(140) DEFAULT NULL,
  `is_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `asset_location` varchar(140) DEFAULT NULL,
  `asset_category` varchar(140) DEFAULT NULL,
  `deferred_expense_account` varchar(140) DEFAULT NULL,
  `service_stop_date` date DEFAULT NULL,
  `enable_deferred_expense` int(1) NOT NULL DEFAULT 0,
  `service_start_date` date DEFAULT NULL,
  `service_end_date` date DEFAULT NULL,
  `allow_zero_valuation_rate` int(1) NOT NULL DEFAULT 0,
  `item_tax_rate` longtext DEFAULT NULL,
  `bom` varchar(140) DEFAULT NULL,
  `include_exploded_items` int(1) NOT NULL DEFAULT 0,
  `purchase_invoice_item` varchar(140) DEFAULT NULL,
  `purchase_order` varchar(140) DEFAULT NULL,
  `po_detail` varchar(140) DEFAULT NULL,
  `purchase_receipt` varchar(140) DEFAULT NULL,
  `pr_detail` varchar(140) DEFAULT NULL,
  `sales_invoice_item` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `serial_and_batch_bundle` (`serial_and_batch_bundle`),
  KEY `batch_no` (`batch_no`),
  KEY `purchase_order` (`purchase_order`),
  KEY `po_detail` (`po_detail`),
  KEY `purchase_receipt` (`purchase_receipt`),
  KEY `pr_detail` (`pr_detail`),
  KEY `material_request` (`material_request`),
  KEY `material_request_item` (`material_request_item`),
  KEY `project` (`project`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Order`
--

DROP TABLE IF EXISTS `tabPurchase Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Order` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{supplier_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `order_confirmation_no` varchar(140) DEFAULT NULL,
  `order_confirmation_date` date DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `apply_tds` int(1) NOT NULL DEFAULT 0,
  `tax_withholding_category` varchar(140) DEFAULT NULL,
  `is_subcontracted` int(1) NOT NULL DEFAULT 0,
  `has_unit_price_items` int(1) NOT NULL DEFAULT 0,
  `supplier_warehouse` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `buying_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `set_from_warehouse` varchar(140) DEFAULT NULL,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_withholding_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_tax_withholding_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `set_reserve_warehouse` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `base_taxes_and_charges_added` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_taxes_and_charges_deducted` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges_added` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges_deducted` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` varchar(240) DEFAULT NULL,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `in_words` varchar(240) DEFAULT NULL,
  `advance_paid` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `other_charges_calculation` longtext DEFAULT NULL,
  `supplier_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` text DEFAULT NULL,
  `dispatch_address` varchar(140) DEFAULT NULL,
  `dispatch_address_display` longtext DEFAULT NULL,
  `shipping_address` varchar(140) DEFAULT NULL,
  `shipping_address_display` text DEFAULT NULL,
  `billing_address` varchar(140) DEFAULT NULL,
  `billing_address_display` text DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `customer_contact_person` varchar(140) DEFAULT NULL,
  `customer_contact_display` text DEFAULT NULL,
  `customer_contact_mobile` text DEFAULT NULL,
  `customer_contact_email` longtext DEFAULT NULL,
  `payment_terms_template` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `per_billed` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `per_received` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `letter_head` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `is_internal_supplier` int(1) NOT NULL DEFAULT 0,
  `represents_company` varchar(140) DEFAULT NULL,
  `ref_sq` varchar(140) DEFAULT NULL,
  `party_account_currency` varchar(140) DEFAULT NULL,
  `inter_company_order_reference` varchar(140) DEFAULT NULL,
  `is_old_subcontracting_flow` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `supplier` (`supplier`),
  KEY `transaction_date` (`transaction_date`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Order Item`
--

DROP TABLE IF EXISTS `tabPurchase Order Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Order Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fg_item` varchar(140) DEFAULT NULL,
  `fg_item_qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `item_code` varchar(140) DEFAULT NULL,
  `supplier_part_no` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `product_bundle` varchar(140) DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `expected_delivery_date` date DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `subcontracted_quantity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `last_purchase_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `margin_type` varchar(140) DEFAULT NULL,
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `stock_uom_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `apply_tds` int(1) NOT NULL DEFAULT 1,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `from_warehouse` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `company_total_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `sales_order_item` varchar(140) DEFAULT NULL,
  `sales_order_packed_item` varchar(140) DEFAULT NULL,
  `supplier_quotation` varchar(140) DEFAULT NULL,
  `supplier_quotation_item` varchar(140) DEFAULT NULL,
  `delivered_by_supplier` int(1) NOT NULL DEFAULT 0,
  `against_blanket_order` int(1) NOT NULL DEFAULT 0,
  `blanket_order` varchar(140) DEFAULT NULL,
  `blanket_order_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `received_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billed_amt` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `expense_account` varchar(140) DEFAULT NULL,
  `wip_composite_asset` varchar(140) DEFAULT NULL,
  `manufacturer` varchar(140) DEFAULT NULL,
  `manufacturer_part_no` varchar(140) DEFAULT NULL,
  `bom` varchar(140) DEFAULT NULL,
  `include_exploded_items` int(1) NOT NULL DEFAULT 0,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `is_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `item_tax_rate` longtext DEFAULT NULL,
  `production_plan` varchar(140) DEFAULT NULL,
  `production_plan_item` varchar(140) DEFAULT NULL,
  `production_plan_sub_assembly_item` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `expected_delivery_date` (`expected_delivery_date`),
  KEY `material_request` (`material_request`),
  KEY `material_request_item` (`material_request_item`),
  KEY `sales_order` (`sales_order`),
  KEY `sales_order_item` (`sales_order_item`),
  KEY `parent` (`parent`),
  KEY `item_code_warehouse_index` (`item_code`,`warehouse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Order Item Supplied`
--

DROP TABLE IF EXISTS `tabPurchase Order Item Supplied`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Order Item Supplied` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `main_item_code` varchar(140) DEFAULT NULL,
  `rm_item_code` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `reserve_warehouse` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `bom_detail_no` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `required_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `supplied_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `consumed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_supplied_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Receipt`
--

DROP TABLE IF EXISTS `tabPurchase Receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Receipt` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{supplier_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `supplier_delivery_note` varchar(140) DEFAULT NULL,
  `subcontracting_receipt` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `apply_putaway_rule` int(1) NOT NULL DEFAULT 0,
  `is_return` int(1) NOT NULL DEFAULT 0,
  `return_against` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `buying_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `set_from_warehouse` varchar(140) DEFAULT NULL,
  `rejected_warehouse` varchar(140) DEFAULT NULL,
  `is_subcontracted` int(1) NOT NULL DEFAULT 0,
  `supplier_warehouse` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_withholding_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_tax_withholding_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_category` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `base_taxes_and_charges_added` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_taxes_and_charges_deducted` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges_added` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges_deducted` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` varchar(240) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `in_words` varchar(240) DEFAULT NULL,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `other_charges_calculation` longtext DEFAULT NULL,
  `supplier_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` text DEFAULT NULL,
  `dispatch_address` varchar(140) DEFAULT NULL,
  `dispatch_address_display` longtext DEFAULT NULL,
  `shipping_address` varchar(140) DEFAULT NULL,
  `shipping_address_display` text DEFAULT NULL,
  `billing_address` varchar(140) DEFAULT NULL,
  `billing_address_display` text DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `per_billed` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `per_returned` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `transporter_name` varchar(140) DEFAULT NULL,
  `lr_no` varchar(140) DEFAULT NULL,
  `lr_date` date DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `is_internal_supplier` int(1) NOT NULL DEFAULT 0,
  `represents_company` varchar(140) DEFAULT NULL,
  `inter_company_reference` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `range` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `is_old_subcontracting_flow` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `supplier` (`supplier`),
  KEY `subcontracting_receipt` (`subcontracting_receipt`),
  KEY `posting_date` (`posting_date`),
  KEY `return_against` (`return_against`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Receipt Item`
--

DROP TABLE IF EXISTS `tabPurchase Receipt Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Receipt Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `barcode` varchar(140) DEFAULT NULL,
  `has_item_scanned` int(1) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `product_bundle` varchar(140) DEFAULT NULL,
  `supplier_part_no` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `received_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rejected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `retain_sample` int(1) NOT NULL DEFAULT 0,
  `sample_quantity` int(11) NOT NULL DEFAULT 0,
  `received_stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `margin_type` varchar(140) DEFAULT NULL,
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `stock_uom_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `apply_tds` int(1) NOT NULL DEFAULT 1,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `sales_incoming_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rm_supp_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `landed_cost_voucher_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount_difference_with_purchase_invoice` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billed_amt` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `warehouse` varchar(140) DEFAULT NULL,
  `rejected_warehouse` varchar(140) DEFAULT NULL,
  `from_warehouse` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `purchase_order` varchar(140) DEFAULT NULL,
  `purchase_invoice` varchar(140) DEFAULT NULL,
  `allow_zero_valuation_rate` int(1) NOT NULL DEFAULT 0,
  `return_qty_from_rejected_warehouse` int(1) NOT NULL DEFAULT 0,
  `is_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `asset_location` varchar(140) DEFAULT NULL,
  `asset_category` varchar(140) DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `quality_inspection` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `purchase_order_item` varchar(140) DEFAULT NULL,
  `purchase_invoice_item` varchar(140) DEFAULT NULL,
  `purchase_receipt_item` varchar(140) DEFAULT NULL,
  `delivery_note_item` varchar(140) DEFAULT NULL,
  `putaway_rule` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `rejected_serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `rejected_serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `include_exploded_items` int(1) NOT NULL DEFAULT 0,
  `bom` varchar(140) DEFAULT NULL,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `manufacturer` varchar(140) DEFAULT NULL,
  `manufacturer_part_no` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `item_tax_rate` longtext DEFAULT NULL,
  `wip_composite_asset` varchar(140) DEFAULT NULL,
  `provisional_expense_account` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `sales_order` varchar(140) DEFAULT NULL,
  `sales_order_item` varchar(140) DEFAULT NULL,
  `subcontracting_receipt_item` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `purchase_order` (`purchase_order`),
  KEY `purchase_order_item` (`purchase_order_item`),
  KEY `purchase_invoice_item` (`purchase_invoice_item`),
  KEY `purchase_receipt_item` (`purchase_receipt_item`),
  KEY `delivery_note_item` (`delivery_note_item`),
  KEY `serial_and_batch_bundle` (`serial_and_batch_bundle`),
  KEY `batch_no` (`batch_no`),
  KEY `sales_order` (`sales_order`),
  KEY `sales_order_item` (`sales_order_item`),
  KEY `subcontracting_receipt_item` (`subcontracting_receipt_item`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Receipt Item Supplied`
--

DROP TABLE IF EXISTS `tabPurchase Receipt Item Supplied`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Receipt Item Supplied` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `main_item_code` varchar(140) DEFAULT NULL,
  `rm_item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `bom_detail_no` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reference_name` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `required_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `consumed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `current_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `batch_no` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `purchase_order` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Taxes and Charges`
--

DROP TABLE IF EXISTS `tabPurchase Taxes and Charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Taxes and Charges` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `category` varchar(140) DEFAULT 'Total',
  `add_deduct_tax` varchar(140) DEFAULT 'Add',
  `charge_type` varchar(140) DEFAULT 'On Net Total',
  `row_id` varchar(140) DEFAULT NULL,
  `included_in_print_rate` int(1) NOT NULL DEFAULT 0,
  `included_in_paid_amount` int(1) NOT NULL DEFAULT 0,
  `account_head` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_tax_withholding_account` int(1) NOT NULL DEFAULT 0,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cost_center` varchar(140) DEFAULT NULL,
  `account_currency` varchar(140) DEFAULT NULL,
  `tax_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_amount_after_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_tax_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_tax_amount_after_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_wise_tax_detail` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPurchase Taxes and Charges Template`
--

DROP TABLE IF EXISTS `tabPurchase Taxes and Charges Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPurchase Taxes and Charges Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabPutaway Rule`
--

DROP TABLE IF EXISTS `tabPutaway Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabPutaway Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disable` int(1) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 1,
  `company` varchar(140) DEFAULT NULL,
  `capacity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `stock_capacity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Action`
--

DROP TABLE IF EXISTS `tabQuality Action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Action` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `corrective_preventive` varchar(140) DEFAULT 'Corrective',
  `review` varchar(140) DEFAULT NULL,
  `feedback` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Open',
  `date` date DEFAULT NULL,
  `goal` varchar(140) DEFAULT NULL,
  `procedure` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Action Resolution`
--

DROP TABLE IF EXISTS `tabQuality Action Resolution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Action Resolution` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `problem` longtext DEFAULT NULL,
  `resolution` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `responsible` varchar(140) DEFAULT NULL,
  `completion_by` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Feedback`
--

DROP TABLE IF EXISTS `tabQuality Feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Feedback` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `template` varchar(140) DEFAULT NULL,
  `document_type` varchar(140) DEFAULT NULL,
  `document_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Feedback Parameter`
--

DROP TABLE IF EXISTS `tabQuality Feedback Parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Feedback Parameter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `parameter` varchar(140) DEFAULT NULL,
  `rating` varchar(140) DEFAULT '1',
  `feedback` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Feedback Template`
--

DROP TABLE IF EXISTS `tabQuality Feedback Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Feedback Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `template` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `template` (`template`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Feedback Template Parameter`
--

DROP TABLE IF EXISTS `tabQuality Feedback Template Parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Feedback Template Parameter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `parameter` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Goal`
--

DROP TABLE IF EXISTS `tabQuality Goal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Goal` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `goal` varchar(140) DEFAULT NULL,
  `frequency` varchar(140) DEFAULT 'None',
  `procedure` varchar(140) DEFAULT NULL,
  `weekday` varchar(140) DEFAULT NULL,
  `date` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `goal` (`goal`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Goal Objective`
--

DROP TABLE IF EXISTS `tabQuality Goal Objective`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Goal Objective` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `objective` text DEFAULT NULL,
  `target` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Inspection`
--

DROP TABLE IF EXISTS `tabQuality Inspection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Inspection` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `report_date` date DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Accepted',
  `child_row_reference` varchar(140) DEFAULT NULL,
  `inspection_type` varchar(140) DEFAULT NULL,
  `reference_type` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_serial_no` varchar(140) DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `sample_size` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `bom_no` varchar(140) DEFAULT NULL,
  `quality_inspection_template` varchar(140) DEFAULT NULL,
  `manual_inspection` int(1) NOT NULL DEFAULT 0,
  `inspected_by` varchar(140) DEFAULT 'user',
  `verified_by` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `report_date` (`report_date`),
  KEY `item_code` (`item_code`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Inspection Parameter`
--

DROP TABLE IF EXISTS `tabQuality Inspection Parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Inspection Parameter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `parameter` varchar(140) DEFAULT NULL,
  `parameter_group` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `parameter` (`parameter`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Inspection Parameter Group`
--

DROP TABLE IF EXISTS `tabQuality Inspection Parameter Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Inspection Parameter Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `group_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `group_name` (`group_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Inspection Reading`
--

DROP TABLE IF EXISTS `tabQuality Inspection Reading`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Inspection Reading` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `specification` varchar(140) DEFAULT NULL,
  `parameter_group` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Accepted',
  `value` varchar(140) DEFAULT NULL,
  `numeric` int(1) NOT NULL DEFAULT 1,
  `manual_inspection` int(1) NOT NULL DEFAULT 0,
  `min_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `formula_based_criteria` int(1) NOT NULL DEFAULT 0,
  `acceptance_formula` longtext DEFAULT NULL,
  `reading_value` varchar(140) DEFAULT NULL,
  `reading_1` varchar(140) DEFAULT NULL,
  `reading_2` varchar(140) DEFAULT NULL,
  `reading_3` varchar(140) DEFAULT NULL,
  `reading_4` varchar(140) DEFAULT NULL,
  `reading_5` varchar(140) DEFAULT NULL,
  `reading_6` varchar(140) DEFAULT NULL,
  `reading_7` varchar(140) DEFAULT NULL,
  `reading_8` varchar(140) DEFAULT NULL,
  `reading_9` varchar(140) DEFAULT NULL,
  `reading_10` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Inspection Template`
--

DROP TABLE IF EXISTS `tabQuality Inspection Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Inspection Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `quality_inspection_template_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `quality_inspection_template_name` (`quality_inspection_template_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Meeting`
--

DROP TABLE IF EXISTS `tabQuality Meeting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Meeting` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT 'Open',
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Meeting Agenda`
--

DROP TABLE IF EXISTS `tabQuality Meeting Agenda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Meeting Agenda` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `agenda` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Meeting Minutes`
--

DROP TABLE IF EXISTS `tabQuality Meeting Minutes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Meeting Minutes` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `document_name` varchar(140) DEFAULT NULL,
  `minute` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Procedure`
--

DROP TABLE IF EXISTS `tabQuality Procedure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Procedure` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `quality_procedure_name` varchar(140) DEFAULT NULL,
  `process_owner` varchar(140) DEFAULT NULL,
  `process_owner_full_name` varchar(140) DEFAULT NULL,
  `parent_quality_procedure` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `lft` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `quality_procedure_name` (`quality_procedure_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Procedure Process`
--

DROP TABLE IF EXISTS `tabQuality Procedure Process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Procedure Process` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `process_description` longtext DEFAULT NULL,
  `procedure` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Review`
--

DROP TABLE IF EXISTS `tabQuality Review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Review` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `goal` varchar(140) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `procedure` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Open',
  `additional_information` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuality Review Objective`
--

DROP TABLE IF EXISTS `tabQuality Review Objective`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuality Review Objective` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `objective` text DEFAULT NULL,
  `target` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Open',
  `review` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuery Parameters`
--

DROP TABLE IF EXISTS `tabQuery Parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuery Parameters` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `key` varchar(140) DEFAULT NULL,
  `value` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuotation`
--

DROP TABLE IF EXISTS `tabQuotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuotation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{customer_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `quotation_to` varchar(140) DEFAULT 'Customer',
  `party_name` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `valid_till` date DEFAULT NULL,
  `order_type` varchar(140) DEFAULT 'Sales',
  `company` varchar(140) DEFAULT NULL,
  `has_unit_price_items` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `selling_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_category` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` varchar(240) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `in_words` varchar(240) DEFAULT NULL,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `coupon_code` varchar(140) DEFAULT NULL,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `referral_sales_partner` varchar(140) DEFAULT NULL,
  `other_charges_calculation` longtext DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `shipping_address_name` varchar(140) DEFAULT NULL,
  `shipping_address` text DEFAULT NULL,
  `company_address` varchar(140) DEFAULT NULL,
  `company_address_display` text DEFAULT NULL,
  `company_contact_person` varchar(140) DEFAULT NULL,
  `payment_terms_template` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `order_lost_reason` text DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `customer_group` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `source` varchar(140) DEFAULT NULL,
  `opportunity` varchar(140) DEFAULT NULL,
  `supplier_quotation` varchar(140) DEFAULT NULL,
  `enq_det` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `party_name` (`party_name`),
  KEY `transaction_date` (`transaction_date`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuotation Item`
--

DROP TABLE IF EXISTS `tabQuotation Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuotation Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `customer_item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `company_total_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `margin_type` varchar(140) DEFAULT NULL,
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `stock_uom_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `is_alternative` int(1) NOT NULL DEFAULT 0,
  `has_alternative_item` int(1) NOT NULL DEFAULT 0,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `gross_profit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `against_blanket_order` int(1) NOT NULL DEFAULT 0,
  `blanket_order` varchar(140) DEFAULT NULL,
  `blanket_order_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `prevdoc_doctype` varchar(140) DEFAULT NULL,
  `prevdoc_docname` varchar(140) DEFAULT NULL,
  `projected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_rate` longtext DEFAULT NULL,
  `additional_notes` text DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuotation Lost Reason`
--

DROP TABLE IF EXISTS `tabQuotation Lost Reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuotation Lost Reason` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `order_lost_reason` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `order_lost_reason` (`order_lost_reason`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabQuotation Lost Reason Detail`
--

DROP TABLE IF EXISTS `tabQuotation Lost Reason Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabQuotation Lost Reason Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `lost_reason` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabReminder`
--

DROP TABLE IF EXISTS `tabReminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabReminder` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `remind_at` datetime(6) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `reminder_doctype` varchar(140) DEFAULT NULL,
  `reminder_docname` varchar(140) DEFAULT NULL,
  `notified` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `user` (`user`),
  KEY `remind_at` (`remind_at`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabReport`
--

DROP TABLE IF EXISTS `tabReport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabReport` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `report_name` varchar(140) DEFAULT NULL,
  `ref_doctype` varchar(140) DEFAULT NULL,
  `reference_report` varchar(140) DEFAULT NULL,
  `is_standard` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `report_type` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `add_total_row` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `prepared_report` int(1) NOT NULL DEFAULT 0,
  `timeout` int(11) NOT NULL DEFAULT 0,
  `query` longtext DEFAULT NULL,
  `report_script` longtext DEFAULT NULL,
  `javascript` longtext DEFAULT NULL,
  `json` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `add_translate_data` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  UNIQUE KEY `report_name` (`report_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabReport Column`
--

DROP TABLE IF EXISTS `tabReport Column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabReport Column` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fieldname` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT NULL,
  `options` varchar(140) DEFAULT NULL,
  `width` int(11) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabReport Filter`
--

DROP TABLE IF EXISTS `tabReport Filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabReport Filter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT NULL,
  `fieldname` varchar(140) DEFAULT NULL,
  `mandatory` int(1) NOT NULL DEFAULT 0,
  `wildcard_filter` int(1) NOT NULL DEFAULT 0,
  `options` text DEFAULT NULL,
  `default` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRepost Accounting Ledger`
--

DROP TABLE IF EXISTS `tabRepost Accounting Ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRepost Accounting Ledger` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `delete_cancelled_entries` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRepost Accounting Ledger Items`
--

DROP TABLE IF EXISTS `tabRepost Accounting Ledger Items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRepost Accounting Ledger Items` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRepost Allowed Types`
--

DROP TABLE IF EXISTS `tabRepost Allowed Types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRepost Allowed Types` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `allowed` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRepost Item Valuation`
--

DROP TABLE IF EXISTS `tabRepost Item Valuation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRepost Item Valuation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `based_on` varchar(140) DEFAULT 'Transaction',
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Queued',
  `company` varchar(140) DEFAULT NULL,
  `allow_negative_stock` int(1) NOT NULL DEFAULT 1,
  `via_landed_cost_voucher` int(1) NOT NULL DEFAULT 0,
  `allow_zero_rate` int(1) NOT NULL DEFAULT 0,
  `recreate_stock_ledgers` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `error_log` longtext DEFAULT NULL,
  `reposting_data_file` text DEFAULT NULL,
  `items_to_be_repost` longtext DEFAULT NULL,
  `distinct_item_and_warehouse` longtext DEFAULT NULL,
  `total_reposting_count` int(11) NOT NULL DEFAULT 0,
  `current_index` int(11) NOT NULL DEFAULT 0,
  `gl_reposting_index` int(11) NOT NULL DEFAULT 0,
  `affected_transactions` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`),
  KEY `item_warehouse` (`warehouse`,`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRepost Payment Ledger`
--

DROP TABLE IF EXISTS `tabRepost Payment Ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRepost Payment Ledger` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `voucher_type` varchar(140) DEFAULT NULL,
  `add_manually` int(1) NOT NULL DEFAULT 0,
  `repost_status` varchar(140) DEFAULT NULL,
  `repost_error_log` longtext DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRepost Payment Ledger Items`
--

DROP TABLE IF EXISTS `tabRepost Payment Ledger Items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRepost Payment Ledger Items` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRequest for Quotation`
--

DROP TABLE IF EXISTS `tabRequest for Quotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRequest for Quotation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `billing_address` varchar(140) DEFAULT NULL,
  `billing_address_display` text DEFAULT NULL,
  `vendor` varchar(140) DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `has_unit_price_items` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `email_template` varchar(140) DEFAULT NULL,
  `send_attached_files` int(1) NOT NULL DEFAULT 1,
  `send_document_print` int(1) NOT NULL DEFAULT 0,
  `message_for_supplier` longtext DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `opportunity` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `company` (`company`),
  KEY `transaction_date` (`transaction_date`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRequest for Quotation Item`
--

DROP TABLE IF EXISTS `tabRequest for Quotation Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRequest for Quotation Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `supplier_part_no` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `warehouse` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `project_name` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `item_name` (`item_name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRequest for Quotation Supplier`
--

DROP TABLE IF EXISTS `tabRequest for Quotation Supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRequest for Quotation Supplier` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `supplier` varchar(140) DEFAULT NULL,
  `contact` varchar(140) DEFAULT NULL,
  `quote_status` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `email_id` varchar(140) DEFAULT NULL,
  `send_email` int(1) NOT NULL DEFAULT 1,
  `email_sent` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabReview Level`
--

DROP TABLE IF EXISTS `tabReview Level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabReview Level` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `level_name` varchar(140) DEFAULT NULL,
  `role` varchar(140) DEFAULT NULL,
  `review_points` int(11) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `level_name` (`level_name`),
  UNIQUE KEY `role` (`role`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRole`
--

DROP TABLE IF EXISTS `tabRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRole` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `role_name` varchar(140) DEFAULT NULL,
  `home_page` varchar(140) DEFAULT NULL,
  `restrict_to_domain` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `is_custom` int(1) NOT NULL DEFAULT 0,
  `desk_access` int(1) NOT NULL DEFAULT 1,
  `two_factor_auth` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `role_name` (`role_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRole Profile`
--

DROP TABLE IF EXISTS `tabRole Profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRole Profile` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `role_profile` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `role_profile` (`role_profile`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRoute History`
--

DROP TABLE IF EXISTS `tabRoute History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRoute History` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `route` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabRouting`
--

DROP TABLE IF EXISTS `tabRouting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabRouting` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `routing_name` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `routing_name` (`routing_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSLA Fulfilled On Status`
--

DROP TABLE IF EXISTS `tabSLA Fulfilled On Status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSLA Fulfilled On Status` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSMS Log`
--

DROP TABLE IF EXISTS `tabSMS Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSMS Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sender_name` varchar(140) DEFAULT NULL,
  `sent_on` date DEFAULT NULL,
  `message` text DEFAULT NULL,
  `no_of_requested_sms` int(11) NOT NULL DEFAULT 0,
  `requested_numbers` longtext DEFAULT NULL,
  `no_of_sent_sms` int(11) NOT NULL DEFAULT 0,
  `sent_to` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSMS Parameter`
--

DROP TABLE IF EXISTS `tabSMS Parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSMS Parameter` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `parameter` varchar(140) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `header` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Invoice`
--

DROP TABLE IF EXISTS `tabSales Invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Invoice` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{customer_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` text DEFAULT NULL,
  `tax_id` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `company_tax_id` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `due_date` date DEFAULT NULL,
  `is_pos` int(1) NOT NULL DEFAULT 0,
  `pos_profile` varchar(140) DEFAULT NULL,
  `is_consolidated` int(1) NOT NULL DEFAULT 0,
  `is_return` int(1) NOT NULL DEFAULT 0,
  `return_against` varchar(140) DEFAULT NULL,
  `update_outstanding_for_self` int(1) NOT NULL DEFAULT 1,
  `update_billed_amount_in_sales_order` int(1) NOT NULL DEFAULT 0,
  `update_billed_amount_in_delivery_note` int(1) NOT NULL DEFAULT 1,
  `is_debit_note` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `selling_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `update_stock` int(1) NOT NULL DEFAULT 0,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `set_target_warehouse` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_category` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` text DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `use_company_roundoff_cost_center` int(1) NOT NULL DEFAULT 0,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `in_words` text DEFAULT NULL,
  `total_advance` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outstanding_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `apply_discount_on` varchar(15) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_cash_or_non_trade_discount` int(1) NOT NULL DEFAULT 0,
  `additional_discount_account` varchar(140) DEFAULT NULL,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `other_charges_calculation` longtext DEFAULT NULL,
  `total_billing_hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_billing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cash_bank_account` varchar(140) DEFAULT NULL,
  `base_paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `paid_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_change_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `change_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `account_for_change_amount` varchar(140) DEFAULT NULL,
  `allocate_advances_automatically` int(1) NOT NULL DEFAULT 0,
  `only_include_allocated_payments` int(1) NOT NULL DEFAULT 0,
  `write_off_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_write_off_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `write_off_outstanding_amount_automatically` int(1) NOT NULL DEFAULT 0,
  `write_off_account` varchar(140) DEFAULT NULL,
  `write_off_cost_center` varchar(140) DEFAULT NULL,
  `redeem_loyalty_points` int(1) NOT NULL DEFAULT 0,
  `loyalty_points` int(11) NOT NULL DEFAULT 0,
  `loyalty_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `loyalty_program` varchar(140) DEFAULT NULL,
  `loyalty_redemption_account` varchar(140) DEFAULT NULL,
  `loyalty_redemption_cost_center` varchar(140) DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `shipping_address_name` varchar(140) DEFAULT NULL,
  `shipping_address` text DEFAULT NULL,
  `dispatch_address_name` varchar(140) DEFAULT NULL,
  `dispatch_address` text DEFAULT NULL,
  `company_address` varchar(140) DEFAULT NULL,
  `company_address_display` text DEFAULT NULL,
  `company_contact_person` varchar(140) DEFAULT NULL,
  `ignore_default_payment_terms_template` int(1) NOT NULL DEFAULT 0,
  `payment_terms_template` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `po_no` varchar(140) DEFAULT NULL,
  `po_date` date DEFAULT NULL,
  `debit_to` varchar(140) DEFAULT NULL,
  `party_account_currency` varchar(140) DEFAULT NULL,
  `is_opening` varchar(4) DEFAULT 'No',
  `unrealized_profit_loss_account` varchar(140) DEFAULT NULL,
  `against_income_account` text DEFAULT NULL,
  `sales_partner` varchar(140) DEFAULT NULL,
  `amount_eligible_for_commission` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `commission_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_commission` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `letter_head` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `language` varchar(6) DEFAULT NULL,
  `subscription` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `status` varchar(30) DEFAULT 'Draft',
  `inter_company_invoice_reference` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `represents_company` varchar(140) DEFAULT NULL,
  `source` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `is_internal_customer` int(1) NOT NULL DEFAULT 0,
  `is_discounted` int(1) NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer` (`customer`),
  KEY `posting_date` (`posting_date`),
  KEY `return_against` (`return_against`),
  KEY `project` (`project`),
  KEY `debit_to` (`debit_to`),
  KEY `inter_company_invoice_reference` (`inter_company_invoice_reference`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Invoice Advance`
--

DROP TABLE IF EXISTS `tabSales Invoice Advance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Invoice Advance` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `reference_type` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `reference_row` varchar(140) DEFAULT NULL,
  `advance_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `exchange_gain_loss` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ref_exchange_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `difference_posting_date` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Invoice Item`
--

DROP TABLE IF EXISTS `tabSales Invoice Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Invoice Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `barcode` varchar(140) DEFAULT NULL,
  `has_item_scanned` int(1) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `customer_item_code` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `margin_type` varchar(140) DEFAULT NULL,
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `stock_uom_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `grant_commission` int(1) NOT NULL DEFAULT 0,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `delivered_by_supplier` int(1) NOT NULL DEFAULT 0,
  `income_account` varchar(140) DEFAULT NULL,
  `is_fixed_asset` int(1) NOT NULL DEFAULT 0,
  `asset` varchar(140) DEFAULT NULL,
  `finance_book` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `discount_account` varchar(140) DEFAULT NULL,
  `deferred_revenue_account` varchar(140) DEFAULT NULL,
  `service_stop_date` date DEFAULT NULL,
  `enable_deferred_revenue` int(1) NOT NULL DEFAULT 0,
  `service_start_date` date DEFAULT NULL,
  `service_end_date` date DEFAULT NULL,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `target_warehouse` varchar(140) DEFAULT NULL,
  `quality_inspection` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `allow_zero_valuation_rate` int(1) NOT NULL DEFAULT 0,
  `incoming_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_rate` text DEFAULT NULL,
  `actual_batch_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `company_total_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `sales_order` varchar(140) DEFAULT NULL,
  `so_detail` varchar(140) DEFAULT NULL,
  `sales_invoice_item` varchar(140) DEFAULT NULL,
  `delivery_note` varchar(140) DEFAULT NULL,
  `dn_detail` varchar(140) DEFAULT NULL,
  `delivered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pos_invoice` varchar(140) DEFAULT NULL,
  `pos_invoice_item` varchar(140) DEFAULT NULL,
  `purchase_order` varchar(140) DEFAULT NULL,
  `purchase_order_item` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `serial_and_batch_bundle` (`serial_and_batch_bundle`),
  KEY `batch_no` (`batch_no`),
  KEY `sales_order` (`sales_order`),
  KEY `so_detail` (`so_detail`),
  KEY `delivery_note` (`delivery_note`),
  KEY `dn_detail` (`dn_detail`),
  KEY `pos_invoice` (`pos_invoice`),
  KEY `purchase_order` (`purchase_order`),
  KEY `project` (`project`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Invoice Payment`
--

DROP TABLE IF EXISTS `tabSales Invoice Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Invoice Payment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `default` int(1) NOT NULL DEFAULT 0,
  `mode_of_payment` varchar(140) DEFAULT NULL,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reference_no` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `clearance_date` date DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Invoice Timesheet`
--

DROP TABLE IF EXISTS `tabSales Invoice Timesheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Invoice Timesheet` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `activity_type` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `from_time` datetime(6) DEFAULT NULL,
  `to_time` datetime(6) DEFAULT NULL,
  `billing_hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `time_sheet` varchar(140) DEFAULT NULL,
  `timesheet_detail` varchar(140) DEFAULT NULL,
  `project_name` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Order`
--

DROP TABLE IF EXISTS `tabSales Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Order` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{customer_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `tax_id` varchar(140) DEFAULT NULL,
  `order_type` varchar(140) DEFAULT 'Sales',
  `transaction_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `po_no` varchar(140) DEFAULT NULL,
  `po_date` date DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `skip_delivery_note` int(1) NOT NULL DEFAULT 0,
  `has_unit_price_items` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `selling_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `reserve_stock` int(1) NOT NULL DEFAULT 0,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_category` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` varchar(240) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `in_words` varchar(240) DEFAULT NULL,
  `advance_paid` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `coupon_code` varchar(140) DEFAULT NULL,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `other_charges_calculation` longtext DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_phone` varchar(140) DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `shipping_address_name` varchar(140) DEFAULT NULL,
  `shipping_address` text DEFAULT NULL,
  `dispatch_address_name` varchar(140) DEFAULT NULL,
  `dispatch_address` text DEFAULT NULL,
  `company_address` varchar(140) DEFAULT NULL,
  `company_address_display` text DEFAULT NULL,
  `company_contact_person` varchar(140) DEFAULT NULL,
  `payment_terms_template` varchar(140) DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `delivery_status` varchar(140) DEFAULT NULL,
  `per_delivered` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `per_billed` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `per_picked` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billing_status` varchar(140) DEFAULT NULL,
  `sales_partner` varchar(140) DEFAULT NULL,
  `amount_eligible_for_commission` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `commission_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_commission` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `loyalty_points` int(11) NOT NULL DEFAULT 0,
  `loyalty_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `is_internal_customer` int(1) NOT NULL DEFAULT 0,
  `represents_company` varchar(140) DEFAULT NULL,
  `source` varchar(140) DEFAULT NULL,
  `inter_company_order_reference` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `party_account_currency` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `customer` (`customer`),
  KEY `transaction_date` (`transaction_date`),
  KEY `project` (`project`),
  KEY `status` (`status`),
  KEY `inter_company_order_reference` (`inter_company_order_reference`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Order Item`
--

DROP TABLE IF EXISTS `tabSales Order Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Order Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `customer_item_code` varchar(140) DEFAULT NULL,
  `ensure_delivery_based_on_produced_serial_no` int(1) NOT NULL DEFAULT 0,
  `is_stock_item` int(1) NOT NULL DEFAULT 0,
  `reserve_stock` int(1) NOT NULL DEFAULT 1,
  `delivery_date` date DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_reserved_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `margin_type` varchar(140) DEFAULT NULL,
  `margin_rate_or_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rate_with_margin` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `stock_uom_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `grant_commission` int(1) NOT NULL DEFAULT 0,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billed_amt` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `gross_profit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `delivered_by_supplier` int(1) NOT NULL DEFAULT 0,
  `supplier` varchar(140) DEFAULT NULL,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `target_warehouse` varchar(140) DEFAULT NULL,
  `prevdoc_docname` varchar(140) DEFAULT NULL,
  `quotation_item` varchar(140) DEFAULT NULL,
  `against_blanket_order` int(1) NOT NULL DEFAULT 0,
  `blanket_order` varchar(140) DEFAULT NULL,
  `blanket_order_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `company_total_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `bom_no` varchar(140) DEFAULT NULL,
  `projected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ordered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `planned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `production_plan_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `work_order_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `delivered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `produced_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `picked_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_notes` text DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `item_tax_rate` longtext DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `purchase_order` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `purchase_order_item` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `prevdoc_docname` (`prevdoc_docname`),
  KEY `purchase_order` (`purchase_order`),
  KEY `project` (`project`),
  KEY `parent` (`parent`),
  KEY `item_code_warehouse_index` (`item_code`,`warehouse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Partner`
--

DROP TABLE IF EXISTS `tabSales Partner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Partner` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `partner_name` varchar(140) DEFAULT NULL,
  `partner_type` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `commission_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `show_in_website` int(1) NOT NULL DEFAULT 0,
  `referral_code` varchar(8) DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `logo` text DEFAULT NULL,
  `partner_website` varchar(140) DEFAULT NULL,
  `introduction` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `partner_name` (`partner_name`),
  UNIQUE KEY `referral_code` (`referral_code`),
  UNIQUE KEY `route` (`route`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Partner Item`
--

DROP TABLE IF EXISTS `tabSales Partner Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Partner Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sales_partner` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Partner Type`
--

DROP TABLE IF EXISTS `tabSales Partner Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Partner Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sales_partner_type` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `sales_partner_type` (`sales_partner_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Person`
--

DROP TABLE IF EXISTS `tabSales Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Person` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sales_person_name` varchar(140) DEFAULT NULL,
  `parent_sales_person` varchar(140) DEFAULT NULL,
  `commission_rate` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `employee` varchar(140) DEFAULT NULL,
  `department` varchar(140) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `sales_person_name` (`sales_person_name`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Stage`
--

DROP TABLE IF EXISTS `tabSales Stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Stage` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `stage_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `stage_name` (`stage_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Taxes and Charges`
--

DROP TABLE IF EXISTS `tabSales Taxes and Charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Taxes and Charges` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `charge_type` varchar(140) DEFAULT NULL,
  `row_id` varchar(140) DEFAULT NULL,
  `account_head` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `included_in_print_rate` int(1) NOT NULL DEFAULT 0,
  `included_in_paid_amount` int(1) NOT NULL DEFAULT 0,
  `cost_center` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `account_currency` varchar(140) DEFAULT NULL,
  `tax_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_amount_after_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_tax_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_tax_amount_after_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_wise_tax_detail` longtext DEFAULT NULL,
  `dont_recompute_tax` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `account_head` (`account_head`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Taxes and Charges Template`
--

DROP TABLE IF EXISTS `tabSales Taxes and Charges Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Taxes and Charges Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSales Team`
--

DROP TABLE IF EXISTS `tabSales Team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSales Team` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `sales_person` varchar(140) DEFAULT NULL,
  `contact_no` varchar(140) DEFAULT NULL,
  `allocated_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `commission_rate` varchar(140) DEFAULT NULL,
  `incentives` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `sales_person` (`sales_person`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSalutation`
--

DROP TABLE IF EXISTS `tabSalutation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSalutation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `salutation` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `salutation` (`salutation`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabScheduled Job Log`
--

DROP TABLE IF EXISTS `tabScheduled Job Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabScheduled Job Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT NULL,
  `scheduled_job_type` varchar(140) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `debug_log` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabScheduled Job Type`
--

DROP TABLE IF EXISTS `tabScheduled Job Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabScheduled Job Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `stopped` int(1) NOT NULL DEFAULT 0,
  `method` varchar(140) DEFAULT NULL,
  `server_script` varchar(140) DEFAULT NULL,
  `frequency` varchar(140) DEFAULT NULL,
  `cron_format` varchar(140) DEFAULT NULL,
  `create_log` int(1) NOT NULL DEFAULT 0,
  `last_execution` datetime(6) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `scheduler_event` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `server_script` (`server_script`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabScheduler Event`
--

DROP TABLE IF EXISTS `tabScheduler Event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabScheduler Event` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `scheduled_against` varchar(140) DEFAULT NULL,
  `method` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSerial No`
--

DROP TABLE IF EXISTS `tabSerial No`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSerial No` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `serial_no` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `purchase_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `customer` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `asset` varchar(140) DEFAULT NULL,
  `asset_status` varchar(140) DEFAULT NULL,
  `location` varchar(140) DEFAULT NULL,
  `employee` varchar(140) DEFAULT NULL,
  `warranty_expiry_date` date DEFAULT NULL,
  `amc_expiry_date` date DEFAULT NULL,
  `maintenance_status` varchar(140) DEFAULT NULL,
  `warranty_period` int(11) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `work_order` varchar(140) DEFAULT NULL,
  `purchase_document_no` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `serial_no` (`serial_no`),
  KEY `maintenance_status` (`maintenance_status`),
  KEY `company` (`company`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSerial and Batch Bundle`
--

DROP TABLE IF EXISTS `tabSerial and Batch Bundle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSerial and Batch Bundle` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT 'SABB-.########',
  `company` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `has_serial_no` int(1) NOT NULL DEFAULT 0,
  `has_batch_no` int(1) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `type_of_transaction` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_group` varchar(140) DEFAULT NULL,
  `avg_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `voucher_detail_no` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `returned_against` varchar(140) DEFAULT NULL,
  `is_cancelled` int(1) NOT NULL DEFAULT 0,
  `is_rejected` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `company` (`company`),
  KEY `item_code` (`item_code`),
  KEY `warehouse` (`warehouse`),
  KEY `type_of_transaction` (`type_of_transaction`),
  KEY `voucher_no` (`voucher_no`),
  KEY `voucher_detail_no` (`voucher_detail_no`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSerial and Batch Entry`
--

DROP TABLE IF EXISTS `tabSerial and Batch Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSerial and Batch Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `serial_no` varchar(140) DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `warehouse` varchar(140) DEFAULT NULL,
  `delivered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `incoming_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outgoing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_value_difference` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `is_outward` int(1) NOT NULL DEFAULT 0,
  `stock_queue` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `serial_no` (`serial_no`),
  KEY `batch_no` (`batch_no`),
  KEY `warehouse` (`warehouse`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSeries`
--

DROP TABLE IF EXISTS `tabSeries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSeries` (
  `name` varchar(100) NOT NULL,
  `current` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabServer Script`
--

DROP TABLE IF EXISTS `tabServer Script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabServer Script` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `script_type` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `event_frequency` varchar(140) DEFAULT NULL,
  `cron_format` varchar(140) DEFAULT NULL,
  `doctype_event` varchar(140) DEFAULT NULL,
  `api_method` varchar(140) DEFAULT NULL,
  `allow_guest` int(1) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `script` longtext DEFAULT NULL,
  `enable_rate_limit` int(1) NOT NULL DEFAULT 0,
  `rate_limit_count` int(11) NOT NULL DEFAULT 5,
  `rate_limit_seconds` int(11) NOT NULL DEFAULT 86400,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_doctype` (`reference_doctype`),
  KEY `module` (`module`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabService Day`
--

DROP TABLE IF EXISTS `tabService Day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabService Day` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `workday` varchar(140) DEFAULT NULL,
  `start_time` time(6) DEFAULT NULL,
  `end_time` time(6) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabService Level Agreement`
--

DROP TABLE IF EXISTS `tabService Level Agreement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabService Level Agreement` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `default_priority` varchar(140) DEFAULT NULL,
  `service_level` varchar(140) DEFAULT NULL,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `default_service_level_agreement` int(1) NOT NULL DEFAULT 0,
  `entity_type` varchar(140) DEFAULT NULL,
  `entity` varchar(140) DEFAULT NULL,
  `condition` longtext DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `apply_sla_for_resolution` int(1) NOT NULL DEFAULT 1,
  `holiday_list` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabService Level Priority`
--

DROP TABLE IF EXISTS `tabService Level Priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabService Level Priority` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `default_priority` int(1) NOT NULL DEFAULT 0,
  `priority` varchar(140) DEFAULT NULL,
  `response_time` decimal(21,9) DEFAULT NULL,
  `resolution_time` decimal(21,9) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSession Default`
--

DROP TABLE IF EXISTS `tabSession Default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSession Default` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `ref_doctype` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSessions`
--

DROP TABLE IF EXISTS `tabSessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSessions` (
  `user` varchar(255) DEFAULT NULL,
  `sid` varchar(255) DEFAULT NULL,
  `sessiondata` longtext DEFAULT NULL,
  `ipaddress` varchar(16) DEFAULT NULL,
  `lastupdate` datetime(6) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  KEY `sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSettings`
--

DROP TABLE IF EXISTS `tabSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSettings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `token` varchar(140) DEFAULT NULL,
  `version_id` varchar(140) DEFAULT NULL,
  `prediction_url` varchar(140) DEFAULT NULL,
  `hf_token` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShare Balance`
--

DROP TABLE IF EXISTS `tabShare Balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShare Balance` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `share_type` varchar(140) DEFAULT NULL,
  `from_no` int(11) NOT NULL DEFAULT 0,
  `rate` int(11) NOT NULL DEFAULT 0,
  `no_of_shares` int(11) NOT NULL DEFAULT 0,
  `to_no` int(11) NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `is_company` int(1) NOT NULL DEFAULT 0,
  `current_state` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShare Transfer`
--

DROP TABLE IF EXISTS `tabShare Transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShare Transfer` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `transfer_type` varchar(140) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `from_shareholder` varchar(140) DEFAULT NULL,
  `from_folio_no` varchar(140) DEFAULT NULL,
  `to_shareholder` varchar(140) DEFAULT NULL,
  `to_folio_no` varchar(140) DEFAULT NULL,
  `equity_or_liability_account` varchar(140) DEFAULT NULL,
  `asset_account` varchar(140) DEFAULT NULL,
  `share_type` varchar(140) DEFAULT NULL,
  `from_no` int(11) NOT NULL DEFAULT 0,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `no_of_shares` int(11) NOT NULL DEFAULT 0,
  `to_no` int(11) NOT NULL DEFAULT 0,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `company` varchar(140) DEFAULT NULL,
  `remarks` longtext DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShare Type`
--

DROP TABLE IF EXISTS `tabShare Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShare Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `title` (`title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShareholder`
--

DROP TABLE IF EXISTS `tabShareholder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShareholder` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `folio_no` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `is_company` int(1) NOT NULL DEFAULT 0,
  `contact_list` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `folio_no` (`folio_no`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShipment`
--

DROP TABLE IF EXISTS `tabShipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShipment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `pickup_from_type` varchar(140) DEFAULT 'Company',
  `pickup_company` varchar(140) DEFAULT NULL,
  `pickup_customer` varchar(140) DEFAULT NULL,
  `pickup_supplier` varchar(140) DEFAULT NULL,
  `pickup` varchar(140) DEFAULT NULL,
  `pickup_address_name` varchar(140) DEFAULT NULL,
  `pickup_address` text DEFAULT NULL,
  `pickup_contact_person` varchar(140) DEFAULT NULL,
  `pickup_contact_name` varchar(140) DEFAULT NULL,
  `pickup_contact_email` varchar(140) DEFAULT NULL,
  `pickup_contact` text DEFAULT NULL,
  `delivery_to_type` varchar(140) DEFAULT 'Customer',
  `delivery_company` varchar(140) DEFAULT NULL,
  `delivery_customer` varchar(140) DEFAULT NULL,
  `delivery_supplier` varchar(140) DEFAULT NULL,
  `delivery_to` varchar(140) DEFAULT NULL,
  `delivery_address_name` varchar(140) DEFAULT NULL,
  `delivery_address` text DEFAULT NULL,
  `delivery_contact_name` varchar(140) DEFAULT NULL,
  `delivery_contact_email` varchar(140) DEFAULT NULL,
  `delivery_contact` text DEFAULT NULL,
  `parcel_template` varchar(140) DEFAULT NULL,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pallets` varchar(140) DEFAULT 'No',
  `value_of_goods` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pickup_date` date DEFAULT NULL,
  `pickup_from` time(6) DEFAULT '09:00:00.000000',
  `pickup_to` time(6) DEFAULT '17:00:00.000000',
  `shipment_type` varchar(140) DEFAULT 'Goods',
  `pickup_type` varchar(140) DEFAULT 'Pickup',
  `incoterm` varchar(140) DEFAULT NULL,
  `description_of_content` text DEFAULT NULL,
  `service_provider` varchar(140) DEFAULT NULL,
  `shipment_id` varchar(140) DEFAULT NULL,
  `shipment_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `status` varchar(140) DEFAULT NULL,
  `tracking_url` text DEFAULT NULL,
  `carrier` varchar(140) DEFAULT NULL,
  `carrier_service` varchar(140) DEFAULT NULL,
  `awb_number` varchar(140) DEFAULT NULL,
  `tracking_status` varchar(140) DEFAULT NULL,
  `tracking_status_info` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShipment Delivery Note`
--

DROP TABLE IF EXISTS `tabShipment Delivery Note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShipment Delivery Note` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `delivery_note` varchar(140) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShipment Parcel`
--

DROP TABLE IF EXISTS `tabShipment Parcel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShipment Parcel` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `length` int(11) NOT NULL DEFAULT 0,
  `width` int(11) NOT NULL DEFAULT 0,
  `height` int(11) NOT NULL DEFAULT 0,
  `weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `count` int(11) NOT NULL DEFAULT 1,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShipment Parcel Template`
--

DROP TABLE IF EXISTS `tabShipment Parcel Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShipment Parcel Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `parcel_template_name` varchar(140) DEFAULT NULL,
  `length` int(11) NOT NULL DEFAULT 0,
  `width` int(11) NOT NULL DEFAULT 0,
  `height` int(11) NOT NULL DEFAULT 0,
  `weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `parcel_template_name` (`parcel_template_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShipping Rule`
--

DROP TABLE IF EXISTS `tabShipping Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShipping Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `shipping_rule_type` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `calculate_based_on` varchar(140) DEFAULT 'Fixed',
  `shipping_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `label` (`label`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShipping Rule Condition`
--

DROP TABLE IF EXISTS `tabShipping Rule Condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShipping Rule Condition` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `from_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `to_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `shipping_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabShipping Rule Country`
--

DROP TABLE IF EXISTS `tabShipping Rule Country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabShipping Rule Country` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `country` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSingles`
--

DROP TABLE IF EXISTS `tabSingles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSingles` (
  `doctype` varchar(255) DEFAULT NULL,
  `field` varchar(255) DEFAULT NULL,
  `value` longtext DEFAULT NULL,
  KEY `singles_doctype_field_index` (`doctype`,`field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSlack Webhook URL`
--

DROP TABLE IF EXISTS `tabSlack Webhook URL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSlack Webhook URL` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `webhook_name` varchar(140) DEFAULT NULL,
  `webhook_url` varchar(140) DEFAULT NULL,
  `show_document_link` int(1) NOT NULL DEFAULT 1,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `webhook_name` (`webhook_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSocial Link Settings`
--

DROP TABLE IF EXISTS `tabSocial Link Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSocial Link Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `social_link_type` varchar(140) DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `background_color` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSocial Login Key`
--

DROP TABLE IF EXISTS `tabSocial Login Key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSocial Login Key` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enable_social_login` int(1) NOT NULL DEFAULT 0,
  `social_login_provider` varchar(140) DEFAULT 'Custom',
  `client_id` varchar(140) DEFAULT NULL,
  `provider_name` varchar(140) DEFAULT NULL,
  `client_secret` text DEFAULT NULL,
  `icon` varchar(140) DEFAULT NULL,
  `base_url` varchar(140) DEFAULT NULL,
  `sign_ups` varchar(140) DEFAULT NULL,
  `authorize_url` varchar(140) DEFAULT NULL,
  `access_token_url` varchar(140) DEFAULT NULL,
  `redirect_url` varchar(140) DEFAULT NULL,
  `api_endpoint` varchar(140) DEFAULT NULL,
  `custom_base_url` int(1) NOT NULL DEFAULT 0,
  `api_endpoint_args` longtext DEFAULT NULL,
  `auth_url_data` longtext DEFAULT NULL,
  `user_id_property` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSouth Africa VAT Account`
--

DROP TABLE IF EXISTS `tabSouth Africa VAT Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSouth Africa VAT Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSouth Africa VAT Settings`
--

DROP TABLE IF EXISTS `tabSouth Africa VAT Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSouth Africa VAT Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `company` (`company`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabStock Entry`
--

DROP TABLE IF EXISTS `tabStock Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabStock Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `stock_entry_type` varchar(140) DEFAULT NULL,
  `outgoing_stock_entry` varchar(140) DEFAULT NULL,
  `purpose` varchar(140) DEFAULT NULL,
  `add_to_transit` int(1) NOT NULL DEFAULT 0,
  `work_order` varchar(140) DEFAULT NULL,
  `purchase_order` varchar(140) DEFAULT NULL,
  `subcontracting_order` varchar(140) DEFAULT NULL,
  `delivery_note_no` varchar(140) DEFAULT NULL,
  `sales_invoice_no` varchar(140) DEFAULT NULL,
  `pick_list` varchar(140) DEFAULT NULL,
  `purchase_receipt_no` varchar(140) DEFAULT NULL,
  `asset_repair` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `inspection_required` int(1) NOT NULL DEFAULT 0,
  `apply_putaway_rule` int(1) NOT NULL DEFAULT 0,
  `from_bom` int(1) NOT NULL DEFAULT 0,
  `use_multi_level_bom` int(1) NOT NULL DEFAULT 1,
  `bom_no` varchar(140) DEFAULT NULL,
  `fg_completed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `process_loss_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `process_loss_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `from_warehouse` varchar(140) DEFAULT NULL,
  `source_warehouse_address` varchar(140) DEFAULT NULL,
  `source_address_display` text DEFAULT NULL,
  `to_warehouse` varchar(140) DEFAULT NULL,
  `target_warehouse_address` varchar(140) DEFAULT NULL,
  `target_address_display` text DEFAULT NULL,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `total_outgoing_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_incoming_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `value_difference` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_additional_costs` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `supplier_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `is_opening` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `per_transferred` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `job_card` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `credit_note` varchar(140) DEFAULT NULL,
  `is_return` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `stock_entry_type` (`stock_entry_type`),
  KEY `purpose` (`purpose`),
  KEY `work_order` (`work_order`),
  KEY `delivery_note_no` (`delivery_note_no`),
  KEY `pick_list` (`pick_list`),
  KEY `purchase_receipt_no` (`purchase_receipt_no`),
  KEY `posting_date` (`posting_date`),
  KEY `job_card` (`job_card`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabStock Entry Detail`
--

DROP TABLE IF EXISTS `tabStock Entry Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabStock Entry Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `barcode` varchar(140) DEFAULT NULL,
  `has_item_scanned` int(1) NOT NULL DEFAULT 0,
  `s_warehouse` varchar(140) DEFAULT NULL,
  `t_warehouse` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `is_finished_item` int(1) NOT NULL DEFAULT 0,
  `is_scrap_item` int(1) NOT NULL DEFAULT 0,
  `quality_inspection` varchar(140) DEFAULT NULL,
  `subcontracted_item` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `transfer_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `retain_sample` int(1) NOT NULL DEFAULT 0,
  `uom` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `sample_quantity` int(11) NOT NULL DEFAULT 0,
  `basic_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allow_zero_valuation_rate` int(1) NOT NULL DEFAULT 0,
  `set_basic_rate_manually` int(1) NOT NULL DEFAULT 0,
  `basic_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `transferred_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `bom_no` varchar(140) DEFAULT NULL,
  `allow_alternative_item` int(1) NOT NULL DEFAULT 0,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `original_item` varchar(140) DEFAULT NULL,
  `against_stock_entry` varchar(140) DEFAULT NULL,
  `ste_detail` varchar(140) DEFAULT NULL,
  `po_detail` varchar(140) DEFAULT NULL,
  `sco_rm_detail` varchar(140) DEFAULT NULL,
  `putaway_rule` varchar(140) DEFAULT NULL,
  `reference_purchase_receipt` varchar(140) DEFAULT NULL,
  `job_card_item` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `serial_and_batch_bundle` (`serial_and_batch_bundle`),
  KEY `actual_qty` (`actual_qty`),
  KEY `material_request` (`material_request`),
  KEY `job_card_item` (`job_card_item`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabStock Entry Type`
--

DROP TABLE IF EXISTS `tabStock Entry Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabStock Entry Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `purpose` varchar(140) DEFAULT 'Material Issue',
  `add_to_transit` int(1) NOT NULL DEFAULT 0,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabStock Ledger Entry`
--

DROP TABLE IF EXISTS `tabStock Ledger Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabStock Ledger Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `posting_datetime` datetime(6) DEFAULT NULL,
  `is_adjustment_entry` int(1) NOT NULL DEFAULT 0,
  `auto_created_serial_and_batch_bundle` int(1) NOT NULL DEFAULT 0,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `voucher_detail_no` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `dependant_sle_voucher_detail_no` varchar(140) DEFAULT NULL,
  `recalculate_rate` int(1) NOT NULL DEFAULT 0,
  `actual_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `qty_after_transaction` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `incoming_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `outgoing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_value_difference` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_queue` longtext DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `fiscal_year` varchar(140) DEFAULT NULL,
  `has_batch_no` int(1) NOT NULL DEFAULT 0,
  `has_serial_no` int(1) NOT NULL DEFAULT 0,
  `is_cancelled` int(1) NOT NULL DEFAULT 0,
  `to_rename` int(1) NOT NULL DEFAULT 1,
  `serial_no` longtext DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `posting_datetime` (`posting_datetime`),
  KEY `voucher_type` (`voucher_type`),
  KEY `voucher_detail_no` (`voucher_detail_no`),
  KEY `serial_and_batch_bundle` (`serial_and_batch_bundle`),
  KEY `to_rename` (`to_rename`),
  KEY `modified` (`modified`),
  KEY `voucher_no_voucher_type_index` (`voucher_no`,`voucher_type`),
  KEY `batch_no_item_code_warehouse_index` (`batch_no`,`item_code`,`warehouse`),
  KEY `item_code_warehouse_posting_datetime_creation_index` (`item_code`,`warehouse`,`posting_datetime`,`creation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabStock Reconciliation`
--

DROP TABLE IF EXISTS `tabStock Reconciliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabStock Reconciliation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `purpose` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `scan_barcode` varchar(140) DEFAULT NULL,
  `scan_mode` int(1) NOT NULL DEFAULT 0,
  `expense_account` varchar(140) DEFAULT NULL,
  `difference_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amended_from` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabStock Reconciliation Item`
--

DROP TABLE IF EXISTS `tabStock Reconciliation Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabStock Reconciliation Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `barcode` varchar(140) DEFAULT NULL,
  `has_item_scanned` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `allow_zero_valuation_rate` int(1) NOT NULL DEFAULT 0,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `reconcile_all_serial_batch` int(1) NOT NULL DEFAULT 0,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `current_serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `serial_no` longtext DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `current_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `current_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `current_valuation_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `current_serial_no` longtext DEFAULT NULL,
  `quantity_difference` varchar(140) DEFAULT NULL,
  `amount_difference` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `serial_and_batch_bundle` (`serial_and_batch_bundle`),
  KEY `batch_no` (`batch_no`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabStock Reservation Entry`
--

DROP TABLE IF EXISTS `tabStock Reservation Entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabStock Reservation Entry` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `has_serial_no` int(1) NOT NULL DEFAULT 0,
  `has_batch_no` int(1) NOT NULL DEFAULT 0,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `voucher_detail_no` varchar(140) DEFAULT NULL,
  `from_voucher_type` varchar(140) DEFAULT NULL,
  `from_voucher_no` varchar(140) DEFAULT NULL,
  `from_voucher_detail_no` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `available_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `voucher_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reserved_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `delivered_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `reservation_based_on` varchar(140) DEFAULT 'Qty',
  `company` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `warehouse` (`warehouse`),
  KEY `voucher_no` (`voucher_no`),
  KEY `voucher_detail_no` (`voucher_detail_no`),
  KEY `from_voucher_no` (`from_voucher_no`),
  KEY `company` (`company`),
  KEY `project` (`project`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSub Operation`
--

DROP TABLE IF EXISTS `tabSub Operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSub Operation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `operation` varchar(140) DEFAULT NULL,
  `time_in_mins` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubcontracting BOM`
--

DROP TABLE IF EXISTS `tabSubcontracting BOM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubcontracting BOM` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_active` int(1) NOT NULL DEFAULT 1,
  `finished_good` varchar(140) DEFAULT NULL,
  `finished_good_qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `finished_good_uom` varchar(140) DEFAULT NULL,
  `finished_good_bom` varchar(140) DEFAULT NULL,
  `service_item` varchar(140) DEFAULT NULL,
  `service_item_qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `service_item_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `finished_good` (`finished_good`),
  KEY `finished_good_bom` (`finished_good_bom`),
  KEY `service_item` (`service_item`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubcontracting Order`
--

DROP TABLE IF EXISTS `tabSubcontracting Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubcontracting Order` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{supplier_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `purchase_order` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `supplier_warehouse` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `set_reserve_warehouse` varchar(140) DEFAULT NULL,
  `supplier_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` text DEFAULT NULL,
  `shipping_address` varchar(140) DEFAULT NULL,
  `shipping_address_display` text DEFAULT NULL,
  `billing_address` varchar(140) DEFAULT NULL,
  `billing_address_display` text DEFAULT NULL,
  `distribute_additional_costs_based_on` varchar(140) DEFAULT 'Qty',
  `total_additional_costs` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `status` varchar(140) DEFAULT 'Draft',
  `per_received` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `supplier` (`supplier`),
  KEY `transaction_date` (`transaction_date`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubcontracting Order Item`
--

DROP TABLE IF EXISTS `tabSubcontracting Order Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubcontracting Order Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `bom` varchar(140) DEFAULT NULL,
  `include_exploded_items` int(1) NOT NULL DEFAULT 0,
  `schedule_date` date DEFAULT NULL,
  `expected_delivery_date` date DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `received_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rm_cost_per_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `service_cost_per_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_cost_per_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `warehouse` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `manufacturer` varchar(140) DEFAULT NULL,
  `manufacturer_part_no` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `purchase_order_item` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `subcontracting_conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `job_card` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `expected_delivery_date` (`expected_delivery_date`),
  KEY `material_request` (`material_request`),
  KEY `material_request_item` (`material_request_item`),
  KEY `purchase_order_item` (`purchase_order_item`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubcontracting Order Service Item`
--

DROP TABLE IF EXISTS `tabSubcontracting Order Service Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubcontracting Order Service Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `fg_item` varchar(140) DEFAULT NULL,
  `fg_item_qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `purchase_order_item` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `purchase_order_item` (`purchase_order_item`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubcontracting Order Supplied Item`
--

DROP TABLE IF EXISTS `tabSubcontracting Order Supplied Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubcontracting Order Supplied Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `main_item_code` varchar(140) DEFAULT NULL,
  `rm_item_code` varchar(140) DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `reserve_warehouse` varchar(140) DEFAULT NULL,
  `bom_detail_no` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `required_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `supplied_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `consumed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_supplied_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubcontracting Receipt`
--

DROP TABLE IF EXISTS `tabSubcontracting Receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubcontracting Receipt` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{supplier_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `supplier_delivery_note` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `posting_date` date DEFAULT NULL,
  `posting_time` time(6) DEFAULT NULL,
  `set_posting_time` int(1) NOT NULL DEFAULT 0,
  `is_return` int(1) NOT NULL DEFAULT 0,
  `return_against` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `set_warehouse` varchar(140) DEFAULT NULL,
  `rejected_warehouse` varchar(140) DEFAULT NULL,
  `supplier_warehouse` varchar(140) DEFAULT NULL,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `in_words` varchar(240) DEFAULT NULL,
  `bill_no` varchar(140) DEFAULT NULL,
  `bill_date` date DEFAULT NULL,
  `supplier_address` varchar(140) DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` text DEFAULT NULL,
  `shipping_address` varchar(140) DEFAULT NULL,
  `shipping_address_display` text DEFAULT NULL,
  `billing_address` varchar(140) DEFAULT NULL,
  `billing_address_display` text DEFAULT NULL,
  `distribute_additional_costs_based_on` varchar(140) DEFAULT 'Qty',
  `total_additional_costs` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amended_from` varchar(140) DEFAULT NULL,
  `range` varchar(140) DEFAULT NULL,
  `represents_company` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `per_returned` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `transporter_name` varchar(140) DEFAULT NULL,
  `lr_no` varchar(140) DEFAULT NULL,
  `lr_date` date DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `supplier` (`supplier`),
  KEY `posting_date` (`posting_date`),
  KEY `status` (`status`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubcontracting Receipt Item`
--

DROP TABLE IF EXISTS `tabSubcontracting Receipt Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubcontracting Receipt Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `is_scrap_item` int(1) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `received_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rejected_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rm_cost_per_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `service_cost_per_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_cost_per_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `scrap_cost_per_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rm_supp_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `warehouse` varchar(140) DEFAULT NULL,
  `subcontracting_order` varchar(140) DEFAULT NULL,
  `subcontracting_order_item` varchar(140) DEFAULT NULL,
  `subcontracting_receipt_item` varchar(140) DEFAULT NULL,
  `rejected_warehouse` varchar(140) DEFAULT NULL,
  `bom` varchar(140) DEFAULT NULL,
  `include_exploded_items` int(1) NOT NULL DEFAULT 0,
  `quality_inspection` varchar(140) DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `rejected_serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `rejected_serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `manufacturer` varchar(140) DEFAULT NULL,
  `manufacturer_part_no` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `purchase_order` varchar(140) DEFAULT NULL,
  `purchase_order_item` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `subcontracting_order` (`subcontracting_order`),
  KEY `subcontracting_order_item` (`subcontracting_order_item`),
  KEY `purchase_order` (`purchase_order`),
  KEY `purchase_order_item` (`purchase_order_item`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubcontracting Receipt Supplied Item`
--

DROP TABLE IF EXISTS `tabSubcontracting Receipt Supplied Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubcontracting Receipt Supplied Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `main_item_code` varchar(140) DEFAULT NULL,
  `rm_item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `bom_detail_no` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `reference_name` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `available_qty_for_consumption` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `required_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `consumed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `current_stock` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `serial_and_batch_bundle` varchar(140) DEFAULT NULL,
  `use_serial_batch_fields` int(1) NOT NULL DEFAULT 0,
  `subcontracting_order` varchar(140) DEFAULT NULL,
  `serial_no` text DEFAULT NULL,
  `batch_no` varchar(140) DEFAULT NULL,
  `expense_account` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubmission Queue`
--

DROP TABLE IF EXISTS `tabSubmission Queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubmission Queue` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT NULL,
  `job_id` varchar(140) DEFAULT NULL,
  `ended_at` datetime(6) DEFAULT NULL,
  `ref_doctype` varchar(140) DEFAULT NULL,
  `ref_docname` varchar(140) DEFAULT NULL,
  `exception` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `ref_docname` (`ref_docname`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubscription`
--

DROP TABLE IF EXISTS `tabSubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubscription` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `cancelation_date` date DEFAULT NULL,
  `trial_period_start` date DEFAULT NULL,
  `trial_period_end` date DEFAULT NULL,
  `follow_calendar_months` int(1) NOT NULL DEFAULT 0,
  `generate_new_invoices_past_due_date` int(1) NOT NULL DEFAULT 0,
  `submit_invoice` int(1) NOT NULL DEFAULT 1,
  `current_invoice_start` date DEFAULT NULL,
  `current_invoice_end` date DEFAULT NULL,
  `days_until_due` int(11) NOT NULL DEFAULT 0,
  `generate_invoice_at` varchar(140) DEFAULT 'End of the current subscription period',
  `number_of_days` int(11) NOT NULL DEFAULT 0,
  `cancel_at_period_end` int(1) NOT NULL DEFAULT 0,
  `sales_tax_template` varchar(140) DEFAULT NULL,
  `purchase_tax_template` varchar(140) DEFAULT NULL,
  `apply_additional_discount` varchar(140) DEFAULT NULL,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cost_center` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubscription Invoice`
--

DROP TABLE IF EXISTS `tabSubscription Invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubscription Invoice` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `invoice` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubscription Plan`
--

DROP TABLE IF EXISTS `tabSubscription Plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubscription Plan` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `plan_name` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `item` varchar(140) DEFAULT NULL,
  `price_determination` varchar(140) DEFAULT NULL,
  `cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list` varchar(140) DEFAULT NULL,
  `billing_interval` varchar(140) DEFAULT 'Day',
  `billing_interval_count` int(11) NOT NULL DEFAULT 1,
  `product_price_id` varchar(140) DEFAULT NULL,
  `payment_gateway` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `plan_name` (`plan_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSubscription Plan Detail`
--

DROP TABLE IF EXISTS `tabSubscription Plan Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSubscription Plan Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `plan` varchar(140) DEFAULT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSuccess Action`
--

DROP TABLE IF EXISTS `tabSuccess Action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSuccess Action` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `ref_doctype` varchar(140) DEFAULT NULL,
  `first_success_message` varchar(140) DEFAULT 'Congratulations on first creations',
  `message` varchar(140) DEFAULT 'Successfully created',
  `next_actions` varchar(140) DEFAULT NULL,
  `action_timeout` int(11) NOT NULL DEFAULT 7,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `ref_doctype` (`ref_doctype`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier`
--

DROP TABLE IF EXISTS `tabSupplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `country` varchar(140) DEFAULT NULL,
  `supplier_group` varchar(140) DEFAULT NULL,
  `supplier_type` varchar(140) DEFAULT 'Company',
  `is_transporter` int(1) NOT NULL DEFAULT 0,
  `image` text DEFAULT NULL,
  `default_currency` varchar(140) DEFAULT NULL,
  `default_bank_account` varchar(140) DEFAULT NULL,
  `default_price_list` varchar(140) DEFAULT NULL,
  `is_internal_supplier` int(1) NOT NULL DEFAULT 0,
  `represents_company` varchar(140) DEFAULT NULL,
  `supplier_details` text DEFAULT NULL,
  `website` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `tax_id` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `tax_withholding_category` varchar(140) DEFAULT NULL,
  `supplier_primary_address` varchar(140) DEFAULT NULL,
  `primary_address` text DEFAULT NULL,
  `supplier_primary_contact` varchar(140) DEFAULT NULL,
  `mobile_no` varchar(140) DEFAULT NULL,
  `email_id` varchar(140) DEFAULT NULL,
  `payment_terms` varchar(140) DEFAULT NULL,
  `allow_purchase_invoice_creation_without_purchase_order` int(1) NOT NULL DEFAULT 0,
  `allow_purchase_invoice_creation_without_purchase_receipt` int(1) NOT NULL DEFAULT 0,
  `is_frozen` int(1) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `warn_rfqs` int(1) NOT NULL DEFAULT 0,
  `warn_pos` int(1) NOT NULL DEFAULT 0,
  `prevent_rfqs` int(1) NOT NULL DEFAULT 0,
  `prevent_pos` int(1) NOT NULL DEFAULT 0,
  `on_hold` int(1) NOT NULL DEFAULT 0,
  `hold_type` varchar(140) DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Group`
--

DROP TABLE IF EXISTS `tabSupplier Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `supplier_group_name` varchar(140) DEFAULT NULL,
  `parent_supplier_group` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `payment_terms` varchar(140) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `supplier_group_name` (`supplier_group_name`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Group Item`
--

DROP TABLE IF EXISTS `tabSupplier Group Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Group Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `supplier_group` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Item`
--

DROP TABLE IF EXISTS `tabSupplier Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `supplier` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Quotation`
--

DROP TABLE IF EXISTS `tabSupplier Quotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Quotation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{supplier_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_name` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `valid_till` date DEFAULT NULL,
  `quotation_number` varchar(140) DEFAULT NULL,
  `has_unit_price_items` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `buying_price_list` varchar(140) DEFAULT NULL,
  `price_list_currency` varchar(140) DEFAULT NULL,
  `plc_conversion_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `ignore_pricing_rule` int(1) NOT NULL DEFAULT 0,
  `total_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_net_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `tax_category` varchar(140) DEFAULT NULL,
  `taxes_and_charges` varchar(140) DEFAULT NULL,
  `shipping_rule` varchar(140) DEFAULT NULL,
  `incoterm` varchar(140) DEFAULT NULL,
  `named_place` varchar(140) DEFAULT NULL,
  `base_taxes_and_charges_added` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_taxes_and_charges_deducted` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges_added` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `taxes_and_charges_deducted` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_taxes_and_charges` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `apply_discount_on` varchar(140) DEFAULT 'Grand Total',
  `base_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_in_words` varchar(240) DEFAULT NULL,
  `grand_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounding_adjustment` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rounded_total` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `in_words` varchar(240) DEFAULT NULL,
  `disable_rounded_total` int(1) NOT NULL DEFAULT 0,
  `other_charges_calculation` longtext DEFAULT NULL,
  `supplier_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` text DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `shipping_address` varchar(140) DEFAULT NULL,
  `shipping_address_display` text DEFAULT NULL,
  `billing_address` varchar(140) DEFAULT NULL,
  `billing_address_display` text DEFAULT NULL,
  `tc_name` varchar(140) DEFAULT NULL,
  `terms` longtext DEFAULT NULL,
  `letter_head` varchar(140) DEFAULT NULL,
  `group_same_items` int(1) NOT NULL DEFAULT 0,
  `select_print_heading` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `auto_repeat` varchar(140) DEFAULT NULL,
  `is_subcontracted` int(1) NOT NULL DEFAULT 0,
  `opportunity` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `supplier` (`supplier`),
  KEY `company` (`company`),
  KEY `status` (`status`),
  KEY `transaction_date` (`transaction_date`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Quotation Item`
--

DROP TABLE IF EXISTS `tabSupplier Quotation Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Quotation Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_code` varchar(140) DEFAULT NULL,
  `supplier_part_no` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `lead_time_days` int(11) NOT NULL DEFAULT 0,
  `expected_delivery_date` date DEFAULT NULL,
  `is_free_item` int(1) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `brand` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_percentage` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distributed_discount_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_price_list_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `item_tax_template` varchar(140) DEFAULT NULL,
  `base_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `pricing_rules` text DEFAULT NULL,
  `net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_net_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_per_unit` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight_uom` varchar(140) DEFAULT NULL,
  `warehouse` varchar(140) DEFAULT NULL,
  `prevdoc_doctype` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `request_for_quotation` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `request_for_quotation_item` varchar(140) DEFAULT NULL,
  `item_tax_rate` longtext DEFAULT NULL,
  `manufacturer` varchar(140) DEFAULT NULL,
  `manufacturer_part_no` varchar(140) DEFAULT NULL,
  `cost_center` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `page_break` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `item_name` (`item_name`),
  KEY `material_request` (`material_request`),
  KEY `sales_order` (`sales_order`),
  KEY `material_request_item` (`material_request_item`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Scorecard`
--

DROP TABLE IF EXISTS `tabSupplier Scorecard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Scorecard` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `supplier` varchar(140) DEFAULT NULL,
  `supplier_score` varchar(140) DEFAULT NULL,
  `indicator_color` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `period` varchar(140) DEFAULT 'Per Month',
  `weighting_function` text,
  `warn_rfqs` int(1) NOT NULL DEFAULT 0,
  `warn_pos` int(1) NOT NULL DEFAULT 0,
  `prevent_rfqs` int(1) NOT NULL DEFAULT 0,
  `prevent_pos` int(1) NOT NULL DEFAULT 0,
  `notify_supplier` int(1) NOT NULL DEFAULT 0,
  `notify_employee` int(1) NOT NULL DEFAULT 0,
  `employee` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Scorecard Criteria`
--

DROP TABLE IF EXISTS `tabSupplier Scorecard Criteria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Scorecard Criteria` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `criteria_name` varchar(140) DEFAULT NULL,
  `max_score` decimal(21,9) NOT NULL DEFAULT 100.000000000,
  `formula` text DEFAULT NULL,
  `weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `criteria_name` (`criteria_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Scorecard Period`
--

DROP TABLE IF EXISTS `tabSupplier Scorecard Period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Scorecard Period` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `supplier` varchar(140) DEFAULT NULL,
  `naming_series` varchar(140) DEFAULT NULL,
  `total_score` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `scorecard` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Scorecard Scoring Criteria`
--

DROP TABLE IF EXISTS `tabSupplier Scorecard Scoring Criteria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Scorecard Scoring Criteria` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `criteria_name` varchar(140) DEFAULT NULL,
  `score` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_score` decimal(21,9) NOT NULL DEFAULT 100.000000000,
  `formula` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Scorecard Scoring Standing`
--

DROP TABLE IF EXISTS `tabSupplier Scorecard Scoring Standing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Scorecard Scoring Standing` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `standing_name` varchar(140) DEFAULT NULL,
  `standing_color` varchar(140) DEFAULT NULL,
  `min_grade` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_grade` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `warn_rfqs` int(1) NOT NULL DEFAULT 0,
  `warn_pos` int(1) NOT NULL DEFAULT 0,
  `prevent_rfqs` int(1) NOT NULL DEFAULT 0,
  `prevent_pos` int(1) NOT NULL DEFAULT 0,
  `notify_supplier` int(1) NOT NULL DEFAULT 0,
  `notify_employee` int(1) NOT NULL DEFAULT 0,
  `employee_link` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Scorecard Scoring Variable`
--

DROP TABLE IF EXISTS `tabSupplier Scorecard Scoring Variable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Scorecard Scoring Variable` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `variable_label` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `param_name` varchar(140) DEFAULT NULL,
  `path` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Scorecard Standing`
--

DROP TABLE IF EXISTS `tabSupplier Scorecard Standing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Scorecard Standing` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `standing_name` varchar(140) DEFAULT NULL,
  `standing_color` varchar(140) DEFAULT NULL,
  `min_grade` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `max_grade` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `warn_rfqs` int(1) NOT NULL DEFAULT 0,
  `warn_pos` int(1) NOT NULL DEFAULT 0,
  `prevent_rfqs` int(1) NOT NULL DEFAULT 0,
  `prevent_pos` int(1) NOT NULL DEFAULT 0,
  `notify_supplier` int(1) NOT NULL DEFAULT 0,
  `notify_employee` int(1) NOT NULL DEFAULT 0,
  `employee_link` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `standing_name` (`standing_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupplier Scorecard Variable`
--

DROP TABLE IF EXISTS `tabSupplier Scorecard Variable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupplier Scorecard Variable` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `variable_label` varchar(140) DEFAULT NULL,
  `is_custom` int(1) NOT NULL DEFAULT 0,
  `param_name` varchar(140) DEFAULT NULL,
  `path` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `variable_label` (`variable_label`),
  UNIQUE KEY `param_name` (`param_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabSupport Search Source`
--

DROP TABLE IF EXISTS `tabSupport Search Source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabSupport Search Source` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `source_name` varchar(140) DEFAULT NULL,
  `source_type` varchar(140) DEFAULT NULL,
  `base_url` varchar(140) DEFAULT NULL,
  `query_route` varchar(140) DEFAULT NULL,
  `search_term_param_name` varchar(140) DEFAULT NULL,
  `response_result_key_path` varchar(140) DEFAULT NULL,
  `post_route` varchar(140) DEFAULT NULL,
  `post_route_key_list` varchar(140) DEFAULT NULL,
  `post_title_key` varchar(140) DEFAULT NULL,
  `post_description_key` varchar(140) DEFAULT NULL,
  `source_doctype` varchar(140) DEFAULT NULL,
  `result_title_field` varchar(140) DEFAULT NULL,
  `result_preview_field` varchar(140) DEFAULT NULL,
  `result_route_field` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTag`
--

DROP TABLE IF EXISTS `tabTag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTag` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTag Link`
--

DROP TABLE IF EXISTS `tabTag Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTag Link` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `document_name` varchar(140) DEFAULT NULL,
  `tag` varchar(140) DEFAULT NULL,
  `title` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`),
  KEY `document_type_document_name_index` (`document_type`,`document_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTarget Detail`
--

DROP TABLE IF EXISTS `tabTarget Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTarget Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_group` varchar(140) DEFAULT NULL,
  `fiscal_year` varchar(140) DEFAULT NULL,
  `target_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `target_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `distribution_id` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_group` (`item_group`),
  KEY `fiscal_year` (`fiscal_year`),
  KEY `target_amount` (`target_amount`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTask`
--

DROP TABLE IF EXISTS `tabTask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTask` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `subject` varchar(140) DEFAULT NULL,
  `project` varchar(140) DEFAULT NULL,
  `issue` varchar(140) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `is_template` int(1) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT NULL,
  `priority` varchar(140) DEFAULT NULL,
  `task_weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent_task` varchar(140) DEFAULT NULL,
  `completed_by` varchar(140) DEFAULT NULL,
  `completed_on` date DEFAULT NULL,
  `exp_start_date` date DEFAULT NULL,
  `expected_time` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `start` int(11) NOT NULL DEFAULT 0,
  `exp_end_date` date DEFAULT NULL,
  `progress` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `duration` int(11) NOT NULL DEFAULT 0,
  `is_milestone` int(1) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `depends_on_tasks` longtext DEFAULT NULL,
  `act_start_date` date DEFAULT NULL,
  `actual_time` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `act_end_date` date DEFAULT NULL,
  `total_costing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_billing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `review_date` date DEFAULT NULL,
  `closing_date` date DEFAULT NULL,
  `department` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `template_task` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `subject` (`subject`),
  KEY `project` (`project`),
  KEY `priority` (`priority`),
  KEY `parent_task` (`parent_task`),
  KEY `exp_end_date` (`exp_end_date`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTask Depends On`
--

DROP TABLE IF EXISTS `tabTask Depends On`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTask Depends On` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `task` varchar(140) DEFAULT NULL,
  `subject` text DEFAULT NULL,
  `project` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTask Type`
--

DROP TABLE IF EXISTS `tabTask Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTask Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `weight` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTax Category`
--

DROP TABLE IF EXISTS `tabTax Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTax Category` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `title` (`title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTax Rule`
--

DROP TABLE IF EXISTS `tabTax Rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTax Rule` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `tax_type` varchar(140) DEFAULT 'Sales',
  `use_for_shopping_cart` int(1) NOT NULL DEFAULT 1,
  `sales_tax_template` varchar(140) DEFAULT NULL,
  `purchase_tax_template` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `supplier` varchar(140) DEFAULT NULL,
  `item` varchar(140) DEFAULT NULL,
  `billing_city` varchar(140) DEFAULT NULL,
  `billing_county` varchar(140) DEFAULT NULL,
  `billing_state` varchar(140) DEFAULT NULL,
  `billing_zipcode` varchar(140) DEFAULT NULL,
  `billing_country` varchar(140) DEFAULT NULL,
  `tax_category` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `supplier_group` varchar(140) DEFAULT NULL,
  `item_group` varchar(140) DEFAULT NULL,
  `shipping_city` varchar(140) DEFAULT NULL,
  `shipping_county` varchar(140) DEFAULT NULL,
  `shipping_state` varchar(140) DEFAULT NULL,
  `shipping_zipcode` varchar(140) DEFAULT NULL,
  `shipping_country` varchar(140) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 1,
  `company` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTax Withheld Vouchers`
--

DROP TABLE IF EXISTS `tabTax Withheld Vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTax Withheld Vouchers` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_name` varchar(140) DEFAULT NULL,
  `taxable_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTax Withholding Account`
--

DROP TABLE IF EXISTS `tabTax Withholding Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTax Withholding Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTax Withholding Category`
--

DROP TABLE IF EXISTS `tabTax Withholding Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTax Withholding Category` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `category_name` varchar(140) DEFAULT NULL,
  `round_off_tax_amount` int(1) NOT NULL DEFAULT 0,
  `consider_party_ledger_amount` int(1) NOT NULL DEFAULT 0,
  `tax_on_excess_amount` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTax Withholding Rate`
--

DROP TABLE IF EXISTS `tabTax Withholding Rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTax Withholding Rate` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `tax_withholding_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `single_threshold` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `cumulative_threshold` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTelephony Call Type`
--

DROP TABLE IF EXISTS `tabTelephony Call Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTelephony Call Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `call_type` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `call_type` (`call_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTerms and Conditions`
--

DROP TABLE IF EXISTS `tabTerms and Conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTerms and Conditions` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `selling` int(1) NOT NULL DEFAULT 1,
  `buying` int(1) NOT NULL DEFAULT 1,
  `terms` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `title` (`title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTerritory`
--

DROP TABLE IF EXISTS `tabTerritory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTerritory` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `territory_name` varchar(140) DEFAULT NULL,
  `parent_territory` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `territory_manager` varchar(140) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `territory_name` (`territory_name`),
  KEY `territory_manager` (`territory_manager`),
  KEY `lft` (`lft`),
  KEY `rgt` (`rgt`),
  KEY `modified` (`modified`),
  KEY `lft_rgt_index` (`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTerritory Item`
--

DROP TABLE IF EXISTS `tabTerritory Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTerritory Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `territory` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTimesheet`
--

DROP TABLE IF EXISTS `tabTimesheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTimesheet` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT '{employee_name}',
  `naming_series` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `currency` varchar(140) DEFAULT NULL,
  `exchange_rate` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `sales_invoice` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `parent_project` varchar(140) DEFAULT NULL,
  `employee` varchar(140) DEFAULT NULL,
  `employee_name` varchar(140) DEFAULT NULL,
  `department` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `total_hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_billable_hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_billable_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_billed_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_total_costing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_billed_hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_billable_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_billed_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_costing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `per_billed` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `note` longtext DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTimesheet Detail`
--

DROP TABLE IF EXISTS `tabTimesheet Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTimesheet Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `activity_type` varchar(140) DEFAULT NULL,
  `from_time` datetime(6) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `expected_hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `to_time` datetime(6) DEFAULT NULL,
  `hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `completed` int(1) NOT NULL DEFAULT 0,
  `project` varchar(140) DEFAULT NULL,
  `project_name` varchar(140) DEFAULT NULL,
  `task` varchar(140) DEFAULT NULL,
  `is_billable` int(1) NOT NULL DEFAULT 0,
  `sales_invoice` varchar(140) DEFAULT NULL,
  `billing_hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_billing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_billing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_costing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `base_costing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `billing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `costing_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `costing_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabToDo`
--

DROP TABLE IF EXISTS `tabToDo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabToDo` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT 'Open',
  `priority` varchar(140) DEFAULT 'Medium',
  `color` varchar(140) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `allocated_to` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `reference_type` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `role` varchar(140) DEFAULT NULL,
  `assigned_by` varchar(140) DEFAULT NULL,
  `assigned_by_full_name` varchar(140) DEFAULT NULL,
  `sender` varchar(140) DEFAULT NULL,
  `assignment_rule` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`),
  KEY `reference_type_reference_name_index` (`reference_type`,`reference_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabToken Cache`
--

DROP TABLE IF EXISTS `tabToken Cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabToken Cache` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `connected_app` varchar(140) DEFAULT NULL,
  `provider_name` varchar(140) DEFAULT NULL,
  `access_token` text DEFAULT NULL,
  `refresh_token` text DEFAULT NULL,
  `expires_in` int(11) NOT NULL DEFAULT 0,
  `state` varchar(140) DEFAULT NULL,
  `success_uri` varchar(140) DEFAULT NULL,
  `token_type` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTop Bar Item`
--

DROP TABLE IF EXISTS `tabTop Bar Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTop Bar Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `url` varchar(140) DEFAULT NULL,
  `open_in_new_tab` int(1) NOT NULL DEFAULT 0,
  `right` int(1) NOT NULL DEFAULT 1,
  `parent_label` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTransaction Deletion Record`
--

DROP TABLE IF EXISTS `tabTransaction Deletion Record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTransaction Deletion Record` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `error_log` longtext DEFAULT NULL,
  `delete_bin_data` int(1) NOT NULL DEFAULT 0,
  `delete_leads_and_addresses` int(1) NOT NULL DEFAULT 0,
  `reset_company_default_values` int(1) NOT NULL DEFAULT 0,
  `clear_notifications` int(1) NOT NULL DEFAULT 0,
  `initialize_doctypes_table` int(1) NOT NULL DEFAULT 0,
  `delete_transactions` int(1) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `process_in_single_transaction` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTransaction Deletion Record Details`
--

DROP TABLE IF EXISTS `tabTransaction Deletion Record Details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTransaction Deletion Record Details` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `doctype_name` varchar(140) DEFAULT NULL,
  `docfield_name` varchar(140) DEFAULT NULL,
  `no_of_docs` int(11) NOT NULL DEFAULT 0,
  `done` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTransaction Deletion Record Item`
--

DROP TABLE IF EXISTS `tabTransaction Deletion Record Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTransaction Deletion Record Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `doctype_name` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTransaction Log`
--

DROP TABLE IF EXISTS `tabTransaction Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTransaction Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `row_index` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `document_name` varchar(140) DEFAULT NULL,
  `timestamp` datetime(6) DEFAULT NULL,
  `checksum_version` varchar(140) DEFAULT NULL,
  `previous_hash` text DEFAULT NULL,
  `transaction_hash` text DEFAULT NULL,
  `chaining_hash` text DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabTranslation`
--

DROP TABLE IF EXISTS `tabTranslation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabTranslation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `contributed` int(1) NOT NULL DEFAULT 0,
  `language` varchar(140) DEFAULT NULL,
  `source_text` longtext DEFAULT NULL,
  `context` varchar(140) DEFAULT NULL,
  `translated_text` longtext DEFAULT NULL,
  `contribution_status` varchar(140) DEFAULT NULL,
  `contribution_docname` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `language` (`language`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUAE VAT Account`
--

DROP TABLE IF EXISTS `tabUAE VAT Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUAE VAT Account` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUAE VAT Settings`
--

DROP TABLE IF EXISTS `tabUAE VAT Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUAE VAT Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `company` (`company`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUOM`
--

DROP TABLE IF EXISTS `tabUOM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUOM` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `uom_name` varchar(140) DEFAULT NULL,
  `must_be_whole_number` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `uom_name` (`uom_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUOM Category`
--

DROP TABLE IF EXISTS `tabUOM Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUOM Category` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `category_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUOM Conversion Detail`
--

DROP TABLE IF EXISTS `tabUOM Conversion Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUOM Conversion Detail` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `uom` varchar(140) DEFAULT NULL,
  `conversion_factor` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUOM Conversion Factor`
--

DROP TABLE IF EXISTS `tabUOM Conversion Factor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUOM Conversion Factor` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `category` varchar(140) DEFAULT NULL,
  `from_uom` varchar(140) DEFAULT NULL,
  `to_uom` varchar(140) DEFAULT NULL,
  `value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUnhandled Email`
--

DROP TABLE IF EXISTS `tabUnhandled Email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUnhandled Email` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_account` varchar(140) DEFAULT NULL,
  `uid` varchar(140) DEFAULT NULL,
  `reason` longtext DEFAULT NULL,
  `message_id` longtext DEFAULT NULL,
  `raw` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUnreconcile Payment`
--

DROP TABLE IF EXISTS `tabUnreconcile Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUnreconcile Payment` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `company` varchar(140) DEFAULT NULL,
  `voucher_type` varchar(140) DEFAULT NULL,
  `voucher_no` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUnreconcile Payment Entries`
--

DROP TABLE IF EXISTS `tabUnreconcile Payment Entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUnreconcile Payment Entries` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `party_type` varchar(140) DEFAULT NULL,
  `party` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `allocated_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `account_currency` varchar(140) DEFAULT NULL,
  `unlinked` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser`
--

DROP TABLE IF EXISTS `tabUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `email` varchar(140) DEFAULT NULL,
  `first_name` varchar(140) DEFAULT NULL,
  `middle_name` varchar(140) DEFAULT NULL,
  `last_name` varchar(140) DEFAULT NULL,
  `full_name` varchar(140) DEFAULT NULL,
  `username` varchar(140) DEFAULT NULL,
  `language` varchar(140) DEFAULT NULL,
  `time_zone` varchar(140) DEFAULT NULL,
  `send_welcome_email` int(1) NOT NULL DEFAULT 1,
  `unsubscribed` int(1) NOT NULL DEFAULT 0,
  `user_image` text DEFAULT NULL,
  `role_profile_name` varchar(140) DEFAULT NULL,
  `module_profile` varchar(140) DEFAULT NULL,
  `home_settings` longtext DEFAULT NULL,
  `gender` varchar(140) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `interest` text DEFAULT NULL,
  `phone` varchar(140) DEFAULT NULL,
  `location` varchar(140) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `mobile_no` varchar(140) DEFAULT NULL,
  `mute_sounds` int(1) NOT NULL DEFAULT 0,
  `desk_theme` varchar(140) DEFAULT NULL,
  `banner_image` text DEFAULT NULL,
  `search_bar` int(1) NOT NULL DEFAULT 1,
  `notifications` int(1) NOT NULL DEFAULT 1,
  `list_sidebar` int(1) NOT NULL DEFAULT 1,
  `bulk_actions` int(1) NOT NULL DEFAULT 1,
  `view_switcher` int(1) NOT NULL DEFAULT 1,
  `form_sidebar` int(1) NOT NULL DEFAULT 1,
  `timeline` int(1) NOT NULL DEFAULT 1,
  `dashboard` int(1) NOT NULL DEFAULT 1,
  `new_password` text DEFAULT NULL,
  `logout_all_sessions` int(1) NOT NULL DEFAULT 1,
  `reset_password_key` varchar(140) DEFAULT NULL,
  `last_reset_password_key_generated_on` datetime(6) DEFAULT NULL,
  `last_password_reset_date` date DEFAULT NULL,
  `redirect_url` text DEFAULT NULL,
  `document_follow_notify` int(1) NOT NULL DEFAULT 0,
  `document_follow_frequency` varchar(140) DEFAULT 'Daily',
  `follow_created_documents` int(1) NOT NULL DEFAULT 0,
  `follow_commented_documents` int(1) NOT NULL DEFAULT 0,
  `follow_liked_documents` int(1) NOT NULL DEFAULT 0,
  `follow_assigned_documents` int(1) NOT NULL DEFAULT 0,
  `follow_shared_documents` int(1) NOT NULL DEFAULT 0,
  `email_signature` text DEFAULT NULL,
  `thread_notify` int(1) NOT NULL DEFAULT 1,
  `send_me_a_copy` int(1) NOT NULL DEFAULT 0,
  `allowed_in_mentions` int(1) NOT NULL DEFAULT 1,
  `default_workspace` varchar(140) DEFAULT NULL,
  `default_app` varchar(140) DEFAULT NULL,
  `simultaneous_sessions` int(11) NOT NULL DEFAULT 2,
  `restrict_ip` text DEFAULT NULL,
  `last_ip` varchar(140) DEFAULT NULL,
  `login_after` int(11) NOT NULL DEFAULT 0,
  `user_type` varchar(140) DEFAULT 'System User',
  `last_active` datetime(6) DEFAULT NULL,
  `login_before` int(11) NOT NULL DEFAULT 0,
  `bypass_restrict_ip_check_if_2fa_enabled` int(1) NOT NULL DEFAULT 0,
  `last_login` varchar(140) DEFAULT NULL,
  `last_known_versions` text DEFAULT NULL,
  `api_key` varchar(140) DEFAULT NULL,
  `api_secret` text DEFAULT NULL,
  `onboarding_status` text,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `mobile_no` (`mobile_no`),
  UNIQUE KEY `api_key` (`api_key`),
  KEY `modified` (`modified`),
  KEY `last_active_index` (`last_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Document Type`
--

DROP TABLE IF EXISTS `tabUser Document Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Document Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `is_custom` int(1) NOT NULL DEFAULT 0,
  `read` int(1) NOT NULL DEFAULT 1,
  `write` int(1) NOT NULL DEFAULT 0,
  `create` int(1) NOT NULL DEFAULT 0,
  `submit` int(1) NOT NULL DEFAULT 0,
  `cancel` int(1) NOT NULL DEFAULT 0,
  `amend` int(1) NOT NULL DEFAULT 0,
  `delete` int(1) NOT NULL DEFAULT 0,
  `email` int(1) NOT NULL DEFAULT 1,
  `share` int(1) NOT NULL DEFAULT 1,
  `print` int(1) NOT NULL DEFAULT 1,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Email`
--

DROP TABLE IF EXISTS `tabUser Email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Email` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `email_account` varchar(140) DEFAULT NULL,
  `email_id` varchar(140) DEFAULT NULL,
  `awaiting_password` int(1) NOT NULL DEFAULT 0,
  `used_oauth` int(1) NOT NULL DEFAULT 0,
  `enable_outgoing` int(1) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Group`
--

DROP TABLE IF EXISTS `tabUser Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Group Member`
--

DROP TABLE IF EXISTS `tabUser Group Member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Group Member` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Permission`
--

DROP TABLE IF EXISTS `tabUser Permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Permission` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `allow` varchar(140) DEFAULT NULL,
  `for_value` varchar(140) DEFAULT NULL,
  `is_default` int(1) NOT NULL DEFAULT 0,
  `apply_to_all_doctypes` int(1) NOT NULL DEFAULT 1,
  `applicable_for` varchar(140) DEFAULT NULL,
  `hide_descendants` int(1) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `user` (`user`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Select Document Type`
--

DROP TABLE IF EXISTS `tabUser Select Document Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Select Document Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Social Login`
--

DROP TABLE IF EXISTS `tabUser Social Login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Social Login` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `provider` varchar(140) DEFAULT NULL,
  `username` varchar(140) DEFAULT NULL,
  `userid` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Type`
--

DROP TABLE IF EXISTS `tabUser Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `role` varchar(140) DEFAULT NULL,
  `apply_user_permission_on` varchar(140) DEFAULT NULL,
  `user_id_field` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabUser Type Module`
--

DROP TABLE IF EXISTS `tabUser Type Module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabUser Type Module` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabVariant Field`
--

DROP TABLE IF EXISTS `tabVariant Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabVariant Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `field_name` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabVehicle`
--

DROP TABLE IF EXISTS `tabVehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabVehicle` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `license_plate` varchar(140) DEFAULT NULL,
  `make` varchar(140) DEFAULT NULL,
  `model` varchar(140) DEFAULT NULL,
  `last_odometer` int(11) NOT NULL DEFAULT 0,
  `acquisition_date` date DEFAULT NULL,
  `location` varchar(140) DEFAULT NULL,
  `chassis_no` varchar(140) DEFAULT NULL,
  `vehicle_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `employee` varchar(140) DEFAULT NULL,
  `insurance_company` varchar(140) DEFAULT NULL,
  `policy_no` varchar(140) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `fuel_type` varchar(140) DEFAULT NULL,
  `uom` varchar(140) DEFAULT NULL,
  `carbon_check_date` date DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `wheels` int(11) NOT NULL DEFAULT 0,
  `doors` int(11) NOT NULL DEFAULT 0,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `license_plate` (`license_plate`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabVersion`
--

DROP TABLE IF EXISTS `tabVersion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabVersion` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `ref_doctype` varchar(140) DEFAULT NULL,
  `docname` varchar(140) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`),
  KEY `ref_doctype_docname_index` (`ref_doctype`,`docname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabVideo`
--

DROP TABLE IF EXISTS `tabVideo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabVideo` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `provider` varchar(140) DEFAULT NULL,
  `url` varchar(140) DEFAULT NULL,
  `youtube_video_id` varchar(140) DEFAULT NULL,
  `publish_date` date DEFAULT NULL,
  `duration` decimal(21,9) DEFAULT NULL,
  `like_count` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `view_count` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `dislike_count` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `comment_count` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` longtext DEFAULT NULL,
  `image` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `title` (`title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabView Log`
--

DROP TABLE IF EXISTS `tabView Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabView Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `viewed_by` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `reference_name` (`reference_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabVoice Call Settings`
--

DROP TABLE IF EXISTS `tabVoice Call Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabVoice Call Settings` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `user` varchar(140) DEFAULT NULL,
  `call_receiving_device` varchar(140) DEFAULT 'Computer',
  `greeting_message` varchar(140) DEFAULT NULL,
  `agent_busy_message` varchar(140) DEFAULT NULL,
  `agent_unavailable_message` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `user` (`user`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWarehouse`
--

DROP TABLE IF EXISTS `tabWarehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWarehouse` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `disabled` int(1) NOT NULL DEFAULT 0,
  `warehouse_name` varchar(140) DEFAULT NULL,
  `is_group` int(1) NOT NULL DEFAULT 0,
  `parent_warehouse` varchar(140) DEFAULT NULL,
  `is_rejected_warehouse` int(1) NOT NULL DEFAULT 0,
  `account` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `email_id` varchar(140) DEFAULT NULL,
  `phone_no` varchar(140) DEFAULT NULL,
  `mobile_no` varchar(140) DEFAULT NULL,
  `address_line_1` varchar(140) DEFAULT NULL,
  `address_line_2` varchar(140) DEFAULT NULL,
  `city` varchar(140) DEFAULT NULL,
  `state` varchar(140) DEFAULT NULL,
  `pin` varchar(140) DEFAULT NULL,
  `warehouse_type` varchar(140) DEFAULT NULL,
  `default_in_transit_warehouse` varchar(140) DEFAULT NULL,
  `lft` int(11) NOT NULL DEFAULT 0,
  `rgt` int(11) NOT NULL DEFAULT 0,
  `old_parent` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent_warehouse` (`parent_warehouse`),
  KEY `company` (`company`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWarehouse Type`
--

DROP TABLE IF EXISTS `tabWarehouse Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWarehouse Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWarranty Claim`
--

DROP TABLE IF EXISTS `tabWarranty Claim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWarranty Claim` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Open',
  `complaint_date` date DEFAULT NULL,
  `customer` varchar(140) DEFAULT NULL,
  `serial_no` varchar(140) DEFAULT NULL,
  `complaint` longtext DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `warranty_amc_status` varchar(140) DEFAULT NULL,
  `warranty_expiry_date` date DEFAULT NULL,
  `amc_expiry_date` date DEFAULT NULL,
  `resolution_date` datetime(6) DEFAULT NULL,
  `resolved_by` varchar(140) DEFAULT NULL,
  `resolution_details` text DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `contact_person` varchar(140) DEFAULT NULL,
  `contact_display` text DEFAULT NULL,
  `contact_mobile` varchar(140) DEFAULT NULL,
  `contact_email` varchar(140) DEFAULT NULL,
  `territory` varchar(140) DEFAULT NULL,
  `customer_group` varchar(140) DEFAULT NULL,
  `customer_address` varchar(140) DEFAULT NULL,
  `address_display` text DEFAULT NULL,
  `service_address` text DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `complaint_raised_by` varchar(140) DEFAULT NULL,
  `from_company` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `status` (`status`),
  KEY `complaint_date` (`complaint_date`),
  KEY `customer` (`customer`),
  KEY `serial_no` (`serial_no`),
  KEY `item_code` (`item_code`),
  KEY `warranty_amc_status` (`warranty_amc_status`),
  KEY `resolution_date` (`resolution_date`),
  KEY `resolved_by` (`resolved_by`),
  KEY `territory` (`territory`),
  KEY `company` (`company`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWeb Form`
--

DROP TABLE IF EXISTS `tabWeb Form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWeb Form` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `published` int(1) NOT NULL DEFAULT 0,
  `doc_type` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `is_standard` int(1) NOT NULL DEFAULT 0,
  `introduction_text` longtext DEFAULT NULL,
  `anonymous` int(1) NOT NULL DEFAULT 0,
  `login_required` int(1) NOT NULL DEFAULT 0,
  `apply_document_permissions` int(1) NOT NULL DEFAULT 0,
  `allow_edit` int(1) NOT NULL DEFAULT 0,
  `allow_multiple` int(1) NOT NULL DEFAULT 0,
  `allow_delete` int(1) NOT NULL DEFAULT 0,
  `allow_incomplete` int(1) NOT NULL DEFAULT 0,
  `allow_comments` int(1) NOT NULL DEFAULT 0,
  `allow_print` int(1) NOT NULL DEFAULT 0,
  `print_format` varchar(140) DEFAULT NULL,
  `max_attachment_size` int(11) NOT NULL DEFAULT 0,
  `show_attachments` int(1) NOT NULL DEFAULT 0,
  `allowed_embedding_domains` text DEFAULT NULL,
  `condition_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`condition_json`)),
  `show_list` int(1) NOT NULL DEFAULT 0,
  `list_title` varchar(140) DEFAULT NULL,
  `show_sidebar` int(1) NOT NULL DEFAULT 0,
  `website_sidebar` varchar(140) DEFAULT NULL,
  `button_label` varchar(140) DEFAULT 'Save',
  `banner_image` text DEFAULT NULL,
  `breadcrumbs` longtext DEFAULT NULL,
  `success_title` varchar(140) DEFAULT NULL,
  `success_url` varchar(140) DEFAULT NULL,
  `success_message` text DEFAULT NULL,
  `meta_title` varchar(140) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_image` text DEFAULT NULL,
  `client_script` longtext DEFAULT NULL,
  `custom_css` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `route` (`route`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWeb Form Field`
--

DROP TABLE IF EXISTS `tabWeb Form Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWeb Form Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fieldname` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `allow_read_on_all_link_options` int(1) NOT NULL DEFAULT 0,
  `reqd` int(1) NOT NULL DEFAULT 0,
  `read_only` int(1) NOT NULL DEFAULT 0,
  `show_in_filter` int(1) NOT NULL DEFAULT 0,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `options` text DEFAULT NULL,
  `max_length` int(11) NOT NULL DEFAULT 0,
  `max_value` int(11) NOT NULL DEFAULT 0,
  `precision` varchar(140) DEFAULT NULL,
  `depends_on` longtext DEFAULT NULL,
  `mandatory_depends_on` longtext DEFAULT NULL,
  `read_only_depends_on` longtext DEFAULT NULL,
  `description` text DEFAULT NULL,
  `default` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWeb Form List Column`
--

DROP TABLE IF EXISTS `tabWeb Form List Column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWeb Form List Column` (
  `name` bigint(20) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fieldname` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWeb Page`
--

DROP TABLE IF EXISTS `tabWeb Page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWeb Page` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `dynamic_route` int(1) NOT NULL DEFAULT 0,
  `published` int(1) NOT NULL DEFAULT 1,
  `module` varchar(140) DEFAULT NULL,
  `content_type` varchar(140) DEFAULT 'Page Builder',
  `slideshow` varchar(140) DEFAULT NULL,
  `dynamic_template` int(1) NOT NULL DEFAULT 0,
  `main_section` longtext DEFAULT NULL,
  `main_section_md` longtext DEFAULT NULL,
  `main_section_html` longtext DEFAULT NULL,
  `context_script` longtext DEFAULT NULL,
  `javascript` longtext DEFAULT NULL,
  `insert_style` int(1) NOT NULL DEFAULT 0,
  `text_align` varchar(140) DEFAULT NULL,
  `css` longtext DEFAULT NULL,
  `full_width` int(1) NOT NULL DEFAULT 1,
  `show_title` int(1) NOT NULL DEFAULT 0,
  `start_date` datetime(6) DEFAULT NULL,
  `end_date` datetime(6) DEFAULT NULL,
  `meta_title` varchar(140) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_image` text DEFAULT NULL,
  `show_sidebar` int(1) NOT NULL DEFAULT 0,
  `website_sidebar` varchar(140) DEFAULT NULL,
  `enable_comments` int(1) NOT NULL DEFAULT 0,
  `header` longtext DEFAULT NULL,
  `breadcrumbs` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `route` (`route`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWeb Page Block`
--

DROP TABLE IF EXISTS `tabWeb Page Block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWeb Page Block` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `web_template` varchar(140) DEFAULT NULL,
  `web_template_values` longtext DEFAULT NULL,
  `css_class` text DEFAULT NULL,
  `section_id` varchar(140) DEFAULT NULL,
  `add_container` int(1) NOT NULL DEFAULT 1,
  `add_top_padding` int(1) NOT NULL DEFAULT 1,
  `add_bottom_padding` int(1) NOT NULL DEFAULT 1,
  `add_border_at_top` int(1) NOT NULL DEFAULT 0,
  `add_border_at_bottom` int(1) NOT NULL DEFAULT 0,
  `add_shade` int(1) NOT NULL DEFAULT 0,
  `hide_block` int(1) NOT NULL DEFAULT 0,
  `add_background_image` int(1) NOT NULL DEFAULT 0,
  `background_image` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWeb Page View`
--

DROP TABLE IF EXISTS `tabWeb Page View`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWeb Page View` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `path` varchar(140) DEFAULT NULL,
  `referrer` varchar(140) DEFAULT NULL,
  `browser` varchar(140) DEFAULT NULL,
  `browser_version` varchar(140) DEFAULT NULL,
  `is_unique` varchar(140) DEFAULT NULL,
  `time_zone` varchar(140) DEFAULT NULL,
  `user_agent` varchar(140) DEFAULT NULL,
  `source` varchar(140) DEFAULT NULL,
  `campaign` varchar(140) DEFAULT NULL,
  `medium` varchar(140) DEFAULT NULL,
  `visitor_id` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `visitor_id` (`visitor_id`),
  KEY `modified` (`modified`),
  KEY `path_index` (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWeb Template`
--

DROP TABLE IF EXISTS `tabWeb Template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWeb Template` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `type` varchar(140) DEFAULT 'Section',
  `standard` int(1) NOT NULL DEFAULT 0,
  `module` varchar(140) DEFAULT NULL,
  `template` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWeb Template Field`
--

DROP TABLE IF EXISTS `tabWeb Template Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWeb Template Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `fieldname` varchar(140) DEFAULT NULL,
  `fieldtype` varchar(140) DEFAULT 'Data',
  `reqd` int(1) NOT NULL DEFAULT 0,
  `options` text DEFAULT NULL,
  `default` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebhook`
--

DROP TABLE IF EXISTS `tabWebhook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebhook` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `webhook_doctype` varchar(140) DEFAULT NULL,
  `webhook_docevent` varchar(140) DEFAULT NULL,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `condition` text DEFAULT NULL,
  `request_url` text DEFAULT NULL,
  `is_dynamic_url` int(1) NOT NULL DEFAULT 0,
  `timeout` int(11) NOT NULL DEFAULT 5,
  `background_jobs_queue` varchar(140) DEFAULT NULL,
  `request_method` varchar(140) DEFAULT 'POST',
  `request_structure` varchar(140) DEFAULT NULL,
  `enable_security` int(1) NOT NULL DEFAULT 0,
  `webhook_secret` text DEFAULT NULL,
  `webhook_json` longtext DEFAULT NULL,
  `preview_document` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebhook Data`
--

DROP TABLE IF EXISTS `tabWebhook Data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebhook Data` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fieldname` varchar(140) DEFAULT NULL,
  `key` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebhook Header`
--

DROP TABLE IF EXISTS `tabWebhook Header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebhook Header` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `key` text DEFAULT NULL,
  `value` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebhook Request Log`
--

DROP TABLE IF EXISTS `tabWebhook Request Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebhook Request Log` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `webhook` varchar(140) DEFAULT NULL,
  `reference_document` varchar(140) DEFAULT NULL,
  `headers` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `url` text DEFAULT NULL,
  `response` longtext DEFAULT NULL,
  `error` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Attribute`
--

DROP TABLE IF EXISTS `tabWebsite Attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Attribute` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `attribute` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Filter Field`
--

DROP TABLE IF EXISTS `tabWebsite Filter Field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Filter Field` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `fieldname` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Item Group`
--

DROP TABLE IF EXISTS `tabWebsite Item Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Item Group` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `item_group` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Meta Tag`
--

DROP TABLE IF EXISTS `tabWebsite Meta Tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Meta Tag` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `key` varchar(140) DEFAULT NULL,
  `value` text DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Route Meta`
--

DROP TABLE IF EXISTS `tabWebsite Route Meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Route Meta` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Route Redirect`
--

DROP TABLE IF EXISTS `tabWebsite Route Redirect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Route Redirect` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `source` text DEFAULT NULL,
  `target` text DEFAULT NULL,
  `redirect_http_status` varchar(140) DEFAULT '301',
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Sidebar`
--

DROP TABLE IF EXISTS `tabWebsite Sidebar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Sidebar` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `title` (`title`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Sidebar Item`
--

DROP TABLE IF EXISTS `tabWebsite Sidebar Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Sidebar Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `title` varchar(140) DEFAULT NULL,
  `route` varchar(140) DEFAULT NULL,
  `group` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Slideshow`
--

DROP TABLE IF EXISTS `tabWebsite Slideshow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Slideshow` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `slideshow_name` varchar(140) DEFAULT NULL,
  `header` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `slideshow_name` (`slideshow_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Slideshow Item`
--

DROP TABLE IF EXISTS `tabWebsite Slideshow Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Slideshow Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `image` text DEFAULT NULL,
  `heading` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `url` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Theme`
--

DROP TABLE IF EXISTS `tabWebsite Theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Theme` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `theme` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT 'Website',
  `custom` int(1) NOT NULL DEFAULT 1,
  `google_font` varchar(140) DEFAULT NULL,
  `font_size` varchar(140) DEFAULT NULL,
  `font_properties` varchar(140) DEFAULT 'wght@300;400;500;600;700;800',
  `button_rounded_corners` int(1) NOT NULL DEFAULT 1,
  `button_shadows` int(1) NOT NULL DEFAULT 0,
  `button_gradients` int(1) NOT NULL DEFAULT 0,
  `primary_color` varchar(140) DEFAULT NULL,
  `text_color` varchar(140) DEFAULT NULL,
  `light_color` varchar(140) DEFAULT NULL,
  `dark_color` varchar(140) DEFAULT NULL,
  `background_color` varchar(140) DEFAULT NULL,
  `custom_overrides` longtext DEFAULT NULL,
  `custom_scss` longtext DEFAULT NULL,
  `theme_scss` longtext DEFAULT NULL,
  `theme_url` varchar(140) DEFAULT NULL,
  `js` longtext DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `theme` (`theme`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWebsite Theme Ignore App`
--

DROP TABLE IF EXISTS `tabWebsite Theme Ignore App`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWebsite Theme Ignore App` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `app` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWork Order`
--

DROP TABLE IF EXISTS `tabWork Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWork Order` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `naming_series` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Draft',
  `production_item` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `bom_no` varchar(140) DEFAULT NULL,
  `sales_order` varchar(140) DEFAULT NULL,
  `company` varchar(140) DEFAULT NULL,
  `qty` decimal(21,9) NOT NULL DEFAULT 1.000000000,
  `material_transferred_for_manufacturing` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `produced_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `disassembled_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `process_loss_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `project` varchar(140) DEFAULT NULL,
  `allow_alternative_item` int(1) NOT NULL DEFAULT 0,
  `use_multi_level_bom` int(1) NOT NULL DEFAULT 1,
  `skip_transfer` int(1) NOT NULL DEFAULT 0,
  `from_wip_warehouse` int(1) NOT NULL DEFAULT 0,
  `update_consumed_material_cost_in_project` int(1) NOT NULL DEFAULT 1,
  `source_warehouse` varchar(140) DEFAULT NULL,
  `wip_warehouse` varchar(140) DEFAULT NULL,
  `fg_warehouse` varchar(140) DEFAULT NULL,
  `scrap_warehouse` varchar(140) DEFAULT NULL,
  `has_serial_no` int(1) NOT NULL DEFAULT 0,
  `has_batch_no` int(1) NOT NULL DEFAULT 0,
  `batch_size` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `transfer_material_against` varchar(140) DEFAULT NULL,
  `planned_start_date` datetime(6) DEFAULT NULL,
  `planned_end_date` datetime(6) DEFAULT NULL,
  `expected_delivery_date` date DEFAULT NULL,
  `actual_start_date` datetime(6) DEFAULT NULL,
  `actual_end_date` datetime(6) DEFAULT NULL,
  `lead_time` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `planned_operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `additional_operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `corrective_operation_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `total_operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` text DEFAULT NULL,
  `stock_uom` varchar(140) DEFAULT NULL,
  `material_request` varchar(140) DEFAULT NULL,
  `material_request_item` varchar(140) DEFAULT NULL,
  `sales_order_item` varchar(140) DEFAULT NULL,
  `production_plan` varchar(140) DEFAULT NULL,
  `production_plan_item` varchar(140) DEFAULT NULL,
  `production_plan_sub_assembly_item` varchar(140) DEFAULT NULL,
  `product_bundle_item` varchar(140) DEFAULT NULL,
  `amended_from` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `_seen` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `status` (`status`),
  KEY `production_plan` (`production_plan`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWork Order Item`
--

DROP TABLE IF EXISTS `tabWork Order Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWork Order Item` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `operation` varchar(140) DEFAULT NULL,
  `item_code` varchar(140) DEFAULT NULL,
  `source_warehouse` varchar(140) DEFAULT NULL,
  `item_name` varchar(140) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `allow_alternative_item` int(1) NOT NULL DEFAULT 0,
  `include_item_in_manufacturing` int(1) NOT NULL DEFAULT 0,
  `required_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `stock_uom` varchar(140) DEFAULT NULL,
  `rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `transferred_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `consumed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `returned_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `available_qty_at_source_warehouse` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `available_qty_at_wip_warehouse` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `item_code` (`item_code`),
  KEY `parent` (`parent`),
  KEY `item_code_source_warehouse_index` (`item_code`,`source_warehouse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWork Order Operation`
--

DROP TABLE IF EXISTS `tabWork Order Operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWork Order Operation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `operation` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT 'Pending',
  `completed_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `process_loss_qty` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `bom` varchar(140) DEFAULT NULL,
  `workstation_type` varchar(140) DEFAULT NULL,
  `workstation` varchar(140) DEFAULT NULL,
  `sequence_id` int(11) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `planned_start_time` datetime(6) DEFAULT NULL,
  `hour_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `time_in_mins` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `planned_end_time` datetime(6) DEFAULT NULL,
  `batch_size` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `planned_operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_start_time` datetime(6) DEFAULT NULL,
  `actual_operation_time` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `actual_end_time` datetime(6) DEFAULT NULL,
  `actual_operating_cost` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkflow`
--

DROP TABLE IF EXISTS `tabWorkflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkflow` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `workflow_name` varchar(140) DEFAULT NULL,
  `document_type` varchar(140) DEFAULT NULL,
  `is_active` int(1) NOT NULL DEFAULT 0,
  `override_status` int(1) NOT NULL DEFAULT 0,
  `send_email_alert` int(1) NOT NULL DEFAULT 0,
  `workflow_state_field` varchar(140) DEFAULT 'workflow_state',
  `workflow_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`workflow_data`)),
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `workflow_name` (`workflow_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkflow Action`
--

DROP TABLE IF EXISTS `tabWorkflow Action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkflow Action` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `status` varchar(140) DEFAULT NULL,
  `reference_name` varchar(140) DEFAULT NULL,
  `reference_doctype` varchar(140) DEFAULT NULL,
  `workflow_state` varchar(140) DEFAULT NULL,
  `completed_by_role` varchar(140) DEFAULT NULL,
  `completed_by` varchar(140) DEFAULT NULL,
  `user` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `user` (`user`),
  KEY `modified` (`modified`),
  KEY `reference_name_reference_doctype_status_index` (`reference_name`,`reference_doctype`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkflow Action Master`
--

DROP TABLE IF EXISTS `tabWorkflow Action Master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkflow Action Master` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `workflow_action_name` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `workflow_action_name` (`workflow_action_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkflow Action Permitted Role`
--

DROP TABLE IF EXISTS `tabWorkflow Action Permitted Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkflow Action Permitted Role` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `role` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkflow Document State`
--

DROP TABLE IF EXISTS `tabWorkflow Document State`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkflow Document State` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `state` varchar(140) DEFAULT NULL,
  `doc_status` varchar(140) DEFAULT '0',
  `update_field` varchar(140) DEFAULT NULL,
  `update_value` varchar(140) DEFAULT NULL,
  `is_optional_state` int(1) NOT NULL DEFAULT 0,
  `avoid_status_override` int(1) NOT NULL DEFAULT 0,
  `next_action_email_template` varchar(140) DEFAULT NULL,
  `allow_edit` varchar(140) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `workflow_builder_id` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  `send_email` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkflow State`
--

DROP TABLE IF EXISTS `tabWorkflow State`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkflow State` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `workflow_state_name` varchar(140) DEFAULT NULL,
  `icon` varchar(140) DEFAULT NULL,
  `style` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `workflow_state_name` (`workflow_state_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkflow Transition`
--

DROP TABLE IF EXISTS `tabWorkflow Transition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkflow Transition` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `state` varchar(140) DEFAULT NULL,
  `action` varchar(140) DEFAULT NULL,
  `next_state` varchar(140) DEFAULT NULL,
  `allowed` varchar(140) DEFAULT NULL,
  `allow_self_approval` int(1) NOT NULL DEFAULT 1,
  `condition` longtext DEFAULT NULL,
  `workflow_builder_id` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  `send_email_to_creator` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkspace`
--

DROP TABLE IF EXISTS `tabWorkspace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkspace` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `label` varchar(140) DEFAULT NULL,
  `title` varchar(140) DEFAULT NULL,
  `sequence_id` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `for_user` varchar(140) DEFAULT NULL,
  `parent_page` varchar(140) DEFAULT NULL,
  `module` varchar(140) DEFAULT NULL,
  `icon` varchar(140) DEFAULT NULL,
  `indicator_color` varchar(140) DEFAULT NULL,
  `restrict_to_domain` varchar(140) DEFAULT NULL,
  `hide_custom` int(1) NOT NULL DEFAULT 0,
  `public` int(1) NOT NULL DEFAULT 0,
  `is_hidden` int(1) NOT NULL DEFAULT 0,
  `content` longtext,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `label` (`label`),
  KEY `restrict_to_domain` (`restrict_to_domain`),
  KEY `public` (`public`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkspace Chart`
--

DROP TABLE IF EXISTS `tabWorkspace Chart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkspace Chart` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `chart_name` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkspace Custom Block`
--

DROP TABLE IF EXISTS `tabWorkspace Custom Block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkspace Custom Block` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `custom_block_name` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkspace Link`
--

DROP TABLE IF EXISTS `tabWorkspace Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkspace Link` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `type` varchar(140) DEFAULT 'Link',
  `label` varchar(140) DEFAULT NULL,
  `icon` varchar(140) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `link_type` varchar(140) DEFAULT NULL,
  `link_to` varchar(140) DEFAULT NULL,
  `report_ref_doctype` varchar(140) DEFAULT NULL,
  `dependencies` varchar(140) DEFAULT NULL,
  `only_for` varchar(140) DEFAULT NULL,
  `onboard` int(1) NOT NULL DEFAULT 0,
  `is_query_report` int(1) NOT NULL DEFAULT 0,
  `link_count` int(11) NOT NULL DEFAULT 0,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkspace Number Card`
--

DROP TABLE IF EXISTS `tabWorkspace Number Card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkspace Number Card` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `number_card_name` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkspace Quick List`
--

DROP TABLE IF EXISTS `tabWorkspace Quick List`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkspace Quick List` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `document_type` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `quick_list_filter` longtext DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkspace Shortcut`
--

DROP TABLE IF EXISTS `tabWorkspace Shortcut`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkspace Shortcut` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `type` varchar(140) DEFAULT NULL,
  `link_to` varchar(140) DEFAULT NULL,
  `url` varchar(140) DEFAULT NULL,
  `doc_view` varchar(140) DEFAULT NULL,
  `kanban_board` varchar(140) DEFAULT NULL,
  `label` varchar(140) DEFAULT NULL,
  `icon` varchar(140) DEFAULT NULL,
  `restrict_to_domain` varchar(140) DEFAULT NULL,
  `stats_filter` longtext DEFAULT NULL,
  `color` varchar(140) DEFAULT NULL,
  `format` varchar(140) DEFAULT NULL,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  `report_ref_doctype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkstation`
--

DROP TABLE IF EXISTS `tabWorkstation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkstation` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `workstation_name` varchar(140) DEFAULT NULL,
  `workstation_type` varchar(140) DEFAULT NULL,
  `plant_floor` varchar(140) DEFAULT NULL,
  `production_capacity` int(11) NOT NULL DEFAULT 1,
  `warehouse` varchar(140) DEFAULT NULL,
  `status` varchar(140) DEFAULT NULL,
  `on_status_image` text DEFAULT NULL,
  `off_status_image` text DEFAULT NULL,
  `hour_rate_electricity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `hour_rate_consumable` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `hour_rate_rent` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `hour_rate_labour` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `hour_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` text DEFAULT NULL,
  `holiday_list` varchar(140) DEFAULT NULL,
  `total_working_hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `workstation_name` (`workstation_name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkstation Type`
--

DROP TABLE IF EXISTS `tabWorkstation Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkstation Type` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `workstation_type` varchar(140) DEFAULT NULL,
  `hour_rate_electricity` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `hour_rate_consumable` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `hour_rate_rent` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `hour_rate_labour` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `hour_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `description` text DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `workstation_type` (`workstation_type`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabWorkstation Working Hour`
--

DROP TABLE IF EXISTS `tabWorkstation Working Hour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabWorkstation Working Hour` (
  `name` varchar(140) NOT NULL,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `start_time` time(6) DEFAULT NULL,
  `hours` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `end_time` time(6) DEFAULT NULL,
  `enabled` int(1) NOT NULL DEFAULT 1,
  `parent` varchar(140) DEFAULT NULL,
  `parentfield` varchar(140) DEFAULT NULL,
  `parenttype` varchar(140) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-10 10:19:33

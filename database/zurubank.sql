CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(255),
    role VARCHAR(50) DEFAULT 'customer',
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    account_number VARCHAR(255),
    account_type VARCHAR(50) DEFAULT 'checking',
    balance NUMERIC(15, 2) DEFAULT 0.00,
    currency VARCHAR(10) DEFAULT 'ZAR',
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE sessions (
    session_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INTEGER DEFAULT 0,
    account_id INTEGER NOT NULL DEFAULT 0,
    from_account VARCHAR(255),
    to_account VARCHAR(255),
    type VARCHAR(50) NOT NULL,
    amount NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    reference VARCHAR(255),
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    swap_fee NUMERIC(15, 2) DEFAULT 0.00,
    creation_fee NUMERIC(15, 2) DEFAULT 0.00,
    admin_fee NUMERIC(15, 2) DEFAULT 0.00,
    sms_fee NUMERIC(15, 2) DEFAULT 0.00,
    rounding_adjustment NUMERIC(15, 2) DEFAULT 0.00
);

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    entity VARCHAR(255) NOT NULL,
    entity_id INTEGER NOT NULL,
    action VARCHAR(255) NOT NULL,
    category VARCHAR(50) DEFAULT 'system',
    severity VARCHAR(50) DEFAULT 'info',
    old_value TEXT,
    new_value TEXT,
    performed_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    performed_by INTEGER NOT NULL,
    ip_address VARCHAR(50),
    user_agent TEXT,
    geo_location VARCHAR(255)
);

CREATE TABLE account_freezes (
    freeze_id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL,
    reason TEXT,
    frozen_by INTEGER,
    start_time TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP WITHOUT TIME ZONE
);


CREATE TABLE ledger_accounts (
    id SERIAL PRIMARY KEY,
    account_name VARCHAR(255) NOT NULL,
    account_number VARCHAR(255) NOT NULL UNIQUE,
    account_type VARCHAR(50) NOT NULL,
    balance NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(10) NOT NULL DEFAULT 'ZAR',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE swap_linked_banks (
    id SERIAL PRIMARY KEY,
    bank_code VARCHAR(50) NOT NULL UNIQUE,
    bank_name VARCHAR(255) NOT NULL,
    api_endpoint VARCHAR(255),
    public_key TEXT,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE central_bank_link (
    id SERIAL PRIMARY KEY,
    bank_id INTEGER NOT NULL,
    link_status VARCHAR(50) DEFAULT 'connected',
    last_sync TIMESTAMP WITHOUT TIME ZONE
);

-- Table: external_banks (Inferred, based on table list)
CREATE TABLE external_banks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    bank_name VARCHAR(255) NOT NULL,
    account_number VARCHAR(255) NOT NULL
);


CREATE TABLE swap_internal_accounts (
    id SERIAL PRIMARY KEY,
    account_code VARCHAR(255) NOT NULL UNIQUE,
    purpose VARCHAR(50) NOT NULL,
    balance NUMERIC(15, 2) DEFAULT 0.00,
    currency CHAR(3) DEFAULT 'ZAR',
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE swap_ledger (
    ledger_id SERIAL PRIMARY KEY,
    reference_id VARCHAR(255) NOT NULL,
    ref_voucher_id INTEGER,
    debit_account VARCHAR(255) NOT NULL,
    credit_account VARCHAR(255) NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    currency CHAR(3) DEFAULT 'ZAR',
    description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE swap_ledgers (
    ledger_id BIGSERIAL PRIMARY KEY,
    swap_reference VARCHAR(255) NOT NULL UNIQUE,
    from_participant VARCHAR(255) NOT NULL,
    to_participant VARCHAR(255) NOT NULL,
    from_type VARCHAR(255) NOT NULL,
    to_type VARCHAR(255) NOT NULL,
    from_account VARCHAR(255),
    to_account VARCHAR(255),
    original_amount NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    final_amount NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    currency_code VARCHAR(10) NOT NULL DEFAULT 'ZAR',
    swap_fee NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    creation_fee NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    admin_fee NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    sms_fee NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    token VARCHAR(255),
    status VARCHAR(50) NOT NULL DEFAULT 'completed',
    reverse_logic BOOLEAN NOT NULL DEFAULT FALSE,
    performed_by INTEGER NOT NULL DEFAULT 1,
    notes TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE swap_transactions (
    id SERIAL PRIMARY KEY,
    middleman_id INTEGER,
    source VARCHAR(255) NOT NULL,
    destination VARCHAR(255),
    type VARCHAR(50) NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    reference VARCHAR(255),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE swap_middleman (
    id SERIAL PRIMARY KEY,
    account_number VARCHAR(255) NOT NULL UNIQUE,
    api_key VARCHAR(255) NOT NULL,
    webhook_url VARCHAR(255),
    encryption_key VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE zurubank_middleman (
    id SERIAL PRIMARY KEY,
    account_number VARCHAR(255) NOT NULL UNIQUE,
    api_key VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE swap_audit (
    id SERIAL PRIMARY KEY,
    action_type VARCHAR(50) NOT NULL,
    actor VARCHAR(255),
    reference VARCHAR(255),
    details TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE swap_settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(255) NOT NULL UNIQUE,
    setting_value VARCHAR(255) NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE system_settings (
    setting_key VARCHAR(255) PRIMARY KEY,
    setting_value VARCHAR(255),
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE instant_money_wallets (
    wallet_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    balance NUMERIC(15, 2) DEFAULT 0.00,
    currency CHAR(3) DEFAULT 'ZAR',
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE instant_money_transactions (
    transaction_id SERIAL PRIMARY KEY,
    wallet_id INTEGER NOT NULL,
    type VARCHAR(50) NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    reference VARCHAR(255),
    related_account_id INTEGER,
    status VARCHAR(50) DEFAULT 'completed',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE instant_money_transfers (
    transfer_id SERIAL PRIMARY KEY,
    from_wallet_id INTEGER NOT NULL,
    to_wallet_id INTEGER NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    reference VARCHAR(255),
    status VARCHAR(50) DEFAULT 'completed',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE instant_money_vouchers (
    voucher_id SERIAL PRIMARY KEY,
    amount NUMERIC(15, 2) NOT NULL,
    currency CHAR(3) DEFAULT 'ZAR',
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    created_by INTEGER NOT NULL,
    recipient_phone VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    voucher_number VARCHAR(255),
    voucher_pin VARCHAR(255),
    redeemed_by INTEGER,
    voucher_created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    voucher_expires_at TIMESTAMP WITHOUT TIME ZONE,
    swap_enabled BOOLEAN DEFAULT FALSE,
    swap_fee_paid_by VARCHAR(50) DEFAULT 'sender',
    swap_expires_at TIMESTAMP WITHOUT TIME ZONE,
    redeemed_at TIMESTAMP WITHOUT TIME ZONE
);


ALTER TABLE accounts ADD CONSTRAINT fk_accounts_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE sessions ADD CONSTRAINT fk_sessions_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE account_freezes ADD CONSTRAINT fk_freezes_account_id FOREIGN KEY (account_id) REFERENCES accounts(account_id);

ALTER TABLE central_bank_link ADD CONSTRAINT fk_cbl_bank_id FOREIGN KEY (bank_id) REFERENCES swap_linked_banks(id);

ALTER TABLE external_banks ADD CONSTRAINT fk_eb_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE instant_money_wallets ADD CONSTRAINT fk_imw_user_id FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE instant_money_transactions ADD CONSTRAINT fk_imt_wallet_id FOREIGN KEY (wallet_id) REFERENCES instant_money_wallets(wallet_id);

ALTER TABLE instant_money_transfers ADD CONSTRAINT fk_imtf_from_wallet_id FOREIGN KEY (from_wallet_id) REFERENCES instant_money_wallets(wallet_id);
ALTER TABLE instant_money_transfers ADD CONSTRAINT fk_imtf_to_wallet_id FOREIGN KEY (to_wallet_id) REFERENCES instant_money_wallets(wallet_id);

ALTER TABLE instant_money_vouchers ADD CONSTRAINT fk_imv_created_by FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE instant_money_vouchers ADD CONSTRAINT fk_imv_redeemed_by FOREIGN KEY (redeemed_by) REFERENCES users(user_id);

ALTER TABLE transactions ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
ALTER TABLE swap_ledger ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;

CREATE OR REPLACE FUNCTION prevent_hard_delete()
RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'Hard deletes are forbidden on financial records per BoB/ECB standards';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER no_delete_transactions
BEFORE DELETE ON transactions
FOR EACH ROW EXECUTE FUNCTION prevent_hard_delete();

CREATE TRIGGER no_delete_swap_ledger
BEFORE DELETE ON swap_ledger
FOR EACH ROW EXECUTE FUNCTION prevent_hard_delete();


ALTER TABLE swap_ledger ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT NOW();

-- Updating Balance Precision to 4 decimal places (ECB/BoB Audit Standard)
ALTER TABLE accounts ALTER COLUMN balance TYPE NUMERIC(20,4);
ALTER TABLE ledger_accounts ALTER COLUMN balance TYPE NUMERIC(20,4);

-- ZuruBank uses 'instant_money_wallets' instead of 'wallets'
ALTER TABLE instant_money_wallets ALTER COLUMN balance TYPE NUMERIC(20,4);


CREATE TABLE chart_of_accounts (
    coa_code VARCHAR(20) PRIMARY KEY,
    coa_name VARCHAR(255) NOT NULL,
    coa_type VARCHAR(20) CHECK (coa_type IN ('asset','liability','equity','income','expense')),
    parent_coa_code VARCHAR(20),
    is_customer_account BOOLEAN DEFAULT FALSE,
    is_trust_account BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounting_closures (
    closure_date DATE PRIMARY KEY,
    closed_by INTEGER,
    closed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    closure_type VARCHAR(20) CHECK (closure_type IN ('EOD','EOM','EOY')),
    remarks TEXT
);

CREATE TABLE data_retention_policies (
    entity_name VARCHAR(100) PRIMARY KEY,
    retention_years INT NOT NULL,
    legal_basis TEXT NOT NULL,
    retention_trigger VARCHAR(150) DEFAULT 'from date of last transaction / end of relationship',
    disposal_action VARCHAR(50) DEFAULT 'DELETE_OR_ANONYMIZE',
    country VARCHAR(50) DEFAULT 'South Africa',
    last_reviewed DATE DEFAULT CURRENT_DATE
);

INSERT INTO data_retention_policies 
(entity_name, retention_years, legal_basis, retention_trigger, disposal_action)
VALUES
(
    'financial_transactions',
    7,
    'South Africa: Companies Act / Tax Administration / VAT record retention; POPIA Section 14 permits retention where required by law',
    'from financial year-end or last transaction date',
    'ARCHIVE_THEN_DELETE'
),
(
    'customer_personal_information',
    5,
    'South Africa: POPIA Section 14 - retain only as long as necessary unless required by law, contract, consent, or lawful business purpose',
    'from end of customer relationship or last lawful processing purpose',
    'DELETE_OR_ANONYMIZE'
),
(
    'kyc_aml_records',
    5,
    'South Africa: FICA record retention; POPIA Section 14 allows legally required retention',
    'from date of last transaction or end of business relationship',
    'SECURE_DELETE'
);


CREATE TABLE disaster_recovery_tests (
    test_id BIGSERIAL PRIMARY KEY,
    test_date DATE NOT NULL,
    test_type VARCHAR(50),
    systems_tested TEXT[],
    result VARCHAR(20) CHECK (result IN ('pass','fail','partial')),
    issues_found TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    signed_off_by INTEGER
);



INSERT INTO chart_of_accounts (coa_code, coa_name, coa_type, is_trust_account)
VALUES 
('1000', 'Cash & Central Bank Reserves', 'asset', TRUE),
('2000', 'Customer Deposit Liabilities', 'liability', FALSE),
('2100', 'Voucher Suspense Liability', 'liability', FALSE),
('4000', 'Transaction Fee Income', 'income', FALSE);

ALTER TABLE users RENAME COLUMN password TO password_hash;

ALTER TABLE users
  ADD COLUMN password_changed_at TIMESTAMP,
  ADD COLUMN failed_login_attempts INT DEFAULT 0,
  ADD COLUMN last_failed_login TIMESTAMP;

CREATE TABLE kyc_profiles (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  kyc_level VARCHAR(20) CHECK (kyc_level IN ('LOW','MEDIUM','HIGH')),
  risk_rating VARCHAR(20) CHECK (risk_rating IN ('LOW','MEDIUM','HIGH')),
  source_of_funds TEXT NOT NULL,
  pep BOOLEAN DEFAULT FALSE,
  sanctions_checked BOOLEAN DEFAULT FALSE,
  last_reviewed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

ALTER TABLE transactions
  ADD COLUMN is_large_transaction BOOLEAN DEFAULT FALSE,
  ADD COLUMN is_suspicious BOOLEAN DEFAULT FALSE,
  ADD COLUMN reported_to_regulator BOOLEAN DEFAULT FALSE,
  ADD COLUMN regulator_report_reference VARCHAR(255);

CREATE TABLE journals (
  journal_id BIGSERIAL PRIMARY KEY,
  reference VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE swap_ledger
  ADD COLUMN journal_id BIGINT,
  ADD CONSTRAINT fk_swap_journal
  FOREIGN KEY (journal_id) REFERENCES journals(journal_id);

CREATE OR REPLACE FUNCTION enforce_balanced_journal()
RETURNS trigger AS $$
DECLARE
  total NUMERIC(20,4);
BEGIN
  SELECT SUM(
    CASE WHEN debit_account IS NOT NULL THEN amount ELSE -amount END
  )
  INTO total
  FROM swap_ledger
  WHERE journal_id = NEW.journal_id;

  IF total <> 0 THEN
    RAISE EXCEPTION 'Journal % is not balanced', NEW.journal_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enforce_journal_balance
AFTER INSERT OR UPDATE ON swap_ledger
FOR EACH ROW EXECUTE FUNCTION enforce_balanced_journal();

INSERT INTO ledger_accounts (account_name, account_number, account_type)
VALUES ('Voucher Suspense Account','VOUCHER-SUSPENSE','liability')
ON CONFLICT DO NOTHING;

ALTER TABLE instant_money_vouchers
  ADD COLUMN holding_account VARCHAR(64) DEFAULT 'VOUCHER-SUSPENSE';
  
ALTER TABLE cashouts ALTER COLUMN atm_id DROP NOT NULL;
ALTER TABLE cashouts ADD COLUMN agent_id INTEGER;

ALTER TABLE cashouts ADD COLUMN IF NOT EXISTS source_bank_id INTEGER;

DROP TABLE IF EXISTS atm_dispenses;

CREATE TABLE atm_dispenses (
    id SERIAL PRIMARY KEY,
    atm_id VARCHAR(50) NOT NULL,
    trace_number VARCHAR(255) NOT NULL UNIQUE,
    amount NUMERIC(20,4) NOT NULL,
    currency VARCHAR(10) DEFAULT 'ZAR',
    status VARCHAR(50) DEFAULT 'DISPENSED',
    created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE atm_dispenses ADD COLUMN IF NOT EXISTS currency VARCHAR(10) DEFAULT 'ZAR';

ALTER TABLE instant_money_vouchers
ADD COLUMN IF NOT EXISTS external_reference VARCHAR(255);

ALTER TABLE instant_money_vouchers
ADD COLUMN IF NOT EXISTS source_institution VARCHAR(100);

ALTER TABLE instant_money_vouchers
ADD COLUMN IF NOT EXISTS source_hold_reference VARCHAR(255);

ALTER TABLE instant_money_vouchers 
ADD COLUMN IF NOT EXISTS reference VARCHAR(255);

ALTER TABLE instant_money_vouchers 
ADD COLUMN IF NOT EXISTS source_institution VARCHAR(100),
ADD COLUMN IF NOT EXISTS source_hold_reference VARCHAR(255),
ADD COLUMN IF NOT EXISTS source_asset_type VARCHAR(50),
ADD COLUMN IF NOT EXISTS code_hash VARCHAR(255);

ALTER TABLE instant_money_vouchers 
ADD COLUMN IF NOT EXISTS reference VARCHAR(255),
ADD COLUMN IF NOT EXISTS source_institution VARCHAR(100),
ADD COLUMN IF NOT EXISTS source_hold_reference VARCHAR(255),
ADD COLUMN IF NOT EXISTS source_asset_type VARCHAR(50),
ADD COLUMN IF NOT EXISTS code_hash VARCHAR(255);

ALTER TABLE voucher_cashout_details 
ADD COLUMN IF NOT EXISTS reference VARCHAR(255),
ADD COLUMN IF NOT EXISTS source_institution VARCHAR(100);


CREATE TABLE IF NOT EXISTS voucher_cashout_details (
    id SERIAL PRIMARY KEY,
    voucher_number VARCHAR(255) NOT NULL UNIQUE,
    auth_code VARCHAR(50) UNIQUE NOT NULL,
    amount NUMERIC(20,4) NOT NULL,
    currency VARCHAR(10) DEFAULT 'ZAR',
    recipient_phone VARCHAR(50),
    instructions TEXT,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    reference VARCHAR(255),
    source_institution VARCHAR(100)
);


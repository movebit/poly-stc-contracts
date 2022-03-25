address 0x18351d311d32201149a4df2a9fc2db8a {

module CrossChainConfig {
    use 0x1::Config;
    use 0x1::Signer;
    use 0x1::Errors;

    const ERR_NOT_GENESIS_ACCOUNT: u64 = 101;

    struct AdminAccount has copy, drop, store {
        addr: address,
    }

    struct FeeCollectionAccount has copy, drop, store {
        addr: address,
    }

    /// Switch is true if opening, otherwise closed
    struct Freeze has copy, drop, store {
        switch: bool,
    }

    public fun set_freeze(signer: &signer, switch: bool) {
        assert_genesis(Signer::address_of(signer));

        let config = Freeze{
            switch,
        };
        if (Config::config_exist_by_address<Freeze>(genesis_address())) {
            Config::set<Freeze>(signer, config);
        } else {
            Config::publish_new_config<Freeze>(signer, config);
        }
    }

    public fun freezing(): bool {
        if (Config::config_exist_by_address<Freeze>(genesis_address())) {
            let conf = Config::get_by_address<Freeze>(genesis_address());
            conf.switch
        } else {
            false
        }
    }

    /// Set admin account to config
    public fun set_admin_account(signer: &signer, addr: address) {
        assert_genesis(Signer::address_of(signer));

        let config = AdminAccount{
            addr,
        };
        if (Config::config_exist_by_address<AdminAccount>(genesis_address())) {
            Config::set<AdminAccount>(signer, config);
        } else {
            Config::publish_new_config<AdminAccount>(signer, config);
        }
    }

    /// Get admin account from config
    public fun admin_account(): address {
        if (Config::config_exist_by_address<AdminAccount>(genesis_address())) {
            let conf = Config::get_by_address<AdminAccount>(genesis_address());
            conf.addr
        } else {
            genesis_address()
        }
    }

    /// Set fee collection account by genesis account
    public fun set_fee_collection_account(signer: &signer, addr: address) {
        assert_genesis(Signer::address_of(signer));

        let config = FeeCollectionAccount{
            addr,
        };
        if (Config::config_exist_by_address<FeeCollectionAccount>(genesis_address())) {
            Config::set<FeeCollectionAccount>(signer, config);
        } else {
            Config::publish_new_config<FeeCollectionAccount>(signer, config);
        }
    }

    /// Get fee collection account from config
    public fun fee_collection_account(): address {
        if (Config::config_exist_by_address<FeeCollectionAccount>(genesis_address())) {
            let conf = Config::get_by_address<FeeCollectionAccount>(genesis_address());
            conf.addr
        } else {
            genesis_address()
        }
    }

    public fun genesis_address(): address {
        @0x18351d311d32201149a4df2a9fc2db8a
    }

    public fun assert_genesis(account: address) {
        assert(account == genesis_address(), Errors::invalid_state(ERR_NOT_GENESIS_ACCOUNT));
    }
}
}

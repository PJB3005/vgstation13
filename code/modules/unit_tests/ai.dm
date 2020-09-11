
/datum/unit_test/malf_apc_hacking_timer/start()
    assert_eq(calculate_malf_hack_APC_cooldown(0), 600)
    assert_eq(calculate_malf_hack_APC_cooldown(1), 600)
    assert_eq(calculate_malf_hack_APC_cooldown(2), 450)
    assert_eq(calculate_malf_hack_APC_cooldown(3), 300)
    assert_eq(calculate_malf_hack_APC_cooldown(4), 230)
    assert_eq(calculate_malf_hack_APC_cooldown(5), 180)
    assert_eq(calculate_malf_hack_APC_cooldown(10), 100)
    assert_eq(calculate_malf_hack_APC_cooldown(50), 100)
    assert_eq(calculate_malf_hack_APC_cooldown(100), 100)

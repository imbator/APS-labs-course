webtalk_init -webtalk_dir C:/Processors/ultimate_processor.sim/sim_1/behav/xsim/xsim.dir/main_behav/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Wed Oct 26 17:55:07 2022" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "XSIM v2019.2 (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "2708876" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "WIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "xsim_vivado" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "07820369-c53b-4f79-8ca4-50520233b3fa" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "265ecdce6de44269ae7328f8ed3704e5" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "111" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "Windows Server 2016 or Windows 10" -context "user_environment"
webtalk_add_data -client project -key os_release -value "major release  (build 9200)" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Core(TM) i5-4670 CPU @ 3.40GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "3392 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "1" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "16.000 GB" -context "user_environment"
webtalk_register_client -client xsim
webtalk_add_data -client xsim -key Command -value "xsim" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key trace_waveform -value "true" -context "xsim\\usage"
webtalk_add_data -client xsim -key runtime -value "100 ns" -context "xsim\\usage"
webtalk_add_data -client xsim -key iteration -value "0" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Time -value "0.03_sec" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Memory -value "6516_KB" -context "xsim\\usage"
webtalk_transmit -clientid 560978216 -regid "" -xml C:/Processors/ultimate_processor.sim/sim_1/behav/xsim/xsim.dir/main_behav/webtalk/usage_statistics_ext_xsim.xml -html C:/Processors/ultimate_processor.sim/sim_1/behav/xsim/xsim.dir/main_behav/webtalk/usage_statistics_ext_xsim.html -wdm C:/Processors/ultimate_processor.sim/sim_1/behav/xsim/xsim.dir/main_behav/webtalk/usage_statistics_ext_xsim.wdm -intro "<H3>XSIM Usage Report</H3><BR>"
webtalk_terminate

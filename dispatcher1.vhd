library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

entity dispatcher1 is

port(	Rd1, Rd2: in std_logic_vector(2 downto 0);
		Rs21, Rs22: in std_logic_vector(2 downto 0);
		RF1_en, RF2_en : in std_logic;		
		free_tag1_in, free_tag2_in : in std_logic_vector(3 downto 0);	--free tags given by RRF to assign
		free1_valid, free2_valid: in std_logic;
		
		--address to write is directly taken from the pipeline
		tag1_out, tag2_out : out std_logic_vector(3 downto 0);
		tag1_write_en, tag2_write_en : out std_logic; 
		--busy is set whenever write occurs (implemented as part of ARF)		
			
		Rs21_tag_mux_ctrl, Rs22_tag_mux_ctrl, busy21, busy22: out std_logic;
		Rs21_tag, Rs22_tag: out std_logic_vector(3 downto 0);

		free_tag1_used, free_tag2_used : out std_logic

		C1_en, Z1_en, C2_en, Z2_en : in std_logic;
		C2_dep, Z2_dep : in std_logic;
		free_tagC1_in, free_tagC2_in, free_tagZ1_in, free_tagZ2_in : in std_logic_vector(3 downto 0);
		freeC1_valid, freeC2_valid, freeZ1_valid, freeZ2_valid: in std_logic;
		
		--address to write is directly taken from the pipeline
		tagC_out, tagZ_out : out std_logic_vector(3 downto 0);
		tagC_write_en, tagZ_write_en : out std_logic; 
		--busy is set whenever write occurs (implemented as part of ARF)

		C2_tag_mux_ctrl, Z2_tag_mux_ctrl, busyC2, busyZ2: out std_logic;
		C2_tag, Z2_tag: out std_logic_vector(3 downto 0);
	
	);

end dispatcher1;

architecture behave of dispatcher1 is


begin
	
	process(Rd1, Rs21, Rs22, RF1_en, RF2_en, free_tag1_in, free_tag2_in, free1_valid, free2_valid)
		variable vtag1_write_en, vtag2_write_en : std_logic;
		variable vRs21_tag_mux_ctrl, vRs22_tag_mux_ctrl : std_logic;
	begin
		vtag1_write_en := '0'; vtag2_write_en := '0';
		vRs21_tag_mux_ctrl := '0'; vRs22_tag_mux_ctrl := '0';

		if(RF1_en = '1' and free1_valid = '1') then
			vtag1_write_en := '1';
		end if;

		if(RF2_en = '1' and free2_valid = '1') then
			vtag2_write_en := '1';	
		end if;
		
		if(Rs21 = Rd1) then		
			vRs21_tag_mux_ctrl := '1';
		end if;

		if(Rs22 = Rd1) then		
			vRs22_tag_mux_ctrl := '1';
		end if;

		tag1_write_en <= vtag1_write_en;
		free_tag1_used <= vtag1_write_en;
		tag2_write_en <= vtag2_write_en;
		free_tag2_used <= vtag2_write_en;
		Rs21_tag_mux_ctrl <= vRs21_tag_mux_ctrl;
		Rs22_tag_mux_ctrl <= vRs22_tag_mux_ctrl;
		busy21 <= vRs21_tag_mux_ctrl;
		busy22 <= vRs22_tag_mux_ctrl;

	end process;

	tag1_out <= free_tag1_in; tag2_out <= free_tag2_in;
	Rs21_tag <= free_tag1_in; Rs22_tag <= free_tag1_in;


-- lot of wrong stuff here. Correct for C and Z renaming. Also add related stuff in dispatcher2
	process(C1_en, C2_en, Z1_en, Z2_en)
		variable vtagC_write_en, vtagZ_write_en : std_logic;
		variable vC2_tag_mux_ctrl, vZ2_tag_mux_ctrl : std_logic;
	begin
		vtagC_write_en := '0'; vtagZ_write_en := '0';
		vC2_tag_mux_ctrl := '0'; vZ2_tag_mux_ctrl := '0';

		if((C1_en or C2_en) = '1' and freeC1_valid = '1') then
			vtagC_write_en := '1';
		end if;

		if(C1_en = '1' and freeC1_valid = '1') then
			if(C2_en = '1' and freeC2_valid = '1') then
				Ctag_out := free_tagC2_in;
			else 
				Ctag_out := free_tagC1_in; 			
		end if;

		if((Z1_en or C2_en) = '1' and freeZ1_valid = '1') then
			vtagZ_write_en := '1';	
		end if;
		
		if(C2_dep = '1' and C1_en = '1') then		
			vC2_tag_mux_ctrl := '1';
		end if;

		if(Z2_dep = '1' and Z1_en = '1') then		
			vZ2_tag_mux_ctrl := '1';
		end if;

		tag1_write_en <= vtag1_write_en;
		free_tag1_used <= vtag1_write_en;
		tag2_write_en <= vtag2_write_en;
		free_tag2_used <= vtag2_write_en;
		C2_tag_mux_ctrl <= vC2_tag_mux_ctrl;
		Z2_tag_mux_ctrl <= vZ2_tag_mux_ctrl;
		busyC2 <= vC2_tag_mux_ctrl;
		busyZ2 <= vZ2_tag_mux_ctrl;

	end process;

	tagC_out <= free_tagC1_in; tagZ_out <= free_tag

end behave;

		C1_en, Z1_en, C2_en, Z2_en : in std_logic;
		C2_dep, Z2_dep : in std_logic;
		free_tagC1_in, free_tagC2_in, free_tagZ1_in, free_tagZ2_in : in std_logic_vector(3 downto 0);
		freeC1_valid, freeC2_valid, freeZ1_valid, freeZ2_valid: in std_logic;
		
		--address to write is directly taken from the pipeline
		tagC_out, tagZ_out : out std_logic_vector(3 downto 0);
		tagC_write_en, tagZ_write_en : out std_logic; 
		--busy is set whenever write occurs (implemented as part of ARF)

		C2_tag_mux_ctrl, Z2_tag_mux_ctrl, busy21, busy22: out std_logic;
		C2_tag, Z2_tag: out std_logic_vector(3 downto 0);

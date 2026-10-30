library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_4bit_tb is
end alu_4bit_tb;

architecture sim of alu_4bit_tb is
    component alu_4bit
        Port ( a, b : in  STD_LOGIC_VECTOR (3 downto 0);
               sel  : in  STD_LOGIC_VECTOR (2 downto 0);
               y    : out STD_LOGIC_VECTOR (3 downto 0);
               cout, ovf, zero : out STD_LOGIC);
    end component;

    signal a, b : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal sel  : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal y    : STD_LOGIC_VECTOR (3 downto 0);
    signal cout, ovf, zero : STD_LOGIC;
begin
    uut: alu_4bit port map (a => a, b => b, sel => sel, y => y,
                            cout => cout, ovf => ovf, zero => zero);

    stim_proc: process
    begin
        a <= "0101"; b <= "0011";       -- A = 5, B = 3

        sel <= "000"; wait for 10 ns;   -- ADD  : 1000 (8), ovf = 1
        assert y = "1000" and cout = '0' and ovf = '1' report "ADD failed" severity error;

        sel <= "001"; wait for 10 ns;   -- SUB  : 0010 (2)
        assert y = "0010" and cout = '0' and ovf = '0' report "SUB failed" severity error;

        sel <= "010"; wait for 10 ns;   -- AND  : 0001
        assert y = "0001" report "AND failed" severity error;

        sel <= "011"; wait for 10 ns;   -- OR   : 0111
        assert y = "0111" report "OR failed" severity error;

        sel <= "100"; wait for 10 ns;   -- XOR  : 0110
        assert y = "0110" report "XOR failed" severity error;

        sel <= "101"; wait for 10 ns;   -- NOT A: 1010
        assert y = "1010" report "NOT failed" severity error;

        sel <= "110"; wait for 10 ns;   -- SHL A: 1010, cout = 0
        assert y = "1010" and cout = '0' report "SHL failed" severity error;

        sel <= "111"; wait for 10 ns;   -- SHR A: 0010, cout = 1
        assert y = "0010" and cout = '1' report "SHR failed" severity error;

        -- Flag corner cases
        a <= "1111"; b <= "0001"; sel <= "000"; wait for 10 ns;  -- 0000, cout = 1, zero = 1
        assert y = "0000" and cout = '1' and zero = '1' report "Carry/zero failed" severity error;

        a <= "0000"; b <= "0001"; sel <= "001"; wait for 10 ns;  -- 1111, borrow = 1
        assert y = "1111" and cout = '1' report "Borrow failed" severity error;

        wait;
    end process;
end sim;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit is
    Port ( a    : in  STD_LOGIC_VECTOR (3 downto 0);
           b    : in  STD_LOGIC_VECTOR (3 downto 0);
           sel  : in  STD_LOGIC_VECTOR (2 downto 0);   -- operation select
           y    : out STD_LOGIC_VECTOR (3 downto 0);
           cout : out STD_LOGIC;                        -- carry / borrow / shifted-out bit
           ovf  : out STD_LOGIC;                        -- signed overflow (ADD, SUB)
           zero : out STD_LOGIC);                       -- result = 0
end alu_4bit;

architecture Behavioral of alu_4bit is
begin
    process (a, b, sel)
        variable ua, ub : unsigned(3 downto 0);
        variable sum    : unsigned(4 downto 0);
        variable r      : STD_LOGIC_VECTOR (3 downto 0);
        variable c, v   : STD_LOGIC;
    begin
        ua := unsigned(a);
        ub := unsigned(b);
        r  := (others => '0');
        c  := '0';
        v  := '0';

        case sel is
            when "000" =>                                   -- ADD
                sum := ('0' & ua) + ('0' & ub);
                r   := STD_LOGIC_VECTOR(sum(3 downto 0));
                c   := sum(4);
                v   := (not (a(3) xor b(3))) and (a(3) xor r(3));
            when "001" =>                                   -- SUB (A - B)
                sum := ('0' & ua) - ('0' & ub);
                r   := STD_LOGIC_VECTOR(sum(3 downto 0));
                c   := sum(4);                              -- borrow
                v   := (a(3) xor b(3)) and (a(3) xor r(3));
            when "010" => r := a and b;                     -- AND
            when "011" => r := a or b;                      -- OR
            when "100" => r := a xor b;                     -- XOR
            when "101" => r := not a;                       -- NOT A
            when "110" =>                                   -- SHIFT LEFT A
                r := a(2 downto 0) & '0';
                c := a(3);
            when others =>                                  -- "111" SHIFT RIGHT A
                r := '0' & a(3 downto 1);
                c := a(0);
        end case;

        y    <= r;
        cout <= c;
        ovf  <= v;
        if r = "0000" then zero <= '1'; else zero <= '0'; end if;
    end process;
end Behavioral;
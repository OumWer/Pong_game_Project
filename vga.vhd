library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
    port(
        clk      : in  std_logic;  -- 25 MHz clock input
        rst      : in  std_logic;
        rin      : in  std_logic_vector(9 downto 0);
        gin      : in  std_logic_vector(9 downto 0);
        bin      : in  std_logic_vector(9 downto 0);

        rout     : out std_logic_vector(9 downto 0);
        gout     : out std_logic_vector(9 downto 0);
        bout     : out std_logic_vector(9 downto 0);

        hs       : out std_logic;
        vs       : out std_logic;
        clkout   : out std_logic;
        blank    : out std_logic;
        sync     : out std_logic;
        x_out    : out integer range 0 to 1023;
        y_out    : out integer range 0 to 1023
    );
end entity;

architecture rtl of vga is

    constant H_VISIBLE_AREA  : integer := 640;
    constant H_FRONT_PORCH   : integer := 16;
    constant H_SYNC_PULSE    : integer := 96;
    constant H_BACK_PORCH    : integer := 48;
    constant H_TOTAL         : integer := 800;

    constant V_VISIBLE_AREA  : integer := 480;
    constant V_FRONT_PORCH   : integer := 10;
    constant V_SYNC_PULSE    : integer := 2;
    constant V_BACK_PORCH    : integer := 33;
    constant V_TOTAL         : integer := 525;

    signal h_count : integer range 0 to H_TOTAL - 1 := 0;
    signal v_count : integer range 0 to V_TOTAL - 1 := 0;

    signal video_on : std_logic;
    signal x_pix, y_pix : integer range 0 to 1023;

begin

    -- Horizontal counter
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                h_count <= 0;
            elsif h_count = H_TOTAL - 1 then
                h_count <= 0;
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;

    -- Vertical counter
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                v_count <= 0;
            elsif h_count = H_TOTAL - 1 then
                if v_count = V_TOTAL - 1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Sync signals
    hs <= '0' when h_count >= (H_VISIBLE_AREA + H_FRONT_PORCH) and
                    h_count < (H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE) else '1';

    vs <= '0' when v_count >= (V_VISIBLE_AREA + V_FRONT_PORCH) and
                    v_count < (V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE) else '1';

    -- Active video check
    video_on <= '1' when (h_count < H_VISIBLE_AREA and v_count < V_VISIBLE_AREA) else '0';

    -- Pixel coordinates
    x_pix <= h_count;
    y_pix <= v_count;

    -- Output pixel coordinates
    x_out <= x_pix;
    y_out <= y_pix;

    -- RGB output
    rout <= rin when video_on = '1' else (others => '0');
    gout <= gin when video_on = '1' else (others => '0');
    bout <= bin when video_on = '1' else (others => '0');

    -- Other VGA signals
    clkout <= clk;
    blank  <= video_on;
    sync   <= '0'; -- Usually unused, tied low

end rtl;

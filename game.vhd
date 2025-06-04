library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
    port(
        CLOCK_50 : in std_logic;
        reset    : in std_logic;

        -- Inputs from Nios II (PIO registers)
        paddle1_pos : in std_logic_vector(7 downto 0);
        paddle2_pos : in std_logic_vector(7 downto 0);
        ball_x_pos  : in std_logic_vector(7 downto 0);
        ball_y_pos  : in std_logic_vector(7 downto 0);

        VGA_CLK   : out std_logic;
        VGA_HS    : out std_logic;
        VGA_VS    : out std_logic;
        VGA_BLANK : out std_logic;
        VGA_SYNC  : out std_logic;

        VGA_R : out std_logic_vector(9 downto 0);
        VGA_G : out std_logic_vector(9 downto 0);
        VGA_B : out std_logic_vector(9 downto 0)
    );
end entity;

architecture rtl of game is

    signal clock_25 : std_logic := '0';

    signal x_out, y_out : integer range 0 to 1023;

    signal VGA_R_IN, VGA_G_IN, VGA_B_IN : std_logic_vector(9 downto 0);

    -- Convert paddle/ball positions from std_logic_vector to integer
    signal ball_x_int, ball_y_int : integer range 0 to 639;
    signal paddle1_y_int, paddle2_y_int : integer range 0 to 479;

    component vga
        port(
            clk     : in std_logic;
            rst     : in std_logic;
            rin     : in std_logic_vector(9 downto 0);
            gin     : in std_logic_vector(9 downto 0);
            bin     : in std_logic_vector(9 downto 0);

            rout    : out std_logic_vector(9 downto 0);
            gout    : out std_logic_vector(9 downto 0);
            bout    : out std_logic_vector(9 downto 0);
            hs      : out std_logic;
            vs      : out std_logic;
            clkout  : out std_logic;
            blank   : out std_logic;
            sync    : out std_logic;
            x_out   : out integer range 0 to 1023;
            y_out   : out integer range 0 to 1023
        );
    end component;

begin

    -- Clock divider to get 25 MHz from 50 MHz input clock
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            clock_25 <= not clock_25;
        end if;
    end process;

    -- Convert input positions from std_logic_vector to integer
    ball_x_int    <= to_integer(unsigned(ball_x_pos));
    ball_y_int    <= to_integer(unsigned(ball_y_pos));
    paddle1_y_int <= to_integer(unsigned(paddle1_pos));
    paddle2_y_int <= to_integer(unsigned(paddle2_pos));

    -- Rendering logic:
    -- Draw ball as 8x8 square at (ball_x_int, ball_y_int)
    -- Draw paddles as 10x40 rectangles at fixed x (left/right) and variable y (paddle_y_int)
    process(x_out, y_out, ball_x_int, ball_y_int, paddle1_y_int, paddle2_y_int)
    begin
        -- Default: black screen
        VGA_R_IN <= (others => '0');
        VGA_G_IN <= (others => '0');
        VGA_B_IN <= (others => '0');

        -- Draw ball (white)
        if (x_out >= ball_x_int and x_out < ball_x_int + 8) and
           (y_out >= ball_y_int and y_out < ball_y_int + 8) then
            VGA_R_IN <= (others => '1');
            VGA_G_IN <= (others => '1');
            VGA_B_IN <= (others => '1');

        -- Draw left paddle (green)
        elsif (x_out >= 10 and x_out < 20) and
              (y_out >= paddle1_y_int and y_out < paddle1_y_int + 40) then
            VGA_G_IN <= (others => '1');

        -- Draw right paddle (blue)
        elsif (x_out >= 610 and x_out < 620) and
              (y_out >= paddle2_y_int and y_out < paddle2_y_int + 40) then
            VGA_B_IN <= (others => '1');
        end if;
    end process;

    -- Instantiate VGA timing controller
    VGA_DRIVER : vga
        port map(
            clk    => clock_25,
            rst    => not reset,
            rin    => VGA_R_IN,
            gin    => VGA_G_IN,
            bin    => VGA_B_IN,
            rout   => VGA_R,
            gout   => VGA_G,
            bout   => VGA_B,
            hs     => VGA_HS,
            vs     => VGA_VS,
            clkout => VGA_CLK,
            blank  => VGA_BLANK,
            sync   => VGA_SYNC,
            x_out  => x_out,
            y_out  => y_out
        );

end rtl;

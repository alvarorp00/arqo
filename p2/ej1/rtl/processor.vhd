--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2020-2021
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor is
   port(
      Clk         : in  std_logic; -- Reloj activo en flanco subida
      Reset       : in  std_logic; -- Reset asincrono activo nivel alto
      -- Instruction memory
      IAddr      : out std_logic_vector(31 downto 0); -- Direccion Instr
      IDataIn    : in  std_logic_vector(31 downto 0); -- Instruccion leida
      -- Data memory
      DAddr      : out std_logic_vector(31 downto 0); -- Direccion
      DRdEn      : out std_logic;                     -- Habilitacion lectura
      DWrEn      : out std_logic;                     -- Habilitacion escritura
      DDataOut   : out std_logic_vector(31 downto 0); -- Dato escrito
      DDataIn    : in  std_logic_vector(31 downto 0)  -- Dato leido
   );
end processor;

architecture rtl of processor is

  component alu
    port(
      OpA : in std_logic_vector (31 downto 0);
      OpB : in std_logic_vector (31 downto 0);
      Control : in std_logic_vector (3 downto 0);
      Result : out std_logic_vector (31 downto 0);
      Zflag : out std_logic
    );
  end component;

  component reg_bank
     port (
        Clk   : in std_logic; -- Reloj activo en flanco de subida
        Reset : in std_logic; -- Reset as�ncrono a nivel alto
        A1    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Rd1
        Rd1   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd1
        A2    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Rd2
        Rd2   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd2
        A3    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Wd3
        Wd3   : in std_logic_vector(31 downto 0);  -- Dato de entrada Wd3
        We3   : in std_logic -- Habilitaci�n de la escritura de Wd3
     );
  end component reg_bank;

  component control_unit
     port (
        -- Entrada = codigo de operacion en la instruccion:
        OpCode   : in  std_logic_vector (5 downto 0);
        -- Seniales para el PC
        Branch   : out  std_logic; -- 1 = Ejecutandose instruccion branch
        -- Seniales relativas a la memoria
        Jump     : out  std_logic;
        
        MemToReg : out  std_logic; -- 1 = Escribir en registro la salida de la mem.
        MemWrite : out  std_logic; -- Escribir la memoria
        MemRead  : out  std_logic; -- Leer la memoria
        -- Seniales para la ALU
        ALUSrc   : out  std_logic;                     -- 0 = oper.B es registro, 1 = es valor inm.
        ALUOp    : out  std_logic_vector (2 downto 0); -- Tipo operacion para control de la ALU
        -- Seniales para el GPR
        RegWrite : out  std_logic; -- 1=Escribir registro
        RegDst   : out  std_logic  -- 0=Reg. destino es rt, 1=rd
     );
  end component;

  component alu_control is
   port (
      -- Entradas:
      ALUOp  : in std_logic_vector (2 downto 0); -- Codigo de control desde la unidad de control
      Funct  : in std_logic_vector (5 downto 0); -- Campo "funct" de la instruccion
      -- Salida de control para la ALU:
      ALUControl : out std_logic_vector (3 downto 0) -- Define operacion a ejecutar por la ALU
   );
  end component alu_control;

  signal Alu_Op1      : std_logic_vector(31 downto 0); -- NEW
  signal Alu_Op2      : std_logic_vector(31 downto 0);
  signal ALU_Igual    : std_logic;
  signal AluControl   : std_logic_vector(3 downto 0);
  signal reg_RD_data  : std_logic_vector(31 downto 0);
  signal reg_RD       : std_logic_vector(4 downto 0);

  signal Regs_eq_branch : std_logic;
  signal PC_next        : std_logic_vector(31 downto 0);
  signal PC_reg         : std_logic_vector(31 downto 0);
  signal PC_plus4       : std_logic_vector(31 downto 0);

  signal Sign_ext        : std_logic_vector(31 downto 0); --Lparte baja de la instrucción extendida de signo
  signal reg_RS, reg_RT : std_logic_vector(31 downto 0);

  signal dataIn_Mem     : std_logic_vector(31 downto 0); --From Data Memory
  signal Addr_Branch    : std_logic_vector(31 downto 0);

  signal Ctrl_Jump, Ctrl_Branch, Ctrl_MemWrite, Ctrl_MemRead,  Ctrl_ALUSrc, Ctrl_RegDest, Ctrl_MemToReg, Ctrl_RegWrite : std_logic;
  signal Ctrl_ALUOP     : std_logic_vector(2 downto 0);

  signal Addr_Jump      : std_logic_vector(31 downto 0);
  signal Addr_Jump_dest : std_logic_vector(31 downto 0);
  signal desition_Jump     : std_logic;
  signal Alu_Res        : std_logic_vector(31 downto 0);

  ---- IFID ----
  -- IF/ID register
  signal IFID_PC_plus4      : std_logic_vector(31 downto 0);
  signal IFID_Instruction   : std_logic_vector(31 downto 0);

  ---- IDEX ----
  -- ID/EX WB
  signal IDEX_MemToReg      : std_logic;
  signal IDEX_RegWrite      : std_logic;            

  -- ID/EX M
  signal IDEX_Branch        : std_logic;
  signal IDEX_Jump          : std_logic;
  signal IDEX_MemWrite      : std_logic;
  signal IDEX_MemRead       : std_logic;

  -- ID/EX EX
  signal IDEX_RegDest       : std_logic;
  signal IDEX_AluSrc        : std_logic;
  signal IDEX_AluOP         : std_logic_vector(2 downto 0);

  -- ID/EX Other --
  signal IDEX_PC_plus4      : std_logic_vector(31 downto 0);
  signal IDEX_RD1           : std_logic_vector(31 downto 0);
  signal IDEX_RD2           : std_logic_vector(31 downto 0);
  signal IDEX_RT_Addr       : std_logic_vector(4 downto 0);
  signal IDEX_RD_Addr       : std_logic_vector(4 downto 0);
  signal IDEX_SignExt       : std_logic_vector(31 downto 0);


  ---- EXMEM ----
  -- EX/MEM WB --
  signal EXMEM_MemToReg     : std_logic;
  signal EXMEM_RegWrite     : std_logic;

  -- EX/MEM M --
  signal EXMEM_Branch        : std_logic;
  signal EXMEM_BranchAddr    : std_logic_vector(31 downto 0);
  signal EXMEM_MemWrite      : std_logic;
  signal EXMEM_MemRead       : std_logic;

  -- EX/MEM Other --
  signal EXMEM_Zero                 : std_logic;
  signal EXMEM_AluResult            : std_logic_vector(31 downto 0);
  signal EXMEM_WriteData            : std_logic_vector(31 downto 0);
  signal EXMEM_RegDestAddr          : std_logic_vector(4 downto 0);

  ---- MEMWB ----
  -- MEM/WB WB --
  signal MEMWB_MemToReg     : std_logic;
  signal MEMWB_RegWrite     : std_logic;

  signal MEMWB_MemData      : std_logic_vector(31 downto 0);
  signal MEMWB_AluResult      : std_logic_vector(31 downto 0);
  signal MEMWB_RegDestAddr    : std_logic_vector(4 downto 0);

  ---- FORWARDING ----
  signal ForwardA     : std_logic_vector(1 downto 0);
  signal ForwardB     : std_logic_vector(1 downto 0);
  signal ForwardMux1Conn : std_logic_vector(31 downto 0); -- Intermediate signal between ForwardA mux and Alu_Op1
  signal ForwardMux2Conn : std_logic_vector(31 downto 0); -- Intermediate signal between ForwardB mux and Alu_Op2

  ---- HAZARD UNIT ----
  signal PCWrite      : std_logic;
  signal IFID_Write   : std_logic;
  signal HazardControl  : std_logic;

begin

  PC_next <= Addr_Jump_dest when desition_Jump = '1' else PC_plus4;

  PC : process(Clk, Reset, PCWrite)
  begin
    if Reset = '1' then
      PC_reg <= (others => '0');
    elsif rising_edge(Clk) then
      if PCWrite = '1' then
        PC_reg <= PC_next;
      else
        PC_reg <= PC_reg;
      end if ;
    end if;
  end process ; -- PC
  
  IFID: process(Clk, Reset, IFID_Write)
  begin
    -- Check Reset
    if Reset = '1' then
      IFID_Instruction <= (others => '0');
      IFID_PC_plus4 <= (others => '0');
      -- pass --> wait for next cycle
    elsif rising_edge(Clk) then
      -- Check Hazard Unit
      if IFID_Write = '1' then 
        IFID_Instruction <= IDataIn; -- store current instruction
        IFID_PC_plus4 <= PC_plus4; -- store current PC+4
      else
        IFID_Instruction <= IFID_Instruction; -- keep instruction
        IFID_PC_plus4 <= IFID_PC_plus4; -- keep ifid pc
      end if;
    end if;
  end process;

  PC_plus4    <= PC_reg + 4;
  IAddr       <= PC_reg;

  IDEX: process(Clk, Reset, HazardControl)
  begin
    if Reset = '1' then

      IDEX_SignExt <= (others => '0');
      IDEX_RT_Addr <= (others => '0');
      IDEX_RD_Addr <= (others => '0');
      IDEX_RD1 <= (others => '0');
      IDEX_RD2 <= (others => '0');
      IDEX_PC_plus4 <= (others => '0');
      
      IDEX_MemToReg <= '0';
      IDEX_RegWrite <= '0';

      IDEX_Branch <= '0';
      IDEX_Jump <= '0';
      IDEX_MemWrite <= '0';
      IDEX_MemRead <= '0';

      IDEX_RegDest <= '0';
      IDEX_AluOp <= (others => '0');
      IDEX_AluSrc <= '0';
      
    elsif rising_edge(Clk) then

      IDEX_SignExt <= Sign_ext;
      IDEX_RT_Addr <= IFID_Instruction(20 downto 16);
      IDEX_RD_Addr <= IFID_Instruction(15 downto 11);
      IDEX_RD1 <= reg_RS;
      IDEX_RD2 <= reg_RT;
      IDEX_PC_plus4 <= IFID_PC_plus4;
      
      if HazardControl = '1' then

        IDEX_MemToReg <= '0';
        IDEX_RegWrite <= '0';

        IDEX_Branch <= '0';
        IDEX_Jump <= '0';
        IDEX_MemWrite <= '0';
        IDEX_MemRead <= '0';

        IDEX_RegDest <= '0';
        IDEX_AluOp <= (others => '0');
        IDEX_AluSrc <= '0';
      
      elsif HazardControl = '0' then
        
        IDEX_MemToReg <= Ctrl_MemToReg;
        IDEX_RegWrite <= Ctrl_RegWrite;

        IDEX_Branch <= Ctrl_Branch;
        IDEX_Jump <= Ctrl_Jump;
        IDEX_MemWrite <= Ctrl_MemWrite;
        IDEX_MemRead <= Ctrl_MemRead;

        IDEX_RegDest <= Ctrl_RegDest;
        IDEX_AluOP <= Ctrl_ALUOP;
        IDEX_AluSrc <= Ctrl_ALUSrc;
      
      end if;
    end if;
  end process;

  EXMEM : process(Clk, Reset) 
  begin
    if Reset = '1' then
      
      EXMEM_MemToReg <= '0';
      EXMEM_RegWrite <= '0';

      EXMEM_Branch <= '0';
      EXMEM_BranchAddr <= (others => '0');

      -- EXMEM_Jump <= '0';

      EXMEM_MemWrite <= '0';
      EXMEM_MemRead <= '0';

      EXMEM_WriteData <= (others => '0'); -- Changed --> assignment before Mux selector by AluSrc
      EXMEM_AluResult <= (others => '0');
      EXMEM_Zero      <= '0';
      EXMEM_RegDestAddr <= (others => '0');

    elsif rising_edge(Clk) then

      EXMEM_MemToReg <= IDEX_MemToReg;
      EXMEM_RegWrite <= IDEX_RegWrite;

      EXMEM_Branch <= IDEX_Branch;
      EXMEM_BranchAddr <= Addr_Branch;

      -- EXMEM_Jump <= IDEX_Jump;

      EXMEM_MemWrite <= IDEX_MemWrite;
      EXMEM_MemRead <= IDEX_MemRead;

      EXMEM_WriteData <= ForwardMux2Conn; -- Changed --> assignment before Mux selector by AluSrc
      EXMEM_AluResult <= ALU_Res;
      EXMEM_Zero      <= ALU_Igual;
      EXMEM_RegDestAddr <= reg_RD;

    end if;
  end process;

  MEMWB : process( Clk, Reset )
  begin
    if Reset = '1' then

      MEMWB_MemToReg <= '0';
      MEMWB_RegWrite <= '0';

      MEMWB_MemData <= (others => '0');
      MEMWB_AluResult <= (others => '0');

      MEMWB_RegDestAddr <= (others => '0');
      
    elsif rising_edge(Clk) then
      
      MEMWB_MemToReg <= EXMEM_MemToReg;
      MEMWB_RegWrite <= EXMEM_RegWrite;

      MEMWB_MemData <= DDataIn;
      MEMWB_AluResult <= EXMEM_AluResult;

      MEMWB_RegDestAddr <= EXMEM_RegDestAddr;

    end if;
  end process;

  -- Forwading depends on registers that are compared, not of Clk or Reset --> output signals (ForwarA & ForwardB) are asynchronous --> they do not depend of a process, registers compared here YES!
  FORWARDING : process(EXMEM_RegWrite, MEMWB_RegWrite, EXMEM_RegDestAddr, MEMWB_RegDestAddr, IDEX_RT_Addr, IDEX_RD_Addr)
  begin

    --ForwardA hazard
    if ((EXMEM_RegWrite = '1') and (EXMEM_RegDestAddr /= "0") and (EXMEM_RegDestAddr = IDEX_RT_Addr))  then
      ForwardA <= "10";
    elsif ((MEMWB_RegWrite = '1') and (MEMWB_RegDestAddr /= "0") and (MEMWB_RegDestAddr = IDEX_RD_Addr)) then -- elsif --> and not <first_if_condition>
      ForwardA <= "01";
    else
      ForwardA <= "00";
    end if;

    -- ForwardB hazard
    if ((EXMEM_RegWrite = '1') and (EXMEM_RegDestAddr /= "0") and (EXMEM_RegDestAddr = IDEX_RT_Addr)) then
      ForwardB <= "10";
    elsif ((MEMWB_RegWrite = '1') and (MEMWB_RegDestAddr /= "0") and (MEMWB_RegDestAddr = IDEX_RD_Addr)) then -- elsif --> and not <first_if_condition>
      ForwardB <= "01";
    else
      ForwardB <= "00";
    end if;

    -- case ForwardA is
    --   when "10" => Alu_Op1 <= EXMEM_AluResult;
    --   when "01" => Alu_Op1 <= reg_RD_data;
    --   when others => Alu_Op1 <= IDEX_RD1;
    -- end case;

    -- case ForwardB is
    --   when "10" => ForwardMux2Conn <= EXMEM_AluResult;
    --   when "01" => ForwardMux2Conn <= reg_RD_data;
    --   when others => ForwardMux2Conn <= IDEX_RD2;
    -- end case;
  end process;

  -- As same as in Forwading Unit, it depends on Registers that are compared, not of Clk or Reset --> those registers depend of synchronous process (Clk, Reset)
  HAZARD : process(IDEX_MemRead, IDEX_RT_Addr, IFID_Instruction)
  begin
    if ((IDEX_MemRead = '1') and ((IDEX_RT_Addr = IFID_Instruction(20 downto 16)) or
        (IDEX_RT_Addr = IFID_Instruction(15 downto 11)))) then
      
      HazardControl <= '1';
      PCWrite <= '0';
      IFID_Write <= '0';
      
    else
    
      HazardControl <= '0';
      PCWrite <= '1';
      IFID_Write <= '1';

    end if;
  end process;


  RegsMIPS : reg_bank
  port map (
    Clk   => Clk,
    Reset => Reset,
    A1    => IFID_Instruction(25 downto 21),
    Rd1   => reg_RS,
    A2    => IFID_Instruction(20 downto 16),
    Rd2   => reg_RT,
    A3    => MEMWB_RegDestAddr, -- address of destination register
    Wd3   => reg_RD_data, -- 
    We3   => MEMWB_RegWrite
  );

  UnidadControl : control_unit
  port map(
    OpCode   => IFID_Instruction(31 downto 26),
    -- Señales para el PC
    Jump     => Ctrl_Jump,
    Branch   => Ctrl_Branch,
    -- Señales para la memoria
    MemToReg => Ctrl_MemToReg,
    MemWrite => Ctrl_MemWrite,
    MemRead  => Ctrl_MemRead,
    -- Señales para la ALU
    ALUSrc   => Ctrl_ALUSrc,
    ALUOP    => Ctrl_ALUOP,
    -- Señales para el GPR
    RegWrite => Ctrl_RegWrite,
    RegDst   => Ctrl_RegDest
  );

  Sign_ext        <= x"FFFF" & IFID_Instruction(15 downto 0) when IFID_Instruction(15)='1' else
                    x"0000" & IFID_Instruction(15 downto 0);

  -- Addr_Jump      <= PC_plus4(31 downto 28) & IFID_Instruction(25 downto 0) & "00";

  Addr_Branch    <= IDEX_PC_plus4 + ( IDEX_SignExt(29 downto 0) & "00");
  
  -- this is the AND door to decide branch
  desition_Jump  <= (EXMEM_Branch and EXMEM_Zero);

  Addr_Jump_dest <= EXMEM_BranchAddr when EXMEM_Branch='1' else
                    (others =>'0');

  Alu_control_i: alu_control
  port map(
    -- Entradas:
    ALUOp  => IDEX_AluOP, -- Codigo de control desde la unidad de control
    Funct  => IDEX_SignExt(5 downto 0), -- we can use the sign extend bus
    -- Salida de control para la ALU:
    ALUControl => AluControl -- Define operacion a ejecutar por la ALU
  );

  Alu_MIPS : alu
  port map (
    OpA     => Alu_Op1,--IDEX_RD1 -- CHANGED
    OpB     => Alu_Op2,
    Control => AluControl,
    Result  => Alu_Res,
    Zflag   => ALU_IGUAL
  );  

  ForwardMux1Conn <= EXMEM_AluResult when ForwardA = "10" else
                    reg_RD_data when ForwardA = "01" else
                    IDEX_RD1;

  ForwardMux2Conn <= EXMEM_AluResult when ForwardB = "10" else
                    reg_RD_data when ForwardB = "01" else
                    IDEX_RD2;

  -- Assign Alu_Op2

  Alu_Op1 <= ForwardMux1Conn; -- Connect signal from Mux on ForwardUnit to Alu's first operand
  Alu_Op2 <= ForwardMux2Conn when IDEX_AluSrc = '0' else IDEX_SignExt; -- Select between forwardB signal and immediate

  -- Address of the register to write
  reg_RD     <= IDEX_RT_Addr when IDEX_RegDest = '0' else IDEX_RD_Addr;
  
  DAddr      <= EXMEM_AluResult;
  DDataOut   <= EXMEM_WriteData;
  DWrEn      <= EXMEM_MemWrite;
  dRdEn      <= EXMEM_MemRead;
  dataIn_Mem <= DDataIn;
  
  -- Data to be written in the write register
  reg_RD_data <= MEMWB_MemData when MEMWB_MemToReg = '1' else MEMWB_AluResult;

end architecture;

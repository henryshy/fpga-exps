
// 地址和数据位宽
`define  ASIZE   13   //SDRAM地址位宽
`define  DSIZE   16   //SDRAM数据位宽
`define  BSIZE   2    //SDRAM的bank地址位宽


parameter //{CS_N,RAS_N,CAS_N,WE}
		C_NOP  = 4'b0111, //空操作
		C_PRE  = 4'b0010, //预充电
		C_AREF = 4'b0001, //自动刷新
		C_MSET = 4'b0000, //加载模式寄存器
		C_ACT  = 4'b0011, //激活
		C_RD   = 4'b0101, //读
		C_WR   = 4'b0100; // 写
		
parameter
		INIT_PRE = 20000,
		tRP      = 3,
		tRFC     = 10,
		tMRD     = 2,
		AUTO_REF = 1560,
		WR_PRE   = 2,
		SC_RCD   = 3,
		SC_CL	= 3,       
		SC_BL	= 8;
//	SDRAM模式寄存器参数化表示
//写突发模式设置
parameter	OP_CODE = 1'b0;  
//突发长度设置
parameter	SDR_BL = (SC_BL == 1)?	3'b000:
							(SC_BL == 2)?	3'b001:
							(SC_BL == 4)?	3'b010:
							(SC_BL == 8)?  3'b011:
							3'b111;	
//突发类型设置								 
parameter	SDR_BT = 1'b0;
//列选通潜伏期设置
parameter	SDR_CL = (SC_CL == 2)? 3'b10: 3'b11;
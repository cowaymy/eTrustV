package com.coway.trust.web.commission;

import org.slf4j.LoggerFactory;

public class CommissionConstants {

	/**
	 * Commission Employee Type Code
	 */
	public static final String COMIS_EMP_CD = "1";				//Employee main code
	public static final String COMIS_CD_GRCD = "2";			//CD common code
	public static final String COMIS_CT_GRCD = "3";			//CT common code
	public static final String COMIS_HP_GRCD = "1";			//HP common code
	public static final String COMIS_CD_CD = "301";			//Commission CD main code
	public static final String COMIS_CT_CD = "302";				//Commission CT main code
	public static final String COMIS_HP_CD = "303";				//Commission HP main code
	public static final String COMIS_ITEM_CD = "304";			//Commission Item code
	public static final String COMIS_PRO_CD_A = "311";			//Commission Procedure code actual
	public static final String COMIS_PRO_CD_S = "354";			//Commission Procedure code simulation
	public static final String COMIS_ADJUST_CD = "77";		//Commission Adjustment Code
	public static final String COMIS_TYPE_CD = "346";			//Commission Value Type Code
	public static final String COMIS_HP = "HP";					//Health Planner
	public static final String COMIS_CD = "CD";					//Coway Lady
	public static final String COMIS_CT = "CT";					//Coway Technician
	public static final String COMIS_END_DT = "999999";		//Default end date
	public static final String COMIS_SUCCESS = "0";				//Default end success
	public static final String COMIS_RUNNING = "1";			//Default end success
	public static final String COMIS_FAIL_NEXT = "8";			//Default end fail
	public static final String COMIS_FAIL = "9";					//Default end fail
	public static final String COMIS_STATUS_ID = "15";					//Status Code Id
	

	//**CALCULATION EXCEL DOWNLOAD LEVEL**//
	public static final String COMIS_S_G_MANAGER_MEM_LEV = "0";			//Super General Manager
	public static final String COMIS_G_MANAGER_MEM_LEV = "1";			//General Manager
	public static final String COMIS_S_MANAGER_MEM_LEV = "2";				//Super Manager
	public static final String COMIS_MANAGER_MEM_LEV = "3";				//Manager(Leader)
	public static final String COMIS_NORMAL_MEM_LEV = "4";					//Normal
	
	//**COMMISSION ORG MEMBER LEVEL**//
	public static final String COMIS_HP_SGM_LEV = "0";				//SGM
	public static final String COMIS_HP_GM_LEV = "1";				//GM
	public static final String COMIS_HP_SM_LEV = "2";					//SM
	public static final String COMIS_HP_HM_LEV = "3";				//HM
	public static final String COMIS_HP_HP_LEV = "4";					//HPP, HPF
	
	public static final String COMIS_CD_GCM_LEV = "1";				//CDG
	public static final String COMIS_CD_SCM_LEV = "2";				//CDS
	public static final String COMIS_CD_CM_LEV = "3";				//CM
	public static final String COMIS_CD_CD_LEV = "4";					//CD, CDC	
		
	public static final String COMIS_CT_CTM_LEV = "2";				//CTM
	public static final String COMIS_CT_CTL_LEV = "3";				//CTL
	public static final String COMIS_CT_CT_LEV = "4";					//CT, CTE, CTN	
	
	
	public static final String COMIS_HP_SGM_CD = "HPT";			
	public static final String COMIS_HP_GM_CD = "HPG";				
	public static final String COMIS_HP_SM_CD = "HPS";				
	public static final String COMIS_HP_HM_CD = "HPM";				
	public static final String COMIS_HP_HPP_CD = "HPP";				
	public static final String COMIS_HP_HPF_CD = "HPF";				
	
	public static final String COMIS_CD_GCM_CD = "CDG";			
	public static final String COMIS_CD_SCM_CD = "CDS";			
	public static final String COMIS_CD_CM_CD = "CDM";				
	public static final String COMIS_CD_CDC_CD = "CDC";				
	public static final String COMIS_CD_CDN_CD = "CDN";				
		
	public static final String COMIS_CT_CTM_CD = "CTM";			
	public static final String COMIS_CT_CTL_CD = "CTL";				
	public static final String COMIS_CT_CTN_CD = "CTN";				
	public static final String COMIS_CT_CTR_CD = "CTR";				
	public static final String COMIS_CT_CTE_CD = "CTE";				
	
	public static final String COMIS_CD_CDN_BIZTYPE = "1375";					//CD-N
	public static final String COMIS_CD_CDC_BIZTYPE = "1376";					//CD-C
	
	public static final String COMIS_HP_HPP_EMPTYPE = "ACT";					//HPP
	public static final String COMIS_HP_HPF_EMPTYPE = "PRO";					//HPF
	
	/**
	 * Commission Procedure Code
	 */
	public static final String COMIS_CTL_P01 = "CTL-P01";					//
	public static final String COMIS_CTM_P01 = "CTM-P01";					//
	public static final String COMIS_CTR_P01 = "CTE-P01";					//
	public static final String COMIS_CTL_P02 = "CTL-P02";					//
	public static final String COMIS_CTM_P02 = "CTM-P02";					//
	public static final String COMIS_CTM_P03 = "CTM-P03";					//
	public static final String COMIS_CTR_P02 = "CTE-P02";					//
	
	public static final String COMIS_CDC_P01 = "CDC-P01";					//
	public static final String COMIS_CDG_P01 = "CDG-P01";					//
	public static final String COMIS_CDM_P01 = "CDM-P01";					//
	public static final String COMIS_CDN_P01 = "CDN-P01";					//
	public static final String COMIS_CDS_P01 = "CDS-P01";					//
	public static final String COMIS_CDC_P02 = "CDC-P02";					//
	public static final String COMIS_CDG_P02 = "CDG-P02";					//
	public static final String COMIS_CDM_P02 = "CDM-P02";					//
	public static final String COMIS_CDN_P02 = "CDN-P02";					//
	public static final String COMIS_CDS_P02 = "CDS-P02";					//
	
	public static final String COMIS_HPF_P01 = "HPF-P01";					//
	public static final String COMIS_HPG_P01 = "HPG-P01";					//
	public static final String COMIS_HPM_P01 = "HPM-P01";					//
	public static final String COMIS_HPS_P01 = "HPS-P01";					//
	public static final String COMIS_HPT_P01 = "HPT-P01";					//
	public static final String COMIS_HPF_P02 = "HPF-P02";					//
	public static final String COMIS_HPG_P02 = "HPG-P02";					//
	public static final String COMIS_HPM_P02 = "HPM-P02";					//
	public static final String COMIS_HPS_P02 = "HPS-P02";					//
	public static final String COMIS_HPT_P02 = "HPT-P02";					//
	public static final String COMIS_HPB_P01 = "HPB-P01";					//
	public static final String COMIS_HPB_P02 = "HPB-P02";					//
	
	public static final String COMIS_BSD_P01 = "BSD-P01";					//CMM0006T
	public static final String COMIS_BSD_P02 = "BSD-P02";					//CMM0007T
	public static final String COMIS_BSD_P03 = "BSD-P03";					//CMM0008T
	public static final String COMIS_BSD_P04 = "BSD-P04";					//CMM0009T
	public static final String COMIS_BSD_P05 = "BSD-P05";					//CMM0010T
	public static final String COMIS_BSD_P06 = "BSD-P06";					//CMM0011T
	public static final String COMIS_BSD_P07 = "BSD-P07";					//CMM0012T
	public static final String COMIS_BSD_P08 = "BSD-P08";					//CMM0013T
	public static final String COMIS_BSD_P09 = "BSD-P09";					//CMM0014T
	public static final String COMIS_BSD_P010 = "BSD-P10";					//CMM0015T
	public static final String COMIS_BSD_P011 = "BSD-P11";					//CMM0017T
	public static final String COMIS_BSD_P012 = "BSD-P12";					//CMM0022T
	public static final String COMIS_BSD_P013 = "BSD-P13";					//CMM0023T
	public static final String COMIS_BSD_P014 = "BSD-P14";					//CMM0025T
	public static final String COMIS_BSD_P015 = "BSD-P15";					//CMM0026T
	public static final String COMIS_BSD_P016 = "BSD-P16";					//CMM0060T
	public static final String COMIS_BSD_P017 = "BSD-P17";					//CMM0067T
	public static final String COMIS_BSD_P018 = "BSD-P18";					//CMM0068T
	public static final String COMIS_BSD_P019 = "BSD-P19";					//CMM0069T
	public static final String COMIS_BSD_P020 = "BSD-P20";					//18
	public static final String COMIS_BSD_P021 = "BSD-P21";					//19
	public static final String COMIS_BSD_P022 = "BSD-P22";					//20
	public static final String COMIS_BSD_P023 = "BSD-P23";					//21
	public static final String COMIS_BSG_P01 = "BSG-P01";					//
	
	public static final String COMIS_NEO_TYPE = "NEOPRO";					//
	
	public static final String COMIS_SAMPLE_HP = "67";					//
	public static final String COMIS_SAMPLE_CD = "66";					//
	public static final String COMIS_INCENTIVE = "1062";					//
	public static final String COMIS_INCENTIVE_ACTIVE = "1";					//
	public static final String COMIS_INCENTIVE_REMOVE = "8";					//
	public static final String COMIS_INCENTIVE_VALID = "4";					//
	public static final String COMIS_INCENTIVE_INVALID = "21";					//
	
	public static final String COMIS_ACTION_TYPE = "A";
	public static final String COMIS_SIMUL_TYPE = "S";//
	
}

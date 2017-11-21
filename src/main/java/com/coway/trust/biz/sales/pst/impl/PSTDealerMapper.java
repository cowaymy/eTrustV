package com.coway.trust.biz.sales.pst.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("pstDealerMapper")
public interface PSTDealerMapper {

	List<EgovMap> pstDealerList(Map<String, Object> params);
	
	EgovMap pstDealerDtBasicInfo(Map<String, Object> params);
	
	EgovMap pstDealerDtUserInfo(Map<String, Object> params);
	
	List<EgovMap> pstDealerAddrComboList(Map<String, Object> params);
	
	EgovMap getAreaId(Map<String, Object> params);
	
	void newDealer(Map<String, Object> params);
	
	int crtSeqSAL0030D();
	
	void insertPstDealer(Map<String, Object> params);
	
	List<EgovMap> dealerBrnchList();
	
	int getUserIdSeq();
	
	void insertUserSYS0047M(Map<String, Object> params);
	
	void updDealerSAL0030D(Map<String, Object> params);
	
	int dealerNricDup(Map<String, Object> params);
	
	void updDealerCntSAL0032D(Map<String, Object> params);
	
}

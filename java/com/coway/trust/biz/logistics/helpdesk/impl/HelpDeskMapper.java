package com.coway.trust.biz.logistics.helpdesk.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HelpDeskMapper")
public interface HelpDeskMapper {
	
	List<EgovMap> selectReasonList(Map<String, Object> params);

	List<EgovMap> selectDataChangeList(Map<String, Object> params);
	
	List<EgovMap> detailDataChangeList(Map<String, Object> params);
	
	List<EgovMap> CompulsoryList(Map<String, Object> params);
	
	List<EgovMap> ChangeItemList(Map<String, Object> params);
	
	List<EgovMap> RespondList(Map<String, Object> params);
	
	void updateDcfRequestM(Map<String, Object> params);
	
	void insertDcfResponseLog(Map<String, Object> params);
	
	int respnsIdCreateSeq();
	
	List<EgovMap> selectDcfRequestM(Map<String, Object> params);
	
	List<EgovMap> selectDcfCompulsoryFieldList(Map<String, Object> params);
	
	List<EgovMap> getTrBookId(String CompulsoryField);
	
	List<EgovMap> getTrBookList(int TrBookId);
	
	List<EgovMap> getTrBookItem(int TrBookId);
	
	void updateTRBookM(Map<String, Object> params);
	
	void insertTrRecordCard(Map<String, Object> params);
	
	void updateTRBookD(Map<String, Object> params);
	
	int trRcordIdCreateSeq();
	
	List<EgovMap> selectEmailaddr(int loginId);
	
	
}

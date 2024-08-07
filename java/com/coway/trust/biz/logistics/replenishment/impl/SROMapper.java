package com.coway.trust.biz.logistics.replenishment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("SROMapper")
public interface SROMapper {

	List<EgovMap> sroItemMgntList(Map<String, Object> params);

	void updateSroItem(Map<String, Object> params);

	List<EgovMap> sroMgmtList(Map<String, Object> params);

	List<EgovMap> sroMgmtDetailList(Map<String, Object> params);

	List<EgovMap> sroMgmtDetailListPopUp(Map<String, Object> params);

	List<EgovMap> selectSroCodeList(Map<String, Object> params);


	int  insertLOG0111D(Map<String, Object> params);

	int  insertLOG0112D(Map<String, Object> params);

	String selectSROSeq();

	List<EgovMap> selectSroMgmtDetailState(Map<String, Object> params);

	int updateLOG0112D (Map<String, Object> params);

	int updateStateLOG0112D (Map<String, Object> params);

	List<EgovMap> selectSTODataInfo(Map<String, Object> params);

	List<EgovMap> selectSMODataInfo(Map<String, Object> params);


	int updateReqNoLOG0111D (Map<String, Object> params);
	int deleteUpdateLOG0112D (Map<String, Object> params);

	void  SP_LOGITIC_SRO_UPDATE (Map<String, Object> params);




}

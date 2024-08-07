package com.coway.trust.biz.services.hiCare.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 10/01/2022    HLTANG      1.0.0       - Initial creation. HiCareMapper. Systemize and easier monitor Hi-Care SPS-02
 *********************************************************************************************/

@Mapper("hiCareMapper")
public interface HiCareMapper {

	public List<EgovMap> selectCdbCode();

	public List<EgovMap> selectModelCode(Map<String, Object> params);

	public List<EgovMap> getBch(Map<String, Object> params);

	public List<EgovMap> selectHiCareList(Map<String, Object> params);

	public EgovMap selectItemSerch(Map<String, Object> obj) throws Exception;

	public int selectHiCareSerialCheck(Map<String, Object> obj) throws Exception;

	public String selectHiCareMasterSeq();

	public int insertHiCareSerialMaster(Map<String, Object> obj) throws Exception;

	public int deleteHiCareSerialInfo(Map<String, Object> obj) throws Exception;

	public void updateHiCareSerialMaster(Map<String, Object> obj) throws Exception;

	public int insertHiCareSerialHistory(Map<String, Object> obj) throws Exception;

	public int insertHiCareSerialHistory1(Map<String, Object> obj) throws Exception;

	public void updateHiCareSerialHistory(Map<String, Object> obj) throws Exception;

	public EgovMap selectHiCareDetail(Map<String, Object> obj) throws Exception;

	public void updateHiCareDetail(Map<String, Object> obj) throws Exception;

	public int selectHiCareMemberCheck(Map<String, Object> obj) throws Exception;

	int selectNextFileId();

	void insertFileDetail(Map<String, Object> flInfo);

	void updateHiCareAttach(Map<String, Object> params) throws Exception;

	public List<EgovMap> selectHiCareHistory(Map<String, Object> obj) throws Exception;

	public EgovMap selectHiCareHolderDetail(Map<String, Object> obj) throws Exception;

	public String selectHiCarePreviousFilter(Map<String, Object> params);

	public int selectOverallPreviousFilter(Map<String, Object> params);

	public List<EgovMap> selectHiCareFilterHistory(Map<String, Object> obj) throws Exception;

	String selectTransitNo();

	void insertTransitMaster(Map<String, Object> params);

	void insertTransitDetails(Map<String, Object> params);

	public List<EgovMap> selectHiCareItemList(Map<String, Object> params);

	public List<EgovMap> selectHiCareDeliveryList(Map<String, Object> params);

	public List<EgovMap> selectHiCareDeliveryDetail(Map<String, Object> obj) throws Exception;

	public int selectHiCareDeliverySerialCheck(Map<String, Object> obj) throws Exception;

	public void updateHiCareDeliverySerialTemp(Map<String, Object> obj) throws Exception;

	public int deleteHiCareDeliverySerial(Map<String, Object> obj) throws Exception;

	public void updateHiCareDeliverySerial(Map<String, Object> obj) throws Exception;

	public void updateHiCareDeliveryMaster(Map<String, Object> obj) throws Exception;
}

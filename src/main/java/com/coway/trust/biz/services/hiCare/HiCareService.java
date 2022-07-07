package com.coway.trust.biz.services.hiCare;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 10/01/2022    HLTANG      1.0.0       - Initial creation. HiCareService. Systemize and easier monitor Hi-Care SPS-02
 *********************************************************************************************/

public interface HiCareService {

	public List<EgovMap> selectCdbCode();

	public List<EgovMap> selectModelCode();

	public List<EgovMap> getBch(Map<String, Object> params);

	public List<EgovMap> selectHiCareList(Map<String, Object> params);

	public List<Object> saveHiCareBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	public void deleteHiCareSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	public void saveSerialNo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	public EgovMap selectHiCareDetail(Map<String, Object> obj) throws Exception;

	public Map<String, Object> updateHiCareDetail(Map<String, Object> obj, SessionVO sessionVO) throws Exception;

	void insertPreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs);

	void updateHiCareAttach(Map<String, Object> params) throws Exception;

	public List<EgovMap> selectHiCareHistory(Map<String, Object> obj) throws Exception;

	public EgovMap selectHiCareHolderDetail(Map<String, Object> obj) throws Exception;

	public Map<String, Object> updateHiCareFilter(Map<String, Object> obj, SessionVO sessionVO) throws Exception;

	public List<EgovMap> selectHiCareFilterHistory(Map<String, Object> obj) throws Exception;

	public List<EgovMap> selectHiCareItemList(Map<String, Object> params);

	public Map<String, Object> insertHiCareTransfer(Map<String, Object> obj, SessionVO sessionVO) throws Exception;

	public List<EgovMap> selectHiCareDeliveryList(Map<String, Object> params);

	public List<EgovMap> selectHiCareDeliveryDetail(Map<String, Object> obj) throws Exception;

	public List<Object> saveHiCareDeliveryBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	public void deleteHiCareDeliverySerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	public Map<String, Object> saveHiCareDelivery(Map<String, Object> obj, SessionVO sessionVO) throws Exception;

	void updateHiCareDetailMapper(Map<String, Object> params) throws Exception;
}

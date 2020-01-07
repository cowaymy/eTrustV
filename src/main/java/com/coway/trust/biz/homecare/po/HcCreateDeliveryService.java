package com.coway.trust.biz.homecare.po;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcCreateDeliveryService {

	// main List 조회
	public int selectPoListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectPoList(Map<String, Object> params) throws Exception;

	// Po Detail List 조회
	public List<EgovMap> selectPoDetailList(Map<String, Object> params) throws Exception;

	// Delivery List 조회
	public List<EgovMap> selectDeliveryList(Map<String, Object> params) throws Exception;

	// save
	public List<EgovMap> multiHcCreateDelivery(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// delete
	public List<EgovMap> deleteHcCreateDelivery(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// delivery
	public List<EgovMap> deliveryHcCreateDelivery(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;


	public List<EgovMap> selectProductionCompar(Map<String, Object> params) throws Exception;


	public List<EgovMap> cancelDeliveryHc(Map<String, Object> params, SessionVO sessionVO) throws Exception;
}
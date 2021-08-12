package com.coway.trust.biz.logistics.inbound.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("inboundMapper")
public interface InboundMapper {

	List<EgovMap> inBoundList(Map<String, Object> params);

	List<EgovMap> inboundLocation(Map<String, Object> params);

	List<EgovMap> receiptList(Map<String, Object> params);

	List<EgovMap> inboundLocationPort(Map<String, Object> params);

	String selectStockTransferSeq();

	void CreateReqM(Map<String, Object> formMap);

	void CreateReqD(Map<String, Object> formMap);

	void updateReqStatus(String reqNo);

	String selectDeliverySeq();

	void CreateDeliveryM(Map<String, Object> formMap);

	void CreateDeliveryD(Map<String, Object> formMap);

	void CreateIssue(Map<String, Object> formMap);

	List<EgovMap> searchSMO(Map<String, Object> params);

	void insertLocSerial(Map<String, Object> insSerial);

	List<EgovMap> selectDeliveryList(Map<String, Object> formMap);

	List<EgovMap> selectDeliverydupCheck(Map<String, Object> setMap);

	// KR HAN
	void CreateIssueSerial(Map<String, Object> formMap);

	// KR HAN : 바코드 스캔
	void callSaveBarcodeScan(Map<String, Object> formMap);
}

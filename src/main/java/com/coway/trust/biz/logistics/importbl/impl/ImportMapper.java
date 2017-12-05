package com.coway.trust.biz.logistics.importbl.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("importMapper")
public interface ImportMapper {

	List<EgovMap> importBLList(Map<String, Object> params);
	
	List<EgovMap> importLocationList(Map<String, Object> params);
	
	String selectStockTransferSeq();

	void CreateReqM(Map<String, Object> formMap);

	void CreateReqD(Map<String, Object> formMap);

	void updateReqStatus(String reqNo);

	String selectDeliverySeq();

	void CreateDeliveryM(Map<String, Object> formMap);

	void CreateDeliveryD(Map<String, Object> formMap);

	void CreateIssue(Map<String, Object> formMap);

	List<EgovMap> selectDeliveryList(Map<String, Object> formMap);

	List<EgovMap> searchSMO(Map<String, Object> params);

}

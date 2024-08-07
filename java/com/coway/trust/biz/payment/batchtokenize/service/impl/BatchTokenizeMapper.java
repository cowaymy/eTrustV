package com.coway.trust.biz.payment.batchtokenize.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("BatchTokenizeMapper")
public interface BatchTokenizeMapper {

	public List<EgovMap> displayRecord();

	public void delSAL0323T();

	public int insertSAL0323T(Map<String, Object> params);

	public EgovMap selectBatchID();

	public int insertSAL0319M(Map<String, String> param);

	public int insertSAL0320D(Map<String, String> params);

	public int insertSAL0029D(Map<String, String> params);

	public int updateSAL0074D(Map<String, String> params);

	public int updateToken(Map<String, String> params);

	public List<EgovMap> selectdataForCSV(EgovMap param);

	public List<EgovMap> selectBatchTokenizeRecord(Map<String, Object> params);

	public EgovMap batchTokenizeDetail(Map<String, Object> params);

	public List<EgovMap> batchTokenizeViewItmJsonList(Map<String, Object> params);

	public void maskCRCNO(EgovMap batchID);



}



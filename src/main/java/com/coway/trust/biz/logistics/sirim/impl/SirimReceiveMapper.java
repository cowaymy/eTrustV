package com.coway.trust.biz.logistics.sirim.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("SirimReceiveMapper")
public interface SirimReceiveMapper {

	List<EgovMap> receiveWarehouseList(Map<String, Object> params);

	List<EgovMap> selectReceiveList(Map<String, Object> params);

	List<EgovMap> detailReceiveList(Map<String, Object> params);

	List<EgovMap> getSirimReceiveInfo(Map<String, Object> params);

	void SrmResultStatusUpdate(Map<String, Object> params);

	void insertReceiveSirim(Map<String, Object> params);

	String docNoCreateSeq();
	int ReceiveCreateSeq();

	int selectTransReceive(Map<String, Object> params);

	void SrmTransStatusUpdate(Map<String, Object> params);


}

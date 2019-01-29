package com.coway.trust.biz.logistics.sirim;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SirimService {

	List<EgovMap> selectWarehouseList(Map<String, Object> params);

	List<EgovMap> selectSirimList(Map<String, Object> params);

	String selectSirimNo(Map<String, Object> params);

	void insertSirimList(Map<String, Object> params);

	List<EgovMap> selectSirimTransList(Map<String, Object> params);

	List<EgovMap> selectSirimToTransit(Map<String, Object> params);

	List<EgovMap> selectTransitItemlist(Map<String, Object> params);

	String insertSirimToTransitItem(Map<String, Object> params , int lid);

	void updateSirimTranItemDetail(Map<String, Object> params);

	List<EgovMap> selectSirimModDetail(Map<String, Object> params);

	int selecthasItemReceiveByReceiverCnt(Map<String, Object> params);

	void doUpdateSirimTransit(Map<String, Object> params);

	List<EgovMap> selectWarehouseLocByUserBranch(Map<String, Object> params);

	List<EgovMap> selectWarehouseLoc(Map<String, Object> params);

}

package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("posStockMapper")
public interface PosStockMapper {


	List<EgovMap> selectPosStockMgmtList(Map<String, Object> params);
	List<EgovMap> selectPosStockMgmtDetailsList(Map<String, Object> params);
	List<EgovMap> selectPosStockMgmtViewList(Map<String, Object> params);

	List<EgovMap> selectPosItmList(Map<String, Object> params);


	EgovMap  selectPosStockMgmtViewInfo(Map<String, Object> params);
	EgovMap  selectItemInvtQty(Map<String, Object> params);





	void insertSAL0293M(Map<String, Object> params);
	void insertSAL0294D(Map<String, Object> params);

	int getSeqSAL0293M();

	void  updateReceviedSAL0294D(Map<String, Object> params);
	void  updateReceviedSAL0293M(Map<String, Object> params);

	void  updateAdjSAL0294D(Map<String, Object> params);
	void  updateAdjSAL0293M(Map<String, Object> params);


    void updateReceviedRejectSAL0294D(Map<String, Object> params);
    void updateReceviedRejectSAL0293M(Map<String, Object> params);
    void updateApprovalSAL0294D(Map<String, Object> params);




	void  updateMergeLOG0106M(Map<String, Object> params);
	void  updateLOG0106M(Map<String, Object> params);
	void  updateOutStockLOG0106M(Map<String, Object> params);
	void  updateFloatingStockLOG0106M(Map<String, Object> params);
	void  updateRejectedFloatingStockLOG0106M(Map<String, Object> params);






}

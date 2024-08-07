package com.coway.trust.biz.logistics.sirim.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("SirimMapper")
public interface SirimMapper {

	List<EgovMap> selectWarehouseList(Map<String, Object> params);
	List<EgovMap> selectSirimList(Map<String, Object> params);
	int selectSirimNo(Map<String, Object> params);

	int SirimMCreateSeq();
	int SirimDCreateSeq();
	int CrdPosCreateSeq();
	String docNoCreateSeq();

	void insertSirimM(Map<String, Object> params);
	void insertSirimD(Map<String, Object> params);
	void insertSirimCrd_Pos(Map<String, Object> params);

	List<EgovMap> selectSirimTransList(Map<String, Object> params);

	List<EgovMap> selectSirimToTransit(Map<String, Object> params);

	List<EgovMap> selectTransitItemlist(Map<String, Object> params);

	List<EgovMap> selectTransitDoctype(int params);

	void updateTransitDocNo(Map<String, Object> params);

	void insertSirimTransferMst(Map<String, Object> params);

	void insertSirimTransferDtl(Map<String, Object> params);

	void insertSirimTransferStk(Map<String, Object> params);

	void updateSirimTranItemDetail(Map<String, Object> params);

	List<EgovMap> selectSirimModDetail(Map<String, Object> params);

	int selecthasItemReceiveByReceiverCnt(Map<String, Object> params);

	void updateSirimTransit36(Map<String, Object> params);
	void updateSirimTransit35(Map<String, Object> params);

	String selectBranchCode(Map<String, Object> params);
	List<EgovMap> selectWarehouseLocByUserBranch(Map<String, Object> params);
	List<EgovMap> selectWarehouseLoc(Map<String, Object> params);

}

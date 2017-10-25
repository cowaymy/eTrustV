package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("posMapper")
public interface PosMapper {

	List<EgovMap> selectPosModuleCodeList (Map<String, Object> params);
	
	List<EgovMap> selectStatusCodeList(Map<String, Object> params);
	
	List<EgovMap> selectPosJsonList(Map<String, Object> params);
	
	List<EgovMap> selectWhBrnchList();
	
	EgovMap selectWarehouse(Map<String, Object> params);
	
	List<EgovMap> selectPSMItmTypeList();
	
	List<EgovMap> selectPIItmTypeList();
	
	List<EgovMap> selectPIItmList(Map<String, Object> params);
	
	List<EgovMap> selectPSMItmList(Map<String, Object> params);
	
	List<EgovMap> chkStockList(Map<String, Object> params);
	
	EgovMap getMemCode(Map<String, Object> params);
	
	List<EgovMap> getReasonCodeList(Map<String, Object> params);
	
	List<EgovMap> getFilterSerialNum(Map<String, Object> params);
	
	String getDocNo(Map<String, Object> params);
	
	EgovMap getItemBankAccCodeByItemTypeID(Map<String, Object> params);
	
	EgovMap getUserFullName(Map<String, Object> params);
	
	/*SEQ*/
	int getSeqSal0057D();
	
	int getSeqSal0058D();
	
	int getSeqPay0007D();
	
	int getSeqPay0016D();
	
	int getSeqPay0031D();
	
	int getSeqPay0032D();
	
	int getSeqLog0014D();
	
	int getSeqPay0069D();
	
	int getSeqSal0147M();
	
	void insertPosMaster(Map<String, Object> params);
	
	void insertPosDetail(Map<String, Object> params);
	
	void insertDeductionPosDetail(Map<String, Object> params);
	
	void insertPosBilling(Map<String, Object> params);
	
	void updatePosMasterPosBillId(Map<String, Object> params);
	
	void insertPosOrderBilling(Map<String, Object> params);
	
	void insertPosTaxInvcMisc(Map<String, Object> params);
	
	void insertPosTaxInvcMiscSub(Map<String, Object> params);
	
	void insertStkRecord(Map<String, Object> params);
	
	void insertSerialNo(Map<String, Object> params);
}

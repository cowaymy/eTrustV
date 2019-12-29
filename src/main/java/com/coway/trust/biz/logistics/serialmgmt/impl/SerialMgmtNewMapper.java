/**
 * @author
 **/
package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("serialMgmtNewMapper")
public interface SerialMgmtNewMapper{


	public EgovMap selectItemSerch(Map<String, Object> obj) throws Exception;

	// HP Serial Check.
	public int selectHPSerialMgtCheck(Map<String, Object> obj) throws Exception;
	public EgovMap selectHPScanInfoCheck(Map<String, Object> obj) throws Exception;

	public String selectHPDeliveryGRInfo(Map<String, Object> obj) throws Exception;

	// 스캔 저장
	public int insertSerialInfo(Map<String, Object> obj) throws Exception;
	public int saveSerialMaster(Map<String, Object> obj) throws Exception;
	public int insertSerialMasterHistory(Map<String, Object> obj) throws Exception;

	// 스캔삭제
	public int selectHPDelStsCheck(Map<String, Object> obj) throws Exception;
	public int deleteSerialInfo(Map<String, Object> obj) throws Exception;
	public int deleteSerialMaster(Map<String, Object> obj) throws Exception;
	public int copySerialMasterHistory(Map<String, Object> obj) throws Exception;

	// HP - 진행중인 GR의 serial 정보 조회
	public List<EgovMap> selectHPIngSerialInfo(Map<String, Object> obj) throws Exception;

	// Logistic barcode scan
	public EgovMap callBarcodeScan(Map<String, Object> param) throws Exception;
	// Logistic barcode delete
	public EgovMap callDeleteBarcodeScan(Map<String, Object> param) throws Exception;

	// Logistic barcode save
	public void callSaveBarcodeScan(Map<String, Object> param) throws Exception;

	public void callReverseBarcodeScan(Map<String, Object> param) throws Exception;

	// Stock Audit Logistic barcode delete
	public EgovMap callAdDeleteBarcodeScan(Map<String, Object> param) throws Exception;
}
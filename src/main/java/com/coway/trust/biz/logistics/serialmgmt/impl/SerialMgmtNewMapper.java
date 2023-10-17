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

	// Other GI/GR Logistic barcode delete
	public EgovMap callOgOiDeleteBarcodeScan(Map<String, Object> param) throws Exception;

	// Added to select by pass-able column checking for serial scanning. By Hui Ding 15-06-2020
	public List<EgovMap> selectScanByPassItm(Map<String, Object> param) throws Exception;

	//HLTANG 202111 - filter barcode scan
	// Select box serial barcode
	public List<EgovMap> selectBoxSerialBarcode(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectSerialInfo(Map<String, Object> obj) throws Exception;
	public void updateDeliveryGrDetail(Map<String, Object> obj) throws Exception;
	public void updateDeliveryGrMain(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectDeliveryGrHist(Map<String, Object> obj) throws Exception;
	public void updateDeliveryGrHist(Map<String, Object> obj) throws Exception;
	public int deleteTempSerialMaster(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectSerialInfoMul(Map<String, Object> obj) throws Exception;

	public int deleteSerialInfoBulk(Map<String, Object> obj) throws Exception;
	public int deleteTempSerialMasterBulk(Map<String, Object> obj) throws Exception;
	public int copySerialMasterHistoryBulk(Map<String, Object> obj) throws Exception;

	//Serial Prefix Conversion checking. By Tommy 17-08-2023
	public String selectSerialPrefixConversion(Map<String, Object> obj) throws Exception;
	public String selectHPDeliveryGRStockCode(Map<String, Object> obj) throws Exception;
}
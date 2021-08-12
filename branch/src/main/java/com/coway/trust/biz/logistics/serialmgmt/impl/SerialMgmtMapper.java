/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("SerialMgmtMapper")
public interface SerialMgmtMapper
{

	List<EgovMap> selectDeliveryBalance(Map<String, Object> params);

	List<EgovMap> selectGIRDCBalance(Map<String, Object> params);

	List<EgovMap> selectDeliveryList(Map<String, Object> params);

	List<EgovMap> selectSerialDetails(Map<String, Object> params);

	List<EgovMap> selectRDCScanList(Map<String, Object> params);

	List<EgovMap> selectScanList(Map<String, Object> params);

	List<EgovMap> selectBoxNoList(Map<String, Object> params);

	List<EgovMap> selectUserDetails(int brnchid);

	String checkScanNoSeq(String delno);

	String selectScanNoSeq();

	void insertScanItems(Map<String, Object> params);
}

/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.sirim.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.sirim.SirimService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SirimService")
public class SirimServiceImpl extends EgovAbstractServiceImpl implements SirimService {

	private static final Logger Logger = LoggerFactory.getLogger(SirimServiceImpl.class);

	@Resource(name = "SirimMapper")
	private SirimMapper SirimMapper;

	@Override
	public List<EgovMap> selectWarehouseList(Map<String, Object> params) {
		return SirimMapper.selectWarehouseList(params);
	}

	@Override
	public List<EgovMap> selectSirimList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimMapper.selectSirimList(params);
	}
	
	@Override
	public String selectSirimNo(Map<String, Object> params) {
		Logger.debug("@@@@@imlpeprefix&&&: {}",params.get("prefix"));
		Logger.debug("####implfirst&&&: {}",params.get("first"));
		Logger.debug("@@@@@impliCnt&&&: {}",params.get("iCnt"));
		String first=(String) params.get("first");
		String prefix=(String) params.get("prefix");
		int iCnt=Integer.parseInt((String) params.get("iCnt"));
		List<String> chekStimNo = new ArrayList<>();
	for (int i = 0 ; i < iCnt ; i++){
		
		String SirimNo = GetNextRunningNumber(prefix,first,i);
		chekStimNo.add(SirimNo);
		// Logger.debug("@@@@StartSirimNo!!!!!@@@@ : {}", SirimNo);
		
		}
		params.put("StartSirimNo", chekStimNo);
		 Logger.debug("dddd????????? : {}", params.get("StartSirimNo"));
	
		String reval = "";
		
		int SirimCnt = SirimMapper.selectSirimNo(params);
		if (SirimCnt > 0) reval = "N";
		else reval = "Y";
		System.out.println("reval :::     "+reval);
		return reval; 
	}
	
	

	@Override
	public void insertSirimList(Map<String, Object> params) {

		int srmBatchId = SirimMapper.SirimMCreateSeq();
		String getdocNo = SirimMapper.docNoCreateSeq();
		
		 Logger.debug("@@@@getdocNo@@@@ : {}", getdocNo);
		// Logger.debug("@@@@srmBatchId@@@@ : {}", srmBatchId);
		// Logger.debug("addWarehouse! : {}", params.get("addWarehouse"));
		// Logger.debug("addTypeSirim! : {}", params.get("addTypeSirim"));
		// Logger.debug("addPrefixNo! : {}", params.get("addPrefixNo"));
		// Logger.debug("addQuantity! : {}", params.get("addQuantity"));
		// Logger.debug("addSirimNoFirst! : {}", params.get("addSirimNoFirst"));
		// Logger.debug("addSirimNoLast ! : {}", params.get("addSirimNoLast"));
		// Logger.debug("crtuser_id ! : {}", params.get("crtuser_id"));
		// Logger.debug("upuser_id ! : {}", params.get("upuser_id"));

		String addWarehouse = (String) params.get("addWarehouse");
		String addTypeSirim = (String) params.get("addTypeSirim");
		String addPrefixNo = (String) params.get("addPrefixNo");
		int Qty = Integer.parseInt((String) params.get("addQuantity"));
		String addSirimNoFirst = (String) params.get("addSirimNoFirst");
		String addSirimNoLast = (String) params.get("addSirimNoLast");

		String SrmNoFrom = addPrefixNo + addSirimNoFirst;
		// Logger.debug("@@@@SrmNoFrom@@@@ : {}", SrmNoFrom);
		String SrmNoTo = addPrefixNo + addSirimNoLast;
		// Logger.debug("@@@@SrmNoTo@@@@ : {}", SrmNoTo);
		
		params.put("getdocNo", getdocNo);
		params.put("srmBatchId", srmBatchId);
		params.put("SrmNoFrom", SrmNoFrom);
		params.put("SrmNoTo", SrmNoTo);

		SirimMapper.insertSirimM(params);
		
		for (int i = 0; i < Qty; i++) {
			int srdBatchId = SirimMapper.SirimDCreateSeq();
			String saveSirimNo = GetNextRunningNumber(addPrefixNo, addSirimNoFirst, i);
			 Logger.debug("@@@@saveSirimNo@@@@ : {}", saveSirimNo);
			Map<String, Object> SirimdMap = new HashMap<String, Object>();
			SirimdMap.put("srdBatchId", srdBatchId);
			SirimdMap.put("srmBatchId", srmBatchId);
			SirimdMap.put("saveSirimNo", saveSirimNo);
			SirimdMap.put("crtuser_id", params.get("crtuser_id"));
			SirimdMap.put("upuser_id", params.get("upuser_id"));
			SirimMapper.insertSirimD(SirimdMap);
			
			Map<String, Object> CrdPosMap = new HashMap<String, Object>();
			int CrdSirimId = SirimMapper.CrdPosCreateSeq();
			CrdPosMap.put("CrdSirimId", CrdSirimId);
			CrdPosMap.put("saveSirimNo", saveSirimNo);
			CrdPosMap.put("addTypeSirim", addTypeSirim);
			CrdPosMap.put("addSirimLoc", "SIRIM");
			CrdPosMap.put("addSirimQty", 1);
			CrdPosMap.put("getdocNo", getdocNo);
			CrdPosMap.put("crtuser_id", params.get("crtuser_id"));
			SirimMapper.insertSirimCrd_Pos(CrdPosMap);
			

			Map<String, Object> CrdNegMap = new HashMap<String, Object>();
			CrdSirimId = SirimMapper.CrdPosCreateSeq();
			CrdNegMap.put("CrdSirimId", CrdSirimId);
			CrdNegMap.put("saveSirimNo", saveSirimNo);
			CrdNegMap.put("addTypeSirim", addTypeSirim);
			CrdNegMap.put("addSirimLoc", "SIRIM");
			CrdNegMap.put("addSirimQty", -1);
			CrdNegMap.put("getdocNo", getdocNo);
			CrdNegMap.put("crtuser_id", params.get("crtuser_id"));
			SirimMapper.insertSirimCrd_Pos(CrdNegMap);
			

			Map<String, Object> CrdWHMap = new HashMap<String, Object>();
			CrdSirimId = SirimMapper.CrdPosCreateSeq();
			CrdWHMap.put("CrdSirimId", CrdSirimId);
			CrdWHMap.put("saveSirimNo", saveSirimNo);
			CrdWHMap.put("addTypeSirim", addTypeSirim);
			CrdWHMap.put("addSirimLoc", addWarehouse);
			CrdWHMap.put("addSirimQty", 1);
			CrdWHMap.put("getdocNo", getdocNo);
			CrdWHMap.put("crtuser_id", params.get("crtuser_id"));
			SirimMapper.insertSirimCrd_Pos(CrdWHMap);
			

		}

	}

	public static String GetNextRunningNumber(String PrefixNo, String StartNo, int increment) {
		Logger.debug("ncrement :         {}", increment);
		if (PrefixNo != null || !"".equals(PrefixNo)) {
			StartNo = StartNo.replace(PrefixNo, "");
		}
		String StartNoFormat = "";
		int currentInt = Integer.parseInt(StartNo);
		for (int i = 0; i <= increment; i++) {
			StartNoFormat = String.format("%0" + StartNo.length() + "d", currentInt++);
		}
		return PrefixNo + StartNoFormat;
	}

}

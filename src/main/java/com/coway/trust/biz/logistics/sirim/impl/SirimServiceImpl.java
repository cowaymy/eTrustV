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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.sirim.SirimService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

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
//		Logger.debug("@@@@@imlpeprefix&&&: {}",params.get("prefix"));
//		Logger.debug("####implfirst&&&: {}",params.get("first"));
//		Logger.debug("@@@@@impliCnt&&&: {}",params.get("iCnt"));
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
//		 Logger.debug("dddd????????? : {}", params.get("StartSirimNo"));

		String reval = "";

		int SirimCnt = SirimMapper.selectSirimNo(params);
		if (SirimCnt > 0) reval = "N";
		else reval = "Y";
		return reval;
	}



	@Override
	public void insertSirimList(Map<String, Object> params) {

		int srmBatchId = SirimMapper.SirimMCreateSeq();
		String getdocNo = SirimMapper.docNoCreateSeq();

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
		//int  addTypeSirim = (int) params.get("addTypeSirim");
		int addTypeSirim = Integer.parseInt((String) params.get("addTypeSirim"));
		String addPrefixNo = (String) params.get("addPrefixNo");
		int Qty = Integer.parseInt((String) params.get("addQuantity"));
		String addSirimNoFirst = (String) params.get("addSirimNoFirst");
		String addSirimNoLast = (String) params.get("addSirimNoLast");

//		Logger.debug("Qty !!!!! : {}", Qty);

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
//			 Logger.debug("@@@@saveSirimNo@@@@ : {}", saveSirimNo);
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

	@Override
	public List<EgovMap> selectSirimTransList(Map<String, Object> params) {

		return SirimMapper.selectSirimTransList(params);
	}

	@Override
	public List<EgovMap> selectSirimToTransit(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimMapper.selectSirimToTransit(params);
	}

	@Override
	public List<EgovMap> selectTransitItemlist(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimMapper.selectTransitItemlist(params);
	}

	@Override
	public String insertSirimToTransitItem(Map<String, Object> params , int lid) {
		//String key = "";
		List<Object> grid            = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		int docype = AppConstants.SIRIM_TRANSFER;
		String transitNo = "";
		String branch = (String)formMap.get("ncourier");
		String tmpDocno = "";

		List<EgovMap> doctype = SirimMapper.selectTransitDoctype(docype);

		if (doctype.isEmpty()){
			return "Fail";
		}else{
			Map<String , Object> hmap = (Map<String, Object>)doctype.get(0);
			//DOC_NO_PREFIX, DOC_NO
			transitNo = (String)hmap.get("docNoPrefix") + (String)hmap.get("docNo");

			tmpDocno = (String)hmap.get("docNo");

			int serial = Integer.parseInt(tmpDocno);
			tmpDocno = String.format("%0"+tmpDocno.length()+"d", (serial + 1));

			for (int i  = 0; i < grid.size() ; i++){
				//LOG0036D INSERT : SirimTransferD
				Map<String , Object> mMap =  (Map<String, Object>)grid.get(i);
				mMap.put("suserid" , lid);
				mMap.put("tsid" , 1);
				mMap.put("rsid" , 44);
				SirimMapper.insertSirimTransferDtl(mMap);
				// LOG0040D INSERT : STKSIRIM
				mMap.put("fsqty", -1);
				mMap.put("docno", transitNo);
				mMap.put("rmark", "");
				mMap.put("schk", "1");
				mMap.put("sepo", 1);
				mMap.put("saws", "1");
				SirimMapper.insertSirimTransferStk(mMap);
				// LOG0040D INSERT : STKSIRIM
				mMap.put("fsqty", 1);
				mMap.put("sloc", branch);
				SirimMapper.insertSirimTransferStk(mMap);
			}

			// LOG0035D INSERT : SirimTransferM
			formMap.put("statusid" , 1);
            formMap.put("strn" , transitNo);
            formMap.put("suserid" , lid);
            SirimMapper.insertSirimTransferMst(formMap);
			// update docNo
			Map<String , Object> dmap = new HashMap();
			dmap.put("dno", docype);
			dmap.put("nno", tmpDocno);
			dmap.put("suserid" , lid);
			SirimMapper.updateTransitDocNo(dmap);
		}

		return transitNo;
	}

	@Override
	public void updateSirimTranItemDetail(Map<String, Object> params) {
		SirimMapper.updateSirimTranItemDetail(params);
	}

	@Override
	public List<EgovMap> selectSirimModDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimMapper.selectSirimModDetail(params);
	}

	@Override
	public int selecthasItemReceiveByReceiverCnt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimMapper.selecthasItemReceiveByReceiverCnt(params);
	}

	@Override
	public void doUpdateSirimTransit(Map<String, Object> params) {
		// TODO Auto-generated method stub
		SirimMapper.updateSirimTransit35(params);
		if(Integer.parseInt((String)params.get("utrnsitstus")) == 8){
			SirimMapper.updateSirimTransit36(params);
		}
	}

	@Override
	public List<EgovMap> selectWarehouseLocByUserBranch(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimMapper.selectWarehouseLocByUserBranch(params);
	}

	@Override
	public List<EgovMap> selectWarehouseLoc(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return SirimMapper.selectWarehouseLoc(params);
	}

}

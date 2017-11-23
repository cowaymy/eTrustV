package com.coway.trust.biz.logistics.pointofsales.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.pointofsales.PointOfSalesService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("PointOfSalesService")
public class PointOfSalesServiceImpl extends EgovAbstractServiceImpl implements PointOfSalesService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "PointOfSalesMapper")
	private PointOfSalesMapper PointOfSalesMapper;

	@Override
	public List<EgovMap> PosSearchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return PointOfSalesMapper.PosSearchList(params);
	}

	@Override
	public List<EgovMap> posItemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return PointOfSalesMapper.posItemList(params);
	}

	@Override
	public List<EgovMap> selectPointOfSalesSerial(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return PointOfSalesMapper.selectPointOfSalesSerial(params);
	}

	@Override
	public String insertPosInfo(Map<String, Object> params) {

		String seq = PointOfSalesMapper.selectPosSeq();

		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

//		for (int i = 0; i < checkList.size(); i++) {
//			logger.debug("checkList    값 : {}", checkList.get(i));
//		}
//
//		if (serialList.size() > 0) {
//			for (int i = 0; i < serialList.size(); i++) {
//				logger.debug("serialList    값 : {}", serialList.get(i));
//			}
//		}

		formMap.put("reqno", formMap.get("headtitle") + seq);
		formMap.put("userId", params.get("userId"));
		String posSeq = formMap.get("headtitle") + seq;

		PointOfSalesMapper.insOtherReceiptHead(formMap);

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				// logger.debug("checkList 값 : {}", checkList.get(i));
				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
				insMap.put("reqno", formMap.get("headtitle") + seq);
				insMap.put("userId", params.get("userId"));
				PointOfSalesMapper.insRequestItem(insMap);
			}
		}

		if (serialList.size() > 0) {
			for (int i = 0; i < serialList.size(); i++) {
				Map<String, Object> serialMap = (Map<String, Object>) serialList.get(i);
				serialMap.put("reqno", posSeq);
				serialMap.put("ttype", formMap.get("trnscType"));
				serialMap.put("userId", params.get("userId"));

				PointOfSalesMapper.insertSerial(serialMap);
			}
		}

		insertStockBooking(formMap);
		return posSeq;
	}

	@Override
	public String insertGiInfo(Map<String, Object> params) {

		List<EgovMap> GIList = (List<EgovMap>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> GiMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		String reVal = "";

		int iCnt = 0;
		String ttype = "";
		String docno = "";
		String tmpdelCd = "";
		String delyCd = "";

		if (GIList.size() > 0) {

			for (int i = 0; i < GIList.size(); i++) {

				Map<String, Object> tmpMap = GIList.get(i);
				Map<String, Object> imap = new HashMap();
				imap = (Map<String, Object>) tmpMap.get("item");
				ttype = (String) imap.get("ttype");
				docno = (String) imap.get("docno");

				String delCd = (String) imap.get("reqstno");

				if (delCd != null && !(tmpdelCd.equals(delCd))) {
					tmpdelCd = delCd;
					if (iCnt == 0) {
						delyCd = delCd;
					} else {
						delyCd += "∈" + delCd;
					}
					iCnt++;
				}

			}
		}
		String[] delvcd = delyCd.split("∈");
		GiMap.put("parray", delvcd);
		GiMap.put("gtype", ttype);
		// GiMap.put("prgnm", "POS PROGRAM");
		GiMap.put("refdocno", docno);
		GiMap.put("salesorder", "");
		GiMap.put("userId", params.get("userId"));

		if ("GC".equals(GiMap.get("gitype"))) {
			PointOfSalesMapper.GICancelIssue(GiMap);
			reVal = (String)GiMap.get("rdata");
		} else {
			PointOfSalesMapper.GIRequestIssue(GiMap);
			reVal = (String)GiMap.get("rdata");
		}
		String returnValue[] = reVal.split("∈"); 
		return returnValue[1];
	}

	@Override
	public List<EgovMap> selectPosReqNoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<EgovMap> list = null;

		list = PointOfSalesMapper.selectPosReqNoList(params);

		return list;
	}

	@Override
	public Map<String, Object> PosDataDetail(String param) {

		Map<String, Object> hdMap = PointOfSalesMapper.selectPosHead(param);

		List<EgovMap> list = PointOfSalesMapper.selectPosItem(param);

		Map<String, Object> pMap = new HashMap();
		pMap.put("reqloc", hdMap.get("reqcr"));

		List<EgovMap> toList = PointOfSalesMapper.selectPosToItem(pMap);

		Map<String, Object> reMap = new HashMap();
		reMap.put("hValue", hdMap);
		reMap.put("iValue", list);
		reMap.put("itemto", toList);

		return reMap;
	}

	@Override
	public List<EgovMap> selectSerial(Map<String, Object> params) {
		// TODO Auto-generated method stub

		List<EgovMap> list = PointOfSalesMapper.selectSerial(params);

		return list;
	}

	@Override
	public void insertStockBooking(Map<String, Object> params) {
		// TODO Auto-generated method stub
		// return stocktran.selectStockTransferMtrDocInfoList(params);
		PointOfSalesMapper.insertStockBooking(params);
	}

	@Override
	public List<EgovMap> selectMaterialDocList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return PointOfSalesMapper.selectMaterialDocList(params);
	}

}

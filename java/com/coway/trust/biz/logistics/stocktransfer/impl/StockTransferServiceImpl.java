/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stocktransfer.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.replenishment.impl.SROMapper;
import com.coway.trust.biz.logistics.serialmgmt.ScanSearchPopService;
import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtNewService;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stocktranService")
public class StockTransferServiceImpl extends EgovAbstractServiceImpl implements StockTransferService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "stockTranMapper")
	private StockTransferMapper stocktran;

	@Resource(name = "serialMgmtNewService")
	private SerialMgmtNewService serialMgmtNewService;

	@Resource(name = "ScanSearchPopService")
	private ScanSearchPopService scanSearchPopService;

	@Resource(name = "SROMapper")
	private SROMapper sROMapper;

	@Resource(name = "servicesLogisticsPFCMapper")
	private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;


	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Override
	public List<EgovMap> selectStockTransferMainList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferMainList(params);
	}

	@Override
	public List<EgovMap> selectStockTransferDeliveryList(Map<String, Object> params) {
		return stocktran.selectStockTransferDeliveryList(params);
	}

	@Override
	public String insertStockTransferInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

				insMap.put("tlocation", fMap.get("tlocation"));

				int iCnt = stocktran.selectAvaliableStockQty(insMap);
				if (iCnt == 1 ){
					return "";
				}
			}
		}
		/* 2017-11-30 김덕호 위원 채번 변경 요청 */
		String seq = stocktran.selectStockTransferSeq();



		// String reqNo = fMap.get("headtitle") + seq;
		String reqNo = seq;

		fMap.put("reqno", reqNo);
		// fMap.put("reqno", fMap.get("headtitle") + seq);
		fMap.put("userId", params.get("userId"));

		stocktran.insStockTransferHead(fMap);

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				// insMap.put("reqno", fMap.get("headtitle") + seq);
				insMap.put("reqno", seq);
				insMap.put("userId", params.get("userId"));
				stocktran.insStockTransfer(insMap);
			}
		}
		// booking insert
		if ("M".equals((String)fMap.get("pridic"))){
			insertStockBooking(fMap);
		}

		return reqNo;

	}

	@Override
	public List<EgovMap> selectStockTransferNoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<EgovMap> list = null;
		if ("stock".equals(params.get("groupCode"))) {
			list = stocktran.selectStockTransferNoList();
		} else {
			list = stocktran.selectDeliveryNoList();
		}
		return list;
	}

	@Override
	public Map<String, Object> StocktransferDataDetail(String param) {

		Map<String, Object> hdMap = stocktran.selectStockTransferHead(param);

		List<EgovMap> list = stocktran.selectStockTransferItem(param);

		Map<String, Object> pMap = new HashMap();
		pMap.put("toloc", hdMap.get("rcivcr"));

		List<EgovMap> toList = stocktran.selectStockTransferToItem(pMap);

		Map<String, Object> reMap = new HashMap();
		reMap.put("hValue", hdMap);
		reMap.put("iValue", list);
		reMap.put("itemto", toList);

		return reMap;
	}

	@Override
	public int stockTransferItemDeliveryQty(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Map<String, Object> map = stocktran.stockTransferItemDeliveryQty(params);
		int iCnt = 0;
		try {
			iCnt = (int) map.get("qty");
		} catch (Exception ex) {
			iCnt = 0;
		}
		return iCnt;
	}

	@Override
	public List<EgovMap> selectTolocationItemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferToItem(params);
	}

	@Override
	public List<EgovMap> addStockTransferInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		List<Object> updList = (List<Object>) params.get("upd");
		/* List<Object> delList = (List<Object>) params.get("rem"); */

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				insMap.put("userId", params.get("userId"));
				stocktran.insStockTransfer(insMap);
			}
		}
		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) updList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				insMap.put("userId", params.get("userId"));
				stocktran.insStockTransfer(insMap);
			}
		}
		List<EgovMap> list = stocktran.selectStockTransferItem((String) fMap.get("reqno"));
		return list;
	}

	@Override
	public void deliveryStockTransferInfo(Map<String, Object> params) {

		List<Object> updList = (List<Object>) params.get("upd");

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		fMap.put("reqno", fMap.get("reqno"));
		String seq = stocktran.selectDeliveryNobyReqsNo(fMap);
		if (seq == null || "0".equals(seq)) {
			seq = stocktran.selectDeliveryStockTransferSeq();
		}

		fMap.put("delno", seq);
		fMap.put("ttype", fMap.get("smtype"));
		fMap.put("userId", params.get("userId"));

		stocktran.deliveryStockTransferIns(fMap);

		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) updList.get(i);
				insMap.put("delno", seq);
				insMap.put("userId", params.get("userId"));

				stocktran.deliveryStockTransferDetailIns(insMap);
			}
		}
	}

	@Override
	public void deliveryStockTransferItmDel(Map<String, Object> params) {
		List<Object> delList = (List<Object>) params.get("del");

		Map<String, Object> fMap = (Map<String, Object>) params.get("form");

		if (delList.size() > 0) {
			for (int i = 0; i < delList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) delList.get(i);
				insMap.put("reqno", fMap.get("reqno"));
				stocktran.StockTransferItmDel(insMap);
				stocktran.deliveryStockTransferItmDel(insMap);
			}
		}
	}

	// @Override
	// public String StocktransferReqDelivery(Map<String, Object> params) {
	//
	// List<Object> updList = (List<Object>) params.get("check");
	//// List<Object> serialList = (List<Object>) params.get("add");
	// Map<String, Object> formMap = (Map<String, Object>) params.get("formMap");
	//
	// // for (int i = 0; i < updList.size(); i++) {
	// // logger.info(" updList.get(i) : {}", updList.get(i));
	// // }
	// // for (int i = 0; i < serialList.size(); i++) {
	// // logger.info(" serialList.get(i) : {}", serialList.get(i));
	// // }
	// //
	// // logger.info(" reqstno : {}", formMap.get("reqstno"));
	//
	// String seq = stocktran.selectDeliveryStockTransferSeq();
	//
	// if (updList.size() > 0) {
	// Map<String, Object> imap = new HashMap();
	// Map<String, Object> insMap = null;
	// for (int i = 0; i < updList.size(); i++) {
	//
	// logger.info(" updList.get(i) : {}", updList.get(i).toString());
	// insMap = (Map<String, Object>) updList.get(i);
	//
	// imap = (Map<String, Object>) insMap.get("item");
	//
	// imap.put("delno", seq);
	// imap.put("userId", params.get("userId"));
	// stocktran.deliveryStockTransferDetailIns(imap);
	// }
	// stocktran.deliveryStockTransferIns(imap);
	// }
	//
	//// if (serialList.size() > 0) {
	////
	//// for (int j = 0; j < serialList.size(); j++) {
	////
	//// Map<String, Object> insSerial = null;
	////
	//// insSerial = (Map<String, Object>) serialList.get(j);
	////
	//// insSerial.put("delno", seq);
	//// insSerial.put("reqstno", formMap.get("reqstno"));
	//// insSerial.put("userId", params.get("userId"));
	//// stocktran.insertTransferSerial(insSerial);
	//// }
	//// }
	// return seq;
	// }

	@Override
	public String StocktransferReqDelivery(Map<String, Object> params) {

		List<Object> updList = (List<Object>) params.get("check");

		String seq;
		boolean dupCheck = true;
		if (updList.size() > 0) {
			Map<String, Object> insMap = null;
			for (int i = 0; i < updList.size(); i++) {

				logger.info(" updList.get(i) : {}", updList.get(i).toString());
				insMap = (Map<String, Object>) updList.get(i);
				List<EgovMap> list = stocktran.selectDeliverydupCheck(insMap);
				logger.info(" list : {}", list.toString());
				logger.info(" list.size : {}", list.size());
				String ttmp1 = (String) insMap.get("reqstno");
				String ttmp2 = (String) insMap.get("itmcd");
				int ttmp3 = (int) insMap.get("reqstqty");
				int ttmp4 = (int) insMap.get("delyqty");
				logger.info(" ttmp1 :ttmp2 : ttmp3 : ttmp4 {} : {} : {} : {}", ttmp1, ttmp2, ttmp3, ttmp4);
				if (list.size() > 0) {
					Map<String, Object> checkmap = null;
					checkmap = list.get(0);
					String tmp1 = (String) checkmap.get("reqstNo");
					String tmp2 = (String) checkmap.get("itmCode");
					// int tmp3 = 1;
					Integer count = ((BigDecimal) checkmap.get("delvryQty")).intValueExact();
					int tmp3 = count;
					// int tmp3 = Integer.parseInt((String) (checkmap.get("delvryQty")));

					logger.info(" tmp1 :tmp2 : tmp3 {} : {} : {}", tmp1, tmp2, tmp3);

					if (ttmp1.equals(tmp1) && ttmp2.equals(tmp2) && (ttmp4 + tmp3) > ttmp3) {
						dupCheck = false;
					}
				}

			}
		}
		if (dupCheck) {
			seq = stocktran.selectDeliveryStockTransferSeq();
			if (updList.size() > 0) {
				Map<String, Object> insMap = null;
				for (int i = 0; i < updList.size(); i++) {

					logger.info(" updList.get(i) : {}", updList.get(i).toString());
					insMap = (Map<String, Object>) updList.get(i);
					insMap.put("delno", seq);
					insMap.put("userId", params.get("userId"));
					stocktran.deliveryStockTransferDetailIns(insMap);
				}
				stocktran.deliveryStockTransferIns(insMap);

				for (int i = 0; i < updList.size(); i++) { // Added for when select more than two diff order by hltang, 8-7-2021
					insMap = (Map<String, Object>) updList.get(i);
					String reqstNo = (String) insMap.get("reqstno");
					logger.info(" reqstNo ??? : {}", reqstNo);
					stocktran.updateRequestTransfer(reqstNo);

				}
			}
		} else {
			seq = "dup";
		}
		/*
		 * String seq = stocktran.selectDeliveryStockTransferSeq();
		 *
		 * if (updList.size() > 0) { Map<String, Object> insMap = null; for (int i = 0; i < updList.size(); i++) {
		 *
		 * logger.info(" updList.get(i) : {}", updList.get(i).toString()); insMap = (Map<String, Object>)
		 * updList.get(i); insMap.put("delno", seq); insMap.put("userId", params.get("userId"));
		 * stocktran.deliveryStockTransferDetailIns(insMap); } stocktran.deliveryStockTransferIns(insMap); }
		 */
		return seq;

	}

	@Override
	public String StockTransferDeliveryIssue(Map<String, Object> params) throws Exception{
		List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		String reVal = "";

		int iCnt = 0;
		String tmpdelCd = "";
		String delyCd = "";
		String delno = "";

		if (checklist.size() > 0) {
			for (int i = 0; i < checklist.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checklist.get(i);

				Map<String, Object> imap = new HashMap();
				imap = (Map<String, Object>) map.get("item");

				String delCd = (String) imap.get("delyno");
				delno = (String) imap.get("delyno");
				if (delCd != null && !(tmpdelCd.equals(delCd))) {
					tmpdelCd = delCd;
					if (iCnt == 0) {
						delyCd = delCd;
					} else {
						delyCd += "∈" + delCd;
					}
					iCnt++;
				}
				//String reqstNo = (String) imap.get("reqstno");
				//stocktran.updateRequestTransfer(reqstNo);
			}
		}


		if (serialList != null && serialList.size() > 0) {

			for (int j = 0; j < serialList.size(); j++) {

				Map<String, Object> insSerial = null;

				insSerial = (Map<String, Object>) serialList.get(j);

				insSerial.put("delno", delno);
				insSerial.put("reqstno", formMap.get("reqstno"));
				insSerial.put("userId", params.get("userId"));

				stocktran.insertTransferSerial(insSerial);


			}
		}

		String[] delvcd = delyCd.split("∈");
		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");
		formMap.put("delyno", delno);

		logger.info(" map:::!!! ??: {}", formMap);

		if ("RC".equals(formMap.get("gtype"))) {
			stocktran.StockTransferCancelIssue(formMap);
			reVal = (String) formMap.get("rdata");

			// STO - new Serial scan Cancel.
			stockSerialReverse(params);


		} else {
			stocktran.StockTransferiSsue(formMap);
			stocktran.updateDelivery54(formMap);
			reVal = (String) formMap.get("rdata");

			//STO COME FROM ATP, AFTER STO GR, NEED TO CREATE SMO FOR THE INSTALLATION
			if("GR".equals(formMap.get("gtype"))){
				if (checklist.size() > 0) {
					for (int i = 0; i < checklist.size(); i++) {
						Map<String, Object> map = (Map<String, Object>) checklist.get(i);

						Map<String, Object> imap = new HashMap();
						imap = (Map<String, Object>) map.get("item");

						String docno = (String) imap.get("docno");
						if (docno != null && !docno.isEmpty()) {
							Map<String, Object> insDetailsprm = new HashMap<String, Object>();
							insDetailsprm.put("refdocno", docno);
							EgovMap insDetails = stocktran.selectDeliveryInsDet(insDetailsprm);

							if (insDetails !=null && !insDetails.get("insStus").toString().equals("21")) { //active or complete
								Map<String, Object> logPram = new HashMap<String, Object>();
							    String pType = "";
							    String pPrgm = "";
								if (insDetails.get("callType").toString().equals("258")) { // PRODUCT RETURN
						          pType = "OD53";
						          pPrgm = "PEXCALL";
						        } else {
						          pType = "OD01";
						          pPrgm = "OCALL";
						        }

						        logPram.put("ORD_ID", docno);
						        logPram.put("RETYPE", "SVO");
						        logPram.put("P_TYPE", pType);
						        logPram.put("P_PRGNM", pPrgm);
						        logPram.put("USERID", Integer.parseInt(String.valueOf(params.get("userId"))));

						        logger.debug("STO GR INS START PRAM ===>" + logPram.toString());
						        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
						        logPram.put("P_RESULT_TYPE", "IN");
						        logPram.put("P_RESULT_MSG", logPram.get("p1"));
						        logger.debug("STO GR INS END ===>");
							}
						}
					}
				}
			}
		}
		String returnValue[] = reVal.split("∈");
		return returnValue[1];
	}

	@Override
	public List<EgovMap> selectStockTransferMtrDocInfoList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stocktran.selectStockTransferMtrDocInfoList(params);
	}

	@Override
	public void insertStockBooking(Map<String, Object> params) {
		// TODO Auto-generated method stub
		// return stocktran.selectStockTransferMtrDocInfoList(params);
		stocktran.insertStockBooking(params);
	}

	@Override
	public void StocktransferDeliveryDelete(Map<String, Object> params) {
		List<Object> updList = (List<Object>) params.get("checked");
		String delno = "";
		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				//Map<String, Object> dmap = (Map<String, Object>) ((Map<String, Object>) updList.get(i)).get("item");
				Map<String, Object> dmap = (Map<String, Object>) updList.get(i);

				logger.debug("323 Line params ::: {}", dmap);

				if (!delno.equals(dmap.get("delyno"))) {
					delno = (String) dmap.get("delyno");

					// new serial checking.
					if( "Y".equals((String)dmap.get("rcvSerialRequireChkYn"))){
						HashMap<String, Object> sMap = new HashMap<String, Object>();
						sMap.put("searchDeliveryNo", delno);
						List<EgovMap> sList = scanSearchPopService.scanSearchDataList(sMap);
						if(sList != null && sList.size() > 0){
							throw new ApplicationException(AppConstants.FAIL, "Please proceed after deleting the serial.");
						}
					}

					stocktran.deliveryDelete54(dmap);
					stocktran.deliveryDelete55(dmap);
					stocktran.deliveryDelete61(dmap);
					logger.debug("329Line :::: " + delno);


				     /**************************
				       * delete sro  by leo.ham
				       **************************/
				       Map<String, Object> sroMap = new HashMap<String, Object>();
				       sroMap.put("refno", delno);
				       sroMap.put("userId", "");
				       sroMap.put("type", "STO");
				       sroMap.put("result", "D");
				       sroMap.put("item", dmap.get("item"));

				       logger.debug("=====>",sroMap.toString());
				       sROMapper.SP_LOGITIC_SRO_UPDATE(sroMap);

				       /**************************
				        * delete sro  by leo.ham
				        **************************/

				}
				stocktran.updateRequestTransfer(dmap);

			}
		}
	}

	@Override
	public void deleteStoNo(Map<String, Object> params) {

		String reqstono = (String) params.get("reqstono");
		logger.info(" reqstono ???? : {}", params.get("reqstono"));
		if(!"".equals(reqstono) || null != reqstono){
			stocktran.updateStockHead(reqstono);
			stocktran.deleteStockDelete(reqstono);
			stocktran.deleteStockBooking(reqstono);
		}
	}

	@Override
	public int selectDelNo(Map<String, Object> params) {
		int delchk =0;
		String reqstono = (String) params.get("reqstono");
		logger.info(" reqstono ???? : {}", params.get("reqstono"));
		if(!"".equals(reqstono) || null != reqstono){
			delchk = stocktran.selectdeliveryHead(reqstono);

		}

		return delchk;
	}

	@Override
	public String selectMaxQtyCheck(Map<String, Object> param) {
		// TODO Auto-generated method stub
		String reChk = "";

		Map<String, Object> map = new HashMap();
		map.put("itmcd", param.get("itmcd"));
		map.put("tlocation", param.get("reqloc"));
		map.put("rqty", param.get("delyqty"));
		int iCnt = stocktran.selectAvaliableStockQty(map);

		logger.debug( " 486 Line ::::: " + iCnt);
		if (iCnt == 1 ){
			reChk = "N";
		}else{
			reChk = "Y";
		}
		return reChk;
	}


	@Override
	public Map<String, Object> selectDelvryGRcmplt(String delyno) {
		// TODO Auto-generated method stub
		return stocktran.selectDelvryGRcmplt(delyno);
	}

	@Override
	public String selectDefLocation(Map<String, Object> param) {

		return stocktran.selectDefLocation(param);

	}

	@Override
	public String defLoc(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<EgovMap> selectStoIssuePop(Map<String, Object> params) throws Exception{
		return stocktran.selectStoIssuePop(params);
	}

	@Override
	public String StockTransferDeliveryIssueNew(Map<String, Object> params, SessionVO sessionVo) throws Exception{
		String reVal = "";
		String delyCd = "";
		delyCd = (String)params.get("zDelvryNo");
		//logger.info(" map:::!!! ??: {}", params);

		String[] delvcd = {delyCd};
		params.put("parray", delvcd);
		params.put("zRstNo", "");
		params.put("salesorder", "");
		params.put("gtype", (String)params.get("zGtype"));
		params.put("delyno", delyCd);

		stocktran.stockTransferiSsueNew(params);

		reVal = (String) params.get("rdata");
		String[] returnValue = reVal.split("∈");

		if( returnValue == null || StringUtils.isEmpty(returnValue[0]) || !"000".equals(StringUtils.trimToEmpty(returnValue[0])) ){
			throw new ApplicationException(AppConstants.FAIL, returnValue[1]);
		}

		stocktran.updateDelivery54(params);

		// serial Save
		params.put("dryNo", delyCd);
		params.put("sGrDate", (String)params.get("sGiptdate"));
		serialMgmtNewService.saveSerialCode(params, sessionVo);

		if( !"000".equals( StringUtils.trimToEmpty((String)params.get("errCode")) ) ){
			throw new ApplicationException(AppConstants.FAIL, StringUtils.trimToEmpty((String)params.get("errMsg")));
		}

		return returnValue[1];
	}

	// STO - new Serial scan Cancel.  KR-Jin
	private void stockSerialReverse(Map<String, Object> params) throws Exception {
		List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		String delCd = "";
		if (checklist.size() > 0) {
			for (int i = 0; i < checklist.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checklist.get(i);

				Map<String, Object> imap = new HashMap();
				imap = (Map<String, Object>) map.get("item");
				if("Y".equals((String)imap.get("rcvSerialRequireChkYn"))){
					if( !delCd.equals(imap.get("delyno")) ){
						imap.put("updUserId", params.get("userId"));
						imap.put("zTrnscType", "US");
						imap.put("zIoType", "O");
						serialMgmtNewService.reverseSerialCode(imap);
					}
					delCd = (String)imap.get("delyno");
				}

			}
		}

	}

	/**
	 * Search Good Receipt Popup List
	 * @Author KR-SH
	 * @Date 2019. 12. 5.
	 * @param params
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.logistics.stocktransfer.StockTransferService#goodReceiptPopList(java.util.Map)
	 */
	@Override
	public List<EgovMap> goodReceiptPopList(Map<String, Object> params) throws Exception {
		return stocktran.goodReceiptPopList(params);
	}

	/**
	 * Save Good Receipt Popup List
	 * @Author KR-SH
	 * @Date 2019. 12. 6.
	 * @param params
	 * @return
	 * @throws Exception
	 * @see com.coway.trust.biz.logistics.stocktransfer.StockTransferService#StockTransferDeliveryIssueSerial(java.util.Map)
	 */
	@Override
	public ReturnMessage StockTransferDeliveryIssueSerial(Map<String, Object> params, SessionVO sessionVo) throws Exception {
		ReturnMessage rtnMsg = new ReturnMessage();

		stocktran.stockTransferiSsueNew(params);

		String reVal = CommonUtils.nvl(params.get("rdata"));
		String[] returnValue = reVal.split("∈");
		String rstNo = CommonUtils.nvl(returnValue[1]);

		if( returnValue == null || StringUtils.isEmpty(returnValue[0]) || !"000".equals(StringUtils.trimToEmpty(returnValue[0])) ){
			throw new ApplicationException(AppConstants.FAIL, rstNo);
		}
		stocktran.updateDelivery54(params);

		// serial Save
		serialMgmtNewService.saveSerialCode(params, sessionVo);

		if( !"000".equals(StringUtils.trimToEmpty(CommonUtils.nvl(params.get("errCode"))))){
			throw new ApplicationException(AppConstants.FAIL, StringUtils.trimToEmpty(CommonUtils.nvl(params.get("errMsg"))));
		}

		rtnMsg.setCode(AppConstants.SUCCESS);
		rtnMsg.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		rtnMsg.setData(rstNo);

		return rtnMsg;
	}

}

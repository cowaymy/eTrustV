package com.coway.trust.biz.logistics.inbound.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.inbound.InboundService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("inboundService")
public class InboundServiceImple extends EgovAbstractServiceImpl implements InboundService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "inboundMapper")
	private InboundMapper inboundMapper;

	@Override
	public List<EgovMap> inBoundList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.inBoundList(params);
	}

	@Override
	public List<EgovMap> inboundLocation(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.inboundLocation(params);
	}

	@Override
	public List<EgovMap> receiptList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.receiptList(params);
	}

	@Override
	public List<EgovMap> inboundLocationPort(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.inboundLocationPort(params);
	}

	@Override
	public Map<String, Object> reqSTO(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		boolean dupCheck = true;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) checkList.get(i);

				Map<String, Object> setMap = new HashMap();
				setMap = (Map<String, Object>) map.get("item");
				logger.info("item : {} ", map.get("item"));
				logger.info("blNo : {} ", setMap.get("blNo"));
				logger.info("itmSeq : {} ", setMap.get("itmSeq"));
				logger.info("matrlNo : {} ", setMap.get("matrlNo"));
				logger.info("qty : {} ", setMap.get("qty"));
				logger.info("reqQty : {} ", setMap.get("reqQty"));

				List<EgovMap> list = inboundMapper.selectDeliverydupCheck(setMap);
				logger.info("list : {} ", list.toString());
				logger.info(" list.size : {}", list.size());
				String ttmp1 = (String) setMap.get("blNo");
				int ttmp2 = (int) setMap.get("itmSeq");
				String ttmp3 = (String) setMap.get("matrlNo");
				int ttmp4 = (int) setMap.get("qty");
				int ttmp5 = (int) setMap.get("reqQty");
				logger.info(" ttmp1 :ttmp2 : ttmp3 : ttmp4 : ttmp5 {} : {} : {} : {} :{}", ttmp1, ttmp2, ttmp3, ttmp4,
						ttmp5);
				if (list.size() > 0) {
					Map<String, Object> checkmap = null;
					checkmap = list.get(0);
					String tmp1 = (String) checkmap.get("blNo");
					Integer count = ((BigDecimal) checkmap.get("blItmSeq")).intValueExact();
					int tmp2 = count;
					String tmp3 = (String) checkmap.get("itmCode");
					// int tmp3 = 1;
					Integer count2 = ((BigDecimal) checkmap.get("reqstQty")).intValueExact();
					int tmp4 = count2;

					logger.info(" tmp1 :tmp2 : tmp3 : tmp3 {} : {} : {} : {}", tmp1, tmp2, tmp3, tmp4);
					if (ttmp1.equals(tmp1) && ttmp2 == tmp2 && ttmp3.equals(tmp3) && (ttmp5 + tmp4) > ttmp4) {
						dupCheck = false;
					}
				}
			}
		}
		Map<String, Object> reMap = new HashMap();
		if (dupCheck) {
			/* 2017-11-30 김덕호 위원 채번 변경 요청 */
			// String seq = inboundMapper.selectStockTransferSeq();
			// String reqNo = "SMO" + seq;
			String reqNo = inboundMapper.selectStockTransferSeq();

			formMap.put("reqNo", reqNo);
			formMap.put("userId", params.get("userId"));

			inboundMapper.CreateReqM(formMap);

			if (checkList.size() > 0) {
				for (int i = 0; i < checkList.size(); i++) {
					Map<String, Object> map = (Map<String, Object>) checkList.get(i);

					Map<String, Object> setMap = new HashMap();
					setMap = (Map<String, Object>) map.get("item");
					setMap.put("reqNo", reqNo);
					setMap.put("userId", params.get("userId"));
					inboundMapper.CreateReqD(setMap);
				}
			}
			String deliveryNo = inboundMapper.selectDeliverySeq();
			formMap.put("reqNo", reqNo);
			formMap.put("deliveryNo", deliveryNo);
			inboundMapper.CreateDeliveryM(formMap);

			List<EgovMap> delList = inboundMapper.selectDeliveryList(formMap);
			logger.info("delList : {} ", delList.toString());
			if (delList.size() > 0) {
				for (int i = 0; i < delList.size(); i++) {

					Map<String, Object> setMap = delList.get(i);
					logger.info("setMap : {} ", setMap);
					setMap.put("deliveryNo", deliveryNo);
					setMap.put("userId", params.get("userId"));
					inboundMapper.CreateDeliveryD(setMap);
				}
			}
			inboundMapper.updateReqStatus(reqNo);

			String[] delvcd = { deliveryNo };

			formMap.put("parray", delvcd);
			formMap.put("userId", params.get("userId"));
			// formMap.put("prgnm", params.get("prgnm"));
			formMap.put("refdocno", "");
			formMap.put("salesorder", "");

			inboundMapper.CreateIssue(formMap);
			reMap.put("reqNo", reqNo);
			reMap.put("deliveryNo", deliveryNo);

		} else {
			reMap.put("reqNo", "dup");
			reMap.put("deliveryNo", "dup");
		}
		/* 2017-11-30 김덕호 위원 채번 변경 요청 */
		// String seq = inboundMapper.selectStockTransferSeq();
		// String reqNo = "SMO" + seq;
		/*
		 * String reqNo = inboundMapper.selectStockTransferSeq();
		 *
		 * formMap.put("reqNo", reqNo); formMap.put("userId", params.get("userId"));
		 *
		 * inboundMapper.CreateReqM(formMap);
		 *
		 * if (checkList.size() > 0) { for (int i = 0; i < checkList.size(); i++) { Map<String, Object> map =
		 * (Map<String, Object>) checkList.get(i);
		 *
		 * Map<String, Object> setMap = new HashMap(); setMap = (Map<String, Object>) map.get("item");
		 * setMap.put("reqNo", reqNo); setMap.put("userId", params.get("userId")); inboundMapper.CreateReqD(setMap); } }
		 * String deliveryNo = inboundMapper.selectDeliverySeq(); formMap.put("reqNo", reqNo); formMap.put("deliveryNo",
		 * deliveryNo); inboundMapper.CreateDeliveryM(formMap);
		 *
		 * List<EgovMap> delList = inboundMapper.selectDeliveryList(formMap); logger.info("delList : {} ",
		 * delList.toString()); if (delList.size() > 0) { for (int i = 0; i < delList.size(); i++) {
		 *
		 * Map<String, Object> setMap = delList.get(i); logger.info("setMap : {} ", setMap); setMap.put("deliveryNo",
		 * deliveryNo); setMap.put("userId", params.get("userId")); inboundMapper.CreateDeliveryD(setMap); } }
		 * inboundMapper.updateReqStatus(reqNo);
		 *
		 * String[] delvcd = { deliveryNo };
		 *
		 * formMap.put("parray", delvcd); formMap.put("userId", params.get("userId")); // formMap.put("prgnm",
		 * params.get("prgnm")); formMap.put("refdocno", ""); formMap.put("salesorder", "");
		 *
		 * inboundMapper.CreateIssue(formMap);
		 *
		 * Map<String, Object> reMap = new HashMap(); reMap.put("reqNo", reqNo); reMap.put("deliveryNo", deliveryNo);
		 */
		return reMap;
	}

	@Override
	public List<EgovMap> searchSMO(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return inboundMapper.searchSMO(params);
	}

	@Override
	public void receipt(Map<String, Object> params) {
		List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

		String delyCd = "";
		if (checklist.size() > 0) {
			Map<String, Object> map = (Map<String, Object>) checklist.get(0);
			Map<String, Object> imap = new HashMap();
			imap = (Map<String, Object>) map.get("item");
			delyCd = (String) imap.get("delyno");
		}

		// String[] delvcd = delyCd.split("∈");
		String[] delvcd = new String[1];
		delvcd[0] = delyCd;
		formMap.put("parray", delvcd);
		formMap.put("userId", params.get("userId"));
		// formMap.put("prgnm", params.get("prgnm"));
		formMap.put("refdocno", "");
		formMap.put("salesorder", "");

		inboundMapper.CreateIssue(formMap);

		if (serialList.size() > 0) {

			for (int j = 0; j < serialList.size(); j++) {

				Map<String, Object> insSerial = null;

				insSerial = (Map<String, Object>) serialList.get(j);

				insSerial.put("delno", delyCd);
				insSerial.put("userId", params.get("userId"));
				inboundMapper.insertLocSerial(insSerial);
			}
		}
	}

	// KR HAN
	  @SuppressWarnings("unchecked")
	  @Override
		public Map<String, Object> receiptSerial(Map<String, Object> params) {

//			List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
//			Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
//			List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

		    Map<String, Object> gridList = (Map<String, Object>) params.get("gridList");
			List<Object> serialGridList = (List<Object>)gridList.get(AppConstants.AUIGRID_ALL);

//			System.out.println("++++ params.toString() ::" + params.toString() );
//			System.out.println("++++ gridList.toString() ::" + gridList.toString() );
//			System.out.println("++++ serialGridList.toString() ::" + serialGridList.toString() );


		    int iCnt = 0;
		    String tmpdelCd = "";
		    String delyCd = "";
		    String delyno = "";

		    if (serialGridList.size() > 0) {
		      for (int i = 0; i < serialGridList.size(); i++) {
		        Map<String, Object> map = (Map<String, Object>) serialGridList.get(i);

		        String delCd = (String) map.get("delvryNo");
		        delyno = (String) map.get("delvryNo");

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
		    logger.info(" delyCd : {}", delyCd);

		    // 유효성 체크

		    // SP_LOGISTIC_DELIVERY_SERIAL 호출
		    String[] delvcd = delyCd.split("∈");

	        params.put("parray", delvcd);
	        params.put("refdocno", "");
	        params.put("salesorder", "");

	        params.put("giptdate", params.get("zGrptdate"));
	        params.put("gipfdate", params.get("zGrpfdate"));
	        params.put("doctext", params.get("zDoctext"));
	        params.put("gtype", params.get("ztype"));

	        logger.debug("**** receiptSerial params ::" + params.toString()  );

	        inboundMapper.CreateIssueSerial(params);

	        String reVal = (String) params.get("rdata");

	        String returnValue[] = reVal.split("∈");

	        logger.debug(" **** receiptSerial [" + returnValue[0]+ "]");
	        logger.debug(" **** receiptSerial [" + returnValue[1]+ "]");

	    	if(!"000".equals(returnValue[0])){
	 		    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + returnValue[0]+ ":" + returnValue[1]);
	 	    }

	    	// SP_LOGISTIC_BARCODE_SAVE 호출
	    	Map<String, Object> barcodeParams = new HashMap<String, Object>();

	    	barcodeParams.put("sGrDate"		, params.get("zGrptdate"));
	    	barcodeParams.put("rstNo"			, "");
	    	barcodeParams.put("dryNo"		, params.get("zDelyNo"));
	    	barcodeParams.put("zTrnscType"	, "UM");
	    	barcodeParams.put("zIoType"		, "I");
	    	barcodeParams.put("updUserId"	, params.get("userId"));

	    	 inboundMapper.callSaveBarcodeScan(barcodeParams);

	        String errCode = (String)barcodeParams.get("errCode");
	  	    String errMsg = (String)barcodeParams.get("errMsg");

	     	logger.debug(">>>>>>>>>>>ERROR CODE : " + errCode);
	  	    logger.debug(">>>>>>>>>>>ERROR MSG: " + errMsg);
	  	  barcodeParams.put("errCode", errCode);
	  	  barcodeParams.put("errMsg", errMsg);
	  	  barcodeParams.put("mdnNo", returnValue[1]);

	  	    // pErrcode : 000  = Success, others = Fail
	  	    if(!"000".equals(errCode)){
	  		    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
	  	    }

	  	  return barcodeParams;
		}
}

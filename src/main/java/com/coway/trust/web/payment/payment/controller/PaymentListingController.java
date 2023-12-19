package com.coway.trust.web.payment.payment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

@Controller
@RequestMapping(value = "/payment")
public class PaymentListingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PaymentListingController.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "accessMonitoringService")
	private AccessMonitoringService accessMonitoringService;

	/******************************************************
	 * Payment Listing
	 *****************************************************/
	/**
	 * Payment Listing 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initPaymentListing.do")
	public String initPaymentListing(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/payment/paymentListing";
	}


	/**
     * Payment Listing - 크리스탈 레포트 호출
     * @param params
     * @param model
     * @return
     * @RequestParam Map<String, Object> params
     */
    @RequestMapping(value = "/generateReportParam.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> generateReportParam(@RequestBody Map<String, Object> params,
    		Model model,  HttpServletRequest request) {

    	LOGGER.debug("params : {}",params);

    	//Log down user search params
    	SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
    	requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/initPaymentListing.do/");
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

    	//레포트 표지에 보여질 데이터
    	String showPaymentDate = "";
    	String showKeyInBranch = "";
    	String showBatchID = "";
    	String showReceiptNo = "";
    	String showTRNo = "";
    	String showKeyInUser = "";

    	//쿼리 조건절
    	String whereSQL = "";
    	int runNo = 0;

    	if(!"".equals(String.valueOf(params.get("payDate1"))) &&  !"".equals(String.valueOf(params.get("payDate2")))){
    		whereSQL += " AND pm.CRT_DT  >= TO_DATE(TO_CHAR(TO_DATE('" + params.get("payDate1") + "','DD/MM/YYYY'),'YYYYMMDD') || '000000','yyyymmddhh24miss')";
    		whereSQL += " AND pm.CRT_DT  < TO_DATE(TO_CHAR(TO_DATE('" + params.get("payDate2") + "','DD/MM/YYYY'),'YYYYMMDD') || '000000','yyyymmddhh24miss') + 1";

    		showPaymentDate = params.get("payDate1") + " To " + params.get("payDate2");
    	}

    	if(!"".equals(String.valueOf(params.get("branchId")))){
    		whereSQL += " AND pm.BRNCH_ID  = " + params.get("branchId");
    		showKeyInBranch = String.valueOf(params.get("branchName"));
    	}

    	if("2".equals(String.valueOf(params.get("paymentType")))){
    		// 화면에서 같은 이름으로 파라미터를 넘기는 경우 처리.
    		List<String> paymentItems = (List<String>) params.get("paymentItem");
    		List<String> payTypeList = new ArrayList<String>();

    		if(paymentItems != null && paymentItems.size() > 0){
    			for (String classId : paymentItems) {
    				this.getPayType(classId,payTypeList);
    			}
    		}

    		if(payTypeList.size() > 0){
    			whereSQL += " AND pm.TYPE_ID IN (";
    			for (String typeId : payTypeList) {
    				  if (runNo > 0){
    					  whereSQL += "," + typeId;
    				  }else{
                    	  whereSQL += typeId;
    				  }
    				  runNo = runNo + 1;
    			}
    			whereSQL += ") ";
    		}

    		if(paymentItems != null && paymentItems.size() > 0){
    			if (paymentItems.size() > 1){
    				if (!paymentItems.contains("1308")){
    					whereSQL += " AND (pm.SVC_CNTRCT_ID = 0 OR pm.SVC_CNTRCT_ID IS NULL)  ";
    				}
    			} else {
    				if (!"1308".equals(paymentItems.get(0))){
    					whereSQL += " AND (pm.SVC_CNTRCT_ID = 0 OR pm.SVC_CNTRCT_ID IS NULL) ";
    				}else if ("1308".equals(paymentItems.get(0))){
    					whereSQL += " AND pm.SVC_CNTRCT_ID <> 0 ";
    				}
    			}

				if (!paymentItems.contains("223")){
					whereSQL += " ";
				}
			 else {
				if (!"223".equals(paymentItems.get(0))){
					whereSQL += " ";
				}else if ("223".equals(paymentItems.get(0))){
					whereSQL += " AND bill1.BILL_SO_ID NOT IN (SELECT SRV_ORD_ID FROM SAL0225D) ";
				}
			}
    		}

         }

    	if(!"".equals(String.valueOf(params.get("batchId")))){
    		showBatchID = String.valueOf(params.get("batchId"));

    		if ("Payment".equals(String.valueOf(params.get("batchType")))){
    			whereSQL += " AND pm.BATCH_PAY_ID = '" + params.get("batchId") + "' ";
            } else {
            	whereSQL += " AND brd.BATCH_ID = '" + params.get("batchId") + "' ";
            }
    	}

    	if(!"".equals(String.valueOf(params.get("receiptNoFr"))) && !"".equals(String.valueOf(params.get("receiptNoTo")))){
        	showReceiptNo = params.get("receiptNoFr") + " To " + params.get("receiptNoTo");
        	whereSQL += "AND (pm.OR_NO BETWEEN '" + params.get("receiptNoFr") + "' AND '" + params.get("receiptNoTo") + "') ";
        }

        if (!"".equals(String.valueOf(params.get("trNoFr"))) && !"".equals(String.valueOf(params.get("trNoTo")))) {
            showTRNo = params.get("trNoFr") + " To " + params.get("trNoTo");
            whereSQL += "AND (pm.TR_NO BETWEEN '" + params.get("trNoFr") + "' AND '" + params.get("trNoTo") + "') ";
        }

        if (!"".equals(String.valueOf(params.get("collector")))) {
        	whereSQL += " AND m.MEM_CODE = '" + params.get("collector") + "' ";
        }

        if (!"".equals(String.valueOf(params.get("userId")))) {
            showKeyInUser = String.valueOf(params.get("userNm"));
            whereSQL += "AND pm.CRT_USER_ID = " + params.get("userId") + " ";
        }

    	//결과 데이터 만들기
    	Map<String, Object> returnMap = new HashMap<String,Object>();
    	returnMap.put("showPaymentDate", showPaymentDate);
    	returnMap.put("showKeyInBranch", showKeyInBranch);
    	returnMap.put("showBatchID", showBatchID);
    	returnMap.put("showReceiptNo", showReceiptNo);
    	returnMap.put("showTRNo", showTRNo);
    	returnMap.put("showKeyInUser", showKeyInUser);
    	returnMap.put("docVal", String.valueOf(params.get("docVal")));
    	returnMap.put("whereSQL", whereSQL);

        // 결과 만들기.
        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(returnMap);
        message.setMessage("Saved Successfully");

        return ResponseEntity.ok(message);
    }



    /**
     * Type ID 세팅
     * @param classID
     * @param payTypeList
     */
    private void getPayType(String classID, List<String> payTypeList) {
        switch (classID)
        {
            case "239":
                payTypeList.add("90");
                payTypeList.add("91");
                payTypeList.add("92");
                payTypeList.add("94");
                payTypeList.add("96");
                payTypeList.add("97");
                payTypeList.add("98");
                payTypeList.add("99");
                payTypeList.add("1032");
                payTypeList.add("1059");
                break;
            case "104":
                payTypeList.add("104");
                break;
            case "222":
                payTypeList.add("222");
                payTypeList.add("224");
                payTypeList.add("225");
                payTypeList.add("226");
                break;
            case "102":
                payTypeList.add("102");
                break;
            case "223":
                payTypeList.add("228");
                payTypeList.add("229");
                payTypeList.add("230");
                payTypeList.add("231");
                payTypeList.add("232");
                payTypeList.add("233");
                payTypeList.add("234");
                payTypeList.add("235");
                payTypeList.add("316");
                payTypeList.add("541");
                break;
            case "238":
                payTypeList.add("93");
                payTypeList.add("103");
                break;
            case "577":
                payTypeList.add("577");
                payTypeList.add("569");
                break;
            case "101":
                payTypeList.add("101");
                break;
            case "1308":
                payTypeList.add("1308"); //Rental
                payTypeList.add("1309"); //Penalty
                payTypeList.add("1310"); //1st BS
                payTypeList.add("91"); //Adv 1y
                payTypeList.add("92"); //Adv 2y
                payTypeList.add("1032"); //AdvS
                break;
            default:
                break;
        }
    }
}

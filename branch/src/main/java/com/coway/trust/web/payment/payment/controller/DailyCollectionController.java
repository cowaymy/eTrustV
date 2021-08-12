package com.coway.trust.web.payment.payment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.payment.billing.service.BillingMgmtService;
import com.coway.trust.biz.payment.payment.service.DailyCollectionService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.web.common.excel.download.ExcelDownloadFormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;
import com.coway.trust.web.payment.billing.controller.BillingMgmtController;

@Controller
@RequestMapping(value = "/payment")
public class DailyCollectionController {

	private static final Logger LOGGER = LoggerFactory.getLogger(DailyCollectionController.class);

	@Resource(name = "dailyCollectionService")
	private DailyCollectionService dailyCollectionService;

	@Autowired
	private LargeExcelService largeExcelService;

	/******************************************************
	 * Daily Collection Raw
	 *****************************************************/
	/**
	 * Daily Collection Raw 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initDailyCollection.do")
	public String initDailyCollection(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/payment/dailyCollectionRaw";
	}


	/**
	 * Daily Collection  카운트 조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/countDailyCollectionData.do")
	public ResponseEntity<Integer> countDailyCollectionData(@RequestParam Map<String, Object> params, ModelMap model) {

		int cnt = dailyCollectionService.countDailyCollectionData(params);
		return ResponseEntity.ok(cnt);
	}



	@RequestMapping(value = "/selectDailyCollectionData.do")
	public void selectDailyCollectionData(HttpServletRequest request, HttpServletResponse response) {

		ExcelDownloadHandler downloadHandler = null;

		try {

            Map<String, Object> map = new HashMap<String, Object>();
    		map.put("payDateFr", request.getParameter("payDateFr") == null ? "01/01/1900" :  request.getParameter("payDateFr"));
    		map.put("payDateTo", request.getParameter("payDateTo") == null ? "01/01/1900" :  request.getParameter("payDateTo"));

    		String[] columns;
            String[] titles;

            columns = new String[] {"receiptno","orderno","trxDate","name","bankAcc","debtCode","branchcode","payitemappvno","payitemchqno",
            		"username","description","cardmode","payitemamt","payitemremark","fpayitemccno","paymode","trNo","refNo","refDtl","crcmode",
            		"crctype","payitemccholdername","payitemccexpirydate","refdate","keyinby","issuedbank","deptcode","orderstatus",
            		"custvano","bankChgAmt","advancemth","runningno","cardtype","pvMonth","pvYear","crcStatementNo","crcStatus",
            		"crcStatementRemark","custcategory","custtype","transId","ordCrtDt","keyInScrn","paymentcollector","batchPayId","crcStateId"};

            titles = new String[] {"RECEIPTNO","ORDERNO","TRX_DATE","NAME","BANK_ACC","DEBT_CODE","BRANCHCODE","PAYITEMAPPVNO","PAYITEMCHQNO","USERNAME",
            		"DESCRIPTION","CARD_MODE","PAYITEMAMT","PAYITEMREMARK","FPAYITEMCCNO","PAYMODE","TR_NO","REF_NO","REF_DTL","CRCMODE","CRCTYPE","PAYITEMCCHOLDERNAME",
            		"PAYITEMCCEXPIRYDATE","REFDATE","KEYINBY","ISSUEDBANK","DEPTCODE","ORDERSTATUS","CUSTVANO","BANK_CHG_AMT","ADVANCEMTH",
            		"RUNNINGNO","CARDTYPE","PV_MONTH","PV_YEAR","CRC_STATEMENT_NO","CRC_STATUS","CRC_STATEMENT_REMARK","CustCategory","CustType","TRANS_ID",
            		"ORD_CRT_DT" ,"KEY IN SCRN" ,"PAYMENTCOLLECTOR" ,"BATCH_PAY_ID", "CRC STATE ID"};


			downloadHandler = getExcelDownloadHandler(response, "DailyCollectionRawData.xlsx", columns, titles);
			largeExcelService.downloadDailyCollectionRawData(map, downloadHandler);

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}
	}

	private ExcelDownloadHandler getExcelDownloadHandler(HttpServletResponse response, String fileName,
			String[] columns, String[] titles) {
		ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(fileName, columns, titles);
		return new ExcelDownloadHandler(excelDownloadVO, response);
	}

}

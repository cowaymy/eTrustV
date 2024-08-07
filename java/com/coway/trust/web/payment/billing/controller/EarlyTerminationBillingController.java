package com.coway.trust.web.payment.billing.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billing.service.EarlyTerminationBillingService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/payment")
public class EarlyTerminationBillingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EarlyTerminationBillingController.class);

	@Resource(name = "earlyTerminationService")
	private EarlyTerminationBillingService earlyTerminationService;

	/**
	 * BillingMgnt 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initEarlyTermination.do")
	public String initBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/billPenalty";
	}

	@RequestMapping(value = "/checkExistOrderCancellationList.do")
	public ResponseEntity<Boolean> checkExistOrderCancellationList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		boolean value= false;

		LOGGER.debug("params : {}", params);

		int val = earlyTerminationService.selectExistOrderCancellationList(String.valueOf(params.get("orderId")));

		if(val > 0)
			value = true;

		return ResponseEntity.ok(value);
	}

	@RequestMapping(value = "/checkExistPenaltyBill.do")
	public ResponseEntity<Boolean> checkExistPenaltyBill(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		boolean value= false;

		LOGGER.debug("params : {}", params);

		int val = earlyTerminationService.selectCheckExistPenaltyBill(String.valueOf(params.get("orderId")));

		if(val > 0)
			value = true;

		return ResponseEntity.ok(value);
	}

	@RequestMapping(value = "/selectRentalProductEarlyTerminationPenalty.do")
	public ResponseEntity<EgovMap> selectRentalProductEarlyTerminationPenalty(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap result = null;

		LOGGER.debug("params : {}", params);
		List<EgovMap> list = earlyTerminationService.selectRentalProductEarlyTerminationPenalty(String.valueOf(params.get("orderId")));
		if(list.size()>0){
			result = list.get(0);
		}

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/createBillsForEarlyTermination.do")
	public ResponseEntity<Map<String, Object>> createBillsForEarlyTermination(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("params : {}", params);

		Map<String, Object> result = new HashMap<String, Object>();
		String message = "";

		int userId = sessionVO.getUserId();

		if(userId > 0){
			List<EgovMap> list = earlyTerminationService.selectRentalProductEarlyTerminationPenalty(String.valueOf(params.get("orderId")));
			Date curdate = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			Map<String, Object> ledger = new HashMap<String, Object>();
			ledger.put("rentId", 0);
			ledger.put("rentSoId", String.valueOf(params.get("orderId")));
			ledger.put("rentDocNo", "");
			ledger.put("rentDocTypeId", 1015);
			ledger.put("rentDateTime", sdf.format(curdate));
			ledger.put("rentAmount", String.valueOf(params.get("amount")));
			ledger.put("rentBatchNo", "");
			ledger.put("rentInstNo", 0);
			ledger.put("rentUpdateBy", userId);
			ledger.put("rentUpdateAt", sdf.format(curdate));
			ledger.put("rentIsSync", false);
			ledger.put("rentBillRunningTotal", 0);
			ledger.put("rentRunId", 0);

			Map<String, Object> orderbill = new HashMap<String, Object>();
			orderbill.put("accBillTaskId", 0);
			orderbill.put("accBillRefDate", sdf.format(curdate));
			orderbill.put("accBillRefNo", "1000");
			orderbill.put("accBillOrderId", String.valueOf(params.get("orderId")));
			orderbill.put("accBillOrderNo", String.valueOf(params.get("orderNo")));
			orderbill.put("accbillTypeId", 1159);
			orderbill.put("accBillModeId", 1172);
			orderbill.put("accBillScheduleId", 0);
			orderbill.put("accBillSchedulePeriod", 0);
			orderbill.put("accBillAdjustmentId", 0);
			orderbill.put("accBillScheduleAmout", String.valueOf(params.get("amount")));
			orderbill.put("accBillAdjustmentAmount", 0);
			orderbill.put("accBillTaxesAmount", list.get(0).get("pnaltyTaxAmt"));
			orderbill.put("accBillNetAmount", String.valueOf(params.get("amount")));
			orderbill.put("accBillStatus", 1);
			orderbill.put("accBillRemark", "");
			orderbill.put("accBillCreateAt", sdf.format(curdate));
			orderbill.put("accBillCreateBy", userId);
			orderbill.put("accBillGroupId", 0);
			orderbill.put("accBillTaxRate", list.get(0).get("pnaltyTaxRate"));
			//orderbill.put("accBillTaxCodeId", Integer.parseInt(String.valueOf(list.get(0).get("pnaltyTaxRate"))) > 0 ? 32 : 28); -- Edited By TPY 28/5/2018
			orderbill.put("accBillTaxCodeId", Integer.parseInt(String.valueOf(list.get(0).get("pnaltyTaxCode"))));

			Map<String, Object> invoiceM = new HashMap<String, Object>();
			invoiceM.put("taxInvoiceRefNo", "");
			invoiceM.put("taxInvoiceRefDate", sdf.format(curdate));
			invoiceM.put("taxInvoiceServiceNo", list.get(0).get("soReqNo"));
			invoiceM.put("taxInvoiceType", 125);
			invoiceM.put("taxInvoiceCustName", list.get(0).get("custName"));
			invoiceM.put("taxInvoiceContactPerson", list.get(0).get("contactname"));
			invoiceM.put("taxInvoiceAddress1", list.get(0).get("add1"));
			invoiceM.put("taxInvoiceAddress2", list.get(0).get("add2"));
			invoiceM.put("taxInvoiceAddress3", list.get(0).get("add3"));
			invoiceM.put("taxInvoiceAddress4", list.get(0).get("sarea"));
			invoiceM.put("taxInvoicePostCode", list.get(0).get("spostCode"));
			invoiceM.put("taxInvoiceStateName", list.get(0).get("sstate"));
			invoiceM.put("taxInvoiceCountry", list.get(0).get("scountry"));
			invoiceM.put("taxInvoiceTaskId", 0);
			invoiceM.put("taxInvoiceRemark", String.valueOf(params.get("remark")));
			invoiceM.put("taxInvoiceCharges", list.get(0).get("pnaltyChrg"));
			invoiceM.put("taxInvoiceTaxes", list.get(0).get("pnaltyTaxAmt"));
			invoiceM.put("taxInvoiceAmountDue", String.valueOf(params.get("amount")));
			invoiceM.put("taxInvoiceCreated", sdf.format(curdate));
			invoiceM.put("taxInvoiceCreator", userId);

			Map<String, Object> invoiceD = new HashMap<String, Object>();
			invoiceD.put("taxInvoiceId", 0);
			invoiceD.put("invoiceItemType", 1276);
			invoiceD.put("invoiceItemOrderNo", String.valueOf(params.get("orderNo")));
			invoiceD.put("invoiceItemPoNo", "");
			invoiceD.put("invoiceItemCode", list.get(0).get("stkCode"));
			invoiceD.put("invoiceItemDescription1", list.get(0).get("stkDesc"));
			invoiceD.put("invoiceItemDescription2", "");
			invoiceD.put("invoiceItemSerialNo", list.get(0).get("serialNo"));
			invoiceD.put("invoiceItemQuantity", 1);
			invoiceD.put("invoiceItemGSTTaxes", list.get(0).get("pnaltyTaxAmt"));
			invoiceD.put("invoiceItemGSTRate", list.get(0).get("pnaltyTaxRate"));
			invoiceD.put("invoiceItemCharges", list.get(0).get("pnaltyChrg"));
			invoiceD.put("invoiceItemAmountDue", String.valueOf(params.get("amount")));
			invoiceD.put("invoiceItemAdd1", list.get(0).get("add1"));
			invoiceD.put("invoiceItemAdd2", list.get(0).get("add2"));
			invoiceD.put("invoiceItemAdd3", list.get(0).get("add3"));
			invoiceD.put("invoiceItemPostCode", list.get(0).get("installPostcode"));
			invoiceD.put("invoiceItemStateName", list.get(0).get("installState"));
			invoiceD.put("invoiceItemCountry", list.get(0).get("installCnty"));
			invoiceD.put("invoiceItemInstallDate", sdf.format(list.get(0).get("installDt")));

			String strInvoiceNo = earlyTerminationService.doSaveProductEarlyTerminationPenalty(ledger, orderbill, invoiceM, invoiceD);
			ledger.put("renDocNo", strInvoiceNo);

			if(!strInvoiceNo.equals("")) message = "Save Successfully";
			else message = "Failed To Save";

			result.put("data", ledger);
			result.put("message", message);

		}else{

		}

		return ResponseEntity.ok(result);
	}

}

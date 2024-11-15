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
import com.coway.trust.biz.payment.billing.service.ProductLostBillingService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/payment")
public class ProductLostBillingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProductLostBillingController.class);

	@Resource(name = "productLostService")
	private ProductLostBillingService productLostService;

	/**
	 * BillingMgnt 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initProductLost.do")
	public String initBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/billProductLost";
	}

	@RequestMapping(value = "/selectRentalProductLostPenalty.do")
	public ResponseEntity<EgovMap> checkExistOrderCancellationList(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap result = null;

		LOGGER.debug("params : {}", params);
		List<EgovMap> list = productLostService.selectRentalProductLostPenalty(String.valueOf(params.get("orderId")));
		if(list.size() > 0){
			result = list.get(0);
		}
		System.out.println("#####result : " + result);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/createBillForProductLost.do")
	public ResponseEntity<Map<String, Object>> createBillForProductLost(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		Map<String, Object> result = new HashMap<String, Object>();
		int userId = sessionVO.getUserId();

		LOGGER.debug("params : {}", params);

		if(userId > 0){

			String tmp = productLostService.getZRLocationId(String.valueOf(params.get("orderId")));
			int zRLocationId = tmp == null ? 0 : Integer.parseInt(tmp);
			String tmp2 = productLostService.getRSCertificateId(String.valueOf(params.get("orderId")));
			int rLCertificateId = tmp2 == null ? 0 : Integer.parseInt(tmp2);
			System.out.println("### zrId : " + zRLocationId + ", rLCertificateId : " + rLCertificateId);

			int taxCodeId = 0;
			int taxRate = 0;

			if(zRLocationId != 0){
				taxCodeId = 39;//ZR
				taxRate = 0;
			}else{
				if(rLCertificateId != 0){
					taxCodeId = 28; //RS
					taxRate = 0;
				}else{
					taxCodeId = 32;//SR
					taxRate = 0;
				}
			}

			Date curdate = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			EgovMap sch = productLostService.selectRentalProductLostPenalty(String.valueOf(params.get("orderId"))).get(0);

			Map<String, Object> ledger = new HashMap<String, Object>();
			ledger.put("rentId", 0);
			ledger.put("rentSoId", params.get("orderId"));
			ledger.put("rentDocNo", "");
			ledger.put("rentDocTypeId", 1016);
			ledger.put("rentDateTime", sdf.format(curdate));
			ledger.put("rentAmount", params.get("lossFee"));
			ledger.put("rentBatchNo", "");
			ledger.put("rentInstNo", 0);
			ledger.put("rendUpdateBy", userId);
			ledger.put("rentUpdateAt", sdf.format(curdate));
			ledger.put("rentIsSync", false);
			ledger.put("rentBillrunningTotal", 0);
			ledger.put("rentRunId", 0);

			Map<String, Object> orderbill = new HashMap<String, Object>();
			orderbill.put("accBillTaskId", 0);
			orderbill.put("accBillRefDate", sdf.format(curdate));
			orderbill.put("accBillRefNo", "1000");
			orderbill.put("accBillOrderId", params.get("orderId"));
			orderbill.put("accBillOrderNo", params.get("orderNo"));
			orderbill.put("accBillTypeId", 1159);
			orderbill.put("accBillModeId", 1273);
			orderbill.put("accBillScheduleId", 0);
			orderbill.put("accBillSchedulePeriod", 0);
			orderbill.put("accBillAdjustmentId", 0);
			orderbill.put("accBillScheduleAmount", params.get("lossFee"));
			orderbill.put("accBillAdjustmentAmount", 0);
			orderbill.put("accBillTaxesAmount", params.get("lossFee"));
			orderbill.put("accBillNetAmount", params.get("lossFee"));
			orderbill.put("accBillStatus", 1);
			orderbill.put("accBillRemark", ""); //InvoiceNo
			orderbill.put("accBillCreateAt", sdf.format(curdate));
			orderbill.put("accBillCreateBy", userId);
			orderbill.put("accBillGroupId", 0);
			orderbill.put("accBillTaxRate", taxRate);
			orderbill.put("accBillTaxCodeId", taxCodeId);

			Map<String, Object> invoiceM = new HashMap<String, Object>();
			invoiceM.put("taxInvoiceRefNo", "");
			invoiceM.put("taxInvoiceRefDate", sdf.format(curdate));
			invoiceM.put("taxInvoiceserviceNo", params.get("orderNo"));
			invoiceM.put("taxInvoiceType", 124);
			invoiceM.put("taxInvoiceCustName", sch.get("custName"));
			invoiceM.put("taxInvoiceContactPerson", sch.get("cntcName"));
			invoiceM.put("taxInvoiceAddress1", sch.get("add1"));
			invoiceM.put("taxInvoiceAddress2", sch.get("add2"));
			invoiceM.put("taxInvoiceAddress3", sch.get("add3"));
			invoiceM.put("taxInvoiceAddress4", sch.get("sarea"));
			invoiceM.put("taxInvoicePostCode", sch.get("spostCode"));
			invoiceM.put("taxInvoiceStateName", sch.get("sstate"));
			invoiceM.put("taxInvoiceCountry", sch.get("scountry"));
			invoiceM.put("taxInvoiceTaskId", 0);
			invoiceM.put("taxInvoiceRemark", params.get("remark"));
			if(taxRate >0){
				invoiceM.put("taxInvoiceCharges", (Integer.parseInt(String.valueOf(params.get("lossFee"))) * 100 / 106));
				invoiceM.put("taxInvoiceTaxes",
						Integer.parseInt(String.valueOf(params.get("lossFee")))-
						(Integer.parseInt(String.valueOf(params.get("lossFee"))) * 100 / 106));
				invoiceM.put("taxInvoiceAmoutDue", params.get("lossFee"));
			}else{
				invoiceM.put("taxInvoiceCharges", params.get("lossFee"));
				invoiceM.put("taxInvoiceTaxes", 0);
				invoiceM.put("taxInvoiceAmoutDue", params.get("lossFee"));
			}
			invoiceM.put("taxInvoiceCreated", sdf.format(curdate));
			invoiceM.put("taxInvoiceCreator", userId);

			Map<String, Object> invoiceD = new HashMap<String, Object>();
			invoiceD.put("taxInvoiceId", 0);
			invoiceD.put("invoiceItemType", 1274);
			invoiceD.put("invoiceItemOrderNo", params.get("orderNo"));
			invoiceD.put("invoiceItemPoNo", "");
			invoiceD.put("invoiceItemCode", sch.get("stkCode"));
			invoiceD.put("invoiceItemDescription1", sch.get("stkDesc"));
			invoiceD.put("invoiceItemDescription2", "");
			invoiceD.put("invoiceItemSerialNo", sch.get("serialNo"));
			invoiceD.put("invoiceItemQuantity", 1);
			invoiceD.put("invoiceItemGSTRate", taxRate);
			if(taxRate > 0){
				invoiceD.put("invoiceItemGSTTaxes",
						Integer.parseInt(String.valueOf(params.get("lossFee"))) -
						(Integer.parseInt(String.valueOf(params.get("lossFee"))) * 100 / 106));
				invoiceD.put("invoiceItemCharges", (Integer.parseInt(String.valueOf(params.get("lossFee"))) * 100 / 106));
				invoiceD.put("invoiceItemAmountDue", params.get("lossFee"));
			}else{
				invoiceD.put("invoiceItemGSTTaxes", params.get("lossFee"));
				invoiceD.put("invoiceItemCharges", 0);
				invoiceD.put("invoiceItemAmountDue", params.get("lossFee"));
			}
			invoiceD.put("invoiceItemAdd1", sch.get("add1"));
			invoiceD.put("invoiceItemAdd2", sch.get("add2"));
			invoiceD.put("invoiceItemAdd3", sch.get("add3"));
			invoiceD.put("invoiceItemPostCode", sch.get("installPostCode"));
			invoiceD.put("invoiceItemStateName", sch.get("installState"));
			invoiceD.put("invoiceItemCountry", sch.get("installCnty"));
			invoiceD.put("invoiceItemInstallDate", sdf.format(sch.get("installDt")));

			String invoiceNo = "";
			String sMessage = "";

			invoiceNo = productLostService.doSaveProductLostPenalty(ledger, orderbill, invoiceM, invoiceD);
			ledger.put("rentDocNo", invoiceNo);

			if(!invoiceNo.equals("")) sMessage = "Save Successfully";
			else sMessage = "Failed To Save";

			result.put("data", ledger);
			result.put("message", sMessage);

		}//end userId

		return ResponseEntity.ok(result);
	}

}

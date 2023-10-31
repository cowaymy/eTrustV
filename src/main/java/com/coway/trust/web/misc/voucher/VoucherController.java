package com.coway.trust.web.misc.voucher;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.misc.voucher.VoucherService;
import com.coway.trust.biz.misc.voucher.VoucherUploadVO;
import com.coway.trust.biz.payment.payment.service.BatchPaymentVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.coway.trust.config.csv.CsvReadComponent;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/misc/voucher")
public class VoucherController {
	private static final Logger LOGGER = LoggerFactory.getLogger(VoucherController.class);

	@Autowired
	private VoucherService voucherService;
	@Autowired
	private CsvReadComponent csvReadComponent;

	@RequestMapping(value = "/voucherCampaignList.do")
	public String voucherCampaignList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "misc/voucherManagement/voucherCampaignList";
	}

	@RequestMapping(value = "/voucherCampaignCreatePop.do")
	public String voucherCampaignCreate(@RequestParam Map<String, Object> params, ModelMap model) {
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		model.put("toDay", toDay);

		return "misc/voucherManagement/voucherCampaignCreatePop";
	}

	@RequestMapping(value = "/createVoucherCampaign.do")
	public ResponseEntity<ReturnMessage> createVoucherCampaign(@RequestBody Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = voucherService.createVoucherCampaign(params, sessionVO);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/editVoucherCampaign.do")
	public ResponseEntity<ReturnMessage> editVoucherCampaign(@RequestBody Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = voucherService.editVoucherCampaign(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/editVoucherCampaignDate.do")
	public ResponseEntity<ReturnMessage> editVoucherCampaignDate(@RequestBody Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = voucherService.editVoucherCampaignDate(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/editVoucherCampaignStatus.do")
	public ResponseEntity<ReturnMessage> editVoucherCampaignStatus(@RequestBody Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = voucherService.editVoucherCampaignStatus(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getVoucherCampaignList.do")
	public ResponseEntity<List<EgovMap>> getVoucherCampaignList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		String[] moduleArr   = request.getParameterValues("moduleSearch");
		String[] platformArr   = request.getParameterValues("platformSearch");
		String[] statusArr = request.getParameterValues("statusSearch");

		if(moduleArr      != null && !CommonUtils.containsEmpty(moduleArr))      params.put("moduleArr", moduleArr);
		if(platformArr    != null && !CommonUtils.containsEmpty(platformArr))    params.put("platformArr", platformArr);
		if(statusArr != null && !CommonUtils.containsEmpty(statusArr)) params.put("statusArr", statusArr);

		List<EgovMap> result = voucherService.getVoucherCampaignList(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/voucherCampaignEditPop.do")
	public String voucherCampaignEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
			throws Exception {
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		EgovMap campaignDetail = voucherService.getVoucherCampaignDetail(params);
		model.addAttribute("campaignDetail", campaignDetail);
		model.put("toDay", toDay);
		return "misc/voucherManagement/voucherCampaignEditPop";
	}

	@RequestMapping(value = "/voucherListViewPop.do")
	public String voucherViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
			throws Exception {
		EgovMap campaignDetail = voucherService.getVoucherCampaignDetail(params);
		model.addAttribute("campaignDetail", campaignDetail);
		return "misc/voucherManagement/voucherListViewPop";
	}

	@RequestMapping(value = "/getVoucherList.do")
	public ResponseEntity<List<EgovMap>> getVoucherList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		List<EgovMap> result = voucherService.getVoucherList(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/getVoucherListForExcel.do")
	public ResponseEntity<List<EgovMap>> getVoucherListForExcel(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		List<EgovMap> result = voucherService.getVoucherListForExcel(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectPromotionList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		String[] arrPromoAppTypeId = request.getParameterValues("promoAppTypeId"); // Promotion Application
		List<String> lPromoAppTypeId = new ArrayList<String>();
		for (String s : arrPromoAppTypeId) {
			lPromoAppTypeId.add(s);
			if (SalesConstants.PROMO_APP_TYPE_CODE_ID_REN == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_RENTAL));
			}
			if (SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT));
			}
			if (SalesConstants.PROMO_APP_TYPE_CODE_ID_INS == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT));
			}
			if (SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS));
			}
		}

		String[] arrPromoAppTypeId2 = new String[lPromoAppTypeId.size()];
		for(int i = 0; i < lPromoAppTypeId.size(); i++){
			arrPromoAppTypeId2[i] = lPromoAppTypeId.get(i);
		}
		if(arrPromoAppTypeId != null && !CommonUtils.containsEmpty(arrPromoAppTypeId)) params.put("arrPromoAppTypeId", arrPromoAppTypeId2);

		params.put("promoDt", CommonUtils.changeFormat(String.valueOf(params.get("promoDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		List<EgovMap> resultList = voucherService.selectPromotionList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/getVoucherCampaignPromotionDetail.do")
	public ResponseEntity<List<EgovMap>> getVoucherCampaignPromotionDetail(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		List<EgovMap> result = voucherService.getVoucherCampaignPromotionDetail(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectExistPromotionList.do")
	public ResponseEntity<List<EgovMap>> selectExistPromotionList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		List<EgovMap> result = voucherService.selectExistPromotionList(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/deleteVoucherPromotionPackage.do")
	public ResponseEntity<ReturnMessage> deleteVoucherPromotionPackage(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = voucherService.deleteVoucherPromotionPackage(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/generateVoucher.do")
	public ResponseEntity<ReturnMessage> generateVoucher(@RequestBody Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = voucherService.generateVoucher(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/voucherGeneratePop.do")
	public String voucherGeneratePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
			throws Exception {
		model.addAttribute("campaignId", params.get("campaignId").toString());
		return "misc/voucherManagement/voucherGeneratePop";
	}

	@RequestMapping(value = "/activateVoucher.do")
	public ResponseEntity<ReturnMessage> activateVoucher(@RequestBody Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = voucherService.activateVoucher(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/deactivateVoucher.do")
	public ResponseEntity<ReturnMessage> deactivateVoucher(@RequestBody Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = voucherService.deactivateVoucher(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/voucherUploadCustomerPop.do")
	public String voucherUploadCustomerPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
			throws Exception {
		model.addAttribute("campaignId", params.get("campaignId").toString());
		return "misc/voucherManagement/voucherUploadCustomerPop";
	}

	@RequestMapping(value = "/csvFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvFileUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
		ReturnMessage message = new ReturnMessage();
		String campaignId = request.getParameter("campaignId");

		if(campaignId.isEmpty()){
			message.setCode(AppConstants.FAIL);
			message.setMessage("Campaign not found");
		}

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<VoucherUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, true, VoucherUploadVO::create);

		List<Map<String, Object>> details = new ArrayList<Map<String, Object>>();

		for (VoucherUploadVO vo : vos) {
			HashMap<String, Object> hm = new HashMap<String, Object>();

			hm.put("voucherCode",vo.getVoucherCode().trim());
			hm.put("custEmail",vo.getCustomerEmail().trim());
			hm.put("orderId",vo.getOrderId().trim());
			hm.put("custName",vo.getCustomerName().trim());
			hm.put("contact",vo.getContact().trim());
			hm.put("productName",vo.getProductName().trim());
			hm.put("obligation",vo.getObligation().trim());
			hm.put("freeItem",vo.getFreeItem().trim());
			details.add(hm);
		}

		if(details.size() > 0){
			message = voucherService.voucherCustomerDataUpload(details,Integer.parseInt(campaignId), sessionVO);
		}
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/voucherVerification.do")
	public ResponseEntity<ReturnMessage> voucherVerification(@RequestParam Map<String, Object> params,
			ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		if(params.get("isEKeyIn") != null && params.get("isEKeyIn").toString().equals("true")){
			message = voucherService.isVoucherValidToApplyIneKeyIn(params, sessionVO);
			if(message.getCode() == AppConstants.SUCCESS){
				message = voucherService.isVoucherValidToApply(params, sessionVO);
			}
		}
		else{
			message = voucherService.isVoucherValidToApply(params, sessionVO);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getVoucherUsagePromotionId.do")
	public ResponseEntity<List<EgovMap>> getVoucherUsagePromotionId(@RequestParam Map<String, Object> params,
			ModelMap model, SessionVO sessionVO) {
		List<EgovMap> result = voucherService.getVoucherUsagePromotionId(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/sendVoucherEmailNotification.do")
	public ResponseEntity<ReturnMessage> sendVoucherEmailNotification(@RequestParam Map<String, Object> params,
			ModelMap model, SessionVO sessionVO) throws JsonParseException, JsonMappingException, IOException {
		ReturnMessage message = new ReturnMessage();
		List<EgovMap> emailListToSend = voucherService.getPendingEmailSendInfo();

		if(emailListToSend.size() > 0){
			for(int i =0;i<emailListToSend.size();i++)
			{
				EgovMap info = emailListToSend.get(i);
				info.put("userId", sessionVO.getUserId());
				voucherService.sendEmail(info);
			}
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Email Send Success");
		return ResponseEntity.ok(message);
	}
}

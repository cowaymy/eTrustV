package com.coway.trust.web.eAccounting.vendor;

import java.io.File;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.coway.trust.biz.common.type.FileType;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.eAccounting.budget.BudgetService;
import com.coway.trust.biz.eAccounting.vendor.VendorApplication;
import com.coway.trust.biz.eAccounting.vendor.VendorService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/vendor")
public class VendorManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(VendorManagementController.class);

	@Autowired
	private WebInvoiceService webInvoiceService;

	@Autowired
	private VendorApplication vendorApplication;

	@Autowired
	private VendorService vendorService;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/vendorManagement.do")
	public String vendorManagement(@RequestParam Map<String, Object> params, ModelMap model) {
	    if(params != null) {
            String clmNo = (String) params.get("clmNo");
            model.addAttribute("clmNo", clmNo);
        }

		return "eAccounting/vendor/vendorManagement";
	}

	@RequestMapping(value = "/supplierSearchPop.do")
	public String supplierSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("pop", params.get("pop"));
		model.addAttribute("accGrp", params.get("accGrp"));
		model.addAttribute("entry", params.get("entry"));
		return "eAccounting/vendor/memberAccountSearchPop";
	}

	@RequestMapping(value = "/costCenterSearchPop.do")
	public String costCenterSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("pop", params.get("pop"));
		model.addAttribute("call", params.get("call"));
		return "eAccounting/vendor/costCenterSearchPop";
	}

	@RequestMapping(value = "/approveLinePop.do")
	public String approveLinePop(ModelMap model) {
		return "eAccounting/vendor/approveLinePop";
	}

	@RequestMapping(value = "/newRegistMsgPop.do")
	public String newRegistMsgPop(ModelMap model) {
		//String costctr = vendorService.getVendorDetails;
		//model.addAttribute(cost center, cost center);
		return "eAccounting/vendor/newVendorRegistMsgPop";
	}

	@RequestMapping(value = "/newCompletedMsgPop.do")
	public String newCompletedMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("callType", params.get("callType"));
		model.addAttribute("clmNo", params.get("clmNo"));
		return "eAccounting/vendor/newVendorCompletedMsgPop";
	}


	@RequestMapping(value = "/newVendorPop.do")
	public String newVendor(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> taxCodeList = webInvoiceService.selectTaxCodeWebInvoiceFlag();
		List<EgovMap> vendorGrp = vendorService.selectVendorGroup();
		List<EgovMap> bankList = vendorService.selectBank();
		List<EgovMap> countryList = vendorService.selectSAPCountry();

		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("costCentr", sessionVO.getCostCentr());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		model.addAttribute("callType", params.get("callType"));

		model.addAttribute("vendorGrp", vendorGrp);
		model.addAttribute("bankList", bankList);
		model.addAttribute("countryList", countryList);



		if(sessionVO.getCostCentr() != null) {
		    params.put("costCenter", sessionVO.getCostCentr());
	        EgovMap costName = (EgovMap) webInvoiceService.getCostCenterName(params);

	        model.addAttribute("costCentrNm", costName.get("costCenterName"));
		}

		return "eAccounting/vendor/newVendorPop";
	}

	@RequestMapping(value = "/editVendorPop.do")
	public String editVendor(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> taxCodeList = webInvoiceService.selectTaxCodeWebInvoiceFlag();

		model.addAttribute(CommonConstants.USER_ID, sessionVO.getUserId());
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("costCentr", sessionVO.getCostCentr());
		model.addAttribute("taxCodeList", new Gson().toJson(taxCodeList));
		model.addAttribute("callType", params.get("callType"));

		if(sessionVO.getCostCentr() != null) {
		    params.put("costCenter", sessionVO.getCostCentr());
	        EgovMap costName = (EgovMap) webInvoiceService.getCostCenterName(params);

	        model.addAttribute("costCentrNm", costName.get("costCenterName"));
		}

		return "eAccounting/vendor/editVendorPop";
	}

	@RequestMapping(value = "/selectSupplier.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSupplier(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = webInvoiceService.selectSupplier(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectCostCenter.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectcostCenter(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> list = webInvoiceService.selectCostCenter(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/selectVendorList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectVendorList(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
        params.put("userId", sessionVO.getUserId());
        if (!"A1101".equals(costCentr)) {
        }

        LOGGER.debug("params =====================================>>  " + params);

        String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");

        params.put("appvPrcssStus", appvPrcssStus);

        List<EgovMap> list = vendorService.selectVendorList(params);

        LOGGER.debug("params =====================================>>  " + list.toString());

        return ResponseEntity.ok(list);
    }

	@RequestMapping(value = "/insertVendorInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertVendorInfo(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String reqNo = vendorService.selectNextReqNo();
		params.put("reqNo", reqNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		String appvPrcssNo = vendorService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		ReturnMessage message = new ReturnMessage();

		vendorService.insertVendorInfo(params);

		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		/*
		int regCompNoCount = vendorService.checkExistNo(params.get("regCompNo").toString());
		int paymentTermCount = vendorService.checkExistNo(params.get("paymentTerms").toString());
		int bankListCount = vendorService.checkExistNo(params.get("bankList").toString());
		int bankAccNoCount = vendorService.checkExistNo(params.get("bankAccNo").toString());
		boolean isReset = false;

		if(regCompNoCount < 0)
		{
			vendorService.insertVendorInfo(params);

			message.setCode(AppConstants.SUCCESS);
			message.setData(params);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}
		else
		{
			LOGGER.debug("regCompNoCount =====================================>>  " + regCompNoCount);
			if(paymentTermCount < 0)
			{
				vendorService.insertVendorInfo(params);

				message.setCode(AppConstants.SUCCESS);
				message.setData(params);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			}
			else
			{
				LOGGER.debug("paymentTermCount =====================================>>  " + paymentTermCount);
				if(bankListCount < 0)
				{
					vendorService.insertVendorInfo(params);

					message.setCode(AppConstants.SUCCESS);
					message.setData(params);
					message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
				}
				else
				{
					LOGGER.debug("bankListCount =====================================>>  " + bankListCount);
					if(bankAccNoCount < 0)
					{
						vendorService.insertVendorInfo(params);

						message.setCode(AppConstants.SUCCESS);
						message.setData(params);
						message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
					}
					else
					{
						LOGGER.debug("bankAccNoCount =====================================>>  " + bankAccNoCount);
						EgovMap hm2 = vendorService.getFinApprover(params);
						//String memCode = hm2.get("apprMemCode").toString();
						isReset = true;
					}
				}
			}
		}
*/
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "vendor", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			vendorApplication.insertVendorAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
		}

		params.put("attachmentList", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectSameVender.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectSameVender (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("Params =====================================>>  " + params);

		String reqNo = vendorService.selectSameVender(params);

		LOGGER.debug("reqNo =====================================>>  " + reqNo);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(reqNo);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("params =====================================>>  " + params);

		String appvPrcssNo = vendorService.selectNextAppvPrcssNo();
		params.put("appvPrcssNo", appvPrcssNo);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		// TODO appvLineMasterTable Insert
		vendorService.insertApproveManagement(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/budgetCheck.do", method = RequestMethod.POST)
	public ResponseEntity<List<Object>> budgetCheck(@RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params =====================================>>  " + params);

		List<Object> result = vendorService.budgetCheck(params);

		LOGGER.debug("result =====================================>>  " + result);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/checkFinAppr.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> checkFinAppr(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

        LOGGER.debug("params =====================================>>  " + params);

        ReturnMessage message = new ReturnMessage();


        int subCount = vendorService.checkExistClmNo(params.get("reqNo").toString());

        if(subCount > 0) {
            message.setCode(AppConstants.FAIL);
            message.setData(params);
            message.setMessage("Claim has been submitted.");
        } else {
            List<Object> apprGridList = (List<Object>) params.get("apprGridList");

            if (apprGridList.size() > 0) {
                Map hm = null;
                List<String> appvLineUserId = new ArrayList<>();

                for (Object map : apprGridList) {
                    hm = (HashMap<String, Object>) map;
                    appvLineUserId.add(hm.get("memCode").toString());
                }

                String finAppvLineUserId = appvLineUserId.get(appvLineUserId.size() - 1);

                params.put("clmType", params.get("reqNo").toString().substring(0, 2));
                EgovMap hm2 = vendorService.getFinApprover(params);
                String memCode = hm2.get("apprMemCode").toString();
                LOGGER.debug("getFinApprover.memCode =====================================>>  " + memCode);

                memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
                if(!finAppvLineUserId.equals(memCode)) {
                    message.setCode(AppConstants.FAIL);
                    message.setData(params);
                    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
                } else {
                    message.setCode(AppConstants.SUCCESS);
                    message.setData(params);
                    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
                }
            }
        }

        return ResponseEntity.ok(message);
    }

}
